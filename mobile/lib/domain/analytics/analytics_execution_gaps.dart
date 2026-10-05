import 'dart:math' as math;
import 'package:satsa_mobile/domain/entities/finding.dart';
import 'package:satsa_mobile/domain/entities/finding_evidence.dart';
import 'package:satsa_mobile/domain/entities/case_entity.dart';
import 'package:satsa_mobile/domain/entities/investigation_entity.dart';
import 'package:satsa_mobile/domain/analytics/analytics_helpers.dart';

String _cleanHex6(String idStr) {
  final clean = idStr.replaceAll('-', '').toLowerCase();
  return clean.substring(0, math.min(6, clean.length));
}

class FindingWithEvidence {
  final FindingEntity finding;
  final List<FindingEvidenceEntity> evidences;

  FindingWithEvidence({required this.finding, required this.evidences});
}

class ExecutionGapAnalyzer {
  static const int minCaseDurationSampleSize = 10;
  static const int repetitionReviewThreshold = 3;

  /// EG-01: Expectation-based Execution/Evidence Gap.
  /// Unconfigured in base schema -> returns empty list.
  static List<FindingWithEvidence> analyzeEG01CriticalAlertWorkflow({
    required String cseId,
    String? batchId,
  }) {
    return [];
  }

  /// EG-02: Expectation-based Escalation Evidence Gap.
  /// Unconfigured in base schema -> returns empty list.
  static List<FindingWithEvidence> analyzeEG02CriticalIncidentEscalation({
    required String cseId,
    String? batchId,
  }) {
    return [];
  }

  /// EG-03: Statistically Rapid Case Closure.
  /// Lower-tail 5th percentile (P5) from observed case resolution durations.
  /// Enforces minimum sample size N >= 10 closed cases.
  static List<FindingWithEvidence> analyzeEG03RapidCaseClosure({
    required String cseId,
    required List<CaseEntity> cases,
    DateTime? obsStart,
    DateTime? obsEnd,
    String? batchId,
  }) {
    // Filter closed cases for target CSE
    var closedCases = cases.where((c) =>
        c.cseId == cseId &&
        c.closedAt != null).toList();

    if (obsStart != null) {
      closedCases = closedCases.where((c) => !c.closedAt!.isBefore(obsStart)).toList();
    }
    if (obsEnd != null) {
      closedCases = closedCases.where((c) => !c.closedAt!.isAfter(obsEnd)).toList();
    }

    if (closedCases.length < minCaseDurationSampleSize) {
      return [];
    }

    // Calculate duration in seconds
    final validDurations = <MapEntry<CaseEntity, double>>[];
    for (final c in closedCases) {
      final dur = c.closedAt!.difference(c.openedAt).inMilliseconds / 1000.0;
      if (dur >= 0) {
        validDurations.add(MapEntry(c, dur));
      }
    }

    if (validDurations.length < minCaseDurationSampleSize) {
      return [];
    }

    final rawSeconds = validDurations.map((e) => e.value).toList();
    final p5Cutoff = calculateP5(rawSeconds);

    final rapidCases = validDurations.where((e) => e.value < p5Cutoff).toList();
    final results = <FindingWithEvidence>[];
    final sampleSize = validDurations.length;
    final evStrength = calculateEvidenceStrength(
      sampleSize: sampleSize,
      hasExplicitEvidence: true,
    );
    final capability = mapRuleToCapability(
      category: 'EXECUTION_GAP',
      ruleCode: 'EG03',
    );

    final cseHex6 = _cleanHex6(cseId);
    final now = DateTime.now().toUtc();

    for (final entry in rapidCases) {
      final caseObj = entry.key;
      final duration = entry.value;
      final caseHex6 = _cleanHex6(caseObj.id);
      final findingCode = 'FND-EG03-$cseHex6-$caseHex6';

      final finding = FindingEntity(
        id: generateUuidV5('FND-EG03-${caseObj.id}-$now'),
        findingCode: findingCode,
        cseId: cseId,
        batchId: batchId,
        category: 'EXECUTION_GAP',
        severity: 'MEDIUM',
        title: 'Statistically Rapid Case Closure',
        description:
            'Case \'${caseObj.externalCaseId}\' was resolved in ${duration.toStringAsFixed(1)} seconds, '
            'which is below the 5th percentile baseline cutoff (${p5Cutoff.toStringAsFixed(1)} seconds) '
            'of observed case resolution durations for this entity.',
        rationale:
            'Statistically rapid resolution (< P5 cutoff of ${p5Cutoff.toStringAsFixed(1)}s across N=$sampleSize cases) '
            'indicates potential superficial handling requiring supervisory review.',
        detectionMethod: 'P5_PERCENTILE',
        metricsJson: {
          'rule_code': 'EG-03',
          'metric': 'case_resolution_duration_seconds',
          'case_id': caseObj.id,
          'duration_seconds': duration,
          'p5_cutoff_seconds': p5Cutoff,
          'observed_value': double.parse(duration.toStringAsFixed(1)),
          'baseline_value': double.parse(p5Cutoff.toStringAsFixed(1)),
          'deviation': double.parse((p5Cutoff - duration).toStringAsFixed(1)),
          'percentile_method': 'P5_LINEAR_INTERPOLATION',
          'sample_size': sampleSize,
          'external_case_id': caseObj.externalCaseId,
          'evidence_strength': evStrength,
          'capability': capability,
          'supervisory_relevance':
              'Unusually rapid case closure indicates potential superficial investigation or hasty disposition.',
        },
        status: 'NEW',
        detectedAt: now,
        updatedAt: now,
      );

      final evidence = FindingEvidenceEntity(
        id: generateUuidV5('EV-EG03-${caseObj.id}-$now'),
        findingId: finding.id,
        evidenceType: 'CASE',
        caseId: caseObj.id,
        notes:
            'Rapid closure evidence: duration ${duration.toStringAsFixed(1)}s < P5 threshold ${p5Cutoff.toStringAsFixed(1)}s.',
        createdAt: now,
      );

      results.add(FindingWithEvidence(finding: finding, evidences: [evidence]));
    }

    return results;
  }

