import 'package:satsa_mobile/domain/entities/cse.dart';
import 'package:satsa_mobile/domain/entities/finding.dart';
import 'package:satsa_mobile/domain/entities/finding_evidence.dart';
import 'package:satsa_mobile/domain/entities/analysis_run.dart';

class SupervisoryAttentionIndicators {
  final int activeFindingsCount;
  final int activeCriticalFindingsCount;
  final int activeHighFindingsCount;
  final int highAttentionFindingsCount;
  final int executionGapFindingsCount;
  final int negativeSpaceFindingsCount;
  final int anomalyFindingsCount;
  final int benchmarkDeviationsCount;
  final Map<String, int> evidenceStrengthDistribution;
  final int affectedRecordCount;
  final int affectedCriticalHighRecords;
  final int peerDeviationsCount;
  final int repeatedSignalsCount;

  SupervisoryAttentionIndicators({
    required this.activeFindingsCount,
    required this.activeCriticalFindingsCount,
    required this.activeHighFindingsCount,
    required this.highAttentionFindingsCount,
    required this.executionGapFindingsCount,
    required this.negativeSpaceFindingsCount,
    required this.anomalyFindingsCount,
    required this.benchmarkDeviationsCount,
    required this.evidenceStrengthDistribution,
    required this.affectedRecordCount,
    required this.affectedCriticalHighRecords,
    required this.peerDeviationsCount,
    required this.repeatedSignalsCount,
  });

  Map<String, dynamic> toJson() => {
        'active_findings_count': activeFindingsCount,
        'active_critical_findings_count': activeCriticalFindingsCount,
        'active_high_findings_count': activeHighFindingsCount,
        'high_attention_findings_count': highAttentionFindingsCount,
        'execution_gap_findings_count': executionGapFindingsCount,
        'negative_space_findings_count': negativeSpaceFindingsCount,
        'anomaly_findings_count': anomalyFindingsCount,
        'benchmark_deviations_count': benchmarkDeviationsCount,
        'evidence_strength_distribution': evidenceStrengthDistribution,
        'affected_record_count': affectedRecordCount,
        'affected_critical_high_records': affectedCriticalHighRecords,
        'peer_deviations_count': peerDeviationsCount,
        'repeated_signals_count': repeatedSignalsCount,
      };
}

class SupervisoryAttentionItem {
  final String cseId;
  final String cseCode;
  final String cseName;
  final String sector;
  final String criticalityTier;
  final SupervisoryAttentionIndicators indicators;
  final List<String> dominantCategories;
  final String? latestAnalysisRunAt;
  final Map<String, String> rationale;

  SupervisoryAttentionItem({
    required this.cseId,
    required this.cseCode,
    required this.cseName,
    required this.sector,
    required this.criticalityTier,
    required this.indicators,
    required this.dominantCategories,
    this.latestAnalysisRunAt,
    required this.rationale,
  });
}

class SupervisoryService {
  static SupervisoryAttentionIndicators calculateIndicators({
    required String cseId,
    required List<FindingEntity> findings,
    required List<FindingEvidenceEntity> evidences,
  }) {
    final cseFindings = findings.where((f) => f.cseId == cseId).toList();
    final activeFindings = cseFindings.where((f) => f.status == 'NEW').toList();

    final activeCount = activeFindings.length;
    final activeCritCount =
        activeFindings.where((f) => f.severity == 'CRITICAL').length;
    final activeHighCount =
        activeFindings.where((f) => f.severity == 'HIGH').length;
    final highAttentionCount = activeCritCount + activeHighCount;

    final execGapCount =
        activeFindings.where((f) => f.category == 'EXECUTION_GAP').length;
    final negSpaceCount =
        activeFindings.where((f) => f.category == 'NEGATIVE_SPACE').length;
    final anomalyCount =
        activeFindings.where((f) => f.category == 'ANOMALY').length;
    final bmCount =
        activeFindings.where((f) => f.category == 'BENCHMARK').length;

    final evStrengthDist = <String, int>{
      'STRONG': 0,
      'MODERATE': 0,
      'LIMITED': 0,
      'NONE': 0,
    };
    var totalAffectedRecords = 0;
    var criticalHighAffectedRecords = 0;

    final findingEvMap = <String, List<FindingEvidenceEntity>>{};
    for (final ev in evidences) {
      findingEvMap.putIfAbsent(ev.findingId, () => []).add(ev);
    }

    for (final f in activeFindings) {
      final fEvs = findingEvMap[f.id] ?? [];
      final evCount = fEvs.length;
      totalAffectedRecords += evCount;
      if (f.severity == 'CRITICAL' || f.severity == 'HIGH') {
        criticalHighAffectedRecords += evCount;
      }

      var strength = 'MODERATE';
      if (f.metricsJson != null && f.metricsJson!['evidence_strength'] != null) {
        strength = f.metricsJson!['evidence_strength'].toString().toUpperCase();
      }
      if (evCount == 0) {
        strength = 'NONE';
      }
      if (!evStrengthDist.containsKey(strength)) {
        strength = 'MODERATE';
      }
      evStrengthDist[strength] = (evStrengthDist[strength] ?? 0) + 1;
    }

    final repeatedSignalsCount = activeFindings
        .where((f) =>
            f.findingCode.startsWith('EG-04') ||
            f.findingCode.startsWith('FND-EG04'))
        .length;

    return SupervisoryAttentionIndicators(
      activeFindingsCount: activeCount,
      activeCriticalFindingsCount: activeCritCount,
      activeHighFindingsCount: activeHighCount,
      highAttentionFindingsCount: highAttentionCount,
      executionGapFindingsCount: execGapCount,
      negativeSpaceFindingsCount: negSpaceCount,
      anomalyFindingsCount: anomalyCount,
      benchmarkDeviationsCount: bmCount,
      evidenceStrengthDistribution: evStrengthDist,
      affectedRecordCount: totalAffectedRecords,
      affectedCriticalHighRecords: criticalHighAffectedRecords,
      peerDeviationsCount: bmCount,
      repeatedSignalsCount: repeatedSignalsCount,
    );
  }

