import uuid
from typing import List, Optional, Tuple
from sqlalchemy.orm import Session
from sqlalchemy import desc
from app.models.assessment import Assessment
from app.models.cse import CSE
from app.schemas.assessment import AssessmentCreate, AssessmentUpdateStatus
from app.utils.exceptions import EntityNotFoundException, SATSAException

VALID_ASSESSMENT_STATUSES = {
    "DRAFT",
    "DATASET_ATTACHED",
    "IN_ANALYSIS",
    "UNDER_REVIEW",
    "COMPLETED",
    "ARCHIVED"
}

ALLOWED_TRANSITIONS = {
    "DRAFT": {"DATASET_ATTACHED", "ARCHIVED"},
    "DATASET_ATTACHED": {"IN_ANALYSIS", "DRAFT", "ARCHIVED"},
    "IN_ANALYSIS": {"UNDER_REVIEW", "DATASET_ATTACHED", "ARCHIVED"},
    "UNDER_REVIEW": {"COMPLETED", "IN_ANALYSIS", "ARCHIVED"},
    "COMPLETED": {"ARCHIVED", "UNDER_REVIEW"},
    "ARCHIVED": set()
}

class AssessmentService:
    """Service handling V2 Supervisory Assessment operations."""

    @staticmethod
    def create_assessment(
        db: Session,
        req: AssessmentCreate,
        user_id: Optional[uuid.UUID] = None
    ) -> Assessment:
        # Verify CSE exists
        cse = db.query(CSE).filter(CSE.id == req.cse_id).first()
        if not cse:
            raise EntityNotFoundException("CSE", req.cse_id)

        assessment = Assessment(
            id=uuid.uuid4(),
            cse_id=req.cse_id,
            name=req.name,
            description=req.description,
            period_start=req.period_start,
            period_end=req.period_end,
            status="DRAFT",
            created_by_user_id=user_id
        )
        db.add(assessment)
        db.commit()
        db.refresh(assessment)
        return assessment

    @staticmethod
    def get_assessment(db: Session, assessment_id: uuid.UUID) -> Assessment:
        assessment = db.query(Assessment).filter(Assessment.id == assessment_id).first()
        if not assessment:
            raise EntityNotFoundException("Assessment", assessment_id)
        return assessment

    @staticmethod
    def update_assessment_status(
        db: Session,
        assessment_id: uuid.UUID,
        target_status: str
    ) -> Assessment:
        assessment = AssessmentService.get_assessment(db, assessment_id)
        status_upper = target_status.upper()

        if status_upper not in VALID_ASSESSMENT_STATUSES:
            raise SATSAException(
                message=f"Invalid assessment status '{target_status}'. Must be one of {sorted(VALID_ASSESSMENT_STATUSES)}",
                code="INVALID_STATUS",
                status_code=422
            )

        current_status = assessment.status
        if current_status != status_upper:
            allowed = ALLOWED_TRANSITIONS.get(current_status, set())
            if status_upper not in allowed:
                raise SATSAException(
                    message=f"Invalid assessment status transition from '{current_status}' to '{status_upper}'. Allowed transitions: {sorted(allowed)}",
                    code="INVALID_STATUS_TRANSITION",
                    status_code=422
                )

        assessment.status = status_upper
        db.commit()
        db.refresh(assessment)
        return assessment

    @staticmethod
    def list_assessments(
        db: Session,
        cse_id: Optional[uuid.UUID] = None,
        allowed_cse_ids: Optional[List[uuid.UUID]] = None,
        skip: int = 0,
        limit: int = 50
    ) -> Tuple[int, List[Assessment]]:
        query = db.query(Assessment)
        if cse_id:
            query = query.filter(Assessment.cse_id == cse_id)
        elif allowed_cse_ids is not None:
            query = query.filter(Assessment.cse_id.in_(allowed_cse_ids))

        total = query.count()
        items = query.order_by(desc(Assessment.created_at)).offset(skip).limit(limit).all()
        return total, items

assessment_service = AssessmentService()
