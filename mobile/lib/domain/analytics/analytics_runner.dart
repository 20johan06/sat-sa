import 'package:satsa_mobile/data/repositories/local_repository.dart';
import 'package:satsa_mobile/domain/entities/analysis_run.dart';
import 'package:satsa_mobile/domain/entities/finding.dart';
import 'package:satsa_mobile/domain/entities/finding_evidence.dart';
import 'package:satsa_mobile/domain/analytics/analytics_helpers.dart';
import 'package:satsa_mobile/domain/analytics/analytics_execution_gaps.dart';
import 'package:satsa_mobile/domain/analytics/analytics_negative_space.dart';
import 'package:satsa_mobile/domain/analytics/analytics_anomalies.dart';
import 'package:satsa_mobile/domain/analytics/analytics_benchmarks.dart';
import 'package:satsa_mobile/domain/analytics/analytics_operational_inconsistency.dart';

class AnalyticsRunResult {
  final AnalysisRunEntity analysisRun;
  final List<FindingEntity> createdFindings;
  final List<FindingEvidenceEntity> createdEvidences;
  final List<PeerBaselineData> createdBaselines;

  AnalyticsRunResult({
    required this.analysisRun,
    required this.createdFindings,
    required this.createdEvidences,
    required this.createdBaselines,
  });
}

class AnalyticsRunner {
  /// Executes the canonical supervisory analytics engine for a target CSE locally.
  /// Strictly offline, 100% deterministic, exact Windows Python parity.
  static Future<AnalyticsRunResult> runAnalyticsForCSE({
    required LocalSupervisoryRepository repository,
    required String cseId,
    String? batchId,
    DateTime? obsStart,
    DateTime? obsEnd,
  }) async {
    final startTime = DateTime.now().toUtc();

    final targetCse = await repository.getCSEById(cseId);
    final allCses = await repository.getAllCSEs();
    final allAlerts = await repository.getAllAlerts();
    final allCases = await repository.getAllCases();
    final allInvestigations = await repository.getAllInvestigations();
    final allEscalations = await repository.getAllEscalations();
    final allCoverages = await repository.getAllCoverages();
    final existingFindings = await repository.getFindingsByCSE(cseId);
    final existingCodes = existingFindings.map((f) => f.findingCode).toSet();

    final allFindingsWithEvidence = <FindingWithEvidence>[];
    final allBaselines = <PeerBaselineData>[];

    // 1. EG-01
    allFindingsWithEvidence.addAll(
      ExecutionGapAnalyzer.analyzeEG01CriticalAlertWorkflow(
        cseId: cseId,
        batchId: batchId,
      ),
    );

    // 2. EG-02
    allFindingsWithEvidence.addAll(
      ExecutionGapAnalyzer.analyzeEG02CriticalIncidentEscalation(
        cseId: cseId,
        batchId: batchId,
      ),
    );

    // 3. EG-03
    allFindingsWithEvidence.addAll(
      ExecutionGapAnalyzer.analyzeEG03RapidCaseClosure(
        cseId: cseId,
        cases: allCases,
        obsStart: obsStart,
        obsEnd: obsEnd,
        batchId: batchId,
      ),
    );

    // 4. EG-04
    allFindingsWithEvidence.addAll(
      ExecutionGapAnalyzer.analyzeEG04RepeatedInvestigations(
        cseId: cseId,
        investigations: allInvestigations,
        cases: allCases,
        obsStart: obsStart,
        obsEnd: obsEnd,
        batchId: batchId,
      ),
    );

    // 5. NS-01
    allFindingsWithEvidence.addAll(
      NegativeSpaceAnalyzer.analyzeNS01InactiveExpectedCoverage(
        cseId: cseId,
        coverages: allCoverages,
        obsStart: obsStart,
        obsEnd: obsEnd,
        batchId: batchId,
      ),
    );

    // 6. NS-02
    allFindingsWithEvidence.addAll(
      NegativeSpaceAnalyzer.analyzeNS02AbsentHighPriorityEscalation(
        cseId: cseId,
        batchId: batchId,
      ),
    );

    // 7. AN-01
    allFindingsWithEvidence.addAll(
      AnomalyAnalyzer.analyzeAN01DailyAlertVolume(
        cseId: cseId,
        alerts: allAlerts,
        obsStart: obsStart,
        obsEnd: obsEnd,
        batchId: batchId,
      ),
    );

    // 8. BM-01
    if (targetCse != null) {
      final bmResult = BenchmarkAnalyzer.analyzeBM01PeerBenchmarks(
        targetCse: targetCse,
        allCses: allCses,
        allAlerts: allAlerts,
        allCases: allCases,
        allEscalations: allEscalations,
        obsStart: obsStart,
        obsEnd: obsEnd,
        batchId: batchId,
      );
      allBaselines.addAll(bmResult.baselines);
      allFindingsWithEvidence.addAll(bmResult.findingsWithEvidence);
    }

    // 9. OI-01
    allFindingsWithEvidence.addAll(
      OperationalInconsistencyAnalyzer.analyzeOI01EvidenceLinkageGaps(
        cseId: cseId,
        cases: allCases,
        investigations: allInvestigations,
        obsStart: obsStart,
        obsEnd: obsEnd,
        batchId: batchId,
      ),
    );

    // Filter out findings that already exist in database by finding_code
    final newFindings = <FindingEntity>[];
    final newEvidences = <FindingEvidenceEntity>[];

    for (final item in allFindingsWithEvidence) {
      if (!existingCodes.contains(item.finding.findingCode)) {
        existingCodes.add(item.finding.findingCode);
        newFindings.add(item.finding);
        newEvidences.addAll(item.evidences);

        // Persist finding and evidence
        await repository.insertFinding(item.finding);
        for (final ev in item.evidences) {
          await repository.insertFindingEvidence(ev);
        }
      }
    }

    final endTime = DateTime.now().toUtc();
    final runId = generateUuidV5('AR-$cseId-${startTime.toIso8601String()}');

    final analysisRun = AnalysisRunEntity(
      id: runId,
      cseId: cseId,
      obsStart: obsStart,
      obsEnd: obsEnd,
      engineVersion: '2.0.0-mobile',
      rulesEvaluated: [
        'EG-01',
        'EG-02',
        'EG-03',
        'EG-04',
        'NS-01',
        'NS-02',
        'AN-01',
        'BM-01-INV',
        'BM-01-ESC',
        'OI-01'
      ],
      status: 'COMPLETED',
      findingsCreated: newFindings.length,
      baselinesPersisted: allBaselines.length,
      startedAt: startTime,
      completedAt: endTime,
    );

    await repository.insertAnalysisRun(analysisRun);

    return AnalyticsRunResult(
      analysisRun: analysisRun,
      createdFindings: newFindings,
      createdEvidences: newEvidences,
      createdBaselines: allBaselines,
    );
  }
}
