import pytest
from app.services.ingestion_validators import validate_file_security
from app.utils.exceptions import IngestionException, FileTooLargeException

def test_validate_file_security_valid():
    safe_name = validate_file_security("valid_alerts.csv", content_length=1000, max_bytes=52428800)
    assert safe_name == "valid_alerts.csv"

def test_validate_file_security_path_traversal():
    safe_name = validate_file_security("../../../etc/passwd.csv", content_length=500, max_bytes=52428800)
    assert safe_name == "passwd.csv"

def test_validate_file_security_windows_path_traversal():
    safe_name = validate_file_security("C:\\Windows\\System32\\config.json", content_length=500, max_bytes=52428800)
    assert safe_name == "config.json"

def test_validate_file_security_null_byte_attempt():
    with pytest.raises(IngestionException) as exc_info:
        validate_file_security("malicious.csv\x00.json", content_length=500, max_bytes=52428800)
    assert exc_info.value.code == "PATH_TRAVERSAL_ATTEMPT"

def test_validate_file_security_oversized_file():
    with pytest.raises(FileTooLargeException) as exc_info:
        validate_file_security("large_file.csv", content_length=100, max_bytes=50)
    assert exc_info.value.code == "FILE_TOO_LARGE"
    assert exc_info.value.status_code == 413

def test_validate_file_security_unsupported_extension():
    with pytest.raises(IngestionException) as exc_info:
        validate_file_security("exploit.exe", content_length=500, max_bytes=52428800)
    assert exc_info.value.code == "UNSUPPORTED_FORMAT"
