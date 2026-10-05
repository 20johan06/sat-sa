import 'package:equatable/equatable.dart';

class InvestigationEntity extends Equatable {
  final String id;
  final String caseId;
  final String investigationReference;
  final String? leadAnalyst;
  final String status;
  final String? summary;
  final DateTime startedAt;
  final DateTime? completedAt;

  const InvestigationEntity({
    required this.id,
    required this.caseId,
    required this.investigationReference,
    this.leadAnalyst,
    required this.status,
    this.summary,
    required this.startedAt,
    this.completedAt,
  });

  factory InvestigationEntity.fromJson(Map<String, dynamic> json) {
    return InvestigationEntity(
      id: json['id'] as String,
      caseId: json['case_id'] as String,
      investigationReference: json['investigation_reference'] as String,
      leadAnalyst: json['lead_analyst'] as String?,
      status: json['status'] as String? ?? 'ACTIVE',
      summary: json['summary'] as String?,
      startedAt: DateTime.parse(json['started_at'] as String).toUtc(),
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String).toUtc() : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'case_id': caseId,
        'investigation_reference': investigationReference,
        'lead_analyst': leadAnalyst,
        'status': status,
        'summary': summary,
        'started_at': startedAt.toIso8601String(),
        'completed_at': completedAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, caseId, investigationReference, leadAnalyst, status, startedAt];
}
