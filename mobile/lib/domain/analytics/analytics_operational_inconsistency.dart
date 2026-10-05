import 'dart:math' as math;
import 'package:satsa_mobile/domain/entities/finding.dart';
import 'package:satsa_mobile/domain/entities/finding_evidence.dart';
import 'package:satsa_mobile/domain/entities/case_entity.dart';
import 'package:satsa_mobile/domain/entities/investigation_entity.dart';
import 'package:satsa_mobile/domain/analytics/analytics_helpers.dart';
import 'package:satsa_mobile/domain/analytics/analytics_execution_gaps.dart';

String _cleanHex6(String idStr) {
  final clean = idStr.replaceAll('-', '').toLowerCase();
  return clean.substring(0, math.min(6, clean.length));
}

class OperationalInconsistencyAnalyzer {
  /// OI-01: Operational Evidence Inconsistency.
  /// Detects closed/resolved cases that possess ZERO linked investigation records.
  static List<FindingWithEvidence> analyzeOI01EvidenceLinkageGaps({
    required String cseId,
    required List<CaseEntity> cases,
    required List<InvestigationEntity> investigations,
    DateTime? obsStart,
    DateTime? obsEnd,
    String? batchId,
  }) {
    var closedCases = cases.where((c) =>
        c.cseId == cseId && c.closedAt != null).toList();

    if (obsStart != null) {
      closedCases = closedCases.where((c) => !c.closedAt!.isBefore(obsStart)).toList();
    }
    if (obsEnd != null) {
      closedCases = closedCases.where((c) => !c.closedAt!.isAfter(obsEnd)).toList();
    }

    final results = <FindingWithEvidence>[];
    final cseHex6 = _cleanHex6(cseId);
    final nowUtc = DateTime.now().toUtc();

    final dateTag = obsStart != null
        ? '${obsStart.year.toString().padLeft(4, '0')}${obsStart.month.toString().padLeft(2, '0')}${obsStart.day.toString().padLeft(2, '0')}'
        : 'obs';

    for (final caseObj in closedCases) {
      final invCount = investigations.where((i) => i.caseId == caseObj.id).length;

      if (invCount == 0) {
        final caseHex6 = _cleanHex6(caseObj.id);
        final findingCode = 'FND-OI01-$cseHex6-$caseHex6-$dateTag';

        final evStrength = calculateEvidenceStrength(
          sampleSize: 1,
          hasExplicitEvidence: true,
        );
        final capability = mapRuleToCapability(
          category: 'EXECUTION_GAP',
          ruleCode: 'OI01',
        );

        final finding = FindingEntity(
          id: generateUuidV5('FND-OI01-$findingCode-$nowUtc'),
          findingCode: findingCode,
          cseId: cseId,
          batchId: batchId,
          category: 'EXECUTION_GAP',
          severity: 'MEDIUM',
          title: 'Operational Evidence Inconsistency',
          description:
              'Case \'${caseObj.externalCaseId}\' was closed as resolved, '
              'but possesses zero linked investigation activity records.',
          rationale:
              'Resolved case \'${caseObj.externalCaseId}\' lacks supporting investigation evidence, '
              'representing an operational documentation inconsistency requiring supervisory review.',
          detectionMethod: 'EVIDENCE_LINKAGE_CHECK',
          metricsJson: {
            'rule_code': 'OI-01',
            'metric': 'linked_investigation_count',
            'observed_value': 0,
            'baseline_value': '>= 1 expected investigation',
            'affected_case_id': caseObj.id,
            'external_case_id': caseObj.externalCaseId,
            'evidence_strength': evStrength,
            'capability': capability,
            'supervisory_relevance':
                'Case closure without logged investigation evidence indicates potential administrative bypass.',
          },
          status: 'NEW',
          detectedAt: nowUtc,
          updatedAt: nowUtc,
        );

        final evidence = FindingEvidenceEntity(
          id: generateUuidV5('EV-OI01-${caseObj.id}-$nowUtc'),
          findingId: finding.id,
          evidenceType: 'CASE',
          caseId: caseObj.id,
          notes:
              'Inconsistency evidence: case ${caseObj.externalCaseId} closed without investigation logs.',
          createdAt: nowUtc,
        );

        results.add(FindingWithEvidence(finding: finding, evidences: [evidence]));
      }
    }

    return results;
  }
}
