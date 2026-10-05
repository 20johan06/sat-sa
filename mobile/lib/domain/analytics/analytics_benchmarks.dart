import 'dart:math' as math;
import 'package:satsa_mobile/domain/entities/cse.dart';
import 'package:satsa_mobile/domain/entities/alert_entity.dart';
import 'package:satsa_mobile/domain/entities/case_entity.dart';
import 'package:satsa_mobile/domain/entities/escalation_entity.dart';
import 'package:satsa_mobile/domain/entities/finding.dart';
import 'package:satsa_mobile/domain/analytics/analytics_helpers.dart';
import 'package:satsa_mobile/domain/analytics/analytics_execution_gaps.dart';

String _cleanHex6(String idStr) {
  final clean = idStr.replaceAll('-', '').toLowerCase();
  return clean.substring(0, math.min(6, clean.length));
}

class PeerBaselineData {
  final String id;
  final String peerGroup;
  final String metricName;
  final double baselineValue;
  final double minValue;
  final double maxValue;
  final int sampleSize;
  final DateTime periodStart;
  final DateTime periodEnd;
  final Map<String, dynamic> metadataJson;

  PeerBaselineData({
    required this.id,
    required this.peerGroup,
    required this.metricName,
    required this.baselineValue,
    required this.minValue,
    required this.maxValue,
    required this.sampleSize,
    required this.periodStart,
    required this.periodEnd,
    required this.metadataJson,
  });
}

class PeerBenchmarkResult {
  final List<PeerBaselineData> baselines;
  final List<FindingWithEvidence> findingsWithEvidence;

  PeerBenchmarkResult({
    required this.baselines,
    required this.findingsWithEvidence,
  });
}

class BenchmarkAnalyzer {
  static const int minPeerGroupSize = 3;
  static const int minAlertBenchmarkDenominator = 10;
  static const int minCriticalBenchmarkDenominator = 5;
  static const double benchmarkSigmaThreshold = 2.0;

