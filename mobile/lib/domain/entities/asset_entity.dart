import 'package:equatable/equatable.dart';

class AssetEntity extends Equatable {
  final String id;
  final String cseId;
  final String assetIdentifier;
  final String name;
  final String assetType;
  final String? ipAddress;
  final String? hostname;
  final String criticality;
  final DateTime createdAt;

  const AssetEntity({
    required this.id,
    required this.cseId,
    required this.assetIdentifier,
    required this.name,
    required this.assetType,
    this.ipAddress,
    this.hostname,
    required this.criticality,
    required this.createdAt,
  });

  factory AssetEntity.fromJson(Map<String, dynamic> json) {
    return AssetEntity(
      id: json['id'] as String,
      cseId: json['cse_id'] as String,
      assetIdentifier: json['asset_identifier'] as String,
      name: json['name'] as String,
      assetType: json['asset_type'] as String? ?? 'SERVER',
      ipAddress: json['ip_address'] as String?,
      hostname: json['hostname'] as String?,
      criticality: json['criticality'] as String? ?? 'MEDIUM',
      createdAt: DateTime.parse(json['created_at'] as String).toUtc(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cse_id': cseId,
        'asset_identifier': assetIdentifier,
        'name': name,
        'asset_type': assetType,
        'ip_address': ipAddress,
        'hostname': hostname,
        'criticality': criticality,
        'created_at': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, cseId, assetIdentifier, name, assetType, ipAddress, hostname, criticality];
}

