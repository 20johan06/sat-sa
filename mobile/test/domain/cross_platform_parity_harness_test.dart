import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:satsa_mobile/data/database/app_database.dart';
import 'package:satsa_mobile/data/repositories/local_repository.dart';
import 'package:satsa_mobile/domain/analytics/analytics_runner.dart';
import 'package:satsa_mobile/domain/analytics/analytics_helpers.dart';
import 'package:satsa_mobile/domain/entities/cse.dart';
import 'package:satsa_mobile/domain/entities/alert_entity.dart';
import 'package:satsa_mobile/domain/entities/case_entity.dart';
import 'package:satsa_mobile/domain/entities/investigation_entity.dart';
import 'package:satsa_mobile/domain/entities/monitoring_coverage_entity.dart';

void main() {
  setUpAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  late AppDatabase db;
  late LocalSupervisoryRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = LocalSupervisoryRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('ACTUAL Cross-Platform Equivalence Harness: Windows Python vs Android Dart', () async {
    final cse1Id = generateUuidV5('cse1');
    final cse2Id = generateUuidV5('cse2');
    final cse3Id = generateUuidV5('cse3');
    final cse4Id = generateUuidV5('cse4');

    final nowUtc = DateTime.utc(2026, 10, 5, 10, 0, 0);

    // 1. CSEs
    await repo.insertCSE(CSEEntity(
      id: cse1Id, cseCode: 'CSE1', name: 'Target Bank', sector: 'BANKING', criticalityTier: 'TIER_1', isActive: true, createdAt: nowUtc, updatedAt: nowUtc,
    ));
    await repo.insertCSE(CSEEntity(
      id: cse2Id, cseCode: 'CSE2', name: 'Peer Bank 1', sector: 'BANKING', criticalityTier: 'TIER_1', isActive: true, createdAt: nowUtc, updatedAt: nowUtc,
    ));
    await repo.insertCSE(CSEEntity(
      id: cse3Id, cseCode: 'CSE3', name: 'Peer Bank 2', sector: 'BANKING', criticalityTier: 'TIER_1', isActive: true, createdAt: nowUtc, updatedAt: nowUtc,
    ));
    await repo.insertCSE(CSEEntity(
      id: cse4Id, cseCode: 'CSE4', name: 'Peer Bank 3', sector: 'BANKING', criticalityTier: 'TIER_1', isActive: true, createdAt: nowUtc, updatedAt: nowUtc,
    ));

    // 2. EG-03 Data: 10 closed cases for CSE1 (durations: 100, 200, 300, 400, 500, 600, 700, 800, 900, 50s)
    final durations = [100, 200, 300, 400, 500, 600, 700, 800, 900, 50];
    for (int i = 0; i < durations.length; i++) {
      final dur = durations[i];
      final openedAt = nowUtc.subtract(Duration(seconds: dur + 1000));
      final closedAt = openedAt.add(Duration(seconds: dur));
      await repo.insertCase(CaseEntity(
        id: generateUuidV5('eg03-case-$i'),
        cseId: cse1Id,
        externalCaseId: 'CSE1-CASE-$i',
        title: 'Case $i',
        status: 'CLOSED',
        priority: 'MEDIUM',
        openedAt: openedAt,
        closedAt: closedAt,
        createdAt: openedAt,
      ));
    }

    // 3. EG-04 Data: 3 distinct cases with identical notes > 15 chars
    const repeatedNote = 'Standard template investigation notes text containing more than fifteen characters long.';
    for (int idx = 1; idx <= 3; idx++) {
      final cId = generateUuidV5('eg04-case-$idx');
      await repo.insertCase(CaseEntity(
        id: cId,
        cseId: cse1Id,
        externalCaseId: 'C$idx',
        title: 'C$idx',
        status: 'OPEN',
        priority: 'MEDIUM',
        openedAt: nowUtc,
        createdAt: nowUtc,
      ));

      await repo.insertInvestigation(InvestigationEntity(
        id: generateUuidV5('eg04-inv-$idx'),
        caseId: cId,
        actionType: 'INVESTIGATE',
        notes: repeatedNote,
        evidenceCount: 1,
        startedAt: nowUtc,
        createdAt: nowUtc,
      ));
    }

    // 4. NS-01 Data: Expected coverages (1 inactive, 1 active)
    await repo.insertMonitoringCoverage(MonitoringCoverageEntity(
      id: generateUuidV5('ns01-cov-1'),
      cseId: cse1Id,
      logSourceCategory: 'FIREWALL',
      isExpected: true,
      isActive: false,
      createdAt: nowUtc,
    ));
    await repo.insertMonitoringCoverage(MonitoringCoverageEntity(
      id: generateUuidV5('ns01-cov-2'),
      cseId: cse1Id,
      logSourceCategory: 'ENDPOINT',
      isExpected: true,
      isActive: true,
      createdAt: nowUtc,
    ));

    // 5. AN-01 Data: Daily alert volume anomaly (10 days: [2, 4, 6, 8, 10, 12, 14, 16, 18, 100])
    final dayCounts = [2, 4, 6, 8, 10, 12, 14, 16, 18, 100];
    for (int dayIdx = 0; dayIdx < dayCounts.length; dayIdx++) {
      final count = dayCounts[dayIdx];
      final alertDate = DateTime.utc(2026, 1, dayIdx + 1, 10, 0, 0);
      for (int aIdx = 0; aIdx < count; aIdx++) {
        await repo.insertAlert(AlertEntity(
          id: generateUuidV5('an01-alert-$dayIdx-$aIdx'),
          cseId: cse1Id,
          externalAlertId: 'ALT-$dayIdx-$aIdx',
          title: 'Alert $dayIdx-$aIdx',
          category: 'MALWARE',
          severity: 'MEDIUM',
          status: 'NEW',
          detectedAt: alertDate,
          createdAt: alertDate,
        ));
      }
    }

    // 6. BM-01 Data: Peer CSEs (2, 3, 4) with 8, 9, 10 cases out of 10 alerts
    final peerCseIds = [cse2Id, cse3Id, cse4Id];
    final peerCaseCounts = [8, 9, 10];
    for (int pIdx = 0; pIdx < peerCseIds.length; pIdx++) {
      final pCseId = peerCseIds[pIdx];
      final cLimit = peerCaseCounts[pIdx];
      for (int i = 0; i < 10; i++) {
        final altId = generateUuidV5('peer-alert-$pIdx-$i');
        await repo.insertAlert(AlertEntity(
          id: altId,
          cseId: pCseId,
          externalAlertId: altId,
          title: 'Peer Alert',
          category: 'THREAT',
          severity: 'HIGH',
          status: 'NEW',
          detectedAt: nowUtc,
          createdAt: nowUtc,
        ));
        if (i < cLimit) {
          await repo.insertCase(CaseEntity(
            id: generateUuidV5('peer-case-$pIdx-$i'),
            cseId: pCseId,
            alertId: altId,
            externalCaseId: 'PCASE-$pIdx-$i',
            title: 'Peer Case',
            status: 'OPEN',
            priority: 'MEDIUM',
            openedAt: nowUtc,
            createdAt: nowUtc,
          ));
        }
      }
    }

    // Target CSE1 has 1 case out of 10 alerts (10% rate vs peer mean 90% std 10%)
    for (int i = 0; i < 10; i++) {
      final altId = generateUuidV5('target-bm01-alert-$i');
      await repo.insertAlert(AlertEntity(
        id: altId,
        cseId: cse1Id,
        externalAlertId: altId,
        title: 'Target Alert',
        category: 'THREAT',
        severity: 'HIGH',
        status: 'NEW',
        detectedAt: nowUtc,
        createdAt: nowUtc,
      ));
      if (i < 1) {
        await repo.insertCase(CaseEntity(
          id: generateUuidV5('target-bm01-case-$i'),
          cseId: cse1Id,
          alertId: altId,
          externalCaseId: 'TCASE-$i',
          title: 'Target Case',
          status: 'OPEN',
          priority: 'MEDIUM',
          openedAt: nowUtc,
          createdAt: nowUtc,
        ));
      }
    }

    // 7. OI-01 Data: Resolved case with 0 linked investigations
    await repo.insertCase(CaseEntity(
      id: generateUuidV5('oi01-case-resolved-no-inv'),
      cseId: cse1Id,
      externalCaseId: 'CASE-RESOLVED-NO-INV',
      title: 'Uninvestigated Resolved Case',
      status: 'RESOLVED',
      priority: 'HIGH',
      openedAt: nowUtc.subtract(const Duration(hours: 5)),
      closedAt: nowUtc,
      createdAt: nowUtc,
    ));

    // --- RUN DART ANALYTICS ENGINE ---
    final dartResult = await AnalyticsRunner.runAnalyticsForCSE(
      repository: repo,
      cseId: cse1Id,
    );

    // Normalize Dart findings into JSON structure
    final serializedFindings = dartResult.createdFindings.map((f) {
      final metrics = f.metricsJson ?? <String, dynamic>{};
      final evidences = dartResult.createdEvidences.where((e) => e.findingId == f.id).toList();
      return {
        'finding_code': f.findingCode,
        'category': f.category,
        'severity': f.severity,
        'title': f.title,
        'description': f.description,
        'rationale': f.rationale,
        'detection_method': f.detectionMethod,
        'metrics_json': metrics,
        'evidences_count': evidences.length,
        'evidence_types': evidences.map((e) => e.evidenceType).toList(),
        'evidence_case_ids': evidences.where((e) => e.caseId != null).map((e) => e.caseId!).toList(),
        'evidence_investigation_ids': evidences.where((e) => e.investigationId != null).map((e) => e.investigationId!).toList(),
        'evidence_coverage_ids': evidences.where((e) => e.coverageId != null).map((e) => e.coverageId!).toList(),
        'evidence_alert_ids': evidences.where((e) => e.alertId != null).map((e) => e.alertId!).toList(),
      };
    }).toList();

    serializedFindings.sort((a, b) => (a['finding_code'] as String).compareTo(b['finding_code'] as String));

    final dartOutput = {
      'generator': 'Dart Drift Engine',
      'cse_id': cse1Id,
      'total_findings': serializedFindings.length,
      'total_baselines': dartResult.createdBaselines.length,
      'findings': serializedFindings,
      'baselines': dartResult.createdBaselines.map((b) => {
        'peer_group': b.peerGroup,
        'metric_name': b.metricName,
        'baseline_value': double.parse(b.baselineValue.toStringAsFixed(4)),
        'sample_size': b.sampleSize,
        'std_dev': double.parse(((b.metadataJson['std_dev'] as num?) ?? 0.0).toStringAsFixed(4)),
      }).toList(),
    };

    // Save Dart output to scratch
    final scratchDir = r'C:\Users\HP\.gemini\antigravity-ide\brain\cea0ad60-d3d9-4d0d-9e44-2f7aa914194a\scratch';
    final dartOutFile = File('$scratchDir\\dart_parity_output.json');
    await dartOutFile.writeAsString(const JsonEncoder.withIndent('  ').convert(dartOutput));

    // --- READ PYTHON PARITY OUTPUT ---
    final pythonOutFile = File('$scratchDir\\python_parity_output.json');
    expect(pythonOutFile.existsSync(), isTrue, reason: 'Python output file must exist');
    final pythonOutput = jsonDecode(await pythonOutFile.readAsString()) as Map<String, dynamic>;

    final pythonFindings = pythonOutput['findings'] as List<dynamic>;

    // Print count summary
    print('====================================================');
    print('CROSS-PLATFORM COMPARISON SUMMARY');
    print('Python total findings: ${pythonFindings.length}');
    print('Dart total findings:   ${serializedFindings.length}');
    print('====================================================');

    // Build lookup maps by finding_code
    final pythonMap = <String, Map<String, dynamic>>{};
    for (var f in pythonFindings) {
      pythonMap[f['finding_code'] as String] = f as Map<String, dynamic>;
    }

    final dartMap = <String, Map<String, dynamic>>{};
    for (var f in serializedFindings) {
      dartMap[f['finding_code'] as String] = f as Map<String, dynamic>;
    }

    final allCodes = {...pythonMap.keys, ...dartMap.keys}.toList()..sort();

    int matchedCount = 0;
    int missingInDart = 0;
    int extraInDart = 0;

    for (var code in allCodes) {
      final pFind = pythonMap[code];
      final dFind = dartMap[code];

      if (pFind != null && dFind != null) {
        matchedCount++;
        // Compare semantic fields
        expect(dFind['category'], equals(pFind['category']), reason: '$code category mismatch');
        expect(dFind['severity'], equals(pFind['severity']), reason: '$code severity mismatch');
        expect(dFind['detection_method'], equals(pFind['detection_method']), reason: '$code detection_method mismatch');
        expect(dFind['evidences_count'], equals(pFind['evidences_count']), reason: '$code evidences_count mismatch');

        // Compare metrics JSON key values with tolerance <= 1e-4 for floating point values
        final pMetrics = pFind['metrics_json'] as Map<String, dynamic>;
        final dMetrics = dFind['metrics_json'] as Map<String, dynamic>;

        for (var k in ['rule_code', 'metric', 'observed_value', 'baseline_value', 'deviation']) {
          if (pMetrics.containsKey(k) && dMetrics.containsKey(k)) {
            final pVal = pMetrics[k];
            final dVal = dMetrics[k];
            if (pVal is num && dVal is num) {
              final diff = ((dVal) - (pVal)).abs();
              expect(diff, lessThanOrEqualTo(1e-4), reason: '$code metric $k numeric mismatch: Python=$pVal, Dart=$dVal');
            } else if (pVal != null && dVal != null) {
              expect(dVal.toString(), equals(pVal.toString()), reason: '$code metric $k mismatch: Python=$pVal, Dart=$dVal');
            }
          }
        }
      } else if (pFind != null && dFind == null) {
        missingInDart++;
        print('MISSING IN DART: $code');
      } else if (pFind == null && dFind != null) {
        extraInDart++;
        print('EXTRA IN DART: $code');
      }
    }

    print('Matched Findings:    $matchedCount');
    print('Missing in Dart:     $missingInDart');
    print('Extra in Dart:       $extraInDart');

    // Explicit P5 check
    final p5Py = (pythonMap['FND-EG03-2d8d49-253677']?['metrics_json'] as Map<String, dynamic>?)?['baseline_value'];
    final p5Dart = (dartMap['FND-EG03-2d8d49-253677']?['metrics_json'] as Map<String, dynamic>?)?['baseline_value'];
    if (p5Py != null && p5Dart != null) {
      final diff = ((p5Dart as num) - (p5Py as num)).abs();
      expect(diff, lessThanOrEqualTo(1e-4));
    }

    // Explicit UTC date check
    final datePy = (pythonMap['FND-AN01-2d8d49-2026-01-10']?['metrics_json'] as Map<String, dynamic>?)?['date'];
    final dateDart = (dartMap['FND-AN01-2d8d49-2026-01-10']?['metrics_json'] as Map<String, dynamic>?)?['date'];
    expect(dateDart, equals(datePy));

    expect(missingInDart, equals(0));
    expect(extraInDart, equals(0));
  });
}
