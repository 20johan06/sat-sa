"""harden_cse_foreign_keys_restrict

Revision ID: 6dcb86c3031f
Revises: 3172ce1dc800
Create Date: 2026-09-28 22:35:10.114293

"""
from typing import Sequence, Union
from alembic import op

# revision identifiers, used by Alembic.
revision: str = '6dcb86c3031f'
down_revision: Union[str, None] = '3172ce1dc800'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.drop_constraint('alerts_cse_id_fkey', 'alerts', type_='foreignkey')
    op.create_foreign_key('alerts_cse_id_fkey', 'alerts', 'cses', ['cse_id'], ['id'], ondelete='RESTRICT')

    op.drop_constraint('cases_cse_id_fkey', 'cases', type_='foreignkey')
    op.create_foreign_key('cases_cse_id_fkey', 'cases', 'cses', ['cse_id'], ['id'], ondelete='RESTRICT')

    op.drop_constraint('findings_cse_id_fkey', 'findings', type_='foreignkey')
    op.create_foreign_key('findings_cse_id_fkey', 'findings', 'cses', ['cse_id'], ['id'], ondelete='RESTRICT')

    op.drop_constraint('ingestion_batches_cse_id_fkey', 'ingestion_batches', type_='foreignkey')
    op.create_foreign_key('ingestion_batches_cse_id_fkey', 'ingestion_batches', 'cses', ['cse_id'], ['id'], ondelete='RESTRICT')

    op.drop_constraint('monitoring_coverages_cse_id_fkey', 'monitoring_coverages', type_='foreignkey')
    op.create_foreign_key('monitoring_coverages_cse_id_fkey', 'monitoring_coverages', 'cses', ['cse_id'], ['id'], ondelete='RESTRICT')


def downgrade() -> None:
    op.drop_constraint('monitoring_coverages_cse_id_fkey', 'monitoring_coverages', type_='foreignkey')
    op.create_foreign_key('monitoring_coverages_cse_id_fkey', 'monitoring_coverages', 'cses', ['cse_id'], ['id'], ondelete='CASCADE')

    op.drop_constraint('ingestion_batches_cse_id_fkey', 'ingestion_batches', type_='foreignkey')
    op.create_foreign_key('ingestion_batches_cse_id_fkey', 'ingestion_batches', 'cses', ['cse_id'], ['id'], ondelete='CASCADE')

    op.drop_constraint('findings_cse_id_fkey', 'findings', type_='foreignkey')
    op.create_foreign_key('findings_cse_id_fkey', 'findings', 'cses', ['cse_id'], ['id'], ondelete='CASCADE')

    op.drop_constraint('cases_cse_id_fkey', 'cases', type_='foreignkey')
    op.create_foreign_key('cases_cse_id_fkey', 'cases', 'cses', ['cse_id'], ['id'], ondelete='CASCADE')

    op.drop_constraint('alerts_cse_id_fkey', 'alerts', type_='foreignkey')
    op.create_foreign_key('alerts_cse_id_fkey', 'alerts', 'cses', ['cse_id'], ['id'], ondelete='CASCADE')
