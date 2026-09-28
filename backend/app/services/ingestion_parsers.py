import csv
import io
import json
from abc import ABC, abstractmethod
from typing import List, Dict, Any
from app.utils.exceptions import IngestionException

class BaseIngestionParser(ABC):
    """Abstract Base Class for Data Ingestion Parsers."""

    @abstractmethod
    def parse(self, content: bytes) -> List[Dict[str, Any]]:
        """Parse raw content bytes into a list of record dictionaries."""
        pass


class CSVIngestionParser(BaseIngestionParser):
    """Parser for CSV operational data files."""

    def parse(self, content: bytes) -> List[Dict[str, Any]]:
        if not content or len(content.strip()) == 0:
            raise IngestionException("CSV content is empty.", code="EMPTY_FILE", status_code=400)

        try:
            text = content.decode("utf-8")
        except UnicodeDecodeError as e:
            raise IngestionException(
                f"Invalid file encoding: File must be valid UTF-8 encoded text. Details: {str(e)}",
                code="INVALID_ENCODING",
                status_code=400
            )

        stream = io.StringIO(text)
        try:
            reader = csv.DictReader(stream)
            if reader.fieldnames is None or len(reader.fieldnames) == 0:
                raise IngestionException("CSV file contains no headers.", code="MALFORMED_CSV", status_code=400)
            
            records: List[Dict[str, Any]] = []
            for row_idx, row in enumerate(reader, start=1):
                # Clean keys (headers) if whitespace present, preserve values exactly as received
                cleaned_row = {}
                for k, v in row.items():
                    if k is None:
                        continue
                    cleaned_row[k.strip()] = v
                records.append(cleaned_row)

            if len(records) == 0:
                raise IngestionException("CSV file contains headers but no data rows.", code="EMPTY_DATASET", status_code=400)

            return records
        except csv.Error as e:
            raise IngestionException(f"Malformed CSV structure: {str(e)}", code="MALFORMED_CSV", status_code=400)


class JSONIngestionParser(BaseIngestionParser):
    """Parser for JSON operational data files."""

    def parse(self, content: bytes) -> List[Dict[str, Any]]:
        if not content or len(content.strip()) == 0:
            raise IngestionException("JSON content is empty.", code="EMPTY_FILE", status_code=400)

        try:
            text = content.decode("utf-8")
        except UnicodeDecodeError as e:
            raise IngestionException(
                f"Invalid file encoding: File must be valid UTF-8 encoded text. Details: {str(e)}",
                code="INVALID_ENCODING",
                status_code=400
            )

        try:
            data = json.loads(text)
        except json.JSONDecodeError as e:
            raise IngestionException(
                f"Invalid JSON format: {str(e)}",
                code="MALFORMED_JSON",
                status_code=400
            )

        if isinstance(data, list):
            if len(data) == 0:
                raise IngestionException("JSON array dataset is empty.", code="EMPTY_DATASET", status_code=400)
            for idx, item in enumerate(data):
                if not isinstance(item, dict):
                    raise IngestionException(
                        f"Invalid JSON record at index {idx}: expected JSON object, got {type(item).__name__}.",
                        code="INVALID_RECORD_STRUCTURE",
                        status_code=400
                    )
            return data

        elif isinstance(data, dict):
            # Check if dict wraps records under 'records', 'items', 'data' or is a single object
            if "records" in data and isinstance(data["records"], list):
                return self._process_dict_list(data["records"])
            elif "items" in data and isinstance(data["items"], list):
                return self._process_dict_list(data["items"])
            elif "data" in data and isinstance(data["data"], list):
                return self._process_dict_list(data["data"])
            else:
                # Treated as a single record
                return [data]

        else:
            raise IngestionException(
                f"JSON content must be a list of objects or a root object containing a list of records. Got {type(data).__name__}.",
                code="UNSUPPORTED_JSON_STRUCTURE",
                status_code=400
            )

    def _process_dict_list(self, items: list) -> List[Dict[str, Any]]:
        if len(items) == 0:
            raise IngestionException("JSON array dataset is empty.", code="EMPTY_DATASET", status_code=400)
        for idx, item in enumerate(items):
            if not isinstance(item, dict):
                raise IngestionException(
                    f"Invalid JSON record at index {idx}: expected JSON object.",
                    code="INVALID_RECORD_STRUCTURE",
                    status_code=400
                )
        return items
