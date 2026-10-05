import '../entities/cse.dart';
import '../entities/assessment.dart';
import '../entities/finding.dart';
import '../entities/report_record.dart';

/// Domain contract for local database interaction via Drift ORM.
abstract class LocalStorageRepository {
  Future<List<CSEEntity>> getCSES();
  Future<CSEEntity?> getCSEById(String id);
  Future<List<AssessmentEntity>> getAssessmentsForCSE(String cseId);
  Future<List<FindingEntity>> getFindingsForAssessment(String assessmentId);
  Future<List<ReportRecordEntity>> getReportsForCSE(String cseId);
  Future<void> saveCSE(CSEEntity cse);
  Future<void> saveAssessment(AssessmentEntity assessment);
  Future<void> clearAllData();
}
