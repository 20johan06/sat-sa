import pytest
from app.services.ingestion_parsers import CSVIngestionParser, JSONIngestionParser
from app.utils.exceptions import IngestionException

def test_csv_parser_valid():
    parser = CSVIngestionParser()
    csv_bytes = (
        b"external_alert_id,title,category,severity,status,detected_at\n"
        b"ALT-1001,Suspicious Login,AUTHENTICATION,HIGH,OPEN,2026-09-28T12:00:00Z\n"
        b"ALT-1002,Malware Detected,ENDPOINT,CRITICAL,CLOSED,2026-09-28T12:05:00Z\n"
    )
    records = parser.parse(csv_bytes)
    assert len(records) == 2
    assert records[0]["external_alert_id"] == "ALT-1001"
    assert records[0]["severity"] == "HIGH"
    assert records[1]["external_alert_id"] == "ALT-1002"

def test_csv_parser_preserves_evidentiary_strings():
    """Verify raw strings (including special chars) are preserved exactly without formula alteration."""
    parser = CSVIngestionParser()
    csv_bytes = (
        b"external_alert_id,title,category,severity,status,detected_at\n"
        b"ALT-1003,=SUM(1+2),COMMAND_INJECTION,HIGH,OPEN,2026-09-28T12:00:00Z\n"
    )
    records = parser.parse(csv_bytes)
    assert records[0]["title"] == "=SUM(1+2)"  # Preserves exact evidentiary value

def test_csv_parser_empty_file():
    parser = CSVIngestionParser()
    with pytest.raises(IngestionException) as exc_info:
        parser.parse(b"")
    assert exc_info.value.code == "EMPTY_FILE"

def test_csv_parser_invalid_encoding():
    parser = CSVIngestionParser()
    invalid_bytes = b"\x80\x81\x82\xff\xfe"
    with pytest.raises(IngestionException) as exc_info:
        parser.parse(invalid_bytes)
    assert exc_info.value.code == "INVALID_ENCODING"

def test_json_parser_valid_array():
    parser = JSONIngestionParser()
    json_bytes = b'[{"external_case_id": "CASE-101", "title": "Phishing Attempt", "status": "OPEN", "opened_at": "2026-09-28T10:00:00Z"}]'
    records = parser.parse(json_bytes)
    assert len(records) == 1
    assert records[0]["external_case_id"] == "CASE-101"

def test_json_parser_wrapped_object():
    parser = JSONIngestionParser()
    json_bytes = b'{"records": [{"log_source_category": "FIREWALL", "is_expected": true}]}'
    records = parser.parse(json_bytes)
    assert len(records) == 1
    assert records[0]["log_source_category"] == "FIREWALL"

def test_json_parser_malformed():
    parser = JSONIngestionParser()
    with pytest.raises(IngestionException) as exc_info:
        parser.parse(b'{"invalid_json": ')
    assert exc_info.value.code == "MALFORMED_JSON"
