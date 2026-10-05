import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:satsa_mobile/data/database/app_database.dart';
import 'package:satsa_mobile/data/repositories/local_repository.dart';
import 'package:satsa_mobile/domain/entities/cse.dart';
import 'package:satsa_mobile/domain/entities/alert_entity.dart';
import 'package:satsa_mobile/domain/entities/case_entity.dart';
import 'package:satsa_mobile/domain/entities/investigation_entity.dart';
import 'package:satsa_mobile/domain/entities/escalation_entity.dart';
import 'package:satsa_mobile/domain/entities/monitoring_coverage_entity.dart';
import 'package:satsa_mobile/domain/entities/finding.dart';
import 'package:satsa_mobile/domain/entities/finding_evidence.dart';
import 'package:satsa_mobile/domain/analytics/analytics_helpers.dart';
import 'package:satsa_mobile/domain/analytics/analytics_execution_gaps.dart';
import 'package:satsa_mobile/domain/analytics/analytics_negative_space.dart';
import 'package:satsa_mobile/domain/analytics/analytics_anomalies.dart';
import 'package:satsa_mobile/domain/analytics/analytics_benchmarks.dart';
import 'package:satsa_mobile/domain/analytics/analytics_operational_inconsistency.dart';
import 'package:satsa_mobile/domain/analytics/analytics_runner.dart';
import 'package:satsa_mobile/domain/analytics/supervisory_service.dart';
import 'package:satsa_mobile/domain/analytics/capability_service.dart';

