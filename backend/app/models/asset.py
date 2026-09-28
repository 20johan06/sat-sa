import uuid
from datetime import datetime, timezone
from typing import List, TYPE_CHECKING
from sqlalchemy import String, DateTime, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.postgresql import UUID
from app.db.base import Base

if TYPE_CHECKING:
    from app.models.cse import CSE
    from app.models.alert import Alert

class Asset(Base):
    """Asset Inventory Model associated with a CSE."""
    __tablename__ = "assets"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4
    )
    cse_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("cses.id", ondelete="CASCADE"),
        index=True,
        nullable=False
    )
    asset_identifier: Mapped[str] = mapped_column(
        String(100),
        index=True,
        nullable=False
    )
    name: Mapped[str] = mapped_column(
        String(255),
        nullable=False
    )
    asset_type: Mapped[str] = mapped_column(
        String(100),
        default="SERVER",
        nullable=False
    )
    ip_address: Mapped[str | None] = mapped_column(
        String(45),
        nullable=True
    )
    hostname: Mapped[str | None] = mapped_column(
        String(255),
        nullable=True
    )
    criticality: Mapped[str] = mapped_column(
        String(50),
        default="MEDIUM",
        nullable=False
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        nullable=False
    )

    # Relationships
    cse: Mapped["CSE"] = relationship("CSE", back_populates="assets")
    alerts: Mapped[List["Alert"]] = relationship("Alert", back_populates="asset")
