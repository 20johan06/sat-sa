import 'dart:math' as math;
import 'package:satsa_mobile/domain/entities/finding.dart';
import 'package:satsa_mobile/domain/entities/finding_evidence.dart';
import 'package:satsa_mobile/domain/entities/monitoring_coverage_entity.dart';
import 'package:satsa_mobile/domain/analytics/analytics_helpers.dart';
import 'package:satsa_mobile/domain/analytics/analytics_execution_gaps.dart';

String _cleanHex6(String idStr) {
  final clean = idStr.replaceAll('-', '').toLowerCase();
  return clean.substring(0, math.min(6, clean.length));
}

class NegativeSpaceAnalyzer {
  /// NS-01: Expected Log Source Coverage Inactive.
  /// Strictly requires an explicit MonitoringCoverage record with isExpected == true.
  static List<FindingWithEvidence> analyzeNS01InactiveExpectedCoverage({
    required String cseId,
    required List<MonitoringCoverageEntity> coverages,
    DateTime? obsStart,
    DateTime? obsEnd,
    String? batchId,
  }) {
    final cseCoverages = coverages.where((c) =>
        c.cseId == cseId && c.isExpected == true).toList();

    final results = <FindingWithEvidence>[];
    final nowUtc = DateTime.now().toUtc();
    final cseHex6 = _cleanHex6(cseId);

    for (final cov in cseCoverages) {
      final isInactive = (cov.isActive == false);
      var isStale = false;
      if (cov.periodEnd != null &&
          cov.periodEnd!.isBefore(nowUtc) &&
          cov.lastReceivedAt == null) {
        isStale = true;
      }

      if (isInactive || isStale) {
        final covHex6 = _cleanHex6(cov.id);
        final findingCode = 'FND-NS01-$cseHex6-$covHex6';

        final reasonStr = isInactive
            ? 'marked inactive'
            : 'no telemetry received in expected period';
        final evStrength = calculateEvidenceStrength(
          sampleSize: 1,
          hasExplicitEvidence: true,
        );
        final capability = mapRuleToCapability(
          category: 'NEGATIVE_SPACE',
          ruleCode: 'NS01',
        );

        final finding = FindingEntity(
          id: generateUuidV5('FND-NS01-$findingCode-$nowUtc'),
          findingCode: findingCode,
          cseId: cseId,
          batchId: batchId,
          category: 'NEGATIVE_SPACE',
          severity: 'HIGH',
          title: 'Expected Log Source Coverage Inactive',
          description:
              'Log source category \'${cov.logSourceCategory}\' is explicitly configured '
              'as expected (is_expected=True), but is currently $reasonStr.',
          rationale:
              'Expected monitoring category \'${cov.logSourceCategory}\' lacks active log collection, '
              'representing an operational monitoring blind spot.',
          detectionMethod: 'EXPLICIT_COVERAGE_CHECK',
          metricsJson: {
            'rule_code': 'NS-01',
            'metric': 'expected_log_source_active_status',
            'observed_value': isInactive ? 'INACTIVE' : 'STALE',
            'baseline_value': 'ACTIVE',
            'coverage_id': cov.id,
            'log_source_category': cov.logSourceCategory,
            'is_expected': cov.isExpected,
            'is_active': cov.isActive,
            'coverage_percentage': cov.coveragePercentage,
            'last_received_at': cov.lastReceivedAt?.toUtc().toIso8601String(),
            'evidence_strength': evStrength,
            'capability': capability,
            'supervisory_relevance':
                'Inactive telemetry sources mask potential security incidents (negative space).',
          },
          status: 'NEW',
          detectedAt: nowUtc,
          updatedAt: nowUtc,
        );

        final evidence = FindingEvidenceEntity(
          id: generateUuidV5('EV-NS01-${cov.id}-$nowUtc'),
          findingId: finding.id,
          evidenceType: 'COVERAGE',
          coverageId: cov.id,
          notes:
              'Coverage evidence: category \'${cov.logSourceCategory}\' expected but inactive/stale.',
          createdAt: nowUtc,
        );

        results.add(FindingWithEvidence(finding: finding, evidences: [evidence]));
      }
    }

    return results;
  }

  /// NS-02: Absent Escalation Evidence for High-Priority Incident Case.
  /// Constraint: Requires explicit high-priority escalation expectation flag.
  /// If unconfigured: Returns empty list.
  static List<FindingWithEvidence> analyzeNS02AbsentHighPriorityEscalation({
    required String cseId,
    String? batchId,
  }) {
    return [];
  }
}
