import 'package:equatable/equatable.dart';

class EscalationEntity extends Equatable {
  final String id;
  final String caseId;
  final String escalationReference;
  final String escalatedTo;
  final String reason;
  final DateTime escalatedAt;

  const EscalationEntity({
    required this.id,
    required this.caseId,
    required this.escalationReference,
    required this.escalatedTo,
    required this.reason,
    required this.escalatedAt,
  });

  factory EscalationEntity.fromJson(Map<String, dynamic> json) {
    return EscalationEntity(
      id: json['id'] as String,
      caseId: json['case_id'] as String,
      escalationReference: json['escalation_reference'] as String,
      escalatedTo: json['escalated_to'] as String,
      reason: json['reason'] as String,
      escalatedAt: DateTime.parse(json['escalated_at'] as String).toUtc(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'case_id': caseId,
        'escalation_reference': escalationReference,
        'escalated_to': escalatedTo,
        'reason': reason,
        'escalated_at': escalatedAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, caseId, escalationReference, escalatedTo, escalatedAt];
}
