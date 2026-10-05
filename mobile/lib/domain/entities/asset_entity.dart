import 'package:equatable/equatable.dart';

class AssetEntity extends Equatable {
  final String id;
  final String cseId;
  final String assetIdentifier;
  final String assetName;
  final String assetType;
  final String? ipAddress;
  final String criticality;
  final bool isMonitored;
  final DateTime createdAt;

  const AssetEntity({
    required this.id,
    required this.cseId,
    required this.assetIdentifier,
    required this.assetName,
    required this.assetType,
    this.ipAddress,
    required this.criticality,
    required this.isMonitored,
    required this.createdAt,
  });

  factory AssetEntity.fromJson(Map<String, dynamic> json) {
    return AssetEntity(
      id: json['id'] as String,
      cseId: json['cse_id'] as String,
      assetIdentifier: json['asset_identifier'] as String,
      assetName: json['asset_name'] as String,
      assetType: json['asset_type'] as String,
      ipAddress: json['ip_address'] as String?,
      criticality: json['criticality'] as String? ?? 'TIER_1',
      isMonitored: json['is_monitored'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String).toUtc(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cse_id': cseId,
        'asset_identifier': assetIdentifier,
        'asset_name': assetName,
        'asset_type': assetType,
        'ip_address': ipAddress,
        'criticality': criticality,
        'is_monitored': isMonitored,
        'created_at': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, cseId, assetIdentifier, assetName, assetType, criticality, isMonitored];
}
