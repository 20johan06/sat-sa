import uuid
from datetime import datetime, timezone
from typing import List, TYPE_CHECKING
from sqlalchemy import String, Boolean, Float, DateTime, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.postgresql import UUID
from app.db.base import Base

if TYPE_CHECKING:
    from app.models.cse import CSE
    from app.models.finding import FindingEvidence

class MonitoringCoverage(Base):
    """Expected & Active Log Source Coverage Context for Negative Space Analysis."""
    __tablename__ = "monitoring_coverages"

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
    log_source_category: Mapped[str] = mapped_column(
        String(100),
        index=True,
        nullable=False
    )
    is_expected: Mapped[bool] = mapped_column(
        Boolean,
        default=True,
        nullable=False
    )
    is_active: Mapped[bool] = mapped_column(
        Boolean,
        default=True,
        nullable=False
    )
    last_received_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True),
        nullable=True
    )
    coverage_percentage: Mapped[float | None] = mapped_column(
        Float,
        nullable=True
    )
    period_start: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True),
        nullable=True
    )
    period_end: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True),
        nullable=True
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        nullable=False
    )

    # Relationships
    cse: Mapped["CSE"] = relationship("CSE", back_populates="monitoring_coverages")
    finding_links: Mapped[List["FindingEvidence"]] = relationship("FindingEvidence", back_populates="coverage")
