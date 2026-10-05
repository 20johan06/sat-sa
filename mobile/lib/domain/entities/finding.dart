import 'package:equatable/equatable.dart';

class FindingEntity extends Equatable {
  final String id;
  final String findingCode;
  final String cseId;
  final String? batchId;
  final String? analysisRunId;
  final String category;
  final String severity;
  final String title;
  final String description;
  final String rationale;
  final String detectionMethod;
  final Map<String, dynamic>? metricsJson;
  final String status;
  final DateTime detectedAt;
  final DateTime updatedAt;

  const FindingEntity({
    required this.id,
    required this.findingCode,
    required this.cseId,
    this.batchId,
    this.analysisRunId,
    required this.category,
    required this.severity,
    required this.title,
    required this.description,
    required this.rationale,
    required this.detectionMethod,
    this.metricsJson,
    required this.status,
    required this.detectedAt,
    required this.updatedAt,
  });

  factory FindingEntity.fromJson(Map<String, dynamic> json) {
    return FindingEntity(
      id: json['id'] as String,
      findingCode: json['finding_code'] as String,
      cseId: json['cse_id'] as String,
      batchId: json['batch_id'] as String?,
      analysisRunId: json['analysis_run_id'] as String?,
      category: json['category'] as String,
      severity: json['severity'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      rationale: json['rationale'] as String,
      detectionMethod: json['detection_method'] as String,
      metricsJson: json['metrics_json'] as Map<String, dynamic>?,
      status: json['status'] as String? ?? 'NEW',
      detectedAt: DateTime.parse(json['detected_at'] as String).toUtc(),
      updatedAt: DateTime.parse(json['updated_at'] as String).toUtc(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'finding_code': findingCode,
        'cse_id': cseId,
        'batch_id': batchId,
        'analysis_run_id': analysisRunId,
        'category': category,
        'severity': severity,
        'title': title,
        'description': description,
        'rationale': rationale,
        'detection_method': detectionMethod,
        'metrics_json': metricsJson,
        'status': status,
        'detected_at': detectedAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, findingCode, cseId, category, severity, title, status];
}
