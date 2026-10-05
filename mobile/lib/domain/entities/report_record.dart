import 'package:equatable/equatable.dart';

class ReportRecordEntity extends Equatable {
  final String id;
  final String reportCode;
  final String cseId;
  final String? assessmentId;
  final String? datasetVersionId;
  final String? analysisRunId;
  final DateTime? obsStart;
  final DateTime? obsEnd;
  final String generatedByUserId;
  final DateTime createdAt;
  final Map<String, dynamic> summaryJson;
  final Map<String, dynamic>? metadataJson;

  const ReportRecordEntity({
    required this.id,
    required this.reportCode,
    required this.cseId,
    this.assessmentId,
    this.datasetVersionId,
    this.analysisRunId,
    this.obsStart,
    this.obsEnd,
    required this.generatedByUserId,
    required this.createdAt,
    required this.summaryJson,
    this.metadataJson,
  });

  factory ReportRecordEntity.fromJson(Map<String, dynamic> json) {
    return ReportRecordEntity(
      id: json['id'] as String,
      reportCode: json['report_code'] as String,
      cseId: json['cse_id'] as String,
      assessmentId: json['assessment_id'] as String?,
      datasetVersionId: json['dataset_version_id'] as String?,
      analysisRunId: json['analysis_run_id'] as String?,
      obsStart: json['obs_start'] != null ? DateTime.parse(json['obs_start'] as String).toUtc() : null,
      obsEnd: json['obs_end'] != null ? DateTime.parse(json['obs_end'] as String).toUtc() : null,
      generatedByUserId: json['generated_by_user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String).toUtc(),
      summaryJson: Map<String, dynamic>.from(json['summary_json'] as Map),
      metadataJson: json['metadata_json'] != null ? Map<String, dynamic>.from(json['metadata_json'] as Map) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'report_code': reportCode,
        'cse_id': cseId,
        'assessment_id': assessmentId,
        'dataset_version_id': datasetVersionId,
        'analysis_run_id': analysisRunId,
        'obs_start': obsStart?.toIso8601String(),
        'obs_end': obsEnd?.toIso8601String(),
        'generated_by_user_id': generatedByUserId,
        'created_at': createdAt.toIso8601String(),
        'summary_json': summaryJson,
        'metadata_json': metadataJson,
      };

  @override
  List<Object?> get props => [id, reportCode, cseId, assessmentId, createdAt];
}
