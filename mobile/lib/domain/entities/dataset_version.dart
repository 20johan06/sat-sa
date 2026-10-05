import 'package:equatable/equatable.dart';

class DatasetVersionEntity extends Equatable {
  final String id;
  final String cseId;
  final String? assessmentId;
  final String? batchId;
  final String versionTag;
  final String datasetType;
  final String sourceFilename;
  final String contentHash;
  final int recordCount;
  final bool isImmutable;
  final DateTime createdAt;
  final String? createdByUserId;

  const DatasetVersionEntity({
    required this.id,
    required this.cseId,
    this.assessmentId,
    this.batchId,
    required this.versionTag,
    required this.datasetType,
    required this.sourceFilename,
    required this.contentHash,
    required this.recordCount,
    required this.isImmutable,
    required this.createdAt,
    this.createdByUserId,
  });

  factory DatasetVersionEntity.fromJson(Map<String, dynamic> json) {
    return DatasetVersionEntity(
      id: json['id'] as String,
      cseId: json['cse_id'] as String,
      assessmentId: json['assessment_id'] as String?,
      batchId: json['batch_id'] as String?,
      versionTag: json['version_tag'] as String,
      datasetType: json['dataset_type'] as String,
      sourceFilename: json['source_filename'] as String,
      contentHash: json['content_hash'] as String,
      recordCount: json['record_count'] as int? ?? 0,
      isImmutable: json['is_immutable'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String).toUtc(),
      createdByUserId: json['created_by_user_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cse_id': cseId,
        'assessment_id': assessmentId,
        'batch_id': batchId,
        'version_tag': versionTag,
        'dataset_type': datasetType,
        'source_filename': sourceFilename,
        'content_hash': contentHash,
        'record_count': recordCount,
        'is_immutable': isImmutable,
        'created_at': createdAt.toIso8601String(),
        'created_by_user_id': createdByUserId,
      };

  @override
  List<Object?> get props => [id, cseId, versionTag, datasetType, contentHash, recordCount];
}
