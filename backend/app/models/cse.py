import uuid
from datetime import datetime, timezone
from typing import List, TYPE_CHECKING
from sqlalchemy import String, Boolean, DateTime
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.postgresql import UUID
from app.db.base import Base

if TYPE_CHECKING:
    from app.models.asset import Asset
    from app.models.ingestion import IngestionBatch
    from app.models.alert import Alert
    from app.models.case import Case
    from app.models.coverage import MonitoringCoverage
    from app.models.finding import Finding

class CSE(Base):
    """Critical Sector Entity (CSE) Model."""
    __tablename__ = "cses"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4
    )
    cse_code: Mapped[str] = mapped_column(
        String(50),
        unique=True,
        index=True,
        nullable=False
    )
    name: Mapped[str] = mapped_column(
        String(255),
        nullable=False
    )
    sector: Mapped[str] = mapped_column(
        String(100),
        index=True,
        nullable=False
    )
    criticality_tier: Mapped[str] = mapped_column(
        String(50),
        default="TIER_1",
        nullable=False
    )
    contact_email: Mapped[str | None] = mapped_column(
        String(255),
        nullable=True
    )
    is_active: Mapped[bool] = mapped_column(
        Boolean,
        default=True,
        nullable=False
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        nullable=False
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
        nullable=False
    )

    # Relationships
    # Assets belong directly to CSE metadata and can be cascade deleted on CSE removal
    assets: Mapped[List["Asset"]] = relationship(
        "Asset",
        back_populates="cse",
        cascade="all, delete-orphan"
    )
    # Operational evidence, provenance records, and findings MUST NOT be automatically deleted on CSE removal
    ingestion_batches: Mapped[List["IngestionBatch"]] = relationship(
        "IngestionBatch",
        back_populates="cse",
        cascade="save-update, merge"
    )
    alerts: Mapped[List["Alert"]] = relationship(
        "Alert",
        back_populates="cse",
        cascade="save-update, merge"
    )
    cases: Mapped[List["Case"]] = relationship(
        "Case",
        back_populates="cse",
        cascade="save-update, merge"
    )
    monitoring_coverages: Mapped[List["MonitoringCoverage"]] = relationship(
        "MonitoringCoverage",
        back_populates="cse",
        cascade="save-update, merge"
    )
    findings: Mapped[List["Finding"]] = relationship(
        "Finding",
        back_populates="cse",
        cascade="save-update, merge"
    )
    assessments: Mapped[List["Assessment"]] = relationship(
        "Assessment",
        back_populates="cse",
        cascade="save-update, merge"
    )
    dataset_versions: Mapped[List["DatasetVersion"]] = relationship(
        "DatasetVersion",
        back_populates="cse",
        cascade="save-update, merge"
    )
    analysis_runs: Mapped[List["AnalysisRun"]] = relationship(
        "AnalysisRun",
        back_populates="cse",
        cascade="save-update, merge"
    )
