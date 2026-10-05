import 'dart:typed_data';
import '../entities/package_manifest_entity.dart';

/// Contract for future .satsa offline package exchange operations in Phase 21.
abstract class DataExchangeRepository {
  /// Validates .satsa package structure, checks for plaintext violation, and verifies AEAD signature.
  Future<PackageManifestEntity> validatePackage({
    required Uint8List fileBytes,
    String? passphrase,
  });

  /// Decrypts .satsa data/data.enc payload and restores records into local storage.
  Future<bool> importPackage({
    required Uint8List fileBytes,
    String? passphrase,
  });

  /// Exports local assessment records to encrypted .satsa package archive.
  Future<Uint8List> exportPackage({
    required String assessmentId,
    String? passphrase,
  });
}
