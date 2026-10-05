import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// 1. CSEs Table
@DataClassName('CSERecord')
@TableIndex(name: 'idx_cses_sector', columns: {#sector})
class CSEs extends Table {
  @override
  String get tableName => 'cses';

  TextColumn get id => text()();
  TextColumn get cseCode => text()();
  TextColumn get name => text()();
  TextColumn get sector => text()();
  TextColumn get criticalityTier => text().withDefault(const Constant('TIER_1'))();
  TextColumn get contactEmail => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {cseCode}
      ];
}

// 2. Assessments Table
@DataClassName('AssessmentRecord')
@TableIndex(name: 'idx_assessments_cse_id', columns: {#cseId})
@TableIndex(name: 'idx_assessments_period_start', columns: {#periodStart})
@TableIndex(name: 'idx_assessments_period_end', columns: {#periodEnd})
@TableIndex(name: 'idx_assessments_status', columns: {#status})
class Assessments extends Table {
  TextColumn get id => text()();
  TextColumn get cseId => text().references(CSEs, #id, onDelete: KeyAction.restrict)();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get periodStart => dateTime()();
  DateTimeColumn get periodEnd => dateTime()();
  TextColumn get status => text().withDefault(const Constant('DRAFT'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get createdByUserId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// 3. DatasetVersions Table
@DataClassName('DatasetVersionRecord')
@TableIndex(name: 'idx_dataset_versions_cse_id', columns: {#cseId})
@TableIndex(name: 'idx_dataset_versions_assessment_id', columns: {#assessmentId})
@TableIndex(name: 'idx_dataset_versions_version_tag', columns: {#versionTag})
@TableIndex(name: 'idx_dataset_versions_content_hash', columns: {#contentHash})
class DatasetVersions extends Table {
  TextColumn get id => text()();
  TextColumn get cseId => text().references(CSEs, #id, onDelete: KeyAction.restrict)();
  TextColumn get assessmentId => text().nullable().references(Assessments, #id, onDelete: KeyAction.setNull)();
  TextColumn get batchId => text().nullable()();
  TextColumn get versionTag => text()();
  TextColumn get datasetType => text()();
  TextColumn get sourceFilename => text()();
  TextColumn get contentHash => text()();
  IntColumn get recordCount => integer().withDefault(const Constant(0))();
  BoolColumn get isImmutable => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get createdByUserId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// 4. AnalysisRuns Table
@DataClassName('AnalysisRunRecord')
@TableIndex(name: 'idx_analysis_runs_cse_id', columns: {#cseId})
@TableIndex(name: 'idx_analysis_runs_assessment_id', columns: {#assessmentId})
@TableIndex(name: 'idx_analysis_runs_dataset_version_id', columns: {#datasetVersionId})
@TableIndex(name: 'idx_analysis_runs_status', columns: {#status})
class AnalysisRuns extends Table {
  TextColumn get id => text()();
  TextColumn get cseId => text().references(CSEs, #id, onDelete: KeyAction.restrict)();
  TextColumn get assessmentId => text().nullable().references(Assessments, #id, onDelete: KeyAction.setNull)();
  TextColumn get datasetVersionId => text().nullable().references(DatasetVersions, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get obsStart => dateTime().nullable()();
  DateTimeColumn get obsEnd => dateTime().nullable()();
  TextColumn get engineVersion => text().withDefault(const Constant('v2.0.0-phase5-canonical'))();
  TextColumn get rulesEvaluated => text()(); // Serialized JSON String array
  TextColumn get status => text().withDefault(const Constant('PENDING'))();
  IntColumn get findingsCreated => integer().withDefault(const Constant(0))();
  IntColumn get baselinesPersisted => integer().withDefault(const Constant(0))();
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get executedByUserId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// 5. Findings Table
@DataClassName('FindingRecord')
@TableIndex(name: 'idx_findings_cse_id', columns: {#cseId})
@TableIndex(name: 'idx_findings_analysis_run_id', columns: {#analysisRunId})
@TableIndex(name: 'idx_findings_category', columns: {#category})
@TableIndex(name: 'idx_findings_severity', columns: {#severity})
@TableIndex(name: 'idx_findings_status', columns: {#status})
@TableIndex(name: 'idx_findings_detected_at', columns: {#detectedAt})
class Findings extends Table {
  TextColumn get id => text()();
  TextColumn get findingCode => text()();
  TextColumn get cseId => text().references(CSEs, #id, onDelete: KeyAction.restrict)();
  TextColumn get batchId => text().nullable()();
  TextColumn get analysisRunId => text().nullable().references(AnalysisRuns, #id, onDelete: KeyAction.setNull)();
  TextColumn get category => text()();
  TextColumn get severity => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get rationale => text()();
  TextColumn get detectionMethod => text()();
  TextColumn get metricsJson => text().nullable()(); // Serialized JSON Map
  TextColumn get status => text().withDefault(const Constant('NEW'))();
  DateTimeColumn get detectedAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {findingCode}
      ];
}

// 6. FindingEvidences Table
@DataClassName('FindingEvidenceRecord')
@TableIndex(name: 'idx_finding_evidences_finding_id', columns: {#findingId})
@TableIndex(name: 'idx_finding_evidences_evidence_type', columns: {#evidenceType})
@TableIndex(name: 'idx_finding_evidences_alert_id', columns: {#alertId})
@TableIndex(name: 'idx_finding_evidences_case_id', columns: {#caseId})
class FindingEvidences extends Table {
  TextColumn get id => text()();
  TextColumn get findingId => text().references(Findings, #id, onDelete: KeyAction.cascade)();
  TextColumn get evidenceType => text()();
  TextColumn get alertId => text().nullable().references(Alerts, #id, onDelete: KeyAction.setNull)();
  TextColumn get caseId => text().nullable().references(Cases, #id, onDelete: KeyAction.setNull)();
  TextColumn get investigationId => text().nullable().references(Investigations, #id, onDelete: KeyAction.setNull)();
  TextColumn get escalationId => text().nullable().references(Escalations, #id, onDelete: KeyAction.setNull)();
  TextColumn get coverageId => text().nullable().references(MonitoringCoverages, #id, onDelete: KeyAction.setNull)();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 7. FindingReviewHistories Table
@DataClassName('FindingReviewHistoryRecord')
@TableIndex(name: 'idx_finding_review_histories_finding_id', columns: {#findingId})
@TableIndex(name: 'idx_finding_review_histories_cse_id', columns: {#cseId})
@TableIndex(name: 'idx_finding_review_histories_action_type', columns: {#actionType})
@TableIndex(name: 'idx_finding_review_histories_created_at', columns: {#createdAt})
class FindingReviewHistories extends Table {
  TextColumn get id => text()();
  TextColumn get findingId => text().references(Findings, #id, onDelete: KeyAction.restrict)();
  TextColumn get userId => text().nullable()();
  TextColumn get cseId => text().references(CSEs, #id, onDelete: KeyAction.restrict)();
  TextColumn get actionType => text()();
  TextColumn get previousStatus => text().nullable()();
  TextColumn get newStatus => text().nullable()();
  TextColumn get noteText => text().nullable()();
  TextColumn get evidenceRequestDetails => text().nullable()(); // Serialized JSON Map
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 8. ReportRecords Table
@DataClassName('ReportRecordData')
@TableIndex(name: 'idx_report_records_cse_id', columns: {#cseId})
@TableIndex(name: 'idx_report_records_assessment_id', columns: {#assessmentId})
class ReportRecords extends Table {
  TextColumn get id => text()();
  TextColumn get reportCode => text()();
  TextColumn get cseId => text().references(CSEs, #id, onDelete: KeyAction.restrict)();
  TextColumn get assessmentId => text().nullable().references(Assessments, #id, onDelete: KeyAction.restrict)();
  TextColumn get datasetVersionId => text().nullable().references(DatasetVersions, #id, onDelete: KeyAction.restrict)();
  TextColumn get analysisRunId => text().nullable().references(AnalysisRuns, #id, onDelete: KeyAction.restrict)();
  DateTimeColumn get obsStart => dateTime().nullable()();
  DateTimeColumn get obsEnd => dateTime().nullable()();
  TextColumn get generatedByUserId => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get summaryJson => text()(); // Serialized JSON Map
  TextColumn get metadataJson => text().nullable()(); // Serialized JSON Map

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {reportCode}
      ];
}

// 9. Alerts Table
@DataClassName('AlertRecord')
@TableIndex(name: 'idx_alerts_cse_id', columns: {#cseId})
@TableIndex(name: 'idx_alerts_external_alert_id', columns: {#externalAlertId})
@TableIndex(name: 'idx_alerts_severity', columns: {#severity})
@TableIndex(name: 'idx_alerts_status', columns: {#status})
class Alerts extends Table {
  TextColumn get id => text()();
  TextColumn get cseId => text().references(CSEs, #id, onDelete: KeyAction.restrict)();
  TextColumn get batchId => text().nullable()();
  TextColumn get assetId => text().nullable().references(Assets, #id, onDelete: KeyAction.setNull)();
  TextColumn get externalAlertId => text()();
  TextColumn get title => text()();
  TextColumn get category => text()();
  TextColumn get severity => text()();
  TextColumn get status => text().withDefault(const Constant('NEW'))();
  TextColumn get disposition => text().nullable()();
  TextColumn get targetAssetName => text().nullable()();
  DateTimeColumn get detectedAt => dateTime()();
  DateTimeColumn get closedAt => dateTime().nullable()();
  TextColumn get rawMetadata => text().nullable()(); // Serialized JSON Map
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 10. Cases Table
@DataClassName('CaseRecord')
@TableIndex(name: 'idx_cases_cse_id', columns: {#cseId})
@TableIndex(name: 'idx_cases_external_case_id', columns: {#externalCaseId})
@TableIndex(name: 'idx_cases_status', columns: {#status})
class Cases extends Table {
  TextColumn get id => text()();
  TextColumn get cseId => text().references(CSEs, #id, onDelete: KeyAction.restrict)();
  TextColumn get batchId => text().nullable()();
  TextColumn get alertId => text().nullable().references(Alerts, #id, onDelete: KeyAction.setNull)();
  TextColumn get externalCaseId => text()();
  TextColumn get title => text()();
  TextColumn get status => text().withDefault(const Constant('OPEN'))();
  TextColumn get priority => text().withDefault(const Constant('MEDIUM'))();
  TextColumn get summary => text().nullable()();
  DateTimeColumn get openedAt => dateTime()();
  DateTimeColumn get closedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 11. Investigations Table
@DataClassName('InvestigationRecord')
@TableIndex(name: 'idx_investigations_case_id', columns: {#caseId})
@TableIndex(name: 'idx_investigations_external_id', columns: {#externalInvestigationId})
class Investigations extends Table {
  TextColumn get id => text()();
  TextColumn get caseId => text().references(Cases, #id, onDelete: KeyAction.cascade)();
  TextColumn get externalInvestigationId => text().nullable()();
  TextColumn get investigatorRef => text().nullable()();
  TextColumn get actionType => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get evidenceCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 12. Escalations Table
@DataClassName('EscalationRecord')
@TableIndex(name: 'idx_escalations_case_id', columns: {#caseId})
@TableIndex(name: 'idx_escalations_alert_id', columns: {#alertId})
class Escalations extends Table {
  TextColumn get id => text()();
  TextColumn get caseId => text().references(Cases, #id, onDelete: KeyAction.cascade)();
  TextColumn get alertId => text().nullable().references(Alerts, #id, onDelete: KeyAction.setNull)();
  TextColumn get escalationLevel => text()();
  TextColumn get reason => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('PENDING'))();
  DateTimeColumn get escalatedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 13. MonitoringCoverages Table
@DataClassName('MonitoringCoverageRecord')
@TableIndex(name: 'idx_coverages_cse_id', columns: {#cseId})
@TableIndex(name: 'idx_coverages_category', columns: {#logSourceCategory})
class MonitoringCoverages extends Table {
  TextColumn get id => text()();
  TextColumn get cseId => text().references(CSEs, #id, onDelete: KeyAction.restrict)();
  TextColumn get logSourceCategory => text()();
  BoolColumn get isExpected => boolean().withDefault(const Constant(true))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastReceivedAt => dateTime().nullable()();
  RealColumn get coveragePercentage => real().nullable()();
  DateTimeColumn get periodStart => dateTime().nullable()();
  DateTimeColumn get periodEnd => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 14. Assets Table
@DataClassName('AssetRecord')
@TableIndex(name: 'idx_assets_cse_id', columns: {#cseId})
@TableIndex(name: 'idx_assets_identifier', columns: {#assetIdentifier})
@TableIndex(name: 'idx_assets_criticality', columns: {#criticality})
class Assets extends Table {
  TextColumn get id => text()();
  TextColumn get cseId => text().references(CSEs, #id, onDelete: KeyAction.cascade)();
  TextColumn get assetIdentifier => text()();
  TextColumn get name => text()();
  TextColumn get assetType => text().withDefault(const Constant('SERVER'))();
  TextColumn get ipAddress => text().nullable()();
  TextColumn get hostname => text().nullable()();
  TextColumn get criticality => text().withDefault(const Constant('MEDIUM'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// Drift Database Class
@DriftDatabase(tables: [
  CSEs,
  Assessments,
  DatasetVersions,
  AnalysisRuns,
  Findings,
  FindingEvidences,
  FindingReviewHistories,
  ReportRecords,
  Alerts,
  Cases,
  Investigations,
  Escalations,
  MonitoringCoverages,
  Assets,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON;');
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'sat_sa_mobile.db'));
    return NativeDatabase.createInBackground(file);
  });
}
