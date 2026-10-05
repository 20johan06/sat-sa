import 'dart:convert';
import 'dart:math' as math;
import 'package:crypto/crypto.dart';

/// Evidence strength levels according to V2 specification.
enum EvidenceStrength { strong, moderate, limited, none }

extension EvidenceStrengthX on EvidenceStrength {
  String toName() {
    switch (this) {
      case EvidenceStrength.strong:
        return 'STRONG';
      case EvidenceStrength.moderate:
        return 'MODERATE';
      case EvidenceStrength.limited:
        return 'LIMITED';
      case EvidenceStrength.none:
        return 'NONE';
    }
  }
}

/// Deterministically calculates evidence strength (STRONG, MODERATE, LIMITED).
String calculateEvidenceStrength({
  required int sampleSize,
  bool hasExplicitEvidence = true,
  double dataCompletenessRatio = 1.0,
}) {
  if (sampleSize >= 10 && hasExplicitEvidence && dataCompletenessRatio >= 0.8) {
    return 'STRONG';
  } else if (sampleSize >= 3 && hasExplicitEvidence && dataCompletenessRatio >= 0.5) {
    return 'MODERATE';
  } else {
    return 'LIMITED';
  }
}

/// Deterministically maps analytics finding rules to 1 of 8 V2 capability dimensions:
/// 1. Threat Detection
/// 2. Investigation
/// 3. Escalation
/// 4. Incident Response
/// 5. Security Operations
/// 6. Governance and Oversight
/// 7. Operational Discipline
/// 8. Cyber Resilience
String mapRuleToCapability({
  required String category,
  required String ruleCode,
}) {
  final ruleCodeUpper = ruleCode.toUpperCase();
  final categoryUpper = category.toUpperCase();

  if (ruleCodeUpper.contains('AN01') ||
      ruleCodeUpper.contains('AN02') ||
      ruleCodeUpper.contains('NS05')) {
    return 'Threat Detection';
  } else if (ruleCodeUpper.contains('EG03') ||
      ruleCodeUpper.contains('EG04') ||
      ruleCodeUpper.contains('EG05')) {
    return 'Investigation';
  } else if (ruleCodeUpper.contains('EG02') || ruleCodeUpper.contains('ESC')) {
    return 'Escalation';
  } else if (ruleCodeUpper.contains('EG01') ||
      ruleCodeUpper.contains('EG06') ||
      ruleCodeUpper.contains('OI01')) {
    return 'Incident Response';
  } else if (ruleCodeUpper.contains('NS01') || ruleCodeUpper.contains('NS06')) {
    return 'Security Operations';
  } else if (ruleCodeUpper.contains('BM01')) {
    return 'Governance and Oversight';
  } else if (categoryUpper == 'EXECUTION_GAP') {
    return 'Operational Discipline';
  } else if (categoryUpper == 'NEGATIVE_SPACE') {
    return 'Cyber Resilience';
  } else {
    return 'Operational Discipline';
  }
}

/// Calculates 5th percentile of a list of doubles using exact Python linear interpolation.
/// Formula: k = (N - 1) * 0.05, f = floor(k), c = ceil(k)
/// P5 = sorted[f] * (c - k) + sorted[c] * (k - f)
double calculateP5(List<double> values) {
  if (values.isEmpty) return 0.0;
  final sortedVals = List<double>.from(values)..sort();
  final k = (sortedVals.length - 1) * 0.05;
  final f = k.floor();
  final c = k.ceil();
  if (f == c) {
    return sortedVals[f];
  }
  return sortedVals[f] * (c - k) + sortedVals[c] * (k - f);
}

/// Calculates arithmetic mean of a list of doubles.
double calculateMean(List<double> values) {
  if (values.isEmpty) return 0.0;
  return values.reduce((a, b) => a + b) / values.length;
}

/// Calculates sample standard deviation (divided by N - 1) matching Python's statistics.stdev.
double calculateSampleStdev(List<double> values) {
  if (values.length <= 1) return 0.0;
  final mean = calculateMean(values);
  final sumSquares = values.map((x) => (x - mean) * (x - mean)).reduce((a, b) => a + b);
  return math.sqrt(sumSquares / (values.length - 1));
}

/// Calculates median matching Python's statistics.median.
double calculateMedian(List<double> values) {
  if (values.isEmpty) return 0.0;
  final sortedVals = List<double>.from(values)..sort();
  final n = sortedVals.length;
  if (n % 2 == 1) {
    return sortedVals[n ~/ 2];
  } else {
    return (sortedVals[n ~/ 2 - 1] + sortedVals[n ~/ 2]) / 2.0;
  }
}

/// Calculates Median Absolute Deviation (MAD).
double calculateMad(List<double> values) {
  if (values.isEmpty) return 0.0;
  final medianVal = calculateMedian(values);
  final absDeviations = values.map((x) => (x - medianVal).abs()).toList();
  return calculateMedian(absDeviations);
}

/// Generates RFC 4122 standard UUIDv5 (SHA-1 namespace hashing) with DNS namespace.
/// Python: uuid.uuid5(uuid.NAMESPACE_DNS, note_text).hex[:8]
String generateUuidV5(String name) {
  // DNS Namespace UUID bytes: 6ba7b810-9dad-11d1-80b4-00c04fd430c8
  final namespaceBytes = <int>[
    0x6b, 0xa7, 0xb8, 0x10,
    0x9d, 0xad,
    0x11, 0xd1,
    0x80, 0xb4,
    0x00, 0xc0, 0x4f, 0xd4, 0x30, 0xc8
  ];
  final nameBytes = utf8.encode(name);
  final content = [...namespaceBytes, ...nameBytes];
  final digest = sha1.convert(content).bytes;
  final bytes = List<int>.from(digest.sublist(0, 16));
  bytes[6] = (bytes[6] & 0x0f) | 0x50; // version 5
  bytes[8] = (bytes[8] & 0x3f) | 0x80; // variant RFC 4122

  final buffer = StringBuffer();
  for (var i = 0; i < 16; i++) {
    if (i == 4 || i == 6 || i == 8 || i == 10) {
      buffer.write('-');
    }
    buffer.write(bytes[i].toRadixString(16).padLeft(2, '0'));
  }
  return buffer.toString();
}

/// Returns the first 8 hex characters of standard UUIDv5 without hyphens.
/// Matches Python `uuid.uuid5(uuid.NAMESPACE_DNS, note_text).hex[:8]`.
String generateUuidV5Hex8(String name) {
  final uuidStr = generateUuidV5(name);
  return uuidStr.replaceAll('-', '').substring(0, 8);
}
