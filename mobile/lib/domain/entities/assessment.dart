import 'package:equatable/equatable.dart';

class AssessmentEntity extends Equatable {
  final String id;
  final String cseId;
  final String name;
  final String? description;
  final DateTime periodStart;
  final DateTime periodEnd;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdByUserId;

  const AssessmentEntity({
    required this.id,
    required this.cseId,
    required this.name,
    this.description,
    required this.periodStart,
    required this.periodEnd,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.createdByUserId,
  });

  factory AssessmentEntity.fromJson(Map<String, dynamic> json) {
    return AssessmentEntity(
      id: json['id'] as String,
      cseId: json['cse_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      periodStart: DateTime.parse(json['period_start'] as String).toUtc(),
      periodEnd: DateTime.parse(json['period_end'] as String).toUtc(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String).toUtc(),
      updatedAt: DateTime.parse(json['updated_at'] as String).toUtc(),
      createdByUserId: json['created_by_user_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cse_id': cseId,
        'name': name,
        'description': description,
        'period_start': periodStart.toIso8601String(),
        'period_end': periodEnd.toIso8601String(),
        'status': status,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'created_by_user_id': createdByUserId,
      };

  @override
  List<Object?> get props => [id, cseId, name, periodStart, periodEnd, status];
}
