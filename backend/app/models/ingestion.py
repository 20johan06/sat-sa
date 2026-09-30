import uuid
from datetime import datetime, timezone
from typing import List, TYPE_CHECKING
from sqlalchemy import String, Integer, Text, DateTime, ForeignKey, JSON
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.postgresql import UUID, JSONB
from app.db.base import Base

if TYPE_CHECKING:
    from app.models.cse import CSE
    from app.models.alert import Alert
    from app.models.case import Case
    from app.models.finding import Finding
    from app.models.assessment import Assessment

class IngestionBatch(Base):
    """Metadata and provenance record for imported data batches."""
    __tablename__ = "ingestion_batches"

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
    batch_reference: Mapped[str] = mapped_column(
        String(100),
        unique=True,
        index=True,
        nullable=False
    )
    source_type: Mapped[str] = mapped_column(
        String(50),
        default="CSV",
        nullable=False
    )
    source_filename: Mapped[str] = mapped_column(
        String(255),
        nullable=False
    )
    total_records: Mapped[int] = mapped_column(
        Integer,
        default=0,
        nullable=False
    )
    valid_records: Mapped[int] = mapped_column(
        Integer,
        default=0,
        nullable=False
    )
    rejected_records: Mapped[int] = mapped_column(
        Integer,
        default=0,
        nullable=False
    )
    status: Mapped[str] = mapped_column(
        String(50),
        default="PENDING",
        index=True,
        nullable=False
    )
    error_summary: Mapped[str | None] = mapped_column(
        Text,
        nullable=True
    )
    quality_report: Mapped[dict | None] = mapped_column(
        JSONB,
        nullable=True
    )
    assessment_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("assessments.id", ondelete="SET NULL"),
        index=True,
        nullable=True
    )
    imported_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        nullable=False
    )

    # Relationships
    cse: Mapped["CSE"] = relationship("CSE", back_populates="ingestion_batches")
    alerts: Mapped[List["Alert"]] = relationship("Alert", back_populates="batch")
    cases: Mapped[List["Case"]] = relationship("Case", back_populates="batch")
    findings: Mapped[List["Finding"]] = relationship("Finding", back_populates="batch")
    dataset_versions: Mapped[List["DatasetVersion"]] = relationship("DatasetVersion", back_populates="batch")
    assessment: Mapped["Assessment | None"] = relationship("Assessment")

