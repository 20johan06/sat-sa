import 'package:equatable/equatable.dart';

class InvestigationEntity extends Equatable {
  final String id;
  final String caseId;
  final String? externalInvestigationId;
  final String? investigatorRef;
  final String actionType;
  final String? notes;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int evidenceCount;
  final DateTime createdAt;

  const InvestigationEntity({
    required this.id,
    required this.caseId,
    this.externalInvestigationId,
    this.investigatorRef,
    required this.actionType,
    this.notes,
    required this.startedAt,
    this.completedAt,
    required this.evidenceCount,
    required this.createdAt,
  });

  factory InvestigationEntity.fromJson(Map<String, dynamic> json) {
    return InvestigationEntity(
      id: json['id'] as String,
      caseId: json['case_id'] as String,
      externalInvestigationId: json['external_investigation_id'] as String?,
      investigatorRef: json['investigator_ref'] as String?,
      actionType: json['action_type'] as String,
      notes: json['notes'] as String?,
      startedAt: DateTime.parse(json['started_at'] as String).toUtc(),
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String).toUtc() : null,
      evidenceCount: json['evidence_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String).toUtc(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'case_id': caseId,
        'external_investigation_id': externalInvestigationId,
        'investigator_ref': investigatorRef,
        'action_type': actionType,
        'notes': notes,
        'started_at': startedAt.toIso8601String(),
        'completed_at': completedAt?.toIso8601String(),
        'evidence_count': evidenceCount,
        'created_at': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, caseId, externalInvestigationId, investigatorRef, actionType, startedAt];
}