void main() {
  setUpAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  group('Phase 20B-1 Offline Supervisory Analytics Engine Parity Test Suite', () {
    late AppDatabase db;
    late LocalSupervisoryRepository repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repo = LocalSupervisoryRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    final nowUtc = DateTime.now().toUtc();
    const cse1Id = '11111111-1111-1111-1111-111111111111';
    const cse2Id = '22222222-2222-2222-2222-222222222222';
    const cse3Id = '33333333-3333-3333-3333-333333333333';

    test('1. EG-01 and EG-02 return empty list when expectation is unconfigured', () {
      final eg01Results = ExecutionGapAnalyzer.analyzeEG01CriticalAlertWorkflow(
        cseId: cse1Id,
      );
      expect(eg01Results, isEmpty);

      final eg02Results = ExecutionGapAnalyzer.analyzeEG02CriticalIncidentEscalation(
        cseId: cse1Id,
      );
      expect(eg02Results, isEmpty);
    });

    test('2. EG-03 Rapid Case Closure triggers below P5 linear interpolation cutoff', () {
      final cases = <CaseEntity>[];
      final durations = [100, 200, 300, 400, 500, 600, 700, 800, 900, 50];

      for (var i = 0; i < durations.length; i++) {
        final openedAt = nowUtc.subtract(Duration(seconds: durations[i] + 1000));
        final closedAt = openedAt.add(Duration(seconds: durations[i]));
        cases.add(CaseEntity(
          id: '10000000-0000-0000-0000-${i.toString().padLeft(12, '0')}',
          cseId: cse1Id,
          externalCaseId: 'CSE1-CASE-$i',
          title: 'Case $i',
          status: 'CLOSED',
          priority: 'MEDIUM',
          openedAt: openedAt,
          closedAt: closedAt,
          createdAt: openedAt,
        ));
      }

      final results = ExecutionGapAnalyzer.analyzeEG03RapidCaseClosure(
        cseId: cse1Id,
        cases: cases,
      );

      expect(results.length, equals(1));
      final item = results.first;
      expect(item.finding.findingCode, startsWith('FND-EG03-111111-100000'));
      expect(item.finding.category, equals('EXECUTION_GAP'));
      expect(item.finding.severity, equals('MEDIUM'));
      expect(item.finding.detectionMethod, equals('P5_PERCENTILE'));
      expect(item.finding.metricsJson!['p5_cutoff_seconds'], equals(72.5));
      expect(item.finding.metricsJson!['observed_value'], equals(50.0));
      expect(item.evidences.length, equals(1));
      expect(item.evidences.first.evidenceType, equals('CASE'));
    });

    test('3. EG-03 returns empty list when N < 10 cases', () {
      final cases = <CaseEntity>[];
      for (var i = 0; i < 9; i++) {
        final openedAt = nowUtc.subtract(const Duration(seconds: 1000));
        final closedAt = openedAt.add(const Duration(seconds: 10));
        cases.add(CaseEntity(
          id: '10000000-0000-0000-0000-${i.toString().padLeft(12, '0')}',
          cseId: cse1Id,
          externalCaseId: 'CSE1-CASE-$i',
          title: 'Case $i',
          status: 'CLOSED',
          priority: 'MEDIUM',
          openedAt: openedAt,
          closedAt: closedAt,
          createdAt: openedAt,
        ));
      }

      final results = ExecutionGapAnalyzer.analyzeEG03RapidCaseClosure(
        cseId: cse1Id,
        cases: cases,
      );

      expect(results, isEmpty);
    });

    test('4. EG-04 Repeated Investigation Pattern triggers for identical notes across >= 3 cases with SHA-1 UUIDv5 hash snippet', () {
      const repeatedNote = 'Standard template investigation notes text containing more than fifteen characters long.';
      final cases = <CaseEntity>[
        CaseEntity(id: 'c1111111-0000-0000-0000-000000000001', cseId: cse1Id, externalCaseId: 'C1', title: 'C1', status: 'OPEN', priority: 'MEDIUM', openedAt: nowUtc, createdAt: nowUtc),
        CaseEntity(id: 'c1111111-0000-0000-0000-000000000002', cseId: cse1Id, externalCaseId: 'C2', title: 'C2', status: 'OPEN', priority: 'MEDIUM', openedAt: nowUtc, createdAt: nowUtc),
        CaseEntity(id: 'c1111111-0000-0000-0000-000000000003', cseId: cse1Id, externalCaseId: 'C3', title: 'C3', status: 'OPEN', priority: 'MEDIUM', openedAt: nowUtc, createdAt: nowUtc),
      ];

      final investigations = <InvestigationEntity>[
        InvestigationEntity(id: 'i1111111-0000-0000-0000-000000000001', caseId: cases[0].id, actionType: 'INVESTIGATE', notes: repeatedNote, evidenceCount: 1, startedAt: nowUtc, createdAt: nowUtc),
        InvestigationEntity(id: 'i1111111-0000-0000-0000-000000000002', caseId: cases[1].id, actionType: 'INVESTIGATE', notes: repeatedNote, evidenceCount: 1, startedAt: nowUtc, createdAt: nowUtc),
        InvestigationEntity(id: 'i1111111-0000-0000-0000-000000000003', caseId: cases[2].id, actionType: 'INVESTIGATE', notes: repeatedNote, evidenceCount: 1, startedAt: nowUtc, createdAt: nowUtc),
      ];

      final results = ExecutionGapAnalyzer.analyzeEG04RepeatedInvestigations(
        cseId: cse1Id,
        investigations: investigations,
        cases: cases,
      );

      expect(results.length, equals(1));
      final item = results.first;
      final hashSnippet = generateUuidV5Hex8(repeatedNote);
      expect(item.finding.findingCode, equals('FND-EG04-111111-$hashSnippet'));
      expect(item.finding.severity, equals('LOW'));
      expect(item.finding.category, equals('EXECUTION_GAP'));
      expect(item.finding.metricsJson!['distinct_cases_count'], equals(3));
      expect(item.evidences.length, equals(3));
      expect(item.evidences.every((e) => e.evidenceType == 'INVESTIGATION'), isTrue);
    });

    test('5. NS-01 Inactive Expected Coverage flags expected inactive/stale coverages', () {
      final coverages = <MonitoringCoverageEntity>[
        MonitoringCoverageEntity(
          id: 'cov11111-0000-0000-0000-000000000001',
          cseId: cse1Id,
          logSourceCategory: 'FIREWALL',
          isExpected: true,
          isActive: false,
          createdAt: nowUtc,
        ),
        MonitoringCoverageEntity(
          id: 'cov11111-0000-0000-0000-000000000002',
          cseId: cse1Id,
          logSourceCategory: 'ENDPOINT',
          isExpected: true,
          isActive: true,
          createdAt: nowUtc,
        ),
      ];

      final results = NegativeSpaceAnalyzer.analyzeNS01InactiveExpectedCoverage(
        cseId: cse1Id,
        coverages: coverages,
      );

      expect(results.length, equals(1));
      final item = results.first;
      expect(item.finding.findingCode, equals('FND-NS01-111111-cov111'));
      expect(item.finding.category, equals('NEGATIVE_SPACE'));
      expect(item.finding.severity, equals('HIGH'));
      expect(item.finding.metricsJson!['observed_value'], equals('INACTIVE'));
      expect(item.evidences.first.evidenceType, equals('COVERAGE'));
    });

    test('6. AN-01 Daily Alert Volume Anomaly triggers when Modified Z-score > 2.5', () {
      final alerts = <AlertEntity>[];
      final dayCounts = [2, 4, 6, 8, 10, 12, 14, 16, 18, 100];

      for (var dayIdx = 0; dayIdx < dayCounts.length; dayIdx++) {
        final alertDate = DateTime.utc(2026, 1, dayIdx + 1, 10, 0, 0);
        final count = dayCounts[dayIdx];
        for (var aIdx = 0; aIdx < count; aIdx++) {
          alerts.add(AlertEntity(
            id: 'alt11111-${dayIdx.toString().padLeft(4, '0')}-${aIdx.toString().padLeft(4, '0')}-000000000000',
            cseId: cse1Id,
            externalAlertId: 'ALT-$dayIdx-$aIdx',
            title: 'Alert $dayIdx-$aIdx',
            category: 'MALWARE',
            severity: 'MEDIUM',
            status: 'NEW',
            detectedAt: alertDate,
            createdAt: alertDate,
          ));
        }
      }

      final results = AnomalyAnalyzer.analyzeAN01DailyAlertVolume(
        cseId: cse1Id,
        alerts: alerts,
      );

      expect(results.length, equals(1));
      final item = results.first;
      expect(item.finding.findingCode, equals('FND-AN01-111111-2026-01-10'));
      expect(item.finding.category, equals('ANOMALY'));
      expect(item.finding.severity, equals('MEDIUM'));
      expect(item.finding.metricsJson!['observed_value'], equals(100));
      expect(item.finding.metricsJson!['baseline_value'], equals(11.0));
      expect(item.finding.metricsJson!['mad'], equals(5.0));
      expect(item.evidences.length, equals(5));
      expect(item.evidences.first.evidenceType, equals('ALERT'));
    });

    test('7. AN-01 returns empty list when MAD is zero', () {
      final alerts = <AlertEntity>[];
      for (var dayIdx = 0; dayIdx < 10; dayIdx++) {
        final alertDate = DateTime.utc(2026, 1, dayIdx + 1, 10, 0, 0);
        for (var aIdx = 0; aIdx < 5; aIdx++) {
          alerts.add(AlertEntity(
            id: 'alt22222-${dayIdx.toString().padLeft(4, '0')}-${aIdx.toString().padLeft(4, '0')}-000000000000',
            cseId: cse1Id,
            externalAlertId: 'ALT-$dayIdx-$aIdx',
            title: 'Alert',
            category: 'MALWARE',
            severity: 'MEDIUM',
            status: 'NEW',
            detectedAt: alertDate,
            createdAt: alertDate,
          ));
        }
      }

      final results = AnomalyAnalyzer.analyzeAN01DailyAlertVolume(
        cseId: cse1Id,
        alerts: alerts,
      );

      expect(results, isEmpty);
    });

    test('8. BM-01 Peer Benchmarking calculates sector Z-scores and flags deviations', () {
      final cse1 = CSEEntity(id: cse1Id, cseCode: 'CSE1', name: 'Bank 1', sector: 'BANKING', criticalityTier: 'TIER_1', isActive: true, createdAt: nowUtc, updatedAt: nowUtc);
      final cse2 = CSEEntity(id: cse2Id, cseCode: 'CSE2', name: 'Bank 2', sector: 'BANKING', criticalityTier: 'TIER_1', isActive: true, createdAt: nowUtc, updatedAt: nowUtc);
      final cse3 = CSEEntity(id: cse3Id, cseCode: 'CSE3', name: 'Bank 3', sector: 'BANKING', criticalityTier: 'TIER_1', isActive: true, createdAt: nowUtc, updatedAt: nowUtc);
      final cseTarget = CSEEntity(id: '44444444-4444-4444-4444-444444444444', cseCode: 'CSET', name: 'Target Bank', sector: 'BANKING', criticalityTier: 'TIER_1', isActive: true, createdAt: nowUtc, updatedAt: nowUtc);

      final allCses = <CSEEntity>[cse1, cse2, cse3, cseTarget];
      final alerts = <AlertEntity>[];
      final cases = <CaseEntity>[];
      final escalations = <EscalationEntity>[];

      final peerCaseCounts = [8, 9, 10];
      final peerCses = [cse1, cse2, cse3];

      for (var idx = 0; idx < peerCses.length; idx++) {
        final c = peerCses[idx];
        final caseLimit = peerCaseCounts[idx];
        for (var i = 0; i < 10; i++) {
          final altId = 'alt-bm-${c.cseCode}-$i';
          alerts.add(AlertEntity(id: altId, cseId: c.id, externalAlertId: altId, title: 'Alert', category: 'THREAT', severity: 'HIGH', status: 'NEW', detectedAt: nowUtc, createdAt: nowUtc));
          if (i < caseLimit) {
            cases.add(CaseEntity(id: 'case-bm-${c.cseCode}-$i', cseId: c.id, alertId: altId, externalCaseId: 'CS', title: 'Case', status: 'OPEN', priority: 'MEDIUM', openedAt: nowUtc, createdAt: nowUtc));
          }
        }
      }

      for (var i = 0; i < 10; i++) {
        final altId = 'alt-bm-CSET-$i';
        alerts.add(AlertEntity(id: altId, cseId: cseTarget.id, externalAlertId: altId, title: 'Alert', category: 'THREAT', severity: 'HIGH', status: 'NEW', detectedAt: nowUtc, createdAt: nowUtc));
        if (i < 1) {
          cases.add(CaseEntity(id: 'case-bm-CSET-$i', cseId: cseTarget.id, alertId: altId, externalCaseId: 'CS', title: 'Case', status: 'OPEN', priority: 'MEDIUM', openedAt: nowUtc, createdAt: nowUtc));
        }
      }

      final bmResult = BenchmarkAnalyzer.analyzeBM01PeerBenchmarks(
        targetCse: cseTarget,
        allCses: allCses,
        allAlerts: alerts,
        allCases: cases,
        allEscalations: escalations,
      );

      expect(bmResult.baselines.length, equals(1));
      expect(bmResult.baselines.first.peerGroup, equals('SECTOR_BANKING'));
      expect(bmResult.findingsWithEvidence.length, equals(1));
      final item = bmResult.findingsWithEvidence.first;
      expect(item.finding.findingCode, startsWith('FND-BM01-INV-444444'));
      expect(item.finding.category, equals('BENCHMARK'));
      expect(item.finding.severity, equals('MEDIUM'));
      expect(item.finding.metricsJson!['observed_value'], equals(0.1));
    });

    test('9. OI-01 Operational Inconsistency flags resolved case with 0 linked investigations', () {
      final cases = <CaseEntity>[
        CaseEntity(
          id: 'c9999999-0000-0000-0000-000000000001',
          cseId: cse1Id,
          externalCaseId: 'CASE-RESOLVED-NO-INV',
          title: 'Uninvestigated Case',
          status: 'RESOLVED',
          priority: 'HIGH',
          openedAt: nowUtc.subtract(const Duration(hours: 5)),
          closedAt: nowUtc,
          createdAt: nowUtc,
        ),
      ];

      final results = OperationalInconsistencyAnalyzer.analyzeOI01EvidenceLinkageGaps(
        cseId: cse1Id,
        cases: cases,
        investigations: <InvestigationEntity>[],
      );

      expect(results.length, equals(1));
      final item = results.first;
      expect(item.finding.findingCode, startsWith('FND-OI01-111111-c99999'));
      expect(item.finding.category, equals('EXECUTION_GAP'));
      expect(item.finding.severity, equals('MEDIUM'));
      expect(item.finding.metricsJson!['observed_value'], equals(0));
      expect(item.evidences.first.evidenceType, equals('CASE'));
    });

    test('10. AnalyticsRunner orchestrates pipeline and persists findings to Drift DB', () async {
      final cse = CSEEntity(id: cse1Id, cseCode: 'CSE1', name: 'Test Bank', sector: 'BANKING', criticalityTier: 'TIER_1', isActive: true, createdAt: nowUtc, updatedAt: nowUtc);
      await repo.insertCSE(cse);

      final closedCase = CaseEntity(
        id: 'c8888888-0000-0000-0000-000000000001',
        cseId: cse1Id,
        externalCaseId: 'CASE-OI01-TEST',
        title: 'Closed Case',
        status: 'CLOSED',
        priority: 'MEDIUM',
        openedAt: nowUtc.subtract(const Duration(hours: 2)),
        closedAt: nowUtc,
        createdAt: nowUtc,
      );
      await repo.insertCase(closedCase);

      final coverage = MonitoringCoverageEntity(
        id: 'cov88888-0000-0000-0000-000000000001',
        cseId: cse1Id,
        logSourceCategory: 'ACTIVE_DIRECTORY',
        isExpected: true,
        isActive: false,
        createdAt: nowUtc,
      );
      await repo.insertMonitoringCoverage(coverage);

      final runResult = await AnalyticsRunner.runAnalyticsForCSE(
        repository: repo,
        cseId: cse1Id,
      );

      expect(runResult.analysisRun.status, equals('COMPLETED'));
      expect(runResult.createdFindings.length, equals(2));

      final dbFindings = await repo.getFindingsByCSE(cse1Id);
      expect(dbFindings.length, equals(2));
      final findingCodes = dbFindings.map((f) => f.findingCode).toSet();
      expect(findingCodes.any((code) => code.startsWith('FND-NS01')), isTrue);
      expect(findingCodes.any((code) => code.startsWith('FND-OI01')), isTrue);
    });

    test('11. Supervisory Attention Queue sorts deterministically according to 4-tier rule', () async {
      final cseA = CSEEntity(id: cse1Id, cseCode: 'CSEA', name: 'Bank A', sector: 'BANKING', criticalityTier: 'TIER_1', isActive: true, createdAt: nowUtc, updatedAt: nowUtc);
      final cseB = CSEEntity(id: cse2Id, cseCode: 'CSEB', name: 'Bank B', sector: 'BANKING', criticalityTier: 'TIER_1', isActive: true, createdAt: nowUtc, updatedAt: nowUtc);
      final cseC = CSEEntity(id: cse3Id, cseCode: 'CSEC', name: 'Bank C', sector: 'BANKING', criticalityTier: 'TIER_1', isActive: true, createdAt: nowUtc, updatedAt: nowUtc);

      final cses = <CSEEntity>[cseA, cseB, cseC];

      final findings = <FindingEntity>[
        FindingEntity(id: 'f-a1', findingCode: 'FND-NS01-A1', cseId: cse1Id, category: 'NEGATIVE_SPACE', severity: 'HIGH', title: 'NS1', description: 'NS1', rationale: 'R1', detectionMethod: 'MANUAL', status: 'NEW', detectedAt: nowUtc, updatedAt: nowUtc),
        FindingEntity(id: 'f-a2', findingCode: 'FND-EG03-A2', cseId: cse1Id, category: 'EXECUTION_GAP', severity: 'MEDIUM', title: 'EG3', description: 'EG3', rationale: 'R2', detectionMethod: 'MANUAL', status: 'NEW', detectedAt: nowUtc, updatedAt: nowUtc),
        FindingEntity(id: 'f-a3', findingCode: 'FND-OI01-A3', cseId: cse1Id, category: 'EXECUTION_GAP', severity: 'MEDIUM', title: 'OI1', description: 'OI1', rationale: 'R3', detectionMethod: 'MANUAL', status: 'NEW', detectedAt: nowUtc, updatedAt: nowUtc),

        FindingEntity(id: 'f-b1', findingCode: 'FND-NS01-B1', cseId: cse2Id, category: 'NEGATIVE_SPACE', severity: 'HIGH', title: 'NS1', description: 'NS1', rationale: 'R1', detectionMethod: 'MANUAL', status: 'NEW', detectedAt: nowUtc, updatedAt: nowUtc),
        FindingEntity(id: 'f-b2', findingCode: 'FND-EG03-B2', cseId: cse2Id, category: 'EXECUTION_GAP', severity: 'MEDIUM', title: 'EG3', description: 'EG3', rationale: 'R2', detectionMethod: 'MANUAL', status: 'NEW', detectedAt: nowUtc, updatedAt: nowUtc),
        FindingEntity(id: 'f-b3', findingCode: 'FND-OI01-B3', cseId: cse2Id, category: 'EXECUTION_GAP', severity: 'MEDIUM', title: 'OI1', description: 'OI1', rationale: 'R3', detectionMethod: 'MANUAL', status: 'NEW', detectedAt: nowUtc, updatedAt: nowUtc),
      ];

      final evidences = <FindingEvidenceEntity>[
        FindingEvidenceEntity(id: 'ev-a1', findingId: 'f-a1', evidenceType: 'COVERAGE', createdAt: nowUtc),
        FindingEvidenceEntity(id: 'ev-a2', findingId: 'f-a1', evidenceType: 'COVERAGE', createdAt: nowUtc),

        FindingEvidenceEntity(id: 'ev-b1', findingId: 'f-b1', evidenceType: 'COVERAGE', createdAt: nowUtc),
        FindingEvidenceEntity(id: 'ev-b2', findingId: 'f-b1', evidenceType: 'COVERAGE', createdAt: nowUtc),
        FindingEvidenceEntity(id: 'ev-b3', findingId: 'f-b1', evidenceType: 'COVERAGE', createdAt: nowUtc),
        FindingEvidenceEntity(id: 'ev-b4', findingId: 'f-b1', evidenceType: 'COVERAGE', createdAt: nowUtc),
        FindingEvidenceEntity(id: 'ev-b5', findingId: 'f-b1', evidenceType: 'COVERAGE', createdAt: nowUtc),
      ];

      final queue = SupervisoryService.getAttentionQueue(
        cses: cses,
        allFindings: findings,
        allEvidences: evidences,
        allRuns: [],
      );

      expect(queue.length, equals(3));
      expect(queue[0].cseCode, equals('CSEB'));
      expect(queue[1].cseCode, equals('CSEA'));
      expect(queue[2].cseCode, equals('CSEC'));
    });

    test('12. CapabilityService aggregates maturity scores across 8 V2 capabilities', () {
      final findings = <FindingEntity>[
        FindingEntity(id: 'f1', findingCode: 'FND-AN01-1', cseId: cse1Id, category: 'ANOMALY', severity: 'MEDIUM', title: 'T1', description: 'D1', rationale: 'R1', detectionMethod: 'MANUAL', status: 'NEW', detectedAt: nowUtc, updatedAt: nowUtc),
        FindingEntity(id: 'f2', findingCode: 'FND-EG03-1', cseId: cse1Id, category: 'EXECUTION_GAP', severity: 'MEDIUM', title: 'T2', description: 'D2', rationale: 'R2', detectionMethod: 'MANUAL', status: 'NEW', detectedAt: nowUtc, updatedAt: nowUtc),
        FindingEntity(id: 'f3', findingCode: 'FND-NS01-1', cseId: cse1Id, category: 'NEGATIVE_SPACE', severity: 'HIGH', title: 'T3', description: 'D3', rationale: 'R3', detectionMethod: 'MANUAL', status: 'NEW', detectedAt: nowUtc, updatedAt: nowUtc),
      ];

      final breakdown = CapabilityService.getCapabilityBreakdown(findings: findings);

      expect(breakdown.keys.length, equals(8));
      expect(breakdown['Threat Detection']!.activeFindings, equals(1));
      expect(breakdown['Investigation']!.activeFindings, equals(1));
      expect(breakdown['Security Operations']!.activeFindings, equals(1));
      expect(breakdown['Security Operations']!.criticalHighFindings, equals(1));
      expect(breakdown['Security Operations']!.maturityScore, equals(85.0));
    });
  });
}
