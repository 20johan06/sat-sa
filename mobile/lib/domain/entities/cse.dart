import 'package:equatable/equatable.dart';

class CSEEntity extends Equatable {
  final String id;
  final String cseCode;
  final String name;
  final String sector;
  final String criticalityTier;
  final String? contactEmail;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CSEEntity({
    required this.id,
    required this.cseCode,
    required this.name,
    required this.sector,
    required this.criticalityTier,
    this.contactEmail,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CSEEntity.fromJson(Map<String, dynamic> json) {
    return CSEEntity(
      id: json['id'] as String,
      cseCode: json['cse_code'] as String,
      name: json['name'] as String,
      sector: json['sector'] as String,
      criticalityTier: json['criticality_tier'] as String? ?? 'TIER_1',
      contactEmail: json['contact_email'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String).toUtc(),
      updatedAt: DateTime.parse(json['updated_at'] as String).toUtc(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cse_code': cseCode,
        'name': name,
        'sector': sector,
        'criticality_tier': criticalityTier,
        'contact_email': contactEmail,
        'is_active': isActive,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, cseCode, name, sector, criticalityTier, contactEmail, isActive];
}
