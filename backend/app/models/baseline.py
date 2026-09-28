import uuid
from datetime import datetime, timezone
from typing import Any
from sqlalchemy import String, Integer, Float, DateTime
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy.dialects.postgresql import UUID, JSONB
from app.db.base import Base

class PeerBaseline(Base):
    """Peer Group Benchmarking Baseline Model."""
    __tablename__ = "peer_baselines"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4
    )
    peer_group: Mapped[str] = mapped_column(
        String(100),
        index=True,
        nullable=False
    )
    metric_name: Mapped[str] = mapped_column(
        String(100),
        index=True,
        nullable=False
    )
    baseline_value: Mapped[float] = mapped_column(
        Float,
        nullable=False
    )
    min_value: Mapped[float | None] = mapped_column(
        Float,
        nullable=True
    )
    max_value: Mapped[float | None] = mapped_column(
        Float,
        nullable=True
    )
    sample_size: Mapped[int] = mapped_column(
        Integer,
        default=0,
        nullable=False
    )
    period_start: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False
    )
    period_end: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False
    )
    metadata_json: Mapped[dict[str, Any] | None] = mapped_column(
        JSONB,
        nullable=True
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        nullable=False
    )
