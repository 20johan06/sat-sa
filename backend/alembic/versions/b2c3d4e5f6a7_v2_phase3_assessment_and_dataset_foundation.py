"""v2_phase3_assessment_and_dataset_foundation

Revision ID: b2c3d4e5f6a7
Revises: a1b2c3d4e5f6
Create Date: 2026-09-29 20:55:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = 'b2c3d4e5f6a7'
down_revision: Union[str, None] = 'a1b2c3d4e5f6'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # 1. Create assessments table
    op.create_table(
        'assessments',
        sa.Column('id', postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column('cse_id', postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column('name', sa.String(length=255), nullable=False),
        sa.Column('description', sa.Text(), nullable=True),
        sa.Column('period_start', sa.DateTime(timezone=True), nullable=False),
        sa.Column('period_end', sa.DateTime(timezone=True), nullable=False),
        sa.Column('status', sa.String(length=50), nullable=False, server_default='DRAFT'),
        sa.Column('created_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('updated_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('created_by_user_id', postgresql.UUID(as_uuid=True), nullable=True),
        sa.ForeignKeyConstraint(['cse_id'], ['cses.id'], ondelete='RESTRICT'),
        sa.ForeignKeyConstraint(['created_by_user_id'], ['users.id'], ondelete='SET NULL'),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_assessments_cse_id'), 'assessments', ['cse_id'], unique=False)
    op.create_index(op.f('ix_assessments_period_start'), 'assessments', ['period_start'], unique=False)
    op.create_index(op.f('ix_assessments_period_end'), 'assessments', ['period_end'], unique=False)
    op.create_index(op.f('ix_assessments_status'), 'assessments', ['status'], unique=False)

    # 2. Create dataset_versions table
    op.create_table(
        'dataset_versions',
        sa.Column('id', postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column('cse_id', postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column('assessment_id', postgresql.UUID(as_uuid=True), nullable=True),
        sa.Column('batch_id', postgresql.UUID(as_uuid=True), nullable=True),
        sa.Column('version_tag', sa.String(length=100), nullable=False),
        sa.Column('dataset_type', sa.String(length=50), nullable=False),
        sa.Column('source_filename', sa.String(length=255), nullable=False),
        sa.Column('content_hash', sa.String(length=64), nullable=False),
        sa.Column('record_count', sa.Integer(), nullable=False, server_default='0'),
        sa.Column('is_immutable', sa.Boolean(), nullable=False, server_default='true'),
        sa.Column('created_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('created_by_user_id', postgresql.UUID(as_uuid=True), nullable=True),
        sa.ForeignKeyConstraint(['cse_id'], ['cses.id'], ondelete='RESTRICT'),
        sa.ForeignKeyConstraint(['assessment_id'], ['assessments.id'], ondelete='SET NULL'),
        sa.ForeignKeyConstraint(['batch_id'], ['ingestion_batches.id'], ondelete='SET NULL'),
        sa.ForeignKeyConstraint(['created_by_user_id'], ['users.id'], ondelete='SET NULL'),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_dataset_versions_cse_id'), 'dataset_versions', ['cse_id'], unique=False)
    op.create_index(op.f('ix_dataset_versions_assessment_id'), 'dataset_versions', ['assessment_id'], unique=False)
    op.create_index(op.f('ix_dataset_versions_batch_id'), 'dataset_versions', ['batch_id'], unique=False)
    op.create_index(op.f('ix_dataset_versions_version_tag'), 'dataset_versions', ['version_tag'], unique=False)
    op.create_index(op.f('ix_dataset_versions_dataset_type'), 'dataset_versions', ['dataset_type'], unique=False)
    op.create_index(op.f('ix_dataset_versions_content_hash'), 'dataset_versions', ['content_hash'], unique=False)

    # 3. Create analysis_runs table
    op.create_table(
        'analysis_runs',
        sa.Column('id', postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column('cse_id', postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column('assessment_id', postgresql.UUID(as_uuid=True), nullable=True),
        sa.Column('dataset_version_id', postgresql.UUID(as_uuid=True), nullable=True),
        sa.Column('obs_start', sa.DateTime(timezone=True), nullable=True),
        sa.Column('obs_end', sa.DateTime(timezone=True), nullable=True),
        sa.Column('engine_version', sa.String(length=100), nullable=False, server_default='v2.0.0-phase5-canonical'),
        sa.Column('rules_evaluated', postgresql.JSONB(astext_type=sa.Text()), nullable=False),
        sa.Column('status', sa.String(length=50), nullable=False, server_default='PENDING'),
        sa.Column('findings_created', sa.Integer(), nullable=False, server_default='0'),
        sa.Column('baselines_persisted', sa.Integer(), nullable=False, server_default='0'),
        sa.Column('error_message', sa.Text(), nullable=True),
        sa.Column('started_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('completed_at', sa.DateTime(timezone=True), nullable=True),
        sa.Column('executed_by_user_id', postgresql.UUID(as_uuid=True), nullable=True),
        sa.ForeignKeyConstraint(['cse_id'], ['cses.id'], ondelete='RESTRICT'),
        sa.ForeignKeyConstraint(['assessment_id'], ['assessments.id'], ondelete='SET NULL'),
        sa.ForeignKeyConstraint(['dataset_version_id'], ['dataset_versions.id'], ondelete='SET NULL'),
        sa.ForeignKeyConstraint(['executed_by_user_id'], ['users.id'], ondelete='SET NULL'),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_analysis_runs_cse_id'), 'analysis_runs', ['cse_id'], unique=False)
    op.create_index(op.f('ix_analysis_runs_assessment_id'), 'analysis_runs', ['assessment_id'], unique=False)
    op.create_index(op.f('ix_analysis_runs_dataset_version_id'), 'analysis_runs', ['dataset_version_id'], unique=False)
    op.create_index(op.f('ix_analysis_runs_status'), 'analysis_runs', ['status'], unique=False)

    # 4. Add nullable analysis_run_id to findings table
    op.add_column('findings', sa.Column('analysis_run_id', postgresql.UUID(as_uuid=True), nullable=True))
    op.create_foreign_key('fk_findings_analysis_run_id', 'findings', 'analysis_runs', ['analysis_run_id'], ['id'], ondelete='SET NULL')
    op.create_index(op.f('ix_findings_analysis_run_id'), 'findings', ['analysis_run_id'], unique=False)


def downgrade() -> None:
    op.drop_index(op.f('ix_findings_analysis_run_id'), table_name='findings')
    op.drop_constraint('fk_findings_analysis_run_id', 'findings', type_='foreignkey')
    op.drop_column('findings', 'analysis_run_id')

    op.drop_index(op.f('ix_analysis_runs_status'), table_name='analysis_runs')
    op.drop_index(op.f('ix_analysis_runs_dataset_version_id'), table_name='analysis_runs')
    op.drop_index(op.f('ix_analysis_runs_assessment_id'), table_name='analysis_runs')
    op.drop_index(op.f('ix_analysis_runs_cse_id'), table_name='analysis_runs')
    op.drop_table('analysis_runs')

    op.drop_index(op.f('ix_dataset_versions_content_hash'), table_name='dataset_versions')
    op.drop_index(op.f('ix_dataset_versions_dataset_type'), table_name='dataset_versions')
    op.drop_index(op.f('ix_dataset_versions_version_tag'), table_name='dataset_versions')
    op.drop_index(op.f('ix_dataset_versions_batch_id'), table_name='dataset_versions')
    op.drop_index(op.f('ix_dataset_versions_assessment_id'), table_name='dataset_versions')
    op.drop_index(op.f('ix_dataset_versions_cse_id'), table_name='dataset_versions')
    op.drop_table('dataset_versions')

    op.drop_index(op.f('ix_assessments_status'), table_name='assessments')
    op.drop_index(op.f('ix_assessments_period_end'), table_name='assessments')
    op.drop_index(op.f('ix_assessments_period_start'), table_name='assessments')
    op.drop_index(op.f('ix_assessments_cse_id'), table_name='assessments')
    op.drop_table('assessments')
