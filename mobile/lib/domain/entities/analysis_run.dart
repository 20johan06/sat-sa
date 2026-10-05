import 'package:equatable/equatable.dart';

class AnalysisRunEntity extends Equatable {
  final String id;
  final String cseId;
  final String? assessmentId;
  final String? datasetVersionId;
  final DateTime? obsStart;
  final DateTime? obsEnd;
  final String engineVersion;
  final List<String> rulesEvaluated;
  final String status;
  final int findingsCreated;
  final int baselinesPersisted;
  final String? errorMessage;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String? executedByUserId;

  const AnalysisRunEntity({
    required this.id,
    required this.cseId,
    this.assessmentId,
    this.datasetVersionId,
    this.obsStart,
    this.obsEnd,
    required this.engineVersion,
    required this.rulesEvaluated,
    required this.status,
    required this.findingsCreated,
    required this.baselinesPersisted,
    this.errorMessage,
    required this.startedAt,
    this.completedAt,
    this.executedByUserId,
  });

  factory AnalysisRunEntity.fromJson(Map<String, dynamic> json) {
    return AnalysisRunEntity(
      id: json['id'] as String,
      cseId: json['cse_id'] as String,
      assessmentId: json['assessment_id'] as String?,
      datasetVersionId: json['dataset_version_id'] as String?,
      obsStart: json['obs_start'] != null ? DateTime.parse(json['obs_start'] as String).toUtc() : null,
      obsEnd: json['obs_end'] != null ? DateTime.parse(json['obs_end'] as String).toUtc() : null,
      engineVersion: json['engine_version'] as String? ?? 'v2.0.0-phase5-canonical',
      rulesEvaluated: List<String>.from(json['rules_evaluated'] as List),
      status: json['status'] as String,
      findingsCreated: json['findings_created'] as int? ?? 0,
      baselinesPersisted: json['baselines_persisted'] as int? ?? 0,
      errorMessage: json['error_message'] as String?,
      startedAt: DateTime.parse(json['started_at'] as String).toUtc(),
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String).toUtc() : null,
      executedByUserId: json['executed_by_user_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cse_id': cseId,
        'assessment_id': assessmentId,
        'dataset_version_id': datasetVersionId,
        'obs_start': obsStart?.toIso8601String(),
        'obs_end': obsEnd?.toIso8601String(),
        'engine_version': engineVersion,
        'rules_evaluated': rulesEvaluated,
        'status': status,
        'findings_created': findingsCreated,
        'baselines_persisted': baselinesPersisted,
        'error_message': errorMessage,
        'started_at': startedAt.toIso8601String(),
        'completed_at': completedAt?.toIso8601String(),
        'executed_by_user_id': executedByUserId,
      };

  @override
  List<Object?> get props => [id, cseId, engineVersion, rulesEvaluated, status, findingsCreated];
}
