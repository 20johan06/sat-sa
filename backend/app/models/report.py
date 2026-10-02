import uuid
from datetime import datetime, timezone
from sqlalchemy import Column, String, DateTime, ForeignKey
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.types import JSON
from sqlalchemy.orm import relationship

from app.db.base import Base

class ReportRecord(Base):
    """
    Persisted immutable supervisory report record.
    Provides snapshot provenance for CSE supervisory assessment reports.
    Foreign keys enforce ON DELETE RESTRICT to protect audit history integrity.
    """
    __tablename__ = "reports"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    report_code = Column(String(64), unique=True, nullable=False, index=True)
    
    cse_id = Column(UUID(as_uuid=True), ForeignKey("cses.id", ondelete="RESTRICT"), nullable=False, index=True)
    assessment_id = Column(UUID(as_uuid=True), ForeignKey("assessments.id", ondelete="RESTRICT"), nullable=True, index=True)
    dataset_version_id = Column(UUID(as_uuid=True), ForeignKey("dataset_versions.id", ondelete="RESTRICT"), nullable=True, index=True)
    analysis_run_id = Column(UUID(as_uuid=True), ForeignKey("analysis_runs.id", ondelete="RESTRICT"), nullable=True, index=True)
    
    obs_start = Column(DateTime(timezone=True), nullable=True)
    obs_end = Column(DateTime(timezone=True), nullable=True)
    
    generated_by_user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="RESTRICT"), nullable=False)
    created_at = Column(DateTime(timezone=True), nullable=False, default=lambda: datetime.now(timezone.utc))
    
    summary_json = Column(JSONB().with_variant(JSON(), "sqlite"), nullable=False)
    metadata_json = Column(JSONB().with_variant(JSON(), "sqlite"), nullable=False)

    # Relationships
    cse = relationship("CSE", backref="reports")
    assessment = relationship("Assessment")
    dataset_version = relationship("DatasetVersion")
    analysis_run = relationship("AnalysisRun")
    generated_by_user = relationship("User")
