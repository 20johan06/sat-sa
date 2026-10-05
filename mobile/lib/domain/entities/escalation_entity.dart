import 'package:equatable/equatable.dart';

class EscalationEntity extends Equatable {
  final String id;
  final String caseId;
  final String? alertId;
  final String escalationLevel;
  final String? reason;
  final String status;
  final DateTime escalatedAt;
  final DateTime createdAt;

  const EscalationEntity({
    required this.id,
    required this.caseId,
    this.alertId,
    required this.escalationLevel,
    this.reason,
    required this.status,
    required this.escalatedAt,
    required this.createdAt,
  });

  factory EscalationEntity.fromJson(Map<String, dynamic> json) {
    return EscalationEntity(
      id: json['id'] as String,
      caseId: json['case_id'] as String,
      alertId: json['alert_id'] as String?,
      escalationLevel: json['escalation_level'] as String,
      reason: json['reason'] as String?,
      status: json['status'] as String? ?? 'PENDING',
      escalatedAt: DateTime.parse(json['escalated_at'] as String).toUtc(),
      createdAt: DateTime.parse(json['created_at'] as String).toUtc(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'case_id': caseId,
        'alert_id': alertId,
        'escalation_level': escalationLevel,
        'reason': reason,
        'status': status,
        'escalated_at': escalatedAt.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, caseId, escalationLevel, status, escalatedAt];
}

