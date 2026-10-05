import 'package:equatable/equatable.dart';

class PackageManifestEntity extends Equatable {
  final String packageFormat;
  final String formatVersion;
  final String appVersion;
  final String packageId;
  final DateTime createdAt;
  final String? exportedByUser;
  final String? exportHostName;
  final String cseId;
  final String cseCode;
  final String assessmentId;
  final String assessmentName;
  final Map<String, int> recordCounts;
  final bool isEncrypted;
  final String keyProtectionMode;
  final String kdfSalt;
  final int kdfIterations;
  final String aeadAlgorithm;
  final String aeadNonce;
  final String dataHashSha256;

  const PackageManifestEntity({
    required this.packageFormat,
    required this.formatVersion,
    required this.appVersion,
    required this.packageId,
    required this.createdAt,
    this.exportedByUser,
    this.exportHostName,
    required this.cseId,
    required this.cseCode,
    required this.assessmentId,
    required this.assessmentName,
    required this.recordCounts,
    required this.isEncrypted,
    required this.keyProtectionMode,
    required this.kdfSalt,
    required this.kdfIterations,
    required this.aeadAlgorithm,
    required this.aeadNonce,
    required this.dataHashSha256,
  });

  factory PackageManifestEntity.fromJson(Map<String, dynamic> json) {
    return PackageManifestEntity(
      packageFormat: json['package_format'] as String? ?? 'SAT-SA-OFFLINE-PACKAGE',
      formatVersion: json['format_version'] as String? ?? '1.0.0',
      appVersion: json['app_version'] as String? ?? 'v2.0.0',
      packageId: json['package_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String).toUtc(),
      exportedByUser: json['exported_by_user'] as String?,
      exportHostName: json['export_host_name'] as String?,
      cseId: json['cse_id'] as String,
      cseCode: json['cse_code'] as String,
      assessmentId: json['assessment_id'] as String,
      assessmentName: json['assessment_name'] as String,
      recordCounts: Map<String, int>.from(json['record_counts'] as Map),
      isEncrypted: json['is_encrypted'] as bool? ?? true,
      keyProtectionMode: json['key_protection_mode'] as String? ?? 'PASSPHRASE',
      kdfSalt: json['kdf_salt'] as String,
      kdfIterations: json['kdf_iterations'] as int? ?? 100000,
      aeadAlgorithm: json['aead_algorithm'] as String? ?? 'AES-256-GCM',
      aeadNonce: json['aead_nonce'] as String,
      dataHashSha256: json['data_hash_sha256'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'package_format': packageFormat,
        'format_version': formatVersion,
        'app_version': appVersion,
        'package_id': packageId,
        'created_at': createdAt.toIso8601String(),
        'exported_by_user': exportedByUser,
        'export_host_name': exportHostName,
        'cse_id': cseId,
        'cse_code': cseCode,
        'assessment_id': assessmentId,
        'assessment_name': assessmentName,
        'record_counts': recordCounts,
        'is_encrypted': isEncrypted,
        'key_protection_mode': keyProtectionMode,
        'kdf_salt': kdfSalt,
        'kdf_iterations': kdfIterations,
        'aead_algorithm': aeadAlgorithm,
        'aead_nonce': aeadNonce,
        'data_hash_sha256': dataHashSha256,
      };

  @override
  List<Object?> get props => [
        packageId,
        cseId,
        assessmentId,
        isEncrypted,
        aeadAlgorithm,
        dataHashSha256,
      ];
}
