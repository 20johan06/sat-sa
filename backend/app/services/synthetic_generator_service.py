import uuid
import random
import hashlib
from datetime import datetime, timedelta, timezone
from typing import List, Dict, Any, Tuple
from sqlalchemy.orm import Session

from app.models.cse import CSE
from app.models.alert import Alert
from app.models.case import Case
from app.models.investigation import Investigation
from app.models.escalation import Escalation
from app.models.coverage import MonitoringCoverage
from app.models.dataset_version import DatasetVersion
from app.models.assessment import Assessment
from app.models.analysis_run import AnalysisRun
from app.models.report import ReportRecord
from app.models.finding import Finding, FindingEvidence, FindingReviewHistory
from app.models.baseline import PeerBaseline

SYNTHETIC_SEED = 202613
BASE_DATETIME = datetime(2026, 1, 1, 0, 0, 0, tzinfo=timezone.utc)
SYNTHETIC_DATASET_TYPE = "SYNTHETIC_VALIDATION"

def generate_stable_uuid(namespace_str: str) -> uuid.UUID:
    """Generates deterministic UUIDv5 based on a string namespace key."""
    return uuid.uuid5(uuid.NAMESPACE_DNS, f"sat-sa.synthetic.{namespace_str}")

class SyntheticGeneratorService:
    """
    Authoritative Phase 13 Synthetic Data Generator.
    Produces isolated, reproducible, deterministic operational telemetry for 8 controlled scenarios.
    Tags dataset versions as 'SYNTHETIC_VALIDATION' and CSEs as 'SYN-CSE-*'.
    """

    @staticmethod
    def generate_all_scenarios(db: Session, force_recreate: bool = True) -> Dict[str, Any]:
        random.seed(SYNTHETIC_SEED)
        
        # 1. Clean up existing synthetic records if requested
        if force_recreate:
            SyntheticGeneratorService.cleanup_synthetic_data(db)

        created_cses: List[CSE] = []

        # 2. Seed Sector Peer CSEs for BM-01 Benchmark Scenarios (Sector: SYNTHETIC_FINANCE)
        peer_cses = SyntheticGeneratorService._seed_peer_population(db)
        created_cses.extend(peer_cses)

        # 3. Seed 8 Controlled Validation CSE Scenarios
        c01 = SyntheticGeneratorService._seed_cse01_normal(db)
        c02 = SyntheticGeneratorService._seed_cse02_rapid_closure(db)
        c03 = SyntheticGeneratorService._seed_cse03_repeated_alerts(db)
        c04 = SyntheticGeneratorService._seed_cse04_missing_escalation(db)
        c05 = SyntheticGeneratorService._seed_cse05_telemetry_gap(db)
        c06 = SyntheticGeneratorService._seed_cse06_uninvestigated_alerts(db)
        c07 = SyntheticGeneratorService._seed_cse07_peer_deviation(db)
        c08 = SyntheticGeneratorService._seed_cse08_volume_anomaly(db)

        created_cses.extend([c01, c02, c03, c04, c05, c06, c07, c08])

        # 4. Create immutable DatasetVersion provenance records
        ds_versions = SyntheticGeneratorService._create_dataset_versions(db, created_cses)

        db.commit()

        return {
            "cses_created": len(created_cses),
            "dataset_versions_created": len(ds_versions),
            "seed": SYNTHETIC_SEED,
            "dataset_type": SYNTHETIC_DATASET_TYPE
        }

    @staticmethod
    def cleanup_synthetic_data(db: Session):
        """Cleans up synthetic validation entities by prefix without touching operational data."""
        syn_cses = db.query(CSE).filter(CSE.cse_code.like("SYN-%")).all()
        syn_cse_ids = [c.id for c in syn_cses]

        if syn_cse_ids:
            syn_alert_ids = [a.id for a in db.query(Alert.id).filter(Alert.cse_id.in_(syn_cse_ids)).all()]
            syn_case_ids = [c.id for c in db.query(Case.id).filter(Case.cse_id.in_(syn_cse_ids)).all()]
            syn_finding_ids = [f.id for f in db.query(Finding.id).filter(Finding.cse_id.in_(syn_cse_ids)).all()]

            # 1. Delete dependent report records
            db.query(ReportRecord).filter(ReportRecord.cse_id.in_(syn_cse_ids)).delete(synchronize_session=False)
            db.flush()

            # 2. Delete finding review history
            db.query(FindingReviewHistory).filter(
                (FindingReviewHistory.cse_id.in_(syn_cse_ids)) | 
                (FindingReviewHistory.finding_id.in_(syn_finding_ids))
            ).delete(synchronize_session=False)
            db.flush()

            # 3. Delete finding evidences
            db.query(FindingEvidence).filter(
                (FindingEvidence.finding_id.in_(syn_finding_ids)) |
                (FindingEvidence.alert_id.in_(syn_alert_ids)) |
                (FindingEvidence.case_id.in_(syn_case_ids))
            ).delete(synchronize_session=False)
            db.flush()

            # 4. Delete findings
            db.query(Finding).filter(Finding.cse_id.in_(syn_cse_ids)).delete(synchronize_session=False)
            db.flush()

            # 5. Delete analysis runs
            db.query(AnalysisRun).filter(AnalysisRun.cse_id.in_(syn_cse_ids)).delete(synchronize_session=False)
            db.flush()

            # 6. Delete escalations
            db.query(Escalation).filter(
                (Escalation.case_id.in_(syn_case_ids)) |
                (Escalation.alert_id.in_(syn_alert_ids))
            ).delete(synchronize_session=False)
            db.flush()

            # 7. Delete investigations
            db.query(Investigation).filter(Investigation.case_id.in_(syn_case_ids)).delete(synchronize_session=False)
            db.flush()

            # 8. Delete cases
            db.query(Case).filter(Case.cse_id.in_(syn_cse_ids)).delete(synchronize_session=False)
            db.flush()

            # 9. Delete alerts
            db.query(Alert).filter(Alert.cse_id.in_(syn_cse_ids)).delete(synchronize_session=False)
            db.flush()

            # 10. Delete monitoring coverages, dataset versions, assessments, peer baselines
            db.query(MonitoringCoverage).filter(MonitoringCoverage.cse_id.in_(syn_cse_ids)).delete(synchronize_session=False)
            db.query(DatasetVersion).filter(DatasetVersion.cse_id.in_(syn_cse_ids)).delete(synchronize_session=False)
            db.query(Assessment).filter(Assessment.cse_id.in_(syn_cse_ids)).delete(synchronize_session=False)
            db.query(PeerBaseline).filter(PeerBaseline.peer_group.like("%SYNTHETIC%")).delete(synchronize_session=False)
            db.flush()

            # 11. Delete CSEs
            db.query(CSE).filter(CSE.id.in_(syn_cse_ids)).delete(synchronize_session=False)
            db.flush()
            db.commit()
            db.expire_all()

    @staticmethod
    def _get_or_create_cse(db: Session, cse_code: str, name: str, sector: str = "SYNTHETIC_FINANCE_SEC") -> CSE:
        cse_id = generate_stable_uuid(f"cse.{cse_code}")
        existing = db.query(CSE).filter(CSE.id == cse_id).first()
        if existing:
            syn_alert_ids = [a.id for a in db.query(Alert.id).filter(Alert.cse_id == cse_id).all()]
            syn_case_ids = [c.id for c in db.query(Case.id).filter(Case.cse_id == cse_id).all()]
            syn_finding_ids = [f.id for f in db.query(Finding.id).filter(Finding.cse_id == cse_id).all()]

            db.query(FindingEvidence).filter(
                (FindingEvidence.finding_id.in_(syn_finding_ids)) |
                (FindingEvidence.alert_id.in_(syn_alert_ids)) |
                (FindingEvidence.case_id.in_(syn_case_ids))
            ).delete(synchronize_session=False)
            db.query(FindingReviewHistory).filter(FindingReviewHistory.cse_id == cse_id).delete(synchronize_session=False)
            db.query(Finding).filter(Finding.cse_id == cse_id).delete(synchronize_session=False)
            db.query(Escalation).filter(Escalation.case_id.in_(syn_case_ids)).delete(synchronize_session=False)
            db.query(Investigation).filter(Investigation.case_id.in_(syn_case_ids)).delete(synchronize_session=False)
            db.query(Case).filter(Case.cse_id == cse_id).delete(synchronize_session=False)
            db.query(Alert).filter(Alert.cse_id == cse_id).delete(synchronize_session=False)
            db.query(MonitoringCoverage).filter(MonitoringCoverage.cse_id == cse_id).delete(synchronize_session=False)
            db.flush()
            db.expire_all()
            return existing

        cse = CSE(
            id=cse_id,
            cse_code=cse_code,
            name=name,
            sector=sector,
            criticality_tier="TIER_1",
            is_active=True
        )
        db.add(cse)
        db.flush()
        return cse

    @staticmethod
    def _seed_peer_population(db: Session) -> List[CSE]:
        """Seeds 5 sector peer CSEs for BM-01 peer group comparison (Sector: SYNTHETIC_FINANCE_SEC)."""
        peers = []
        peer_case_limits = [85, 84, 86, 83, 87]
        for i in range(1, 6):
            code = f"SYN-PEER-0{i}"
            name = f"Synthetic Sector Peer {i}"
            cse = SyntheticGeneratorService._get_or_create_cse(db, code, name, sector="SYNTHETIC_PEER_FINANCE")
            case_limit = peer_case_limits[i - 1]
            
            for j in range(100):
                alt_id = generate_stable_uuid(f"peer.{code}.alert.{j}")
                ext_id = f"ALT-{code}-{j:03d}"
                alt = Alert(
                    id=alt_id,
                    cse_id=cse.id,
                    external_alert_id=ext_id,
                    title=f"Synthetic Peer Alert {ext_id}",
                    category="MALWARE",
                    severity="CRITICAL" if j % 4 == 0 else "HIGH",
                    detected_at=BASE_DATETIME + timedelta(days=j % 20, hours=j % 12),
                    status="CLOSED" if j < case_limit else "NEW"
                )
                db.add(alt)
                
                if j < case_limit:
                    case_id = generate_stable_uuid(f"peer.{code}.case.{j}")
                    c = Case(
                        id=case_id,
                        cse_id=cse.id,
                        alert_id=alt_id,
                        external_case_id=f"CAS-{code}-{j:03d}",
                        title=f"Peer Incident Case {j}",
                        status="CLOSED",
                        priority="HIGH",
                        opened_at=alt.detected_at,
                        closed_at=alt.detected_at + timedelta(hours=4)
                    )
                    db.add(c)

                    if alt.severity == "CRITICAL":
                        esc_id = generate_stable_uuid(f"peer.{code}.esc.{j}")
                        esc = Escalation(
                            id=esc_id,
                            case_id=case_id,
                            alert_id=alt_id,
                            escalation_level="LEVEL_2",
                            reason="Critical incident escalation",
                            status="COMPLETED",
                            escalated_at=alt.detected_at + timedelta(hours=1)
                        )
                        db.add(esc)

            peers.append(cse)
        return peers

    @staticmethod
    def _seed_cse01_normal(db: Session) -> CSE:
        """CSE-01: Normal Operations (Negative Control - 0 findings expected)."""
        cse = SyntheticGeneratorService._get_or_create_cse(db, "SYN-CSE-01", "Synthetic CSE 01 (Normal Operations)")
        
        # 1. 20 alerts across 12 distinct days (AN-01 baseline: med=2, mad=0.5 > 0)
        daily_distribution = [2, 1, 2, 2, 3, 1, 2, 2, 1, 2, 1, 1]
        day_idx = 0
        alt_counter = 0
        for cnt in daily_distribution:
            for c_idx in range(cnt):
                alt_counter += 1
                alt_id = generate_stable_uuid(f"cse01.alert.{alt_counter}")
                ext_id = f"ALT-C01-{alt_counter:03d}"
                det_time = BASE_DATETIME + timedelta(days=day_idx, hours=c_idx * 2)
                alt = Alert(
                    id=alt_id,
                    cse_id=cse.id,
                    external_alert_id=ext_id,
                    title=f"Synthetic Normal Alert {ext_id}",
                    category="EXPLOIT",
                    severity="HIGH",
                    detected_at=det_time,
                    status="CLOSED"
                )
                db.add(alt)

            day_idx += 1

        # 2. 12 closed cases with durations 14,000s to 25,000s (EG-03: N=12 >= 10, no low outlier)
        for i in range(1, 13):
            alt_id = generate_stable_uuid(f"cse01.alert.{i}")
            case_id = generate_stable_uuid(f"cse01.case.{i}")
            duration_sec = 18000
            opened = BASE_DATETIME + timedelta(days=i)
            closed = opened + timedelta(seconds=duration_sec)
            
            c = Case(
                id=case_id,
                cse_id=cse.id,
                alert_id=alt_id,
                external_case_id=f"CAS-C01-{i:03d}",
                title=f"Normal Case {i}",
                status="CLOSED",
                priority="HIGH",
                opened_at=opened,
                closed_at=closed
            )
            db.add(c)

            inv_id = generate_stable_uuid(f"cse01.inv.{i}")
            inv = Investigation(
                id=inv_id,
                case_id=case_id,
                action_type="ANALYSIS",
                notes=f"Normal investigation notes unique for case {i} with distinct resolution details.",
                started_at=opened,
                completed_at=closed
            )
            db.add(inv)

        # 3. Active coverage record (NS-01: active coverage present)
        cov_id = generate_stable_uuid("cse01.coverage.1")
        cov = MonitoringCoverage(
            id=cov_id,
            cse_id=cse.id,
            log_source_category="FIREWALL",
            is_expected=True,
            is_active=True,
            period_start=BASE_DATETIME,
            period_end=BASE_DATETIME + timedelta(days=30),
            last_received_at=BASE_DATETIME + timedelta(days=15)
        )
        db.add(cov)

        return cse

    @staticmethod
    def _seed_cse02_rapid_closure(db: Session) -> CSE:
        """CSE-02: Rapid Case Closure Pattern (Triggers EG-03)."""
        cse = SyntheticGeneratorService._get_or_create_cse(db, "SYN-CSE-02", "Synthetic CSE 02 (Rapid Closure Pattern)", sector="SYN_SEC_CSE02")
        
        for i in range(1, 13):
            alt_id = generate_stable_uuid(f"cse02.alert.{i}")
            case_id = generate_stable_uuid(f"cse02.case.{i}")
            ext_id = f"ALT-C02-{i:03d}"
            
            alt = Alert(
                id=alt_id,
                cse_id=cse.id,
                external_alert_id=ext_id,
                title=f"Rapid Closure Alert {ext_id}",
                category="SUSPICIOUS_LOGIN",
                severity="HIGH",
                detected_at=BASE_DATETIME + timedelta(days=i),
                status="CLOSED"
            )
            db.add(alt)

            duration_sec = 60 if i == 1 else 18000
            opened = BASE_DATETIME + timedelta(days=i)
            closed = opened + timedelta(seconds=duration_sec)

            c = Case(
                id=case_id,
                cse_id=cse.id,
                alert_id=alt_id,
                external_case_id=f"CAS-C02-{i:03d}",
                title=f"Rapid Closure Case {i}",
                status="CLOSED",
                priority="HIGH",
                opened_at=opened,
                closed_at=closed
            )
            db.add(c)

        return cse

    @staticmethod
    def _seed_cse03_repeated_alerts(db: Session) -> CSE:
        """CSE-03: Repeated Investigations Without Remediation (Triggers EG-04)."""
        cse = SyntheticGeneratorService._get_or_create_cse(db, "SYN-CSE-03", "Synthetic CSE 03 (Repeated Investigations)", sector="SYN_SEC_CSE03")
        
        exact_repeated_note = "Standard malware triage template: Asset isolated, memory dump captured, false positive confirmed."

        for i in range(1, 5):
            alt_id = generate_stable_uuid(f"cse03.alert.{i}")
            case_id = generate_stable_uuid(f"cse03.case.{i}")
            inv_id = generate_stable_uuid(f"cse03.inv.{i}")
            ext_id = f"ALT-C03-{i:03d}"

            alt = Alert(
                id=alt_id,
                cse_id=cse.id,
                external_alert_id=ext_id,
                title=f"Repeated Alert {ext_id}",
                category="MALWARE",
                severity="MEDIUM",
                detected_at=BASE_DATETIME + timedelta(days=i),
                status="CLOSED"
            )
            db.add(alt)

            c = Case(
                id=case_id,
                cse_id=cse.id,
                alert_id=alt_id,
                external_case_id=f"CAS-C03-{i:03d}",
                title=f"Repeated Investigation Case {i}",
                status="CLOSED",
                priority="MEDIUM",
                opened_at=alt.detected_at,
                closed_at=alt.detected_at + timedelta(hours=2)
            )
            db.add(c)

            inv = Investigation(
                id=inv_id,
                case_id=case_id,
                action_type="MALWARE_ANALYSIS",
                notes=exact_repeated_note,
                started_at=c.opened_at,
                completed_at=c.closed_at
            )
            db.add(inv)

        return cse

    @staticmethod
    def _seed_cse04_missing_escalation(db: Session) -> CSE:
        """CSE-04: Missing Escalation (Unconfigured expectation flags -> Expected NO FINDING)."""
        cse = SyntheticGeneratorService._get_or_create_cse(db, "SYN-CSE-04", "Synthetic CSE 04 (Missing Escalation)", sector="SYN_SEC_CSE04")
        
        for i in range(1, 6):
            alt_id = generate_stable_uuid(f"cse04.alert.{i}")
            case_id = generate_stable_uuid(f"cse04.case.{i}")
            ext_id = f"ALT-C04-{i:03d}"

            alt = Alert(
                id=alt_id,
                cse_id=cse.id,
                external_alert_id=ext_id,
                title=f"Unescalated Alert {ext_id}",
                category="EXPLOIT",
                severity="CRITICAL",
                detected_at=BASE_DATETIME + timedelta(days=i),
                status="CLOSED"
            )
            db.add(alt)

            c = Case(
                id=case_id,
                cse_id=cse.id,
                alert_id=alt_id,
                external_case_id=f"CAS-C04-{i:03d}",
                title=f"Unescalated Case {i}",
                status="CLOSED",
                priority="CRITICAL",
                opened_at=alt.detected_at,
                closed_at=alt.detected_at + timedelta(hours=3)
            )
            db.add(c)

        return cse

    @staticmethod
    def _seed_cse05_telemetry_gap(db: Session) -> CSE:
        """CSE-05: Telemetry Gap (Triggers NS-01 - Evidence of Absence)."""
        cse = SyntheticGeneratorService._get_or_create_cse(db, "SYN-CSE-05", "Synthetic CSE 05 (Telemetry Gap)", sector="SYN_SEC_CSE05")
        
        cov_id = generate_stable_uuid("cse05.coverage.1")
        cov = MonitoringCoverage(
            id=cov_id,
            cse_id=cse.id,
            log_source_category="EDR_TELEMETRY",
            is_expected=True,
            is_active=False,
            period_start=BASE_DATETIME,
            period_end=BASE_DATETIME + timedelta(days=30),
            last_received_at=None
        )
        db.add(cov)

        return cse

    @staticmethod
    def _seed_cse06_uninvestigated_alerts(db: Session) -> CSE:
        """CSE-06: Repetitive Uninvestigated Alerts (EG-01 unconfigured -> Expected NO FINDING)."""
        cse = SyntheticGeneratorService._get_or_create_cse(db, "SYN-CSE-06", "Synthetic CSE 06 (Uninvestigated Alerts)", sector="SYN_SEC_CSE06")
        
        for i in range(1, 11):
            alt_id = generate_stable_uuid(f"cse06.alert.{i}")
            ext_id = f"ALT-C06-{i:03d}"
            alt = Alert(
                id=alt_id,
                cse_id=cse.id,
                external_alert_id=ext_id,
                title=f"Uninvestigated Alert {ext_id}",
                category="MALWARE",
                severity="CRITICAL",
                detected_at=BASE_DATETIME + timedelta(days=i),
                status="NEW"
            )
            db.add(alt)

        return cse

    @staticmethod
    def _seed_cse07_peer_deviation(db: Session) -> CSE:
        """CSE-07: Peer Benchmark Deviation (Triggers BM-01)."""
        cse = SyntheticGeneratorService._get_or_create_cse(db, "SYN-CSE-07", "Synthetic CSE 07 (Peer Benchmark Deviation)", sector="SYNTHETIC_PEER_FINANCE")
        
        for j in range(100):
            alt_id = generate_stable_uuid(f"cse07.alert.{j}")
            ext_id = f"ALT-C07-{j:03d}"
            alt = Alert(
                id=alt_id,
                cse_id=cse.id,
                external_alert_id=ext_id,
                title=f"Peer Deviation Alert {ext_id}",
                category="SUSPICIOUS_ACTIVITY",
                severity="HIGH",
                detected_at=BASE_DATETIME + timedelta(days=j % 20, hours=j % 12),
                status="CLOSED" if j < 5 else "NEW"
            )
            db.add(alt)

            if j < 5:
                case_id = generate_stable_uuid(f"cse07.case.{j}")
                c = Case(
                    id=case_id,
                    cse_id=cse.id,
                    alert_id=alt_id,
                    external_case_id=f"CAS-C07-{j:03d}",
                    title=f"Peer Deviation Case {j}",
                    status="CLOSED",
                    priority="HIGH",
                    opened_at=alt.detected_at,
                    closed_at=alt.detected_at + timedelta(hours=2)
                )
                db.add(c)

        return cse

    @staticmethod
    def _seed_cse08_volume_anomaly(db: Session) -> CSE:
        """CSE-08: Daily Alert Volume Anomaly (Triggers AN-01)."""
        cse = SyntheticGeneratorService._get_or_create_cse(db, "SYN-CSE-08", "Synthetic CSE 08 (Volume Anomaly)", sector="SYN_SEC_CSE08")
        
        counts = [8, 9, 10, 10, 11, 12, 9, 10, 11, 10, 150]
        
        alt_counter = 0
        for day_idx, cnt in enumerate(counts):
            for c_idx in range(cnt):
                alt_counter += 1
                alt_id = generate_stable_uuid(f"cse08.alert.{alt_counter}")
                ext_id = f"ALT-C08-{alt_counter:04d}"
                alt = Alert(
                    id=alt_id,
                    cse_id=cse.id,
                    external_alert_id=ext_id,
                    title=f"Volume Anomaly Alert {ext_id}",
                    category="DOS_ATTACK",
                    severity="MEDIUM",
                    detected_at=BASE_DATETIME + timedelta(days=day_idx, hours=(c_idx * 15) % 24),
                    status="CLOSED"
                )
                db.add(alt)

        return cse

    @staticmethod
    def _create_dataset_versions(db: Session, cses: List[CSE]) -> List[DatasetVersion]:
        """Creates immutable DatasetVersion records for each synthetic CSE tagged with 'SYNTHETIC_VALIDATION'."""
        ds_versions = []
        for c in cses:
            ds_id = generate_stable_uuid(f"dataset.{c.cse_code}")
            existing = db.query(DatasetVersion).filter(DatasetVersion.id == ds_id).first()
            if existing:
                ds_versions.append(existing)
                continue

            content_hash = hashlib.sha256(f"SYNTHETIC-DATA-{c.cse_code}-{SYNTHETIC_SEED}".encode()).hexdigest()
            ds = DatasetVersion(
                id=ds_id,
                cse_id=c.id,
                version_tag=f"SYN-VAL-{c.cse_code}-v1.0",
                dataset_type=SYNTHETIC_DATASET_TYPE,
                source_filename=f"synthetic_{c.cse_code.lower()}_telemetry.csv",
                content_hash=content_hash,
                record_count=100,
                is_immutable=True,
                created_at=BASE_DATETIME
            )
            db.add(ds)
            ds_versions.append(ds)

        return ds_versions

synthetic_generator_service = SyntheticGeneratorService()
