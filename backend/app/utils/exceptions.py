class SATSAException(Exception):
    """Base exception class for SAT-SA application errors."""
    def __init__(self, message: str, code: str = "INTERNAL_ERROR", status_code: int = 500, details: any = None):
        self.message = message
        self.code = code
        self.status_code = status_code
        self.details = details
        super().__init__(message)

class EntityNotFoundException(SATSAException):
    def __init__(self, entity_name: str, identifier: any):
        super().__init__(
            message=f"{entity_name} with identifier '{identifier}' was not found.",
            code="ENTITY_NOT_FOUND",
            status_code=404
        )

class DuplicateEntityException(SATSAException):
    def __init__(self, entity_name: str, field_name: str, value: any):
        super().__init__(
            message=f"{entity_name} with {field_name} '{value}' already exists.",
            code="DUPLICATE_ENTITY",
            status_code=409
        )

class ValidationException(SATSAException):
    def __init__(self, message: str, details: any = None):
        super().__init__(
            message=message,
            code="VALIDATION_ERROR",
            status_code=422,
            details=details
        )