  /// EG-04: Repeated Investigation Pattern Detected.
  /// Exact matching investigation notes across >= 3 distinct cases.
  static List<FindingWithEvidence> analyzeEG04RepeatedInvestigations({
    required String cseId,
    required List<InvestigationEntity> investigations,
    required List<CaseEntity> cases,
    DateTime? obsStart,
    DateTime? obsEnd,
    String? batchId,
  }) {
    final cseCaseIds = cases.where((c) => c.cseId == cseId).map((c) => c.id).toSet();

    var cseInvestigations = investigations.where((i) => cseCaseIds.contains(i.caseId)).toList();

    if (obsStart != null) {
      cseInvestigations = cseInvestigations.where((i) => !i.startedAt.isBefore(obsStart)).toList();
    }
    if (obsEnd != null) {
      cseInvestigations = cseInvestigations.where((i) => !i.startedAt.isAfter(obsEnd)).toList();
    }

    final noteMap = <String, List<InvestigationEntity>>{};
    for (final inv in cseInvestigations) {
      if (inv.notes != null && inv.notes!.trim().length > 15) {
        final cleanNote = inv.notes!.trim();
        noteMap.putIfAbsent(cleanNote, () => []).add(inv);
      }
    }

    final results = <FindingWithEvidence>[];
    final cseHex6 = _cleanHex6(cseId);
    final now = DateTime.now().toUtc();

    for (final entry in noteMap.entries) {
      final noteText = entry.key;
      final invList = entry.value;
      final distinctCaseIds = invList.map((i) => i.caseId).toSet();

      if (distinctCaseIds.length >= repetitionReviewThreshold) {
        final sampleSize = distinctCaseIds.length;
        final hashSnippet = generateUuidV5Hex8(noteText);
        final findingCode = 'FND-EG04-$cseHex6-$hashSnippet';

        final evStrength = calculateEvidenceStrength(
          sampleSize: sampleSize,
          hasExplicitEvidence: true,
        );
        final capability = mapRuleToCapability(
          category: 'EXECUTION_GAP',
          ruleCode: 'EG04',
        );

        final snippetEnd = math.min(100, noteText.length);
        final snippet = noteText.substring(0, snippetEnd);

        final finding = FindingEntity(
          id: generateUuidV5('FND-EG04-$findingCode-$now'),
          findingCode: findingCode,
          cseId: cseId,
          batchId: batchId,
          category: 'EXECUTION_GAP',
          severity: 'LOW',
          title: 'Repeated Investigation Pattern Detected',
          description:
              'Repeated investigation pattern detected across $sampleSize distinct cases. '
              'Pattern snippet: \'$snippet...\'',
          rationale:
              'Identical investigation notes observed in $sampleSize distinct cases '
              '(exceeding review threshold of $repetitionReviewThreshold). '
              'This signal is provided for supervisory review of investigation thoroughness.',
          detectionMethod: 'PATTERN_REPETITION',
          metricsJson: {
            'rule_code': 'EG-04',
            'metric': 'repeated_investigation_notes',
            'observed_value': sampleSize,
            'baseline_value': repetitionReviewThreshold,
            'repetition_threshold': repetitionReviewThreshold,
            'deviation': sampleSize - repetitionReviewThreshold,
            'method': 'TEXT_EXACT_HASH_MATCH',
            'distinct_cases_count': sampleSize,
            'total_investigations': invList.length,
            'sample_investigation_ids': invList.take(10).map((i) => i.id).toList(),
            'evidence_strength': evStrength,
            'capability': capability,
            'supervisory_relevance':
                'Template or copy-paste investigation text across multiple cases may indicate superficial investigation.',
          },
          status: 'NEW',
          detectedAt: now,
          updatedAt: now,
        );

        final evidences = <FindingEvidenceEntity>[];
        for (final inv in invList) {
          evidences.add(FindingEvidenceEntity(
            id: generateUuidV5('EV-EG04-${inv.id}-$now'),
            findingId: finding.id,
            evidenceType: 'INVESTIGATION',
            investigationId: inv.id,
            caseId: inv.caseId,
            notes: 'Repeated investigation pattern evidence.',
            createdAt: now,
          ));
        }

        results.add(FindingWithEvidence(finding: finding, evidences: evidences));
      }
    }

    return results;
  }
}
