import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:satsa_mobile/data/database/app_database.dart';
import 'package:satsa_mobile/data/database/json_helpers.dart';
import 'package:satsa_mobile/data/mappers/entity_mappers.dart';
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

/// Combined Local Persistence Repository for SAT-SA Offline Database Operations.
class LocalSupervisoryRepository {
  final AppDatabase db;

  LocalSupervisoryRepository(this.db);

  // 1. CSE
  Future<void> insertCSE(CSEEntity entity) async {
    await db.into(db.cSEs).insert(
          CSEsCompanion.insert(
            id: entity.id,
            cseCode: entity.cseCode,
            name: entity.name,
            sector: entity.sector,
            criticalityTier: Value(entity.criticalityTier),
            contactEmail: Value(entity.contactEmail),
            isActive: Value(entity.isActive),
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt,
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<CSEEntity?> getCSEById(String id) async {
    final query = db.select(db.cSEs)..where((tbl) => tbl.id.equals(id));
    final record = await query.getSingleOrNull();
    return record?.toEntity();
  }

  Future<List<CSEEntity>> getAllCSEs() async {
    final records = await db.select(db.cSEs).get();
    return records.map((r) => r.toEntity()).toList();
  }

  // 2. Assessment
  Future<void> insertAssessment(AssessmentEntity entity) async {
    await db.into(db.assessments).insert(
          AssessmentsCompanion.insert(
            id: entity.id,
            cseId: entity.cseId,
            name: entity.name,
            description: Value(entity.description),
            periodStart: entity.periodStart,
            periodEnd: entity.periodEnd,
            status: Value(entity.status),
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt,
            createdByUserId: Value(entity.createdByUserId),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<AssessmentEntity?> getAssessmentById(String id) async {
    final query = db.select(db.assessments)..where((tbl) => tbl.id.equals(id));
    final record = await query.getSingleOrNull();
    return record?.toEntity();
  }

  Future<List<AssessmentEntity>> getAssessmentsByCSE(String cseId) async {
    final query = db.select(db.assessments)..where((tbl) => tbl.cseId.equals(cseId));
    final records = await query.get();
    return records.map((r) => r.toEntity()).toList();
  }

  // 3. DatasetVersion
  Future<void> insertDatasetVersion(DatasetVersionEntity entity) async {
    await db.into(db.datasetVersions).insert(
          DatasetVersionsCompanion.insert(
            id: entity.id,
            cseId: entity.cseId,
            assessmentId: Value(entity.assessmentId),
            batchId: Value(entity.batchId),
            versionTag: entity.versionTag,
            datasetType: entity.datasetType,
            sourceFilename: entity.sourceFilename,
            contentHash: entity.contentHash,
            recordCount: Value(entity.recordCount),
            isImmutable: Value(entity.isImmutable),
            createdAt: entity.createdAt,
            createdByUserId: Value(entity.createdByUserId),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<DatasetVersionEntity?> getDatasetVersionById(String id) async {
    final query = db.select(db.datasetVersions)..where((tbl) => tbl.id.equals(id));
    final record = await query.getSingleOrNull();
    return record?.toEntity();
  }

  Future<List<DatasetVersionEntity>> getDatasetVersionsByCSE(String cseId) async {
    final query = db.select(db.datasetVersions)..where((tbl) => tbl.cseId.equals(cseId));
    final records = await query.get();
    return records.map((r) => r.toEntity()).toList();
  }

  // 4. AnalysisRun
  Future<void> insertAnalysisRun(AnalysisRunEntity entity) async {
    await db.into(db.analysisRuns).insert(
          AnalysisRunsCompanion.insert(
            id: entity.id,
            cseId: entity.cseId,
            assessmentId: Value(entity.assessmentId),
            datasetVersionId: Value(entity.datasetVersionId),
            obsStart: Value(entity.obsStart),
            obsEnd: Value(entity.obsEnd),
            engineVersion: Value(entity.engineVersion),
            rulesEvaluated: jsonEncode(entity.rulesEvaluated),
            status: Value(entity.status),
            findingsCreated: Value(entity.findingsCreated),
            baselinesPersisted: Value(entity.baselinesPersisted),
            errorMessage: Value(entity.errorMessage),
            startedAt: entity.startedAt,
            completedAt: Value(entity.completedAt),
            executedByUserId: Value(entity.executedByUserId),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<AnalysisRunEntity?> getAnalysisRunById(String id) async {
    final query = db.select(db.analysisRuns)..where((tbl) => tbl.id.equals(id));
    final record = await query.getSingleOrNull();
    return record?.toEntity();
  }

  Future<List<AnalysisRunEntity>> getAnalysisRunsByCSE(String cseId) async {
    final query = db.select(db.analysisRuns)..where((tbl) => tbl.cseId.equals(cseId));
    final records = await query.get();
    return records.map((r) => r.toEntity()).toList();
  }

  // 5. Finding
  Future<void> insertFinding(FindingEntity entity) async {
    await db.into(db.findings).insert(
          FindingsCompanion.insert(
            id: entity.id,
            findingCode: entity.findingCode,
            cseId: entity.cseId,
            batchId: Value(entity.batchId),
            analysisRunId: Value(entity.analysisRunId),
            category: entity.category,
            severity: entity.severity,
            title: entity.title,
            description: entity.description,
            rationale: entity.rationale,
            detectionMethod: entity.detectionMethod,
            metricsJson: Value(jsonEncodeOrNull(entity.metricsJson)),
            status: Value(entity.status),
            detectedAt: entity.detectedAt,
            updatedAt: entity.updatedAt,
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<FindingEntity?> getFindingById(String id) async {
    final query = db.select(db.findings)..where((tbl) => tbl.id.equals(id));
    final record = await query.getSingleOrNull();
    return record?.toEntity();
  }

  Future<List<FindingEntity>> getFindingsByCSE(String cseId) async {
    final query = db.select(db.findings)..where((tbl) => tbl.cseId.equals(cseId));
    final records = await query.get();
    return records.map((r) => r.toEntity()).toList();
  }

  // 6. FindingEvidence
  Future<void> insertFindingEvidence(FindingEvidenceEntity entity) async {
    await db.into(db.findingEvidences).insert(
          FindingEvidencesCompanion.insert(
            id: entity.id,
            findingId: entity.findingId,
            evidenceType: entity.evidenceType,
            alertId: Value(entity.alertId),
            caseId: Value(entity.caseId),
            investigationId: Value(entity.investigationId),
            escalationId: Value(entity.escalationId),
            coverageId: Value(entity.coverageId),
            notes: Value(entity.notes),
            createdAt: entity.createdAt,
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<FindingEvidenceEntity?> getFindingEvidenceById(String id) async {
    final query = db.select(db.findingEvidences)..where((tbl) => tbl.id.equals(id));
    final record = await query.getSingleOrNull();
    return record?.toEntity();
  }

  Future<List<FindingEvidenceEntity>> getEvidencesByFinding(String findingId) async {
    final query = db.select(db.findingEvidences)..where((tbl) => tbl.findingId.equals(findingId));
    final records = await query.get();
    return records.map((r) => r.toEntity()).toList();
  }

  // 7. FindingReviewHistory
  Future<void> insertFindingReviewHistory(FindingReviewHistoryEntity entity) async {
    await db.into(db.findingReviewHistories).insert(
          FindingReviewHistoriesCompanion.insert(
            id: entity.id,
            findingId: entity.findingId,
            userId: Value(entity.userId),
            cseId: entity.cseId,
            actionType: entity.actionType,
            previousStatus: Value(entity.previousStatus),
            newStatus: Value(entity.newStatus),
            noteText: Value(entity.noteText),
            evidenceRequestDetails: Value(jsonEncodeOrNull(entity.evidenceRequestDetails)),
            createdAt: entity.createdAt,
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<FindingReviewHistoryEntity?> getFindingReviewHistoryById(String id) async {
    final query = db.select(db.findingReviewHistories)..where((tbl) => tbl.id.equals(id));
    final record = await query.getSingleOrNull();
    return record?.toEntity();
  }

  Future<List<FindingReviewHistoryEntity>> getReviewHistoriesByCSE(String cseId) async {
    final query = db.select(db.findingReviewHistories)..where((tbl) => tbl.cseId.equals(cseId));
    final records = await query.get();
    return records.map((r) => r.toEntity()).toList();
  }

  // 8. ReportRecord
  Future<void> insertReportRecord(ReportRecordEntity entity) async {
    await db.into(db.reportRecords).insert(
          ReportRecordsCompanion.insert(
            id: entity.id,
            reportCode: entity.reportCode,
            cseId: entity.cseId,
            assessmentId: Value(entity.assessmentId),
            datasetVersionId: Value(entity.datasetVersionId),
            analysisRunId: Value(entity.analysisRunId),
            obsStart: Value(entity.obsStart),
            obsEnd: Value(entity.obsEnd),
            generatedByUserId: entity.generatedByUserId,
            createdAt: entity.createdAt,
            summaryJson: jsonEncode(entity.summaryJson),
            metadataJson: Value(jsonEncodeOrNull(entity.metadataJson)),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<ReportRecordEntity?> getReportRecordById(String id) async {
    final query = db.select(db.reportRecords)..where((tbl) => tbl.id.equals(id));
    final record = await query.getSingleOrNull();
    return record?.toEntity();
  }

  Future<List<ReportRecordEntity>> getReportRecordsByCSE(String cseId) async {
    final query = db.select(db.reportRecords)..where((tbl) => tbl.cseId.equals(cseId));
    final records = await query.get();
    return records.map((r) => r.toEntity()).toList();
  }

  // 9. Alert
  Future<void> insertAlert(AlertEntity entity) async {
    await db.into(db.alerts).insert(
          AlertsCompanion.insert(
            id: entity.id,
            cseId: entity.cseId,
            batchId: Value(entity.batchId),
            assetId: Value(entity.assetId),
            externalAlertId: entity.externalAlertId,
            title: entity.title,
            category: entity.category,
            severity: entity.severity,
            status: Value(entity.status),
            disposition: Value(entity.disposition),
            targetAssetName: Value(entity.targetAssetName),
            detectedAt: entity.detectedAt,
            closedAt: Value(entity.closedAt),
            rawMetadata: Value(jsonEncodeOrNull(entity.rawMetadata)),
            createdAt: entity.createdAt,
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<AlertEntity?> getAlertById(String id) async {
    final query = db.select(db.alerts)..where((tbl) => tbl.id.equals(id));
    final record = await query.getSingleOrNull();
    return record?.toEntity();
  }

  Future<List<AlertEntity>> getAlertsByCSE(String cseId) async {
    final query = db.select(db.alerts)..where((tbl) => tbl.cseId.equals(cseId));
    final records = await query.get();
    return records.map((r) => r.toEntity()).toList();
  }

  // 10. Case
  Future<void> insertCase(CaseEntity entity) async {
    await db.into(db.cases).insert(
          CasesCompanion.insert(
            id: entity.id,
            cseId: entity.cseId,
            batchId: Value(entity.batchId),
            alertId: Value(entity.alertId),
            externalCaseId: entity.externalCaseId,
            title: entity.title,
            status: Value(entity.status),
            priority: Value(entity.priority),
            summary: Value(entity.summary),
            openedAt: entity.openedAt,
            closedAt: Value(entity.closedAt),
            createdAt: entity.createdAt,
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<CaseEntity?> getCaseById(String id) async {
    final query = db.select(db.cases)..where((tbl) => tbl.id.equals(id));
    final record = await query.getSingleOrNull();
    return record?.toEntity();
  }

  Future<List<CaseEntity>> getCasesByCSE(String cseId) async {
    final query = db.select(db.cases)..where((tbl) => tbl.cseId.equals(cseId));
    final records = await query.get();
    return records.map((r) => r.toEntity()).toList();
  }

  // 11. Investigation
  Future<void> insertInvestigation(InvestigationEntity entity) async {
    await db.into(db.investigations).insert(
          InvestigationsCompanion.insert(
            id: entity.id,
            caseId: entity.caseId,
            externalInvestigationId: Value(entity.externalInvestigationId),
            investigatorRef: Value(entity.investigatorRef),
            actionType: entity.actionType,
            notes: Value(entity.notes),
            startedAt: entity.startedAt,
            completedAt: Value(entity.completedAt),
            evidenceCount: Value(entity.evidenceCount),
            createdAt: entity.createdAt,
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<InvestigationEntity?> getInvestigationById(String id) async {
    final query = db.select(db.investigations)..where((tbl) => tbl.id.equals(id));
    final record = await query.getSingleOrNull();
    return record?.toEntity();
  }

  Future<List<InvestigationEntity>> getInvestigationsByCase(String caseId) async {
    final query = db.select(db.investigations)..where((tbl) => tbl.caseId.equals(caseId));
    final records = await query.get();
    return records.map((r) => r.toEntity()).toList();
  }

  // 12. Escalation
  Future<void> insertEscalation(EscalationEntity entity) async {
    await db.into(db.escalations).insert(
          EscalationsCompanion.insert(
            id: entity.id,
            caseId: entity.caseId,
            alertId: Value(entity.alertId),
            escalationLevel: entity.escalationLevel,
            reason: Value(entity.reason),
            status: Value(entity.status),
            escalatedAt: entity.escalatedAt,
            createdAt: entity.createdAt,
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<EscalationEntity?> getEscalationById(String id) async {
    final query = db.select(db.escalations)..where((tbl) => tbl.id.equals(id));
    final record = await query.getSingleOrNull();
    return record?.toEntity();
  }

  Future<List<EscalationEntity>> getEscalationsByCase(String caseId) async {
    final query = db.select(db.escalations)..where((tbl) => tbl.caseId.equals(caseId));
    final records = await query.get();
    return records.map((r) => r.toEntity()).toList();
  }

  // 13. MonitoringCoverage
  Future<void> insertMonitoringCoverage(MonitoringCoverageEntity entity) async {
    await db.into(db.monitoringCoverages).insert(
          MonitoringCoveragesCompanion.insert(
            id: entity.id,
            cseId: entity.cseId,
            logSourceCategory: entity.logSourceCategory,
            isExpected: Value(entity.isExpected),
            isActive: Value(entity.isActive),
            lastReceivedAt: Value(entity.lastReceivedAt),
            coveragePercentage: Value(entity.coveragePercentage),
            periodStart: Value(entity.periodStart),
            periodEnd: Value(entity.periodEnd),
            createdAt: entity.createdAt,
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<MonitoringCoverageEntity?> getMonitoringCoverageById(String id) async {
    final query = db.select(db.monitoringCoverages)..where((tbl) => tbl.id.equals(id));
    final record = await query.getSingleOrNull();
    return record?.toEntity();
  }

  Future<List<MonitoringCoverageEntity>> getCoveragesByCSE(String cseId) async {
    final query = db.select(db.monitoringCoverages)..where((tbl) => tbl.cseId.equals(cseId));
    final records = await query.get();
    return records.map((r) => r.toEntity()).toList();
  }

  // 14. Asset
  Future<void> insertAsset(AssetEntity entity) async {
    await db.into(db.assets).insert(
          AssetsCompanion.insert(
            id: entity.id,
            cseId: entity.cseId,
            assetIdentifier: entity.assetIdentifier,
            name: entity.name,
            assetType: Value(entity.assetType),
            ipAddress: Value(entity.ipAddress),
            hostname: Value(entity.hostname),
            criticality: Value(entity.criticality),
            createdAt: entity.createdAt,
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<AssetEntity?> getAssetById(String id) async {
    final query = db.select(db.assets)..where((tbl) => tbl.id.equals(id));
    final record = await query.getSingleOrNull();
    return record?.toEntity();
  }

  Future<List<AssetEntity>> getAssetsByCSE(String cseId) async {
    final query = db.select(db.assets)..where((tbl) => tbl.cseId.equals(cseId));
    final records = await query.get();
    return records.map((r) => r.toEntity()).toList();
  }

  // Bulk queries for peer benchmarking & analytics
  Future<List<AlertEntity>> getAllAlerts() async {
    final records = await db.select(db.alerts).get();
    return records.map((r) => r.toEntity()).toList();
  }

  Future<List<CaseEntity>> getAllCases() async {
    final records = await db.select(db.cases).get();
    return records.map((r) => r.toEntity()).toList();
  }

  Future<List<InvestigationEntity>> getAllInvestigations() async {
    final records = await db.select(db.investigations).get();
    return records.map((r) => r.toEntity()).toList();
  }

  Future<List<EscalationEntity>> getAllEscalations() async {
    final records = await db.select(db.escalations).get();
    return records.map((r) => r.toEntity()).toList();
  }

  Future<List<MonitoringCoverageEntity>> getAllCoverages() async {
    final records = await db.select(db.monitoringCoverages).get();
    return records.map((r) => r.toEntity()).toList();
  }

  Future<List<FindingEntity>> getAllFindings() async {
    final records = await db.select(db.findings).get();
    return records.map((r) => r.toEntity()).toList();
  }

  Future<List<FindingEvidenceEntity>> getAllFindingEvidences() async {
    final records = await db.select(db.findingEvidences).get();
    return records.map((r) => r.toEntity()).toList();
  }
}
