"""v2_phase4_data_quality_reporting

Revision ID: c3d4e5f6a7b8
Revises: b2c3d4e5f6a7
Create Date: 2026-09-29 21:50:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = 'c3d4e5f6a7b8'
down_revision: Union[str, None] = 'b2c3d4e5f6a7'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Add quality_report JSONB and assessment_id FK to ingestion_batches
    op.add_column('ingestion_batches', sa.Column('quality_report', postgresql.JSONB(astext_type=sa.Text()), nullable=True))
    op.add_column('ingestion_batches', sa.Column('assessment_id', postgresql.UUID(as_uuid=True), nullable=True))
    op.create_foreign_key('fk_ingestion_batches_assessment_id', 'ingestion_batches', 'assessments', ['assessment_id'], ['id'], ondelete='SET NULL')
    op.create_index(op.f('ix_ingestion_batches_assessment_id'), 'ingestion_batches', ['assessment_id'], unique=False)


def downgrade() -> None:
    op.drop_index(op.f('ix_ingestion_batches_assessment_id'), table_name='ingestion_batches')
    op.drop_constraint('fk_ingestion_batches_assessment_id', 'ingestion_batches', type_='foreignkey')
    op.drop_column('ingestion_batches', 'assessment_id')
    op.drop_column('ingestion_batches', 'quality_report')
