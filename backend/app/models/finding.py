import uuid
from datetime import datetime, timezone
from typing import List, Any, TYPE_CHECKING
from sqlalchemy import String, Text, DateTime, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.postgresql import UUID, JSONB
from app.db.base import Base

if TYPE_CHECKING:
    from app.models.cse import CSE
    from app.models.ingestion import IngestionBatch
    from app.models.alert import Alert
    from app.models.case import Case
    from app.models.investigation import Investigation
    from app.models.escalation import Escalation
    from app.models.coverage import MonitoringCoverage

class Finding(Base):
    """Derived Supervisory Finding Model."""
    __tablename__ = "findings"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4
    )
    finding_code: Mapped[str] = mapped_column(
        String(100),
        unique=True,
        index=True,
        nullable=False
    )
    cse_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("cses.id", ondelete="RESTRICT"),
        index=True,
        nullable=False
    )
    batch_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("ingestion_batches.id", ondelete="SET NULL"),
        index=True,
        nullable=True
    )
    analysis_run_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("analysis_runs.id", ondelete="SET NULL"),
        index=True,
        nullable=True
    )
    category: Mapped[str] = mapped_column(
        String(100),
        index=True,
        nullable=False
    )
    severity: Mapped[str] = mapped_column(
        String(50),
        index=True,
        nullable=False
    )
    title: Mapped[str] = mapped_column(
        String(255),
        nullable=False
    )
    description: Mapped[str] = mapped_column(
        Text,
        nullable=False
    )
    rationale: Mapped[str] = mapped_column(
        Text,
        nullable=False
    )
    detection_method: Mapped[str] = mapped_column(
        String(100),
        nullable=False
    )
    metrics_json: Mapped[dict[str, Any] | None] = mapped_column(
        JSONB,
        nullable=True
    )
    status: Mapped[str] = mapped_column(
        String(50),
        default="NEW",
        index=True,
        nullable=False
    )
    detected_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        index=True,
        nullable=False
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
        nullable=False
    )

    # Relationships
    cse: Mapped["CSE"] = relationship("CSE", back_populates="findings")
    batch: Mapped["IngestionBatch"] = relationship("IngestionBatch", back_populates="findings")
    analysis_run: Mapped["AnalysisRun | None"] = relationship("AnalysisRun", back_populates="findings")
    evidence_links: Mapped[List["FindingEvidence"]] = relationship(
        "FindingEvidence",
        back_populates="finding",
        cascade="all, delete-orphan"
    )

class FindingEvidence(Base):
    """Drill-Down Link Table connecting Findings to Underlying Operational Evidence."""
    __tablename__ = "finding_evidence"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4
    )
    finding_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("findings.id", ondelete="CASCADE"),
        index=True,
        nullable=False
    )
    evidence_type: Mapped[str] = mapped_column(
        String(50),
        index=True,
        nullable=False
    )
    alert_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("alerts.id", ondelete="SET NULL"),
        index=True,
        nullable=True
    )
    case_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("cases.id", ondelete="SET NULL"),
        index=True,
        nullable=True
    )
    investigation_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("investigations.id", ondelete="SET NULL"),
        index=True,
        nullable=True
    )
    escalation_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("escalations.id", ondelete="SET NULL"),
        index=True,
        nullable=True
    )
    coverage_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("monitoring_coverages.id", ondelete="SET NULL"),
        index=True,
        nullable=True
    )
    notes: Mapped[str | None] = mapped_column(
        Text,
        nullable=True
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        nullable=False
    )

    # Relationships
    finding: Mapped["Finding"] = relationship("Finding", back_populates="evidence_links")
    alert: Mapped["Alert"] = relationship("Alert", back_populates="finding_links")
    case: Mapped["Case"] = relationship("Case", back_populates="finding_links")
    investigation: Mapped["Investigation"] = relationship("Investigation", back_populates="finding_links")
    escalation: Mapped["Escalation"] = relationship("Escalation", back_populates="finding_links")
    coverage: Mapped["MonitoringCoverage"] = relationship("MonitoringCoverage", back_populates="finding_links")
