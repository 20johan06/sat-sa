import 'dart:math' as math;
import 'package:satsa_mobile/domain/entities/finding.dart';
import 'package:satsa_mobile/domain/entities/finding_evidence.dart';
import 'package:satsa_mobile/domain/entities/alert_entity.dart';
import 'package:satsa_mobile/domain/analytics/analytics_helpers.dart';
import 'package:satsa_mobile/domain/analytics/analytics_execution_gaps.dart';

String _cleanHex6(String idStr) {
  final clean = idStr.replaceAll('-', '').toLowerCase();
  return clean.substring(0, math.min(6, clean.length));
}

class AnomalyAnalyzer {
  static const int minAnomalyObservationDays = 10;
  static const double madModifiedZThreshold = 2.5;

  /// AN-01: Daily Alert Volume Statistical Anomaly.
  /// Aggregates Alert.detectedAt by UTC calendar day.
  /// Calculates median, MAD, and Modified Z-score.
  /// Requires N >= 10 days. MAD == 0 returns empty list.
  static List<FindingWithEvidence> analyzeAN01DailyAlertVolume({
    required String cseId,
    required List<AlertEntity> alerts,
    DateTime? obsStart,
    DateTime? obsEnd,
    String? batchId,
  }) {
    var cseAlerts = alerts.where((a) => a.cseId == cseId).toList();

    if (obsStart != null) {
      cseAlerts = cseAlerts.where((a) => !a.detectedAt.isBefore(obsStart)).toList();
    }
    if (obsEnd != null) {
      cseAlerts = cseAlerts.where((a) => !a.detectedAt.isAfter(obsEnd)).toList();
    }

    final dailyCounts = <String, List<AlertEntity>>{};
    for (final alt in cseAlerts) {
      final utcDt = alt.detectedAt.toUtc();
      final dtKey =
          '${utcDt.year.toString().padLeft(4, '0')}-${utcDt.month.toString().padLeft(2, '0')}-${utcDt.day.toString().padLeft(2, '0')}';
      dailyCounts.putIfAbsent(dtKey, () => []).add(alt);
    }

    final distinctDays = dailyCounts.keys.toList()..sort();

    if (distinctDays.length < minAnomalyObservationDays) {
      return [];
    }

    final counts = distinctDays.map((d) => dailyCounts[d]!.length.toDouble()).toList();

    final medianVal = calculateMedian(counts);
    final absDeviations = counts.map((x) => (x - medianVal).abs()).toList();
    final madVal = calculateMedian(absDeviations);

    if (madVal == 0.0) {
      return [];
    }

    final results = <FindingWithEvidence>[];
    final sampleSize = distinctDays.length;
    final evStrength = calculateEvidenceStrength(
      sampleSize: sampleSize,
      hasExplicitEvidence: true,
    );
    final capability = mapRuleToCapability(
      category: 'ANOMALY',
      ruleCode: 'AN01',
    );

    final cseHex6 = _cleanHex6(cseId);
    final nowUtc = DateTime.now().toUtc();

    for (var i = 0; i < distinctDays.length; i++) {
      final dayStr = distinctDays[i];
      final count = counts[i];
      final modZ = 0.6745 * (count - medianVal) / madVal;

      if (modZ.abs() > madModifiedZThreshold) {
        final findingCode = 'FND-AN01-$cseHex6-$dayStr';
        final dayAlerts = dailyCounts[dayStr]!;

        final finding = FindingEntity(
          id: generateUuidV5('FND-AN01-$findingCode-$nowUtc'),
          findingCode: findingCode,
          cseId: cseId,
          batchId: batchId,
          category: 'ANOMALY',
          severity: 'MEDIUM',
          title: 'Daily Alert Volume Statistical Anomaly',
          description:
              'Daily alert volume on $dayStr was ${count.toInt()} alerts, '
              'representing a statistical anomaly (Modified Z-score: ${modZ.toStringAsFixed(2)}).',
          rationale:
              'Observed daily alert volume (${count.toInt()}) significantly deviates '
              'from the CSE median (${medianVal.toStringAsFixed(1)}) with MAD=${madVal.toStringAsFixed(1)} '
              '(|Modified Z| > $madModifiedZThreshold).',
          detectionMethod: 'MAD_MODIFIED_Z_SCORE',
          metricsJson: {
            'rule_code': 'AN-01',
            'metric': 'daily_alert_volume',
            'observed_value': count.toInt(),
            'baseline_value': double.parse(medianVal.toStringAsFixed(1)),
            'mad': double.parse(madVal.toStringAsFixed(1)),
            'deviation': double.parse(modZ.toStringAsFixed(4)),
            'modified_z_score': double.parse(modZ.toStringAsFixed(4)),
            'observation_days_count': sampleSize,
            'date': dayStr,
            'evidence_strength': evStrength,
            'capability': capability,
            'supervisory_relevance':
                'Unusual volume spikes or drops indicate potential cyber attacks, system misconfigurations, or ingestion telemetry anomalies.',
          },
          status: 'NEW',
          detectedAt: nowUtc,
          updatedAt: nowUtc,
        );

        final evidences = <FindingEvidenceEntity>[];
        for (final sampleAlt in dayAlerts.take(5)) {
          evidences.add(FindingEvidenceEntity(
            id: generateUuidV5('EV-AN01-${sampleAlt.id}-$nowUtc'),
            findingId: finding.id,
            evidenceType: 'ALERT',
            alertId: sampleAlt.id,
            notes:
                'Anomaly evidence: alert on anomalous day $dayStr (Z=${modZ.toStringAsFixed(2)}).',
            createdAt: nowUtc,
          ));
        }

        results.add(FindingWithEvidence(finding: finding, evidences: evidences));
      }
    }

    return results;
  }
}
