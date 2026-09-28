import uuid
from datetime import datetime, timezone
from typing import List, Any, TYPE_CHECKING
from sqlalchemy import String, DateTime, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.postgresql import UUID, JSONB
from app.db.base import Base

if TYPE_CHECKING:
    from app.models.cse import CSE
    from app.models.ingestion import IngestionBatch
    from app.models.asset import Asset
    from app.models.case import Case
    from app.models.escalation import Escalation
    from app.models.finding import FindingEvidence

class Alert(Base):
    """Source Operational Security Alert Model."""
    __tablename__ = "alerts"

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
    asset_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("assets.id", ondelete="SET NULL"),
        index=True,
        nullable=True
    )
    external_alert_id: Mapped[str] = mapped_column(
        String(100),
        index=True,
        nullable=False
    )
    title: Mapped[str] = mapped_column(
        String(255),
        nullable=False
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
    status: Mapped[str] = mapped_column(
        String(50),
        index=True,
        nullable=False
    )
    disposition: Mapped[str | None] = mapped_column(
        String(100),
        nullable=True
    )
    target_asset_name: Mapped[str | None] = mapped_column(
        String(255),
        nullable=True
    )
    detected_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        index=True,
        nullable=False
    )
    closed_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True),
        nullable=True
    )
    raw_metadata: Mapped[dict[str, Any] | None] = mapped_column(
        JSONB,
        nullable=True
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        nullable=False
    )

    # Relationships
    cse: Mapped["CSE"] = relationship("CSE", back_populates="alerts")
    batch: Mapped["IngestionBatch"] = relationship("IngestionBatch", back_populates="alerts")
    asset: Mapped["Asset"] = relationship("Asset", back_populates="alerts")
    cases: Mapped[List["Case"]] = relationship("Case", back_populates="alert")
    escalations: Mapped[List["Escalation"]] = relationship("Escalation", back_populates="alert")
    finding_links: Mapped[List["FindingEvidence"]] = relationship("FindingEvidence", back_populates="alert")
