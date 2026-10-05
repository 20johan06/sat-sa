import 'package:flutter_test/flutter_test.dart';
import 'package:satsa_mobile/domain/analytics/analytics_helpers.dart';

void main() {
  group('Analytics Helpers & Statistical Parity Tests', () {
    test('calculateP5 matches Python linear interpolation', () {
      final values = [10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0, 90.0, 100.0];
      // N = 10 -> k = (10-1)*0.05 = 0.45 -> f = 0, c = 1 -> 10*(0.55) + 20*(0.45) = 14.5
      final p5 = calculateP5(values);
      expect(p5, closeTo(14.5, 1e-4));
    });

    test('calculateP5 with single element returns that element', () {
      expect(calculateP5([42.0]), equals(42.0));
    });

    test('calculateP5 with empty list returns 0.0', () {
      expect(calculateP5([]), equals(0.0));
    });

    test('calculateMedian odd and even lengths match Python statistics.median', () {
      expect(calculateMedian([1.0, 3.0, 5.0]), equals(3.0));
      expect(calculateMedian([1.0, 2.0, 3.0, 4.0]), equals(2.5));
      expect(calculateMedian([]), equals(0.0));
    });

    test('calculateMad matches Python Median Absolute Deviation', () {
      final values = [10.0, 12.0, 15.0, 18.0, 20.0, 22.0, 25.0, 28.0, 30.0, 100.0];
      // median = (20 + 22)/2 = 21
      // absDevs = [11, 9, 6, 3, 1, 1, 4, 7, 9, 79]
      // sorted absDevs = [1, 1, 3, 4, 6, 7, 9, 9, 11, 79] -> median = (6 + 7)/2 = 6.5
      final mad = calculateMad(values);
      expect(mad, equals(6.5));
    });

    test('calculateSampleStdev matches Python statistics.stdev (divided by N-1)', () {
      final values = [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0];
      // mean = 5.0
      // diffs^2 = 9 + 1 + 1 + 1 + 0 + 0 + 4 + 16 = 32
      // sample variance = 32 / (8 - 1) = 32/7 = 4.571428...
      // sample stdev = sqrt(32/7) = 2.138089935299395
      final stdev = calculateSampleStdev(values);
      expect(stdev, closeTo(2.1380899, 1e-4));
    });

    test('UUIDv5 generates valid RFC 4122 v5 hex matching SHA-1 DNS namespace', () {
      final uuidStr = generateUuidV5('Test Note Text For Repeated Investigation');
      expect(uuidStr.length, equals(36));
      expect(uuidStr[14], equals('5')); // version 5
      final hex8 = generateUuidV5Hex8('Test Note Text For Repeated Investigation');
      expect(hex8.length, equals(8));
      expect(RegExp(r'^[0-9a-f]{8}$').hasMatch(hex8), isTrue);
    });

    test('calculateEvidenceStrength thresholds', () {
      expect(
        calculateEvidenceStrength(sampleSize: 12, hasExplicitEvidence: true, dataCompletenessRatio: 0.9),
        equals('STRONG'),
      );
      expect(
        calculateEvidenceStrength(sampleSize: 5, hasExplicitEvidence: true, dataCompletenessRatio: 0.6),
        equals('MODERATE'),
      );
      expect(
        calculateEvidenceStrength(sampleSize: 1, hasExplicitEvidence: true, dataCompletenessRatio: 1.0),
        equals('LIMITED'),
      );
    });

    test('mapRuleToCapability maps all 8 V2 capabilities correctly', () {
      expect(mapRuleToCapability(category: 'ANOMALY', ruleCode: 'AN01'), equals('Threat Detection'));
      expect(mapRuleToCapability(category: 'EXECUTION_GAP', ruleCode: 'EG03'), equals('Investigation'));
      expect(mapRuleToCapability(category: 'EXECUTION_GAP', ruleCode: 'EG02'), equals('Escalation'));
      expect(mapRuleToCapability(category: 'EXECUTION_GAP', ruleCode: 'OI01'), equals('Incident Response'));
      expect(mapRuleToCapability(category: 'NEGATIVE_SPACE', ruleCode: 'NS01'), equals('Security Operations'));
      expect(mapRuleToCapability(category: 'BENCHMARK', ruleCode: 'BM01'), equals('Governance and Oversight'));
      expect(mapRuleToCapability(category: 'EXECUTION_GAP', ruleCode: 'CUSTOM'), equals('Operational Discipline'));
      expect(mapRuleToCapability(category: 'NEGATIVE_SPACE', ruleCode: 'CUSTOM'), equals('Cyber Resilience'));
    });
  });
}
