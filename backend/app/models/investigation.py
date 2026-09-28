import uuid
from datetime import datetime, timezone
from typing import List, TYPE_CHECKING
from sqlalchemy import String, Integer, Text, DateTime, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.postgresql import UUID
from app.db.base import Base

if TYPE_CHECKING:
    from app.models.case import Case
    from app.models.finding import FindingEvidence

class Investigation(Base):
    """Investigation Actions & Workflow Evidence Model."""
    __tablename__ = "investigations"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4
    )
    case_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("cases.id", ondelete="CASCADE"),
        index=True,
        nullable=False
    )
    external_investigation_id: Mapped[str | None] = mapped_column(
        String(100),
        nullable=True
    )
    investigator_ref: Mapped[str | None] = mapped_column(
        String(100),
        nullable=True
    )
    action_type: Mapped[str] = mapped_column(
        String(100),
        nullable=False
    )
    notes: Mapped[str | None] = mapped_column(
        Text,
        nullable=True
    )
    started_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        index=True,
        nullable=False
    )
    completed_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True),
        nullable=True
    )
    evidence_count: Mapped[int] = mapped_column(
        Integer,
        default=0,
        nullable=False
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        nullable=False
    )

    # Relationships
    case: Mapped["Case"] = relationship("Case", back_populates="investigations")
    finding_links: Mapped[List["FindingEvidence"]] = relationship("FindingEvidence", back_populates="investigation")
