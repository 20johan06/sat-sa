from typing import Optional, List
import uuid
from sqlalchemy.orm import Session
from sqlalchemy import select
from app.models.cse import CSE
from app.schemas.cse import CSECreate, CSEUpdate
from app.services.base import BaseService
from app.utils.exceptions import EntityNotFoundException, DuplicateEntityException

class CSEService(BaseService[CSE]):
    """Domain service managing Critical Sector Entities (CSEs)."""

    def __init__(self):
        super().__init__(CSE)

    def get_by_code(self, db: Session, cse_code: str) -> Optional[CSE]:
        stmt = select(CSE).where(CSE.cse_code == cse_code)
        return db.scalar(stmt)

    def create_cse(self, db: Session, cse_in: CSECreate) -> CSE:
        existing = self.get_by_code(db, cse_in.cse_code)
        if existing:
            raise DuplicateEntityException("CSE", "cse_code", cse_in.cse_code)
        
        return self.create(db, cse_in.model_dump())

    def get_cse_or_404(self, db: Session, cse_id: uuid.UUID) -> CSE:
        cse = self.get_by_id(db, cse_id)
        if not cse:
            raise EntityNotFoundException("CSE", cse_id)
        return cse

    def list_cses(self, db: Session, skip: int = 0, limit: int = 100) -> List[CSE]:
        return self.get_multi(db, skip=skip, limit=limit)

cse_service = CSEService()
