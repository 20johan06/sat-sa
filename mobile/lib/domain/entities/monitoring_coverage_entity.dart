import 'package:equatable/equatable.dart';

class MonitoringCoverageEntity extends Equatable {
  final String id;
  final String cseId;
  final String logSourceType;
  final String coverageStatus;
  final double? expectedEps;
  final DateTime? lastSeenAt;

  const MonitoringCoverageEntity({
    required this.id,
    required this.cseId,
    required this.logSourceType,
    required this.coverageStatus,
    this.expectedEps,
    this.lastSeenAt,
  });

  factory MonitoringCoverageEntity.fromJson(Map<String, dynamic> json) {
    return MonitoringCoverageEntity(
      id: json['id'] as String,
      cseId: json['cse_id'] as String,
      logSourceType: json['log_source_type'] as String,
      coverageStatus: json['coverage_status'] as String,
      expectedEps: (json['expected_eps'] as num?)?.toDouble(),
      lastSeenAt: json['last_seen_at'] != null ? DateTime.parse(json['last_seen_at'] as String).toUtc() : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cse_id': cseId,
        'log_source_type': logSourceType,
        'coverage_status': coverageStatus,
        'expected_eps': expectedEps,
        'last_seen_at': lastSeenAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, cseId, logSourceType, coverageStatus, expectedEps];
}
