import 'package:equatable/equatable.dart';

class AlertEntity extends Equatable {
  final String id;
  final String cseId;
  final String? batchId;
  final String? assetId;
  final String externalAlertId;
  final String title;
  final String category;
  final String severity;
  final String status;
  final String? disposition;
  final String? targetAssetName;
  final DateTime detectedAt;
  final DateTime? closedAt;
  final Map<String, dynamic>? rawMetadata;
  final DateTime createdAt;

  const AlertEntity({
    required this.id,
    required this.cseId,
    this.batchId,
    this.assetId,
    required this.externalAlertId,
    required this.title,
    required this.category,
    required this.severity,
    required this.status,
    this.disposition,
    this.targetAssetName,
    required this.detectedAt,
    this.closedAt,
    this.rawMetadata,
    required this.createdAt,
  });

  factory AlertEntity.fromJson(Map<String, dynamic> json) {
    return AlertEntity(
      id: json['id'] as String,
      cseId: json['cse_id'] as String,
      batchId: json['batch_id'] as String?,
      assetId: json['asset_id'] as String?,
      externalAlertId: json['external_alert_id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      severity: json['severity'] as String,
      status: json['status'] as String? ?? 'NEW',
      disposition: json['disposition'] as String?,
      targetAssetName: json['target_asset_name'] as String?,
      detectedAt: DateTime.parse(json['detected_at'] as String).toUtc(),
      closedAt: json['closed_at'] != null ? DateTime.parse(json['closed_at'] as String).toUtc() : null,
      rawMetadata: json['raw_metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String).toUtc(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cse_id': cseId,
        'batch_id': batchId,
        'asset_id': assetId,
        'external_alert_id': externalAlertId,
        'title': title,
        'category': category,
        'severity': severity,
        'status': status,
        'disposition': disposition,
        'target_asset_name': targetAssetName,
        'detected_at': detectedAt.toIso8601String(),
        'closed_at': closedAt?.toIso8601String(),
        'raw_metadata': rawMetadata,
        'created_at': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, cseId, externalAlertId, title, category, severity, status, detectedAt];
}

