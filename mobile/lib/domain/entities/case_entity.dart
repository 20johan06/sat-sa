import 'package:equatable/equatable.dart';

class CaseEntity extends Equatable {
  final String id;
  final String cseId;
  final String? batchId;
  final String? alertId;
  final String externalCaseId;
  final String title;
  final String status;
  final String priority;
  final String? summary;
  final DateTime openedAt;
  final DateTime? closedAt;
  final DateTime createdAt;

  const CaseEntity({
    required this.id,
    required this.cseId,
    this.batchId,
    this.alertId,
    required this.externalCaseId,
    required this.title,
    required this.status,
    required this.priority,
    this.summary,
    required this.openedAt,
    this.closedAt,
    required this.createdAt,
  });

  factory CaseEntity.fromJson(Map<String, dynamic> json) {
    return CaseEntity(
      id: json['id'] as String,
      cseId: json['cse_id'] as String,
      batchId: json['batch_id'] as String?,
      alertId: json['alert_id'] as String?,
      externalCaseId: json['external_case_id'] as String,
      title: json['title'] as String,
      status: json['status'] as String? ?? 'OPEN',
      priority: json['priority'] as String? ?? 'MEDIUM',
      summary: json['summary'] as String?,
      openedAt: DateTime.parse(json['opened_at'] as String).toUtc(),
      closedAt: json['closed_at'] != null ? DateTime.parse(json['closed_at'] as String).toUtc() : null,
      createdAt: DateTime.parse(json['created_at'] as String).toUtc(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cse_id': cseId,
        'batch_id': batchId,
        'alert_id': alertId,
        'external_case_id': externalCaseId,
        'title': title,
        'status': status,
        'priority': priority,
        'summary': summary,
        'opened_at': openedAt.toIso8601String(),
        'closed_at': closedAt?.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, cseId, externalCaseId, title, status, priority, openedAt, closedAt];
}

