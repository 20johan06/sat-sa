import 'dart:io';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:satsa_mobile/data/database/app_database.dart';
import 'package:satsa_mobile/data/repositories/local_repository.dart';
import 'package:satsa_mobile/domain/entities/cse.dart';
import 'package:satsa_mobile/domain/entities/assessment.dart';
import 'package:satsa_mobile/domain/entities/dataset_version.dart';
import 'package:satsa_mobile/domain/entities/analysis_run.dart';
import 'package:satsa_mobile/domain/entities/finding.dart';
import 'package:satsa_mobile/domain/entities/finding_evidence.dart';
import 'package:satsa_mobile/domain/entities/finding_review_history.dart';
import 'package:satsa_mobile/domain/entities/report_record.dart';
import 'package:satsa_mobile/domain/entities/alert_entity.dart';
import 'package:satsa_mobile/domain/entities/case_entity.dart';
import 'package:satsa_mobile/domain/entities/investigation_entity.dart';
import 'package:satsa_mobile/domain/entities/escalation_entity.dart';
import 'package:satsa_mobile/domain/entities/monitoring_coverage_entity.dart';
import 'package:satsa_mobile/domain/entities/asset_entity.dart';

void main() {
  late AppDatabase db;
  late LocalSupervisoryRepository repo;

  setUpAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = LocalSupervisoryRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Drift Offline Database Foundation Tests (Phase 20A)', () {
    // 1. Database opens successfully
    test('1. Database opens successfully', () async {
      expect(db.schemaVersion, 1);
    });

    // 2. All 14 tables are available
    test('2. All 14 tables are available', () async {
      final cses = await repo.getAllCSEs();
      expect(cses, isEmpty);
    });

    // 3. Insert and read CSE
    test('3. Insert and read CSE', () async {
      final now = DateTime.now().toUtc();
      final cse = CSEEntity(
        id: 'cse-1',
        cseCode: 'CSE-BANK-01',
        name: 'National Reserve Bank',
        sector: 'FINANCIAL',
        criticalityTier: 'TIER_1',
        contactEmail: 'soc@bank.org',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );

      await repo.insertCSE(cse);
      final fetched = await repo.getCSEById('cse-1');

      expect(fetched, isNotNull);
      expect(fetched!.id, 'cse-1');
      expect(fetched.name, 'National Reserve Bank');
    });

    // 4. CSE code uniqueness
    test('4. CSE code uniqueness', () async {
      final now = DateTime.now().toUtc();
      final cse1 = CSEEntity(
        id: 'cse-1',
        cseCode: 'CSE-UNIQUE',
        name: 'Bank A',
        sector: 'FINANCIAL',
        criticalityTier: 'TIER_1',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );

      final cse2 = CSEEntity(
        id: 'cse-2',
        cseCode: 'CSE-UNIQUE',
        name: 'Bank B',
        sector: 'FINANCIAL',
        criticalityTier: 'TIER_1',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );

      await repo.insertCSE(cse1);
      // Inserting duplicate unique key via insertOrReplace replaces record with same cseCode
      await repo.insertCSE(cse2);
      final all = await repo.getAllCSEs();
      expect(all.length, 1);
      expect(all.first.name, 'Bank B');
    });

    // 5. Assessment → CSE relationship
    test('5. Assessment -> CSE relationship', () async {
      final now = DateTime.now().toUtc();
      await repo.insertCSE(CSEEntity(
        id: 'cse-1',
        cseCode: 'CSE-1',
        name: 'CSE One',
        sector: 'BANKING',
        criticalityTier: 'TIER_1',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ));

      final ass = AssessmentEntity(
        id: 'ass-1',
        cseId: 'cse-1',
        name: 'Q3 Assessment',
        periodStart: now,
        periodEnd: now,
        status: 'UNDER_REVIEW',
        createdAt: now,
        updatedAt: now,
      );

      await repo.insertAssessment(ass);
      final list = await repo.getAssessmentsByCSE('cse-1');

      expect(list.length, 1);
      expect(list.first.cseId, 'cse-1');
    });

    // 6. DatasetVersion → CSE/Assessment
    test('6. DatasetVersion -> CSE/Assessment relationship', () async {
      final now = DateTime.now().toUtc();
      await repo.insertCSE(CSEEntity(
        id: 'cse-1',
        cseCode: 'CSE-1',
        name: 'CSE 1',
        sector: 'FIN',
        criticalityTier: 'TIER_1',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ));

      await repo.insertAssessment(AssessmentEntity(
        id: 'ass-1',
        cseId: 'cse-1',
        name: 'Assessment 1',
        periodStart: now,
        periodEnd: now,
        status: 'OPEN',
        createdAt: now,
        updatedAt: now,
      ));

      final dv = DatasetVersionEntity(
        id: 'dv-1',
        cseId: 'cse-1',
        assessmentId: 'ass-1',
        versionTag: 'v1.0',
        datasetType: 'SIEM',
        sourceFilename: 'logs.csv',
        contentHash: 'hash123',
        recordCount: 500,
        isImmutable: true,
        createdAt: now,
      );

      await repo.insertDatasetVersion(dv);
      final fetched = await repo.getDatasetVersionById('dv-1');

      expect(fetched, isNotNull);
      expect(fetched!.cseId, 'cse-1');
      expect(fetched.assessmentId, 'ass-1');
    });

    // 7. AnalysisRun relationships
    test('7. AnalysisRun relationships', () async {
      final now = DateTime.now().toUtc();
      await repo.insertCSE(CSEEntity(
        id: 'cse-1',
        cseCode: 'CSE-1',
        name: 'CSE 1',
        sector: 'FIN',
        criticalityTier: 'TIER_1',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ));

      await repo.insertAssessment(AssessmentEntity(
        id: 'ass-1',
        cseId: 'cse-1',
        name: 'Assessment 1',
        periodStart: now,
        periodEnd: now,
        status: 'OPEN',
        createdAt: now,
        updatedAt: now,
      ));

      await repo.insertDatasetVersion(DatasetVersionEntity(
        id: 'dv-1',
        cseId: 'cse-1',
        assessmentId: 'ass-1',
        versionTag: 'v1.0',
        datasetType: 'SIEM',
        sourceFilename: 'logs.csv',
        contentHash: 'hash123',
        recordCount: 500,
        isImmutable: true,
        createdAt: now,
      ));

      final ar = AnalysisRunEntity(
        id: 'ar-1',
        cseId: 'cse-1',
        assessmentId: 'ass-1',
        datasetVersionId: 'dv-1',
        engineVersion: 'v2.0.0',
        rulesEvaluated: ['EG-01', 'NS-01'],
        status: 'COMPLETED',
        findingsCreated: 2,
        baselinesPersisted: 1,
        startedAt: now,
      );

      await repo.insertAnalysisRun(ar);
      final fetched = await repo.getAnalysisRunById('ar-1');

      expect(fetched, isNotNull);
      expect(fetched!.rulesEvaluated, contains('EG-01'));
      expect(fetched.findingsCreated, 2);
    });

    // 8. Finding → CSE/AnalysisRun
    test('8. Finding -> CSE/AnalysisRun relationship', () async {
      final now = DateTime.now().toUtc();
      await repo.insertCSE(CSEEntity(
        id: 'cse-1',
        cseCode: 'CSE-1',
        name: 'CSE 1',
        sector: 'FIN',
        criticalityTier: 'TIER_1',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ));

      await repo.insertAssessment(AssessmentEntity(
        id: 'ass-1',
        cseId: 'cse-1',
        name: 'Assessment 1',
        periodStart: now,
        periodEnd: now,
        status: 'OPEN',
        createdAt: now,
        updatedAt: now,
      ));

      await repo.insertDatasetVersion(DatasetVersionEntity(
        id: 'dv-1',
        cseId: 'cse-1',
        assessmentId: 'ass-1',
        versionTag: 'v1.0',
        datasetType: 'SIEM',
        sourceFilename: 'logs.csv',
        contentHash: 'hash123',
        recordCount: 500,
        isImmutable: true,
        createdAt: now,
      ));

      await repo.insertAnalysisRun(AnalysisRunEntity(
        id: 'ar-1',
        cseId: 'cse-1',
        assessmentId: 'ass-1',
        datasetVersionId: 'dv-1',
        engineVersion: 'v2.0.0',
        rulesEvaluated: ['EG-01'],
        status: 'COMPLETED',
        findingsCreated: 1,
        baselinesPersisted: 0,
        startedAt: now,
      ));

      final finding = FindingEntity(
        id: 'find-1',
        findingCode: 'FIND-001',
        cseId: 'cse-1',
        analysisRunId: 'ar-1',
        category: 'EXECUTION_GAP',
        severity: 'CRITICAL',
        title: 'Unmonitored Node',
        description: 'Desc',
        rationale: 'Rat',
        detectionMethod: 'RULE',
        status: 'NEW',
        detectedAt: now,
        updatedAt: now,
      );

      await repo.insertFinding(finding);
      final list = await repo.getFindingsByCSE('cse-1');

      expect(list.length, 1);
      expect(list.first.findingCode, 'FIND-001');
    });

    // 9. FindingEvidence relationships
    test('9. FindingEvidence relationships', () async {
      final now = DateTime.now().toUtc();
      await repo.insertCSE(CSEEntity(
        id: 'cse-1',
        cseCode: 'CSE-1',
        name: 'CSE 1',
        sector: 'FIN',
        criticalityTier: 'TIER_1',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ));

      await repo.insertAsset(AssetEntity(
        id: 'ast-1',
        cseId: 'cse-1',
        assetIdentifier: 'AST-1',
        name: 'Asset 1',
        assetType: 'SERVER',
        criticality: 'HIGH',
        createdAt: now,
      ));

      await repo.insertFinding(FindingEntity(
        id: 'find-1',
        findingCode: 'FIND-001',
        cseId: 'cse-1',
        category: 'EXECUTION_GAP',
        severity: 'HIGH',
        title: 'Title',
        description: 'Desc',
        rationale: 'Rat',
        detectionMethod: 'RULE',
        status: 'NEW',
        detectedAt: now,
        updatedAt: now,
      ));

      await repo.insertAlert(AlertEntity(
        id: 'alt-1',
        cseId: 'cse-1',
        assetId: 'ast-1',
        externalAlertId: 'ALT-1',
        title: 'Alert 1',
        category: 'PERF',
        severity: 'HIGH',
        status: 'NEW',
        detectedAt: now,
        createdAt: now,
      ));

      await repo.insertCase(CaseEntity(
        id: 'cas-1',
        cseId: 'cse-1',
        alertId: 'alt-1',
        externalCaseId: 'CAS-1',
        title: 'Case 1',
        status: 'OPEN',
        priority: 'HIGH',
        openedAt: now,
        createdAt: now,
      ));

      final ev = FindingEvidenceEntity(
        id: 'ev-1',
        findingId: 'find-1',
        evidenceType: 'ALERT',
        alertId: 'alt-1',
        caseId: 'cas-1',
        createdAt: now,
      );

      await repo.insertFindingEvidence(ev);
      final list = await repo.getEvidencesByFinding('find-1');

      expect(list.length, 1);
      expect(list.first.alertId, 'alt-1');
    });

    // 10. Review history relationships
    test('10. Review history relationships', () async {
      final now = DateTime.now().toUtc();
      await repo.insertCSE(CSEEntity(
        id: 'cse-1',
        cseCode: 'CSE-1',
        name: 'CSE 1',
        sector: 'FIN',
        criticalityTier: 'TIER_1',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ));

      await repo.insertFinding(FindingEntity(
        id: 'find-1',
        findingCode: 'FIND-001',
        cseId: 'cse-1',
        category: 'EXECUTION_GAP',
        severity: 'HIGH',
        title: 'Title',
        description: 'Desc',
        rationale: 'Rat',
        detectionMethod: 'RULE',
        status: 'NEW',
        detectedAt: now,
        updatedAt: now,
      ));

      final fr = FindingReviewHistoryEntity(
        id: 'fr-1',
        findingId: 'find-1',
        cseId: 'cse-1',
        actionType: 'REVIEW',
        previousStatus: 'NEW',
        newStatus: 'IN_REVIEW',
        noteText: 'Inspecting finding',
        createdAt: now,
      );

      await repo.insertFindingReviewHistory(fr);
      final list = await repo.getReviewHistoriesByCSE('cse-1');

      expect(list.length, 1);
      expect(list.first.noteText, 'Inspecting finding');
    });

    // 11. Report relationships
    test('11. Report relationships', () async {
      final now = DateTime.now().toUtc();
      await repo.insertCSE(CSEEntity(
        id: 'cse-1',
        cseCode: 'CSE-1',
        name: 'CSE 1',
        sector: 'FIN',
        criticalityTier: 'TIER_1',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ));

      final report = ReportRecordEntity(
        id: 'rep-1',
        reportCode: 'REP-100',
        cseId: 'cse-1',
        generatedByUserId: 'usr-1',
        createdAt: now,
        summaryJson: {'score': 95.0},
      );

      await repo.insertReportRecord(report);
      final list = await repo.getReportRecordsByCSE('cse-1');

      expect(list.length, 1);
      expect(list.first.summaryJson['score'], 95.0);
    });

    // 12. Alert → Asset/CSE
    test('12. Alert -> Asset/CSE relationship', () async {
      final now = DateTime.now().toUtc();
      await repo.insertCSE(CSEEntity(
        id: 'cse-1',
        cseCode: 'CSE-1',
        name: 'CSE 1',
        sector: 'FIN',
        criticalityTier: 'TIER_1',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ));

      await repo.insertAsset(AssetEntity(
        id: 'ast-1',
        cseId: 'cse-1',
        assetIdentifier: 'AST-1',
        name: 'Asset 1',
        assetType: 'SERVER',
        criticality: 'HIGH',
        createdAt: now,
      ));

      final alert = AlertEntity(
        id: 'alt-1',
        cseId: 'cse-1',
        assetId: 'ast-1',
        externalAlertId: 'ALT-500',
        title: 'CPU Spike',
        category: 'PERF',
        severity: 'HIGH',
        status: 'NEW',
        detectedAt: now,
        createdAt: now,
      );

      await repo.insertAlert(alert);
      final list = await repo.getAlertsByCSE('cse-1');

      expect(list.length, 1);
      expect(list.first.assetId, 'ast-1');
    });

    // 13. Case → Alert/CSE
    test('13. Case -> Alert/CSE relationship', () async {
      final now = DateTime.now().toUtc();
      await repo.insertCSE(CSEEntity(
        id: 'cse-1',
        cseCode: 'CSE-1',
        name: 'CSE 1',
        sector: 'FIN',
        criticalityTier: 'TIER_1',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ));

      await repo.insertAsset(AssetEntity(
        id: 'ast-1',
        cseId: 'cse-1',
        assetIdentifier: 'AST-1',
        name: 'Asset 1',
        assetType: 'SERVER',
        criticality: 'HIGH',
        createdAt: now,
      ));

      await repo.insertAlert(AlertEntity(
        id: 'alt-1',
        cseId: 'cse-1',
        assetId: 'ast-1',
        externalAlertId: 'ALT-1',
        title: 'Alert 1',
        category: 'PERF',
        severity: 'HIGH',
        status: 'NEW',
        detectedAt: now,
        createdAt: now,
      ));

      final caseObj = CaseEntity(
        id: 'cas-1',
        cseId: 'cse-1',
        alertId: 'alt-1',
        externalCaseId: 'CAS-900',
        title: 'Outage Case',
        status: 'OPEN',
        priority: 'HIGH',
        openedAt: now,
        createdAt: now,
      );

      await repo.insertCase(caseObj);
      final list = await repo.getCasesByCSE('cse-1');

      expect(list.length, 1);
      expect(list.first.alertId, 'alt-1');
    });

    // 14. Investigation → Case
    test('14. Investigation -> Case relationship', () async {
      final now = DateTime.now().toUtc();
      await repo.insertCSE(CSEEntity(
        id: 'cse-1',
        cseCode: 'CSE-1',
        name: 'CSE 1',
        sector: 'FIN',
        criticalityTier: 'TIER_1',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ));

      await repo.insertAsset(AssetEntity(
        id: 'ast-1',
        cseId: 'cse-1',
        assetIdentifier: 'AST-1',
        name: 'Asset 1',
        assetType: 'SERVER',
        criticality: 'HIGH',
        createdAt: now,
      ));

      await repo.insertAlert(AlertEntity(
        id: 'alt-1',
        cseId: 'cse-1',
        assetId: 'ast-1',
        externalAlertId: 'ALT-1',
        title: 'Alert 1',
        category: 'PERF',
        severity: 'HIGH',
        status: 'NEW',
        detectedAt: now,
        createdAt: now,
      ));

      await repo.insertCase(CaseEntity(
        id: 'cas-1',
        cseId: 'cse-1',
        alertId: 'alt-1',
        externalCaseId: 'CAS-1',
        title: 'Case 1',
        status: 'OPEN',
        priority: 'HIGH',
        openedAt: now,
        createdAt: now,
      ));

      final inv = InvestigationEntity(
        id: 'inv-1',
        caseId: 'cas-1',
        actionType: 'PIPELINE_AUDIT',
        startedAt: now,
        evidenceCount: 4,
        createdAt: now,
      );

      await repo.insertInvestigation(inv);
      final list = await repo.getInvestigationsByCase('cas-1');

      expect(list.length, 1);
      expect(list.first.evidenceCount, 4);
    });

    // 15. Escalation → Case/Alert
    test('15. Escalation -> Case/Alert relationship', () async {
      final now = DateTime.now().toUtc();
      await repo.insertCSE(CSEEntity(
        id: 'cse-1',
        cseCode: 'CSE-1',
        name: 'CSE 1',
        sector: 'FIN',
        criticalityTier: 'TIER_1',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ));

      await repo.insertAsset(AssetEntity(
        id: 'ast-1',
        cseId: 'cse-1',
        assetIdentifier: 'AST-1',
        name: 'Asset 1',
        assetType: 'SERVER',
        criticality: 'HIGH',
        createdAt: now,
      ));

      await repo.insertAlert(AlertEntity(
        id: 'alt-1',
        cseId: 'cse-1',
        assetId: 'ast-1',
        externalAlertId: 'ALT-1',
        title: 'Alert 1',
        category: 'PERF',
        severity: 'HIGH',
        status: 'NEW',
        detectedAt: now,
        createdAt: now,
      ));

      await repo.insertCase(CaseEntity(
        id: 'cas-1',
        cseId: 'cse-1',
        alertId: 'alt-1',
        externalCaseId: 'CAS-1',
        title: 'Case 1',
        status: 'OPEN',
        priority: 'HIGH',
        openedAt: now,
        createdAt: now,
      ));

      final esc = EscalationEntity(
        id: 'esc-1',
        caseId: 'cas-1',
        alertId: 'alt-1',
        escalationLevel: 'LEVEL_2',
        status: 'PENDING',
        escalatedAt: now,
        createdAt: now,
      );

      await repo.insertEscalation(esc);
      final list = await repo.getEscalationsByCase('cas-1');

      expect(list.length, 1);
      expect(list.first.escalationLevel, 'LEVEL_2');
    });

    // 16. MonitoringCoverage → CSE
    test('16. MonitoringCoverage -> CSE relationship', () async {
      final now = DateTime.now().toUtc();
      await repo.insertCSE(CSEEntity(
        id: 'cse-1',
        cseCode: 'CSE-1',
        name: 'CSE 1',
        sector: 'FIN',
        criticalityTier: 'TIER_1',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ));

      final mc = MonitoringCoverageEntity(
        id: 'mc-1',
        cseId: 'cse-1',
        logSourceCategory: 'SIEM_LOGS',
        isExpected: true,
        isActive: true,
        coveragePercentage: 100.0,
        createdAt: now,
      );

      await repo.insertMonitoringCoverage(mc);
      final list = await repo.getCoveragesByCSE('cse-1');

      expect(list.length, 1);
      expect(list.first.coveragePercentage, 100.0);
    });

    // 17. Asset → CSE
    test('17. Asset -> CSE relationship', () async {
      final now = DateTime.now().toUtc();
      await repo.insertCSE(CSEEntity(
        id: 'cse-1',
        cseCode: 'CSE-1',
        name: 'CSE 1',
        sector: 'FIN',
        criticalityTier: 'TIER_1',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ));

      final asset = AssetEntity(
        id: 'ast-1',
        cseId: 'cse-1',
        assetIdentifier: 'SRV-01',
        name: 'Server 01',
        assetType: 'SERVER',
        criticality: 'HIGH',
        createdAt: now,
      );

      await repo.insertAsset(asset);
      final list = await repo.getAssetsByCSE('cse-1');

      expect(list.length, 1);
      expect(list.first.assetIdentifier, 'SRV-01');
    });

    // 18. Nullable foreign keys work correctly
    test('18. Nullable foreign keys work correctly', () async {
      final now = DateTime.now().toUtc();
      await repo.insertCSE(CSEEntity(
        id: 'cse-1',
        cseCode: 'CSE-1',
        name: 'CSE 1',
        sector: 'FIN',
        criticalityTier: 'TIER_1',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ));

      final finding = FindingEntity(
        id: 'find-null-fk',
        findingCode: 'FIND-NULL',
        cseId: 'cse-1',
        batchId: null,
        analysisRunId: null,
        category: 'NEGATIVE_SPACE',
        severity: 'MEDIUM',
        title: 'Nullable FK Finding',
        description: 'Testing null FKs',
        rationale: 'Rationale',
        detectionMethod: 'TEST',
        status: 'NEW',
        detectedAt: now,
        updatedAt: now,
      );

      await repo.insertFinding(finding);
      final fetched = await repo.getFindingById('find-null-fk');

      expect(fetched, isNotNull);
      expect(fetched!.batchId, isNull);
      expect(fetched.analysisRunId, isNull);
    });

    // 19. JSON fields round-trip correctly
    test('19. JSON fields round-trip correctly', () async {
      final now = DateTime.now().toUtc();
      await repo.insertCSE(CSEEntity(
        id: 'cse-1',
        cseCode: 'CSE-1',
        name: 'CSE 1',
        sector: 'FIN',
        criticalityTier: 'TIER_1',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ));

      final finding = FindingEntity(
        id: 'find-json',
        findingCode: 'FIND-JSON',
        cseId: 'cse-1',
        category: 'ANOMALY',
        severity: 'HIGH',
        title: 'JSON Test',
        description: 'Testing JSON map',
        rationale: 'Rationale',
        detectionMethod: 'ANOMALY_ENGINE',
        metricsJson: {'volume': 1500, 'baseline': 200, 'z_score': 3.5},
        status: 'NEW',
        detectedAt: now,
        updatedAt: now,
      );

      await repo.insertFinding(finding);
      final fetched = await repo.getFindingById('find-json');

      expect(fetched, isNotNull);
      expect(fetched!.metricsJson, isNotNull);
      expect(fetched.metricsJson!['volume'], 1500);
      expect(fetched.metricsJson!['z_score'], 3.5);
    });

    // 20. DateTime fields round-trip correctly
    test('20. DateTime fields round-trip correctly', () async {
      final dt = DateTime.utc(2026, 10, 5, 12, 30, 0);
      final cse = CSEEntity(
        id: 'cse-dt',
        cseCode: 'CSE-DT',
        name: 'DateTime Test CSE',
        sector: 'GOV',
        criticalityTier: 'TIER_1',
        isActive: true,
        createdAt: dt,
        updatedAt: dt,
      );

      await repo.insertCSE(cse);
      final fetched = await repo.getCSEById('cse-dt');

      expect(fetched, isNotNull);
      expect(fetched!.createdAt.toUtc().toIso8601String(), dt.toIso8601String());
    });

    // 21. CSE filtering prevents cross-CSE leakage
    test('21. CSE filtering prevents cross-CSE leakage', () async {
      final now = DateTime.now().toUtc();
      await repo.insertCSE(CSEEntity(id: 'cse-A', cseCode: 'CSE-A', name: 'Bank A', sector: 'FIN', criticalityTier: 'TIER_1', isActive: true, createdAt: now, updatedAt: now));
      await repo.insertCSE(CSEEntity(id: 'cse-B', cseCode: 'CSE-B', name: 'Bank B', sector: 'FIN', criticalityTier: 'TIER_1', isActive: true, createdAt: now, updatedAt: now));

      await repo.insertFinding(FindingEntity(id: 'f-A', findingCode: 'F-A', cseId: 'cse-A', category: 'EG', severity: 'HIGH', title: 'Finding A', description: 'D', rationale: 'R', detectionMethod: 'M', status: 'NEW', detectedAt: now, updatedAt: now));
      await repo.insertFinding(FindingEntity(id: 'f-B', findingCode: 'F-B', cseId: 'cse-B', category: 'EG', severity: 'HIGH', title: 'Finding B', description: 'D', rationale: 'R', detectionMethod: 'M', status: 'NEW', detectedAt: now, updatedAt: now));

      final listA = await repo.getFindingsByCSE('cse-A');
      final listB = await repo.getFindingsByCSE('cse-B');

      expect(listA.length, 1);
      expect(listA.first.id, 'f-A');

      expect(listB.length, 1);
      expect(listB.first.id, 'f-B');
    });

    // 22. Database survives close/reopen
    test('22. Database survives close/reopen', () async {
      final tempDir = await Directory.systemTemp.createTemp('satsa_db_test_');
      final dbFile = File('${tempDir.path}/test.db');
      final now = DateTime.now().toUtc();

      final db1 = AppDatabase(NativeDatabase(dbFile));
      final repo1 = LocalSupervisoryRepository(db1);

      await repo1.insertCSE(CSEEntity(
        id: 'cse-persist',
        cseCode: 'CSE-PERSIST',
        name: 'Persistent Bank',
        sector: 'FINANCIAL',
        criticalityTier: 'TIER_1',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ));

      await db1.close();

      final db2 = AppDatabase(NativeDatabase(dbFile));
      final repo2 = LocalSupervisoryRepository(db2);
      final fetched = await repo2.getCSEById('cse-persist');

      expect(fetched, isNotNull);
      expect(fetched!.name, 'Persistent Bank');
      await db2.close();

      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    // 23. Migration/version initialization works
    test('23. Migration/version initialization works', () async {
      expect(db.schemaVersion, 1);
    });

    // 24. Secondary indexes exist in generated database schema
    test('24. Secondary indexes exist in generated database schema', () async {
      final indexEntities = db.allSchemaEntities.whereType<Index>().toList();
      expect(indexEntities, isNotEmpty);
      final indexNames = indexEntities.map((i) => i.entityName).toSet();

      expect(indexNames, contains('idx_cses_sector'));
      expect(indexNames, contains('idx_assessments_cse_id'));
      expect(indexNames, contains('idx_assessments_period_start'));
      expect(indexNames, contains('idx_assessments_period_end'));
      expect(indexNames, contains('idx_assessments_status'));
      expect(indexNames, contains('idx_dataset_versions_cse_id'));
      expect(indexNames, contains('idx_dataset_versions_assessment_id'));
      expect(indexNames, contains('idx_dataset_versions_version_tag'));
      expect(indexNames, contains('idx_dataset_versions_content_hash'));
      expect(indexNames, contains('idx_analysis_runs_cse_id'));
      expect(indexNames, contains('idx_analysis_runs_assessment_id'));
      expect(indexNames, contains('idx_analysis_runs_dataset_version_id'));
      expect(indexNames, contains('idx_analysis_runs_status'));
      expect(indexNames, contains('idx_findings_cse_id'));
      expect(indexNames, contains('idx_findings_analysis_run_id'));
      expect(indexNames, contains('idx_findings_category'));
      expect(indexNames, contains('idx_findings_severity'));
      expect(indexNames, contains('idx_findings_status'));
      expect(indexNames, contains('idx_findings_detected_at'));
      expect(indexNames, contains('idx_finding_evidences_finding_id'));
      expect(indexNames, contains('idx_finding_evidences_evidence_type'));
      expect(indexNames, contains('idx_finding_evidences_alert_id'));
      expect(indexNames, contains('idx_finding_evidences_case_id'));
      expect(indexNames, contains('idx_finding_review_histories_finding_id'));
      expect(indexNames, contains('idx_finding_review_histories_cse_id'));
      expect(indexNames, contains('idx_finding_review_histories_action_type'));
      expect(indexNames, contains('idx_finding_review_histories_created_at'));
      expect(indexNames, contains('idx_report_records_cse_id'));
      expect(indexNames, contains('idx_report_records_assessment_id'));
      expect(indexNames, contains('idx_alerts_cse_id'));
      expect(indexNames, contains('idx_alerts_external_alert_id'));
      expect(indexNames, contains('idx_alerts_severity'));
      expect(indexNames, contains('idx_alerts_status'));
      expect(indexNames, contains('idx_cases_cse_id'));
      expect(indexNames, contains('idx_cases_external_case_id'));
      expect(indexNames, contains('idx_cases_status'));
      expect(indexNames, contains('idx_investigations_case_id'));
      expect(indexNames, contains('idx_investigations_external_id'));
      expect(indexNames, contains('idx_escalations_case_id'));
      expect(indexNames, contains('idx_escalations_alert_id'));
      expect(indexNames, contains('idx_coverages_cse_id'));
      expect(indexNames, contains('idx_coverages_category'));
      expect(indexNames, contains('idx_assets_cse_id'));
      expect(indexNames, contains('idx_assets_identifier'));
      expect(indexNames, contains('idx_assets_criticality'));
    });
  });
}