  /// Builds explainable rationale matching backend specification.
  static Map<String, String> buildRationale({
    required CSEEntity cse,
    required List<FindingEntity> activeFindings,
    required SupervisoryAttentionIndicators indicators,
  }) {
    if (activeFindings.isEmpty) {
      return {
        'what': 'No Active Supervisory Signals Detected',
        'why':
            'CSE ${cse.name} currently displays no active execution gaps, negative space, or benchmark deviations.',
        'how':
            'System periodically evaluates canonical rules EG-01..04, NS-01..02, AN-01, BM-01 against ingested telemetry.',
        'evidence': '0 active findings detected in the observation period.',
        'baseline': 'CSE metrics remain within established operational baselines.',
        'impact': 'Standard supervisory oversight applies.',
      };
    }

    final severityOrder = {'CRITICAL': 4, 'HIGH': 3, 'MEDIUM': 2, 'LOW': 1};
    final sortedF = List<FindingEntity>.from(activeFindings)
      ..sort((a, b) => (severityOrder[b.severity] ?? 0)
          .compareTo(severityOrder[a.severity] ?? 0));

    final top = sortedF.first;
    return {
      'what': '${top.title} (${indicators.activeFindingsCount} total active findings)',
      'why': 'Primary trigger: ${top.title}. ${top.description}',
      'how': 'Evaluated by analytic rule ${top.findingCode}.',
      'evidence':
          '${indicators.affectedRecordCount} total affected records linked across ${indicators.activeFindingsCount} active finding(s).',
      'baseline':
          'Evaluated against historical CSE metrics and peer group standards.',
      'impact': top.rationale,
    };
  }

  /// Generates the Supervisory Attention Queue sorted deterministically by:
  /// 1. active_findings_count DESC
  /// 2. affected_critical_high_records DESC
  /// 3. high_attention_findings_count DESC
  /// 4. cse_code DESC
  static List<SupervisoryAttentionItem> getAttentionQueue({
    required List<CSEEntity> cses,
    required List<FindingEntity> allFindings,
    required List<FindingEvidenceEntity> allEvidences,
    required List<AnalysisRunEntity> allRuns,
  }) {
    final validCses = cses
        .where((c) =>
            !c.cseCode.startsWith('SYN-') &&
            !c.sector.toUpperCase().contains('SYNTHETIC'))
        .toList();

    final queueItems = <SupervisoryAttentionItem>[];

    for (final cse in validCses) {
      final cseFindings = allFindings.where((f) => f.cseId == cse.id).toList();
      final activeFindings = cseFindings.where((f) => f.status == 'NEW').toList();

      final indicators = calculateIndicators(
        cseId: cse.id,
        findings: cseFindings,
        evidences: allEvidences,
      );

      final catCounts = <String, int>{};
      for (final f in activeFindings) {
        catCounts[f.category] = (catCounts[f.category] ?? 0) + 1;
      }
      final sortedCats = catCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final dominantCats = sortedCats.take(2).map((e) => e.key).toList();

      final cseRuns = allRuns.where((r) => r.cseId == cse.id).toList()
        ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
      final latestRunAt =
          cseRuns.isNotEmpty ? cseRuns.first.startedAt.toIso8601String() : null;

      final rationale = buildRationale(
        cse: cse,
        activeFindings: activeFindings,
        indicators: indicators,
      );

      queueItems.add(SupervisoryAttentionItem(
        cseId: cse.id,
        cseCode: cse.cseCode,
        cseName: cse.name,
        sector: cse.sector,
        criticalityTier: cse.criticalityTier,
        indicators: indicators,
        dominantCategories: dominantCats,
        latestAnalysisRunAt: latestRunAt,
        rationale: rationale,
      ));
    }

    // Deterministic sorting
    queueItems.sort((a, b) {
      final c1 = b.indicators.activeFindingsCount.compareTo(a.indicators.activeFindingsCount);
      if (c1 != 0) return c1;

      final c2 = b.indicators.affectedCriticalHighRecords.compareTo(a.indicators.affectedCriticalHighRecords);
      if (c2 != 0) return c2;

      final c3 = b.indicators.highAttentionFindingsCount.compareTo(a.indicators.highAttentionFindingsCount);
      if (c3 != 0) return c3;

      return b.cseCode.compareTo(a.cseCode);
    });

    return queueItems;
  }
}
