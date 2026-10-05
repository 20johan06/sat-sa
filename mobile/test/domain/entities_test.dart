import 'package:flutter_test/flutter_test.dart';
import 'package:satsa_mobile/domain/entities/cse.dart';
import 'package:satsa_mobile/domain/entities/alert_entity.dart';
import 'package:satsa_mobile/domain/entities/case_entity.dart';
import 'package:satsa_mobile/domain/entities/investigation_entity.dart';
import 'package:satsa_mobile/domain/entities/escalation_entity.dart';
import 'package:satsa_mobile/domain/entities/monitoring_coverage_entity.dart';
import 'package:satsa_mobile/domain/entities/asset_entity.dart';
import 'package:satsa_mobile/domain/entities/package_manifest_entity.dart';

void main() {
  group('Domain Entity JSON Serialization Parity', () {
    test('CSEEntity JSON round trip', () {
      final now = DateTime.now().toUtc();
      final cse = CSEEntity(
        id: '123e4567-e89b-12d3-a456-426614174000',
        cseCode: 'CSE-BANK-01',
        name: 'State Reserve Bank',
        sector: 'FINANCIAL',
        criticalityTier: 'TIER_1',
        contactEmail: 'soc@bank.org',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );

      final jsonMap = cse.toJson();
      final restored = CSEEntity.fromJson(jsonMap);

      expect(restored.id, cse.id);
      expect(restored.cseCode, cse.cseCode);
      expect(restored.sector, cse.sector);
    });

    test('AlertEntity JSON parity with Windows Alert model', () {
      final now = DateTime.now().toUtc();
      final alert = AlertEntity(
        id: 'alt-1',
        cseId: 'cse-1',
        externalAlertId: 'ALT-100',
        title: 'High CPU',
        category: 'PERFORMANCE',
        severity: 'HIGH',
        status: 'NEW',
        detectedAt: now,
        createdAt: now,
      );

      final jsonMap = alert.toJson();
      final restored = AlertEntity.fromJson(jsonMap);

      expect(restored.externalAlertId, 'ALT-100');
      expect(restored.title, 'High CPU');
      expect(restored.severity, 'HIGH');
    });

    test('CaseEntity JSON parity with Windows Case model', () {
      final now = DateTime.now().toUtc();
      final caseObj = CaseEntity(
        id: 'cas-1',
        cseId: 'cse-1',
        externalCaseId: 'CAS-500',
        title: 'Node Outage',
        status: 'OPEN',
        priority: 'HIGH',
        openedAt: now,
        createdAt: now,
      );

      final jsonMap = caseObj.toJson();
      final restored = CaseEntity.fromJson(jsonMap);

      expect(restored.externalCaseId, 'CAS-500');
      expect(restored.priority, 'HIGH');
    });

    test('InvestigationEntity JSON parity with Windows Investigation model', () {
      final now = DateTime.now().toUtc();
      final inv = InvestigationEntity(
        id: 'inv-1',
        caseId: 'cas-1',
        actionType: 'AUDIT',
        startedAt: now,
        evidenceCount: 2,
        createdAt: now,
      );

      final jsonMap = inv.toJson();
      final restored = InvestigationEntity.fromJson(jsonMap);

      expect(restored.actionType, 'AUDIT');
      expect(restored.evidenceCount, 2);
    });

    test('EscalationEntity JSON parity with Windows Escalation model', () {
      final now = DateTime.now().toUtc();
      final esc = EscalationEntity(
        id: 'esc-1',
        caseId: 'cas-1',
        escalationLevel: 'LEVEL_2',
        status: 'PENDING',
        escalatedAt: now,
        createdAt: now,
      );

      final jsonMap = esc.toJson();
      final restored = EscalationEntity.fromJson(jsonMap);

      expect(restored.escalationLevel, 'LEVEL_2');
    });

    test('MonitoringCoverageEntity JSON parity with Windows MonitoringCoverage model', () {
      final now = DateTime.now().toUtc();
      final mc = MonitoringCoverageEntity(
        id: 'mc-1',
        cseId: 'cse-1',
        logSourceCategory: 'SIEM',
        isExpected: true,
        isActive: true,
        createdAt: now,
      );

      final jsonMap = mc.toJson();
      final restored = MonitoringCoverageEntity.fromJson(jsonMap);

      expect(restored.logSourceCategory, 'SIEM');
      expect(restored.isExpected, true);
    });

    test('AssetEntity JSON parity with Windows Asset model', () {
      final now = DateTime.now().toUtc();
      final asset = AssetEntity(
        id: 'ast-1',
        cseId: 'cse-1',
        assetIdentifier: 'PAY-01',
        name: 'Payment Server',
        assetType: 'SERVER',
        criticality: 'HIGH',
        createdAt: now,
      );

      final jsonMap = asset.toJson();
      final restored = AssetEntity.fromJson(jsonMap);

      expect(restored.assetIdentifier, 'PAY-01');
      expect(restored.name, 'Payment Server');
    });

    test('PackageManifestEntity JSON parity with Phase 18 backend schema', () {
      final now = DateTime.now().toUtc();
      final manifest = PackageManifestEntity(
        packageFormat: 'SAT-SA-OFFLINE-PACKAGE',
        formatVersion: '1.0.0',
        appVersion: 'v2.0.0',
        packageId: '987e6543-e89b-12d3-a456-426614174000',
        createdAt: now,
        cseId: '123e4567-e89b-12d3-a456-426614174000',
        cseCode: 'CSE-BANK-01',
        assessmentId: '456e7890-e89b-12d3-a456-426614174000',
        assessmentName: 'Q3 Assessment',
        recordCounts: {'cses': 1, 'assessments': 1, 'findings': 5},
        isEncrypted: true,
        keyProtectionMode: 'PASSPHRASE',
        kdfSalt: 'a1b2c3d4e5f60708',
        kdfIterations: 100000,
        aeadAlgorithm: 'AES-256-GCM',
        aeadNonce: '0102030405060708090a0b0c',
        dataHashSha256: 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
      );

      final jsonMap = manifest.toJson();
      final restored = PackageManifestEntity.fromJson(jsonMap);

      expect(restored.packageFormat, 'SAT-SA-OFFLINE-PACKAGE');
      expect(restored.aeadAlgorithm, 'AES-256-GCM');
      expect(restored.kdfIterations, 100000);
      expect(restored.isEncrypted, true);
    });
  });
}

