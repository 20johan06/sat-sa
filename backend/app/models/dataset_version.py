import uuid
from datetime import datetime, timezone
from typing import List, TYPE_CHECKING
from sqlalchemy import String, Integer, Boolean, DateTime, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.postgresql import UUID
from app.db.base import Base

if TYPE_CHECKING:
    from app.models.cse import CSE
    from app.models.assessment import Assessment
    from app.models.ingestion import IngestionBatch
    from app.models.user import User
    from app.models.analysis_run import AnalysisRun

class DatasetVersion(Base):
    """Immutable Dataset Version Model."""
    __tablename__ = "dataset_versions"

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
    batch_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("ingestion_batches.id", ondelete="SET NULL"),
        index=True,
        nullable=True
    )
    version_tag: Mapped[str] = mapped_column(
        String(100),
        index=True,
        nullable=False
    )
    dataset_type: Mapped[str] = mapped_column(
        String(50),
        index=True,
        nullable=False
    )
    source_filename: Mapped[str] = mapped_column(
        String(255),
        nullable=False
    )
    content_hash: Mapped[str] = mapped_column(
        String(64),
        index=True,
        nullable=False
    )
    record_count: Mapped[int] = mapped_column(
        Integer,
        default=0,
        nullable=False
    )
    is_immutable: Mapped[bool] = mapped_column(
        Boolean,
        default=True,
        nullable=False
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        nullable=False
    )
    created_by_user_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("users.id", ondelete="SET NULL"),
        nullable=True
    )

    # Relationships
    cse: Mapped["CSE"] = relationship("CSE", back_populates="dataset_versions")
    assessment: Mapped["Assessment | None"] = relationship("Assessment", back_populates="dataset_versions")
    batch: Mapped["IngestionBatch | None"] = relationship("IngestionBatch", back_populates="dataset_versions")
    created_by_user: Mapped["User | None"] = relationship("User")
    analysis_runs: Mapped[List["AnalysisRun"]] = relationship(
        "AnalysisRun",
        back_populates="dataset_version",
        cascade="save-update, merge"
    )
