import 'package:equatable/equatable.dart';

class CaseEntity extends Equatable {
  final String id;
  final String cseId;
  final String? batchId;
  final String caseReference;
  final String title;
  final String severity;
  final String status;
  final String? assignedTeam;
  final DateTime openedAt;
  final DateTime? closedAt;
  final Map<String, dynamic>? detailsJson;

  const CaseEntity({
    required this.id,
    required this.cseId,
    this.batchId,
    required this.caseReference,
    required this.title,
    required this.severity,
    required this.status,
    this.assignedTeam,
    required this.openedAt,
    this.closedAt,
    this.detailsJson,
  });

  factory CaseEntity.fromJson(Map<String, dynamic> json) {
    return CaseEntity(
      id: json['id'] as String,
      cseId: json['cse_id'] as String,
      batchId: json['batch_id'] as String?,
      caseReference: json['case_reference'] as String,
      title: json['title'] as String,
      severity: json['severity'] as String,
      status: json['status'] as String? ?? 'OPEN',
      assignedTeam: json['assigned_team'] as String?,
      openedAt: DateTime.parse(json['opened_at'] as String).toUtc(),
      closedAt: json['closed_at'] != null ? DateTime.parse(json['closed_at'] as String).toUtc() : null,
      detailsJson: json['details_json'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cse_id': cseId,
        'batch_id': batchId,
        'case_reference': caseReference,
        'title': title,
        'severity': severity,
        'status': status,
        'assigned_team': assignedTeam,
        'opened_at': openedAt.toIso8601String(),
        'closed_at': closedAt?.toIso8601String(),
        'details_json': detailsJson,
      };

  @override
  List<Object?> get props => [id, cseId, caseReference, title, severity, status, openedAt, closedAt];
}
