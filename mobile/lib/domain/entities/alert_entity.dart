import 'package:equatable/equatable.dart';

class AlertEntity extends Equatable {
  final String id;
  final String cseId;
  final String? batchId;
  final String alertReference;
  final String sourceSystem;
  final String ruleName;
  final String severity;
  final String status;
  final DateTime eventTimestamp;
  final DateTime ingestedAt;
  final Map<String, dynamic>? rawDataJson;

  const AlertEntity({
    required this.id,
    required this.cseId,
    this.batchId,
    required this.alertReference,
    required this.sourceSystem,
    required this.ruleName,
    required this.severity,
    required this.status,
    required this.eventTimestamp,
    required this.ingestedAt,
    this.rawDataJson,
  });

  factory AlertEntity.fromJson(Map<String, dynamic> json) {
    return AlertEntity(
      id: json['id'] as String,
      cseId: json['cse_id'] as String,
      batchId: json['batch_id'] as String?,
      alertReference: json['alert_reference'] as String,
      sourceSystem: json['source_system'] as String,
      ruleName: json['rule_name'] as String,
      severity: json['severity'] as String,
      status: json['status'] as String? ?? 'NEW',
      eventTimestamp: DateTime.parse(json['event_timestamp'] as String).toUtc(),
      ingestedAt: DateTime.parse(json['ingested_at'] as String).toUtc(),
      rawDataJson: json['raw_data_json'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cse_id': cseId,
        'batch_id': batchId,
        'alert_reference': alertReference,
        'source_system': sourceSystem,
        'rule_name': ruleName,
        'severity': severity,
        'status': status,
        'event_timestamp': eventTimestamp.toIso8601String(),
        'ingested_at': ingestedAt.toIso8601String(),
        'raw_data_json': rawDataJson,
      };

  @override
  List<Object?> get props => [id, cseId, alertReference, sourceSystem, ruleName, severity, eventTimestamp];
}
