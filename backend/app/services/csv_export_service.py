import io
import csv
from typing import Dict, Any

class CSVExportService:
    """
    Generates tabular evidence-oriented CSV export for SAT-SA supervisory reports.
    Mandates LEFT OUTER JOIN logic so findings with zero direct evidence records
    are preserved as valid rows rather than silently omitted.
    """

    @staticmethod
    def generate_evidence_csv(report_data: Dict[str, Any]) -> str:
        output = io.StringIO()
        writer = csv.writer(output)

        # CSV Header
        header = [
            "report_id",
            "report_code",
            "cse_code",
            "cse_name",
            "sector",
            "criticality_tier",
            "finding_id",
            "finding_code",
            "category",
            "severity",
            "finding_status",
            "detected_at",
            "finding_title",
            "finding_description",
            "finding_rationale",
            "detection_method",
            "metrics_json",
            "evidence_id",
            "evidence_type",
            "evidence_record_id",
            "evidence_notes",
            "capability_dimension",
            "examiner_disposition",
            "examiner_last_note",
            "examiner_username",
            "examiner_updated_at",
        ]
        writer.writerow(header)

        meta = report_data.get("report_metadata", {})
        report_id = meta.get("report_id", "")
        report_code = meta.get("report_code", report_id)
        cse_code = meta.get("cse_code", "")
        cse_name = meta.get("cse_name", "")
        sector = meta.get("sector", "")
        criticality_tier = meta.get("criticality_tier", "")

        findings = report_data.get("active_findings", [])
        capability_map = report_data.get("capability_finding_mapping", {})

        for f in findings:
            f_id = str(f.get("id", ""))
            f_code = f.get("finding_code", "")
            cat = f.get("category", "")
            sev = f.get("severity", "")
            status = f.get("status", "")
            detected_at = f.get("detected_at", "")
            title = f.get("title", "")
            desc = f.get("description", "")
            rationale = f.get("rationale", "")
            method = f.get("detection_method", "")
            metrics = str(f.get("metrics_json", {}))

            # Capability lookup
            cap_dim = capability_map.get(f_id, "UNASSIGNED")

            # Examiner review history info
            rev_history = f.get("review_history", [])
            last_rev = rev_history[0] if rev_history else {}
            examiner_disposition = last_rev.get("new_status", status)
            examiner_note = last_rev.get("note_text", "")
            examiner_user = last_rev.get("username", "")
            examiner_time = last_rev.get("created_at", "")

            evidence_list = f.get("evidence", [])

            if evidence_list:
                # One row per evidence item
                for ev in evidence_list:
                    ev_id = str(ev.get("id", ""))
                    ev_type = ev.get("evidence_type", "")
                    ev_rec_id = str(ev.get("evidence_record_id", ""))
                    ev_notes = ev.get("notes", "")

                    writer.writerow([
                        report_id,
                        report_code,
                        cse_code,
                        cse_name,
                        sector,
                        criticality_tier,
                        f_id,
                        f_code,
                        cat,
                        sev,
                        status,
                        detected_at,
                        title,
                        desc,
                        rationale,
                        method,
                        metrics,
                        ev_id,
                        ev_type,
                        ev_rec_id,
                        ev_notes,
                        cap_dim,
                        examiner_disposition,
                        examiner_note,
                        examiner_user,
                        examiner_time,
                    ])
            else:
                # LEFT OUTER JOIN: Zero-evidence finding is preserved as 1 row with empty evidence fields
                writer.writerow([
                    report_id,
                    report_code,
                    cse_code,
                    cse_name,
                    sector,
                    criticality_tier,
                    f_id,
                    f_code,
                    cat,
                    sev,
                    status,
                    detected_at,
                    title,
                    desc,
                    rationale,
                    method,
                    metrics,
                    "", # evidence_id
                    "", # evidence_type
                    "", # evidence_record_id
                    "", # evidence_notes
                    cap_dim,
                    examiner_disposition,
                    examiner_note,
                    examiner_user,
                    examiner_time,
                ])

        return output.getvalue()
