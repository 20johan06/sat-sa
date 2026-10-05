import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Security Service for offline cryptographic validation assumptions.
class SecurityService {
  /// Deterministically verifies payload SHA256 integrity hash against decoded bytes.
  static bool verifySha256(List<int> bytes, String expectedHexHash) {
    final digest = sha256.convert(bytes);
    return digest.toString().toLowerCase() == expectedHexHash.toLowerCase();
  }

  /// Constructs Additional Authenticated Data (AAD) for AES-256-GCM context binding.
  static List<int> constructAad(String packageFormat, String formatVersion, String packageIdStr) {
    final str = '$packageFormat:$formatVersion:$packageIdStr';
    return utf8.encode(str);
  }
}
