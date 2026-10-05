import 'package:satsa_mobile/data/database/app_database.dart';
import 'package:satsa_mobile/data/database/json_helpers.dart';
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

extension CSERecordMapper on CSERecord {
  CSEEntity toEntity() {
    return CSEEntity(
      id: id,
      cseCode: cseCode,
      name: name,
      sector: sector,
      criticalityTier: criticalityTier,
      contactEmail: contactEmail,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension AssessmentRecordMapper on AssessmentRecord {
  AssessmentEntity toEntity() {
    return AssessmentEntity(
      id: id,
      cseId: cseId,
      name: name,
      description: description,
      periodStart: periodStart,
      periodEnd: periodEnd,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      createdByUserId: createdByUserId,
    );
  }
}

extension DatasetVersionRecordMapper on DatasetVersionRecord {
  DatasetVersionEntity toEntity() {
    return DatasetVersionEntity(
      id: id,
      cseId: cseId,
      assessmentId: assessmentId,
      batchId: batchId,
      versionTag: versionTag,
      datasetType: datasetType,
      sourceFilename: sourceFilename,
      contentHash: contentHash,
      recordCount: recordCount,
      isImmutable: isImmutable,
      createdAt: createdAt,
      createdByUserId: createdByUserId,
    );
  }
}

extension AnalysisRunRecordMapper on AnalysisRunRecord {
  AnalysisRunEntity toEntity() {
    return AnalysisRunEntity(
      id: id,
      cseId: cseId,
      assessmentId: assessmentId,
      datasetVersionId: datasetVersionId,
      obsStart: obsStart,
      obsEnd: obsEnd,
      engineVersion: engineVersion,
      rulesEvaluated: jsonDecodeListString(rulesEvaluated),
      status: status,
      findingsCreated: findingsCreated,
      baselinesPersisted: baselinesPersisted,
      errorMessage: errorMessage,
      startedAt: startedAt,
      completedAt: completedAt,
      executedByUserId: executedByUserId,
    );
  }
}

extension FindingRecordMapper on FindingRecord {
  FindingEntity toEntity() {
    return FindingEntity(
      id: id,
      findingCode: findingCode,
      cseId: cseId,
      batchId: batchId,
      analysisRunId: analysisRunId,
      category: category,
      severity: severity,
      title: title,
      description: description,
      rationale: rationale,
      detectionMethod: detectionMethod,
      metricsJson: jsonDecodeMapOrNull(metricsJson),
      status: status,
      detectedAt: detectedAt,
      updatedAt: updatedAt,
    );
  }
}

extension FindingEvidenceRecordMapper on FindingEvidenceRecord {
  FindingEvidenceEntity toEntity() {
    return FindingEvidenceEntity(
      id: id,
      findingId: findingId,
      evidenceType: evidenceType,
      alertId: alertId,
      caseId: caseId,
      investigationId: investigationId,
      escalationId: escalationId,
      coverageId: coverageId,
      notes: notes,
      createdAt: createdAt,
    );
  }
}

extension FindingReviewHistoryRecordMapper on FindingReviewHistoryRecord {
  FindingReviewHistoryEntity toEntity() {
    return FindingReviewHistoryEntity(
      id: id,
      findingId: findingId,
      userId: userId,
      cseId: cseId,
      actionType: actionType,
      previousStatus: previousStatus,
      newStatus: newStatus,
      noteText: noteText ?? '',
      evidenceRequestDetails: jsonDecodeMapOrNull(evidenceRequestDetails),
      createdAt: createdAt,
    );
  }
}

extension ReportRecordDataMapper on ReportRecordData {
  ReportRecordEntity toEntity() {
    return ReportRecordEntity(
      id: id,
      reportCode: reportCode,
      cseId: cseId,
      assessmentId: assessmentId,
      datasetVersionId: datasetVersionId,
      analysisRunId: analysisRunId,
      obsStart: obsStart,
      obsEnd: obsEnd,
      generatedByUserId: generatedByUserId,
      createdAt: createdAt,
      summaryJson: jsonDecodeMapOrNull(summaryJson) ?? {},
      metadataJson: jsonDecodeMapOrNull(metadataJson),
    );
  }
}

extension AlertRecordMapper on AlertRecord {
  AlertEntity toEntity() {
    return AlertEntity(
      id: id,
      cseId: cseId,
      batchId: batchId,
      assetId: assetId,
      externalAlertId: externalAlertId,
      title: title,
      category: category,
      severity: severity,
      status: status,
      disposition: disposition,
      targetAssetName: targetAssetName,
      detectedAt: detectedAt,
      closedAt: closedAt,
      rawMetadata: jsonDecodeMapOrNull(rawMetadata),
      createdAt: createdAt,
    );
  }
}

extension CaseRecordMapper on CaseRecord {
  CaseEntity toEntity() {
    return CaseEntity(
      id: id,
      cseId: cseId,
      batchId: batchId,
      alertId: alertId,
      externalCaseId: externalCaseId,
      title: title,
      status: status,
      priority: priority,
      summary: summary,
      openedAt: openedAt,
      closedAt: closedAt,
      createdAt: createdAt,
    );
  }
}

extension InvestigationRecordMapper on InvestigationRecord {
  InvestigationEntity toEntity() {
    return InvestigationEntity(
      id: id,
      caseId: caseId,
      externalInvestigationId: externalInvestigationId,
      investigatorRef: investigatorRef,
      actionType: actionType,
      notes: notes,
      startedAt: startedAt,
      completedAt: completedAt,
      evidenceCount: evidenceCount,
      createdAt: createdAt,
    );
  }
}

extension EscalationRecordMapper on EscalationRecord {
  EscalationEntity toEntity() {
    return EscalationEntity(
      id: id,
      caseId: caseId,
      alertId: alertId,
      escalationLevel: escalationLevel,
      reason: reason,
      status: status,
      escalatedAt: escalatedAt,
      createdAt: createdAt,
    );
  }
}

extension MonitoringCoverageRecordMapper on MonitoringCoverageRecord {
  MonitoringCoverageEntity toEntity() {
    return MonitoringCoverageEntity(
      id: id,
      cseId: cseId,
      logSourceCategory: logSourceCategory,
      isExpected: isExpected,
      isActive: isActive,
      lastReceivedAt: lastReceivedAt,
      coveragePercentage: coveragePercentage,
      periodStart: periodStart,
      periodEnd: periodEnd,
      createdAt: createdAt,
    );
  }
}

extension AssetRecordMapper on AssetRecord {
  AssetEntity toEntity() {
    return AssetEntity(
      id: id,
      cseId: cseId,
      assetIdentifier: assetIdentifier,
      name: name,
      assetType: assetType,
      ipAddress: ipAddress,
      hostname: hostname,
      criticality: criticality,
      createdAt: createdAt,
    );
  }
}
