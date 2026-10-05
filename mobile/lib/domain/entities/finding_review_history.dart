import 'package:equatable/equatable.dart';

class FindingReviewHistoryEntity extends Equatable {
  final String id;
  final String findingId;
  final String? userId;
  final String cseId;
  final String actionType;
  final String? previousStatus;
  final String? newStatus;
  final String noteText;
  final Map<String, dynamic>? evidenceRequestDetails;
  final DateTime createdAt;

  const FindingReviewHistoryEntity({
    required this.id,
    required this.findingId,
    this.userId,
    required this.cseId,
    required this.actionType,
    this.previousStatus,
    this.newStatus,
    required this.noteText,
    this.evidenceRequestDetails,
    required this.createdAt,
  });

  factory FindingReviewHistoryEntity.fromJson(Map<String, dynamic> json) {
    return FindingReviewHistoryEntity(
      id: json['id'] as String,
      findingId: json['finding_id'] as String,
      userId: json['user_id'] as String?,
      cseId: json['cse_id'] as String,
      actionType: json['action_type'] as String,
      previousStatus: json['previous_status'] as String?,
      newStatus: json['new_status'] as String?,
      noteText: json['note_text'] as String,
      evidenceRequestDetails: json['evidence_request_details'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String).toUtc(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'finding_id': findingId,
        'user_id': userId,
        'cse_id': cseId,
        'action_type': actionType,
        'previous_status': previousStatus,
        'new_status': newStatus,
        'note_text': noteText,
        'evidence_request_details': evidenceRequestDetails,
        'created_at': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, findingId, cseId, actionType, previousStatus, newStatus];
}
