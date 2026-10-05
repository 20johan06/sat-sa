import 'package:equatable/equatable.dart';

class FindingEvidenceEntity extends Equatable {
  final String id;
  final String findingId;
  final String evidenceType;
  final String? alertId;
  final String? caseId;
  final String? investigationId;
  final String? escalationId;
  final String? coverageId;
  final String? notes;
  final DateTime createdAt;

  const FindingEvidenceEntity({
    required this.id,
    required this.findingId,
    required this.evidenceType,
    this.alertId,
    this.caseId,
    this.investigationId,
    this.escalationId,
    this.coverageId,
    this.notes,
    required this.createdAt,
  });

  factory FindingEvidenceEntity.fromJson(Map<String, dynamic> json) {
    return FindingEvidenceEntity(
      id: json['id'] as String,
      findingId: json['finding_id'] as String,
      evidenceType: json['evidence_type'] as String,
      alertId: json['alert_id'] as String?,
      caseId: json['case_id'] as String?,
      investigationId: json['investigation_id'] as String?,
      escalationId: json['escalation_id'] as String?,
      coverageId: json['coverage_id'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String).toUtc(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'finding_id': findingId,
        'evidence_type': evidenceType,
        'alert_id': alertId,
        'case_id': caseId,
        'investigation_id': investigationId,
        'escalation_id': escalationId,
        'coverage_id': coverageId,
        'notes': notes,
        'created_at': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, findingId, evidenceType, alertId, caseId, investigationId];
}
