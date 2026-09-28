import uuid
from datetime import datetime, timezone
from typing import List, TYPE_CHECKING
from sqlalchemy import String, Text, DateTime, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.postgresql import UUID
from app.db.base import Base

if TYPE_CHECKING:
    from app.models.cse import CSE
    from app.models.ingestion import IngestionBatch
    from app.models.alert import Alert
    from app.models.investigation import Investigation
    from app.models.escalation import Escalation
    from app.models.finding import FindingEvidence

class Case(Base):
    """Source Operational Case/Incident Model."""
    __tablename__ = "cases"

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
    batch_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("ingestion_batches.id", ondelete="SET NULL"),
        index=True,
        nullable=True
    )
    alert_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("alerts.id", ondelete="SET NULL"),
        index=True,
        nullable=True
    )
    external_case_id: Mapped[str] = mapped_column(
        String(100),
        index=True,
        nullable=False
    )
    title: Mapped[str] = mapped_column(
        String(255),
        nullable=False
    )
    status: Mapped[str] = mapped_column(
        String(50),
        index=True,
        nullable=False
    )
    priority: Mapped[str] = mapped_column(
        String(50),
        default="MEDIUM",
        nullable=False
    )
    summary: Mapped[str | None] = mapped_column(
        Text,
        nullable=True
    )
    opened_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        index=True,
        nullable=False
    )
    closed_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True),
        nullable=True
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        nullable=False
    )

    # Relationships
    cse: Mapped["CSE"] = relationship("CSE", back_populates="cases")
    batch: Mapped["IngestionBatch"] = relationship("IngestionBatch", back_populates="cases")
    alert: Mapped["Alert"] = relationship("Alert", back_populates="cases")
    investigations: Mapped[List["Investigation"]] = relationship("Investigation", back_populates="case", cascade="all, delete-orphan")
    escalations: Mapped[List["Escalation"]] = relationship("Escalation", back_populates="case", cascade="all, delete-orphan")
    finding_links: Mapped[List["FindingEvidence"]] = relationship("FindingEvidence", back_populates="case")
