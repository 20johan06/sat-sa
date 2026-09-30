import uuid
from datetime import datetime, timezone
from typing import List, Any, TYPE_CHECKING
from sqlalchemy import String, Integer, Text, DateTime, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.postgresql import UUID, JSONB
from app.db.base import Base

if TYPE_CHECKING:
    from app.models.cse import CSE
    from app.models.assessment import Assessment
    from app.models.dataset_version import DatasetVersion
    from app.models.user import User
    from app.models.finding import Finding

class AnalysisRun(Base):
    """Analysis Run Execution Traceability Model."""
    __tablename__ = "analysis_runs"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4
    )
    cse_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("cses.id", ondelete="RESTRICT"),
        index=True,
        nullable=False
    )
    assessment_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("assessments.id", ondelete="SET NULL"),
        index=True,
        nullable=True
    )
    dataset_version_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("dataset_versions.id", ondelete="SET NULL"),
        index=True,
        nullable=True
    )
    obs_start: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True),
        nullable=True
    )
    obs_end: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True),
        nullable=True
    )
    engine_version: Mapped[str] = mapped_column(
        String(100),
        default="v2.0.0-phase5-canonical",
        nullable=False
    )
    rules_evaluated: Mapped[dict[str, Any] | List[Any]] = mapped_column(
        JSONB,
        nullable=False
    )
    status: Mapped[str] = mapped_column(
        String(50),
        default="PENDING",
        index=True,
        nullable=False
    )
    findings_created: Mapped[int] = mapped_column(
        Integer,
        default=0,
        nullable=False
    )
    baselines_persisted: Mapped[int] = mapped_column(
        Integer,
        default=0,
        nullable=False
    )
    error_message: Mapped[str | None] = mapped_column(
        Text,
        nullable=True
    )
    started_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        nullable=False
    )
    completed_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True),
        nullable=True
    )
    executed_by_user_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("users.id", ondelete="SET NULL"),
        nullable=True
    )

    # Relationships
    cse: Mapped["CSE"] = relationship("CSE", back_populates="analysis_runs")
    assessment: Mapped["Assessment | None"] = relationship("Assessment", back_populates="analysis_runs")
    dataset_version: Mapped["DatasetVersion | None"] = relationship("DatasetVersion", back_populates="analysis_runs")
    executed_by_user: Mapped["User | None"] = relationship("User")
    findings: Mapped[List["Finding"]] = relationship("Finding", back_populates="analysis_run")
