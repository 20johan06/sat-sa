import 'package:equatable/equatable.dart';

class MonitoringCoverageEntity extends Equatable {
  final String id;
  final String cseId;
  final String logSourceCategory;
  final bool isExpected;
  final bool isActive;
  final DateTime? lastReceivedAt;
  final double? coveragePercentage;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final DateTime createdAt;

  const MonitoringCoverageEntity({
    required this.id,
    required this.cseId,
    required this.logSourceCategory,
    required this.isExpected,
    required this.isActive,
    this.lastReceivedAt,
    this.coveragePercentage,
    this.periodStart,
    this.periodEnd,
    required this.createdAt,
  });

  factory MonitoringCoverageEntity.fromJson(Map<String, dynamic> json) {
    return MonitoringCoverageEntity(
      id: json['id'] as String,
      cseId: json['cse_id'] as String,
      logSourceCategory: json['log_source_category'] as String,
      isExpected: json['is_expected'] as bool? ?? true,
      isActive: json['is_active'] as bool? ?? true,
      lastReceivedAt: json['last_received_at'] != null ? DateTime.parse(json['last_received_at'] as String).toUtc() : null,
      coveragePercentage: (json['coverage_percentage'] as num?)?.toDouble(),
      periodStart: json['period_start'] != null ? DateTime.parse(json['period_start'] as String).toUtc() : null,
      periodEnd: json['period_end'] != null ? DateTime.parse(json['period_end'] as String).toUtc() : null,
      createdAt: DateTime.parse(json['created_at'] as String).toUtc(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cse_id': cseId,
        'log_source_category': logSourceCategory,
        'is_expected': isExpected,
        'is_active': isActive,
        'last_received_at': lastReceivedAt?.toIso8601String(),
        'coverage_percentage': coveragePercentage,
        'period_start': periodStart?.toIso8601String(),
        'period_end': periodEnd?.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, cseId, logSourceCategory, isExpected, isActive, coveragePercentage];
}

