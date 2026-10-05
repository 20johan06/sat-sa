import 'package:drift/drift.dart';

// Drift Table Schema Contracts for Phase 19 Base Initialization

@DataClassName('CSERecord')
class CSEs extends Table {
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
}

@DataClassName('AssessmentRecord')
class Assessments extends Table {
  TextColumn get id => text()();
  TextColumn get cseId => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get periodStart => dateTime()();
  DateTimeColumn get periodEnd => dateTime()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get createdByUserId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('FindingRecord')
class Findings extends Table {
  TextColumn get id => text()();
  TextColumn get findingCode => text()();
  TextColumn get cseId => text()();
  TextColumn get batchId => text().nullable()();
  TextColumn get analysisRunId => text().nullable()();
  TextColumn get category => text()();
  TextColumn get severity => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get rationale => text()();
  TextColumn get detectionMethod => text()();
  TextColumn get metricsJson => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('NEW'))();
  DateTimeColumn get detectedAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
