import 'package:satsa_mobile/domain/entities/finding.dart';
import 'package:satsa_mobile/domain/analytics/analytics_helpers.dart';

class CapabilityScoreItem {
  final String capabilityName;
  final int totalFindings;
  final int activeFindings;
  final int criticalHighFindings;
  final double maturityScore; // 0.0 to 100.0

  CapabilityScoreItem({
    required this.capabilityName,
    required this.totalFindings,
    required this.activeFindings,
    required this.criticalHighFindings,
    required this.maturityScore,
  });
}

class CapabilityService {
  static const List<String> canonicalCapabilities = [
    'Threat Detection',
    'Investigation',
    'Escalation',
    'Incident Response',
    'Security Operations',
    'Governance and Oversight',
    'Operational Discipline',
    'Cyber Resilience',
  ];

  /// Groups findings by capability dimension and calculates maturity scores.
  static Map<String, CapabilityScoreItem> getCapabilityBreakdown({
    required List<FindingEntity> findings,
  }) {
    final grouped = <String, List<FindingEntity>>{
      for (final cap in canonicalCapabilities) cap: [],
    };

    for (final f in findings) {
      final cap = mapRuleToCapability(
        category: f.category,
        ruleCode: f.findingCode,
      );
      grouped.putIfAbsent(cap, () => []).add(f);
    }

    final result = <String, CapabilityScoreItem>{};

    for (final entry in grouped.entries) {
      final capName = entry.key;
      final capFindings = entry.value;

      final activeFs = capFindings.where((f) => f.status == 'NEW').toList();
      final critHighFs =
          activeFs.where((f) => f.severity == 'CRITICAL' || f.severity == 'HIGH').length;

      // Maturity score starts at 100.0 and degrades based on active findings
      // Deduct 15 for each CRITICAL/HIGH active finding, 5 for MEDIUM/LOW
      var penalty = 0.0;
      for (final f in activeFs) {
        if (f.severity == 'CRITICAL' || f.severity == 'HIGH') {
          penalty += 15.0;
        } else {
          penalty += 5.0;
        }
      }
      final maturity = (100.0 - penalty).clamp(0.0, 100.0);

      result[capName] = CapabilityScoreItem(
        capabilityName: capName,
        totalFindings: capFindings.length,
        activeFindings: activeFs.length,
        criticalHighFindings: critHighFs,
        maturityScore: maturity,
      );
    }

    return result;
  }
}