  /// BM-01: Peer Benchmarking for alert_investigation_rate and critical_escalation_rate.
  /// Calculates sector peer baselines (or POPULATION_ALL fallback if sector size < 3).
  /// Generates benchmark deviation findings if |Z| > 2.0.
  static PeerBenchmarkResult analyzeBM01PeerBenchmarks({
    required CSEEntity targetCse,
    required List<CSEEntity> allCses,
    required List<AlertEntity> allAlerts,
    required List<CaseEntity> allCases,
    required List<EscalationEntity> allEscalations,
    DateTime? obsStart,
    DateTime? obsEnd,
    String? batchId,
  }) {
    final activeCses = allCses.where((c) => c.isActive).toList();
    final sectorCses = activeCses.where((c) => c.sector == targetCse.sector).toList();

    String peerGroupName;
    List<CSEEntity> groupCses;

    if (sectorCses.length >= minPeerGroupSize) {
      peerGroupName = 'SECTOR_${targetCse.sector}';
      groupCses = sectorCses;
    } else {
      peerGroupName = 'POPULATION_ALL';
      groupCses = activeCses;
    }

    final baselines = <PeerBaselineData>[];
    final findingsWithEvidence = <FindingWithEvidence>[];

    final nowUtc = DateTime.now().toUtc();
    final pStart = obsStart ?? DateTime.utc(2026, 1, 1);
    final pEnd = obsEnd ?? nowUtc;
    final capability = mapRuleToCapability(
      category: 'BENCHMARK',
      ruleCode: 'BM01',
    );

    final dateTag =
        '${pStart.year.toString().padLeft(4, '0')}${pStart.month.toString().padLeft(2, '0')}${pStart.day.toString().padLeft(2, '0')}';
    final targetHex6 = _cleanHex6(targetCse.id);

    // --- Metric 1: alert_investigation_rate ---
    final cseInvestigationRates = <String, double>{};
    for (final c in groupCses) {
      var cAlerts = allAlerts.where((a) => a.cseId == c.id).toList();
      if (obsStart != null) {
        cAlerts = cAlerts.where((a) => !a.detectedAt.isBefore(obsStart)).toList();
      }
      if (obsEnd != null) {
        cAlerts = cAlerts.where((a) => !a.detectedAt.isAfter(obsEnd)).toList();
      }

      if (cAlerts.length < minAlertBenchmarkDenominator) {
        continue;
      }

      final cCasesAlertIds = allCases
          .where((cs) => cs.cseId == c.id && cs.alertId != null)
          .map((cs) => cs.alertId!)
          .toSet();

      final investigatedCount =
          cAlerts.where((a) => cCasesAlertIds.contains(a.id)).length;
      cseInvestigationRates[c.id] = investigatedCount / cAlerts.length;
    }

    final peerInvestigationRates = cseInvestigationRates.entries
        .where((e) => e.key != targetCse.id)
        .map((e) => e.value)
        .toList();

    if (peerInvestigationRates.length >= minPeerGroupSize &&
        cseInvestigationRates.containsKey(targetCse.id)) {
      final meanRate = calculateMean(peerInvestigationRates);
      final stdRate = peerInvestigationRates.length > 1
          ? calculateSampleStdev(peerInvestigationRates)
          : 0.0;

      final minVal = peerInvestigationRates.reduce(math.min);
      final maxVal = peerInvestigationRates.reduce(math.max);

      baselines.add(PeerBaselineData(
        id: generateUuidV5('PB-INV-${targetCse.id}-$nowUtc'),
        peerGroup: peerGroupName,
        metricName: 'alert_investigation_rate',
        baselineValue: meanRate,
        minValue: minVal,
        maxValue: maxVal,
        sampleSize: peerInvestigationRates.length,
        periodStart: pStart,
        periodEnd: pEnd,
        metadataJson: {'std_dev': stdRate},
      ));

      final targetVal = cseInvestigationRates[targetCse.id]!;
      if (stdRate > 0) {
        final zScore = (targetVal - meanRate) / stdRate;
        if (zScore.abs() > benchmarkSigmaThreshold) {
          final findingCode = 'FND-BM01-INV-$targetHex6-$dateTag';
          final evStrength = calculateEvidenceStrength(
            sampleSize: peerInvestigationRates.length,
            hasExplicitEvidence: true,
          );

          final finding = FindingEntity(
            id: generateUuidV5('FND-BM01-INV-$findingCode-$nowUtc'),
            findingCode: findingCode,
            cseId: targetCse.id,
            batchId: batchId,
            category: 'BENCHMARK',
            severity: 'MEDIUM',
            title: 'Significant Peer Group Deviation: Alert Investigation Rate',
            description:
                'Alert investigation rate (${(targetVal * 100).toStringAsFixed(1)}%) significantly deviates '
                'from $peerGroupName baseline mean (${(meanRate * 100).toStringAsFixed(1)}%, Z=${zScore.toStringAsFixed(2)}).',
            rationale:
                'CSE alert investigation rate of ${(targetVal * 100).toStringAsFixed(1)}% deviates by ${zScore.abs().toStringAsFixed(2)} '
                'standard deviations from peer baseline mean (${(meanRate * 100).toStringAsFixed(1)}%).',
            detectionMethod: 'PEER_BENCHMARK_Z_SCORE',
            metricsJson: {
              'rule_code': 'BM-01-INV',
              'metric_name': 'alert_investigation_rate',
              'metric': 'alert_investigation_rate',
              'peer_group': peerGroupName,
              'observed_value': double.parse(targetVal.toStringAsFixed(4)),
              'baseline_value': double.parse(meanRate.toStringAsFixed(4)),
              'peer_mean': double.parse(meanRate.toStringAsFixed(4)),
              'peer_std': double.parse(stdRate.toStringAsFixed(4)),
              'deviation': double.parse(zScore.toStringAsFixed(4)),
              'z_score': double.parse(zScore.toStringAsFixed(4)),
              'peer_sample_size': peerInvestigationRates.length,
              'evidence_strength': evStrength,
              'capability': capability,
              'supervisory_relevance':
                  'Deviating from peer investigation rates indicates potential operational under-reporting or over-filtering.',
            },
            status: 'NEW',
            detectedAt: nowUtc,
            updatedAt: nowUtc,
          );

          findingsWithEvidence.add(FindingWithEvidence(finding: finding, evidences: []));
        }
      }
    }

    // --- Metric 2: critical_escalation_rate ---
    final cseCriticalRates = <String, double>{};
    for (final c in groupCses) {
      var cCrits = allAlerts
          .where((a) => a.cseId == c.id && a.severity == 'CRITICAL')
          .toList();
      if (obsStart != null) {
        cCrits = cCrits.where((a) => !a.detectedAt.isBefore(obsStart)).toList();
      }
      if (obsEnd != null) {
        cCrits = cCrits.where((a) => !a.detectedAt.isAfter(obsEnd)).toList();
      }

      if (cCrits.length < minCriticalBenchmarkDenominator) {
        continue;
      }

      final cEscAlertIds = allEscalations
          .where((esc) => esc.alertId != null)
          .map((esc) => esc.alertId!)
          .toSet();

      final escalatedCount =
          cCrits.where((a) => cEscAlertIds.contains(a.id)).length;
      cseCriticalRates[c.id] = escalatedCount / cCrits.length;
    }

    final peerCriticalRates = cseCriticalRates.entries
        .where((e) => e.key != targetCse.id)
        .map((e) => e.value)
        .toList();

    if (peerCriticalRates.length >= minPeerGroupSize &&
        cseCriticalRates.containsKey(targetCse.id)) {
      final meanCrit = calculateMean(peerCriticalRates);
      final stdCrit = peerCriticalRates.length > 1
          ? calculateSampleStdev(peerCriticalRates)
          : 0.0;

      final minVal = peerCriticalRates.reduce(math.min);
      final maxVal = peerCriticalRates.reduce(math.max);

      baselines.add(PeerBaselineData(
        id: generateUuidV5('PB-ESC-${targetCse.id}-$nowUtc'),
        peerGroup: peerGroupName,
        metricName: 'critical_escalation_rate',
        baselineValue: meanCrit,
        minValue: minVal,
        maxValue: maxVal,
        sampleSize: peerCriticalRates.length,
        periodStart: pStart,
        periodEnd: pEnd,
        metadataJson: {'std_dev': stdCrit},
      ));

      final targetCritVal = cseCriticalRates[targetCse.id]!;
      if (stdCrit > 0) {
        final zScoreCrit = (targetCritVal - meanCrit) / stdCrit;
        if (zScoreCrit.abs() > benchmarkSigmaThreshold) {
          final findingCode = 'FND-BM01-ESC-$targetHex6-$dateTag';
          final evStrength = calculateEvidenceStrength(
            sampleSize: peerCriticalRates.length,
            hasExplicitEvidence: true,
          );

          final finding = FindingEntity(
            id: generateUuidV5('FND-BM01-ESC-$findingCode-$nowUtc'),
            findingCode: findingCode,
            cseId: targetCse.id,
            batchId: batchId,
            category: 'BENCHMARK',
            severity: 'MEDIUM',
            title: 'Significant Peer Group Deviation: Critical Escalation Rate',
            description:
                'Critical alert escalation rate (${(targetCritVal * 100).toStringAsFixed(1)}%) significantly deviates '
                'from $peerGroupName baseline mean (${(meanCrit * 100).toStringAsFixed(1)}%, Z=${zScoreCrit.toStringAsFixed(2)}).',
            rationale:
                'Critical escalation rate of ${(targetCritVal * 100).toStringAsFixed(1)}% deviates by ${zScoreCrit.abs().toStringAsFixed(2)} '
                'standard deviations from peer baseline mean (${(meanCrit * 100).toStringAsFixed(1)}%).',
            detectionMethod: 'PEER_BENCHMARK_Z_SCORE',
            metricsJson: {
              'rule_code': 'BM-01-ESC',
              'metric_name': 'critical_escalation_rate',
              'metric': 'critical_escalation_rate',
              'peer_group': peerGroupName,
              'observed_value': double.parse(targetCritVal.toStringAsFixed(4)),
              'baseline_value': double.parse(meanCrit.toStringAsFixed(4)),
              'peer_mean': double.parse(meanCrit.toStringAsFixed(4)),
              'peer_std': double.parse(stdCrit.toStringAsFixed(4)),
              'deviation': double.parse(zScoreCrit.toStringAsFixed(4)),
              'z_score': double.parse(zScoreCrit.toStringAsFixed(4)),
              'peer_sample_size': peerCriticalRates.length,
              'evidence_strength': evStrength,
              'capability': capability,
              'supervisory_relevance':
                  'Low critical escalation rate compared to sector peers signals potential escalation suppression.',
            },
            status: 'NEW',
            detectedAt: nowUtc,
            updatedAt: nowUtc,
          );

          findingsWithEvidence.add(FindingWithEvidence(finding: finding, evidences: []));
        }
      }
    }

    return PeerBenchmarkResult(
      baselines: baselines,
      findingsWithEvidence: findingsWithEvidence,
    );
  }
}
