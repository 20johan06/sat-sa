import uuid
import pytest
from datetime import datetime, timezone
from sqlalchemy import event
from app.models.cse import CSE
from app.models.user import User, UserCSE
from app.models.finding import Finding, FindingEvidence
from app.services.reporting_service import ReportingService
from app.services.auth_service import AuthService
from app.utils.security import create_access_token, get_password_hash
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_get_findings_query_count_and_zero_evidence(db_session):
    """
    Verify get_findings eliminates N+1 queries by aggregating evidence counts in a single query
    and accurately returns counts for zero-evidence (0), 2-evidence, and 5-evidence findings.
    """
    cse = CSE(
        id=uuid.uuid4(),
        name="Opt Test CSE",
        cse_code=f"CSE-OPT-{uuid.uuid4().hex[:6]}",
        sector="DEFENSE",
        criticality_tier="TIER_1"
    )
    db_session.add(cse)
    db_session.commit()

    # Create 3 findings: A (0 evidence), B (2 evidence), C (5 evidence)
    f_a = Finding(
        id=uuid.uuid4(),
        finding_code=f"OPT-A-{uuid.uuid4().hex[:6]}",
        cse_id=cse.id,
        category="ANOMALY",
        severity="HIGH",
        title="Finding A - Zero Evidence",
        description="Desc A",
        rationale="Rat A",
        detection_method="STAT",
        status="NEW",
        detected_at=datetime.now(timezone.utc)
    )
    f_b = Finding(
        id=uuid.uuid4(),
        finding_code=f"OPT-B-{uuid.uuid4().hex[:6]}",
        cse_id=cse.id,
        category="ANOMALY",
        severity="HIGH",
        title="Finding B - 2 Evidence",
        description="Desc B",
        rationale="Rat B",
        detection_method="STAT",
        status="NEW",
        detected_at=datetime.now(timezone.utc)
    )
    f_c = Finding(
        id=uuid.uuid4(),
        finding_code=f"OPT-C-{uuid.uuid4().hex[:6]}",
        cse_id=cse.id,
        category="ANOMALY",
        severity="HIGH",
        title="Finding C - 5 Evidence",
        description="Desc C",
        rationale="Rat C",
        detection_method="STAT",
        status="NEW",
        detected_at=datetime.now(timezone.utc)
    )
    db_session.add_all([f_a, f_b, f_c])
    db_session.commit()

    # B has 2 evidence
    ev_b1 = FindingEvidence(id=uuid.uuid4(), finding_id=f_b.id, evidence_type="ALERT", notes="ev B1")
    ev_b2 = FindingEvidence(id=uuid.uuid4(), finding_id=f_b.id, evidence_type="ALERT", notes="ev B2")
    db_session.add_all([ev_b1, ev_b2])

    # C has 5 evidence
    for i in range(5):
        db_session.add(FindingEvidence(id=uuid.uuid4(), finding_id=f_c.id, evidence_type="ALERT", notes=f"ev C{i}"))
    db_session.commit()

    # Instrument SQL execution count during get_findings
    queries = []
    def before_cursor_execute(conn, cursor, statement, parameters, context, executemany):
        queries.append(statement)

    engine = db_session.bind
    event.listen(engine, "before_cursor_execute", before_cursor_execute)

    try:
        response = ReportingService.get_findings(
            db=db_session,
            cse_id=cse.id,
            page=1,
            page_size=20
        )
    finally:
        event.remove(engine, "before_cursor_execute", before_cursor_execute)

    # 1. Total findings & evidence queriesExecuted should be 3:
    # SQL #1: count query for total matching findings
    # SQL #2: findings page query
    # SQL #3: SINGLE aggregated evidence count query (LEFT OUTER JOIN + GROUP BY)
    finding_queries = [q for q in queries if "findings" in q.lower() or "finding_evidence" in q.lower()]
    assert len(finding_queries) == 3, f"Expected 3 finding queries, got {len(finding_queries)}: {finding_queries}"

    # Verify SQL #3 uses LEFT OUTER JOIN and GROUP BY
    evidence_sql = finding_queries[2]
    assert "LEFT OUTER JOIN" in evidence_sql.upper() or "LEFT JOIN" in evidence_sql.upper()
    assert "GROUP BY" in evidence_sql.upper()

    # 2. Verify evidence counts in response
    items_by_id = {item.id: item for item in response.items}
    assert items_by_id[f_a.id].evidence_count == 0
    assert items_by_id[f_b.id].evidence_count == 2
    assert items_by_id[f_c.id].evidence_count == 5


def test_cse_isolation_and_authorization(db_session):
    """
    Verify server-side CSE isolation and object-level authorization (403 for unauthorized CSE).
    """
    cse_auth = CSE(
        id=uuid.uuid4(),
        name="Authorized CSE",
        cse_code=f"CSE-AUTH-{uuid.uuid4().hex[:6]}",
        sector="DEFENSE",
        criticality_tier="TIER_1"
    )
    cse_unauth = CSE(
        id=uuid.uuid4(),
        name="Unauthorized CSE",
        cse_code=f"CSE-UNAUTH-{uuid.uuid4().hex[:6]}",
        sector="FINANCE",
        criticality_tier="TIER_2"
    )
    db_session.add_all([cse_auth, cse_unauth])
    db_session.commit()

    # Create a user assigned via UserCSE to cse_auth
    u_id = uuid.uuid4()
    username = f"user_{u_id.hex[:6]}"
    user = User(
        id=u_id,
        username=username,
        email=f"{username}@example.com",
        hashed_password=get_password_hash("Pass123!"),
        role="ANALYST",
        is_active=True
    )
    db_session.add(user)
    db_session.commit()

    user_cse = UserCSE(user_id=user.id, cse_id=cse_auth.id)
    db_session.add(user_cse)
    db_session.commit()

    token = create_access_token({"sub": str(user.id), "role": "ANALYST"})
    headers = {"Authorization": f"Bearer {token}"}

    # 1. Authorized CSE request -> 200 OK
    res_auth = client.get(f"/api/v1/findings/?cse_id={cse_auth.id}", headers=headers)
    assert res_auth.status_code == 200

    # 2. Unauthorized CSE request -> 403 Forbidden
    res_unauth = client.get(f"/api/v1/findings/?cse_id={cse_unauth.id}", headers=headers)
    assert res_unauth.status_code == 403
