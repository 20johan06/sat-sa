import 'package:flutter_test/flutter_test.dart';
import 'package:satsa_mobile/domain/entities/cse.dart';
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
