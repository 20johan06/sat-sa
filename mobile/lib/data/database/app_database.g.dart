// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CSEsTable extends CSEs with TableInfo<$CSEsTable, CSERecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CSEsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cseCodeMeta =
      const VerificationMeta('cseCode');
  @override
  late final GeneratedColumn<String> cseCode = GeneratedColumn<String>(
      'cse_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sectorMeta = const VerificationMeta('sector');
  @override
  late final GeneratedColumn<String> sector = GeneratedColumn<String>(
      'sector', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _criticalityTierMeta =
      const VerificationMeta('criticalityTier');
  @override
  late final GeneratedColumn<String> criticalityTier = GeneratedColumn<String>(
      'criticality_tier', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('TIER_1'));
  static const VerificationMeta _contactEmailMeta =
      const VerificationMeta('contactEmail');
  @override
  late final GeneratedColumn<String> contactEmail = GeneratedColumn<String>(
      'contact_email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        cseCode,
        name,
        sector,
        criticalityTier,
        contactEmail,
        isActive,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cses';
  @override
  VerificationContext validateIntegrity(Insertable<CSERecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cse_code')) {
      context.handle(_cseCodeMeta,
          cseCode.isAcceptableOrUnknown(data['cse_code']!, _cseCodeMeta));
    } else if (isInserting) {
      context.missing(_cseCodeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sector')) {
      context.handle(_sectorMeta,
          sector.isAcceptableOrUnknown(data['sector']!, _sectorMeta));
    } else if (isInserting) {
      context.missing(_sectorMeta);
    }
    if (data.containsKey('criticality_tier')) {
      context.handle(
          _criticalityTierMeta,
          criticalityTier.isAcceptableOrUnknown(
              data['criticality_tier']!, _criticalityTierMeta));
    }
    if (data.containsKey('contact_email')) {
      context.handle(
          _contactEmailMeta,
          contactEmail.isAcceptableOrUnknown(
              data['contact_email']!, _contactEmailMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {cseCode},
      ];
  @override
  CSERecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CSERecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      cseCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cse_code'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      sector: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sector'])!,
      criticalityTier: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}criticality_tier'])!,
      contactEmail: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contact_email']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CSEsTable createAlias(String alias) {
    return $CSEsTable(attachedDatabase, alias);
  }
}

class CSERecord extends DataClass implements Insertable<CSERecord> {
  final String id;
  final String cseCode;
  final String name;
  final String sector;
  final String criticalityTier;
  final String? contactEmail;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CSERecord(
      {required this.id,
      required this.cseCode,
      required this.name,
      required this.sector,
      required this.criticalityTier,
      this.contactEmail,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cse_code'] = Variable<String>(cseCode);
    map['name'] = Variable<String>(name);
    map['sector'] = Variable<String>(sector);
    map['criticality_tier'] = Variable<String>(criticalityTier);
    if (!nullToAbsent || contactEmail != null) {
      map['contact_email'] = Variable<String>(contactEmail);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CSEsCompanion toCompanion(bool nullToAbsent) {
    return CSEsCompanion(
      id: Value(id),
      cseCode: Value(cseCode),
      name: Value(name),
      sector: Value(sector),
      criticalityTier: Value(criticalityTier),
      contactEmail: contactEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(contactEmail),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CSERecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CSERecord(
      id: serializer.fromJson<String>(json['id']),
      cseCode: serializer.fromJson<String>(json['cseCode']),
      name: serializer.fromJson<String>(json['name']),
      sector: serializer.fromJson<String>(json['sector']),
      criticalityTier: serializer.fromJson<String>(json['criticalityTier']),
      contactEmail: serializer.fromJson<String?>(json['contactEmail']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cseCode': serializer.toJson<String>(cseCode),
      'name': serializer.toJson<String>(name),
      'sector': serializer.toJson<String>(sector),
      'criticalityTier': serializer.toJson<String>(criticalityTier),
      'contactEmail': serializer.toJson<String?>(contactEmail),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CSERecord copyWith(
          {String? id,
          String? cseCode,
          String? name,
          String? sector,
          String? criticalityTier,
          Value<String?> contactEmail = const Value.absent(),
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      CSERecord(
        id: id ?? this.id,
        cseCode: cseCode ?? this.cseCode,
        name: name ?? this.name,
        sector: sector ?? this.sector,
        criticalityTier: criticalityTier ?? this.criticalityTier,
        contactEmail:
            contactEmail.present ? contactEmail.value : this.contactEmail,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  CSERecord copyWithCompanion(CSEsCompanion data) {
    return CSERecord(
      id: data.id.present ? data.id.value : this.id,
      cseCode: data.cseCode.present ? data.cseCode.value : this.cseCode,
      name: data.name.present ? data.name.value : this.name,
      sector: data.sector.present ? data.sector.value : this.sector,
      criticalityTier: data.criticalityTier.present
          ? data.criticalityTier.value
          : this.criticalityTier,
      contactEmail: data.contactEmail.present
          ? data.contactEmail.value
          : this.contactEmail,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CSERecord(')
          ..write('id: $id, ')
          ..write('cseCode: $cseCode, ')
          ..write('name: $name, ')
          ..write('sector: $sector, ')
          ..write('criticalityTier: $criticalityTier, ')
          ..write('contactEmail: $contactEmail, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cseCode, name, sector, criticalityTier,
      contactEmail, isActive, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CSERecord &&
          other.id == this.id &&
          other.cseCode == this.cseCode &&
          other.name == this.name &&
          other.sector == this.sector &&
          other.criticalityTier == this.criticalityTier &&
          other.contactEmail == this.contactEmail &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CSEsCompanion extends UpdateCompanion<CSERecord> {
  final Value<String> id;
  final Value<String> cseCode;
  final Value<String> name;
  final Value<String> sector;
  final Value<String> criticalityTier;
  final Value<String?> contactEmail;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CSEsCompanion({
    this.id = const Value.absent(),
    this.cseCode = const Value.absent(),
    this.name = const Value.absent(),
    this.sector = const Value.absent(),
    this.criticalityTier = const Value.absent(),
    this.contactEmail = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CSEsCompanion.insert({
    required String id,
    required String cseCode,
    required String name,
    required String sector,
    this.criticalityTier = const Value.absent(),
    this.contactEmail = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        cseCode = Value(cseCode),
        name = Value(name),
        sector = Value(sector),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<CSERecord> custom({
    Expression<String>? id,
    Expression<String>? cseCode,
    Expression<String>? name,
    Expression<String>? sector,
    Expression<String>? criticalityTier,
    Expression<String>? contactEmail,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cseCode != null) 'cse_code': cseCode,
      if (name != null) 'name': name,
      if (sector != null) 'sector': sector,
      if (criticalityTier != null) 'criticality_tier': criticalityTier,
      if (contactEmail != null) 'contact_email': contactEmail,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CSEsCompanion copyWith(
      {Value<String>? id,
      Value<String>? cseCode,
      Value<String>? name,
      Value<String>? sector,
      Value<String>? criticalityTier,
      Value<String?>? contactEmail,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return CSEsCompanion(
      id: id ?? this.id,
      cseCode: cseCode ?? this.cseCode,
      name: name ?? this.name,
      sector: sector ?? this.sector,
      criticalityTier: criticalityTier ?? this.criticalityTier,
      contactEmail: contactEmail ?? this.contactEmail,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cseCode.present) {
      map['cse_code'] = Variable<String>(cseCode.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sector.present) {
      map['sector'] = Variable<String>(sector.value);
    }
    if (criticalityTier.present) {
      map['criticality_tier'] = Variable<String>(criticalityTier.value);
    }
    if (contactEmail.present) {
      map['contact_email'] = Variable<String>(contactEmail.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CSEsCompanion(')
          ..write('id: $id, ')
          ..write('cseCode: $cseCode, ')
          ..write('name: $name, ')
          ..write('sector: $sector, ')
          ..write('criticalityTier: $criticalityTier, ')
          ..write('contactEmail: $contactEmail, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssessmentsTable extends Assessments
    with TableInfo<$AssessmentsTable, AssessmentRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssessmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cseIdMeta = const VerificationMeta('cseId');
  @override
  late final GeneratedColumn<String> cseId = GeneratedColumn<String>(
      'cse_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES cses (id) ON DELETE RESTRICT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _periodStartMeta =
      const VerificationMeta('periodStart');
  @override
  late final GeneratedColumn<DateTime> periodStart = GeneratedColumn<DateTime>(
      'period_start', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _periodEndMeta =
      const VerificationMeta('periodEnd');
  @override
  late final GeneratedColumn<DateTime> periodEnd = GeneratedColumn<DateTime>(
      'period_end', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('DRAFT'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdByUserIdMeta =
      const VerificationMeta('createdByUserId');
  @override
  late final GeneratedColumn<String> createdByUserId = GeneratedColumn<String>(
      'created_by_user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        cseId,
        name,
        description,
        periodStart,
        periodEnd,
        status,
        createdAt,
        updatedAt,
        createdByUserId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assessments';
  @override
  VerificationContext validateIntegrity(Insertable<AssessmentRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cse_id')) {
      context.handle(
          _cseIdMeta, cseId.isAcceptableOrUnknown(data['cse_id']!, _cseIdMeta));
    } else if (isInserting) {
      context.missing(_cseIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('period_start')) {
      context.handle(
          _periodStartMeta,
          periodStart.isAcceptableOrUnknown(
              data['period_start']!, _periodStartMeta));
    } else if (isInserting) {
      context.missing(_periodStartMeta);
    }
    if (data.containsKey('period_end')) {
      context.handle(_periodEndMeta,
          periodEnd.isAcceptableOrUnknown(data['period_end']!, _periodEndMeta));
    } else if (isInserting) {
      context.missing(_periodEndMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_by_user_id')) {
      context.handle(
          _createdByUserIdMeta,
          createdByUserId.isAcceptableOrUnknown(
              data['created_by_user_id']!, _createdByUserIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssessmentRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssessmentRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      cseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cse_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      periodStart: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}period_start'])!,
      periodEnd: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}period_end'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      createdByUserId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}created_by_user_id']),
    );
  }

  @override
  $AssessmentsTable createAlias(String alias) {
    return $AssessmentsTable(attachedDatabase, alias);
  }
}

class AssessmentRecord extends DataClass
    implements Insertable<AssessmentRecord> {
  final String id;
  final String cseId;
  final String name;
  final String? description;
  final DateTime periodStart;
  final DateTime periodEnd;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdByUserId;
  const AssessmentRecord(
      {required this.id,
      required this.cseId,
      required this.name,
      this.description,
      required this.periodStart,
      required this.periodEnd,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      this.createdByUserId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cse_id'] = Variable<String>(cseId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['period_start'] = Variable<DateTime>(periodStart);
    map['period_end'] = Variable<DateTime>(periodEnd);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || createdByUserId != null) {
      map['created_by_user_id'] = Variable<String>(createdByUserId);
    }
    return map;
  }

  AssessmentsCompanion toCompanion(bool nullToAbsent) {
    return AssessmentsCompanion(
      id: Value(id),
      cseId: Value(cseId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      periodStart: Value(periodStart),
      periodEnd: Value(periodEnd),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      createdByUserId: createdByUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(createdByUserId),
    );
  }

  factory AssessmentRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssessmentRecord(
      id: serializer.fromJson<String>(json['id']),
      cseId: serializer.fromJson<String>(json['cseId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      periodStart: serializer.fromJson<DateTime>(json['periodStart']),
      periodEnd: serializer.fromJson<DateTime>(json['periodEnd']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdByUserId: serializer.fromJson<String?>(json['createdByUserId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cseId': serializer.toJson<String>(cseId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'periodStart': serializer.toJson<DateTime>(periodStart),
      'periodEnd': serializer.toJson<DateTime>(periodEnd),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdByUserId': serializer.toJson<String?>(createdByUserId),
    };
  }

  AssessmentRecord copyWith(
          {String? id,
          String? cseId,
          String? name,
          Value<String?> description = const Value.absent(),
          DateTime? periodStart,
          DateTime? periodEnd,
          String? status,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<String?> createdByUserId = const Value.absent()}) =>
      AssessmentRecord(
        id: id ?? this.id,
        cseId: cseId ?? this.cseId,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        periodStart: periodStart ?? this.periodStart,
        periodEnd: periodEnd ?? this.periodEnd,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        createdByUserId: createdByUserId.present
            ? createdByUserId.value
            : this.createdByUserId,
      );
  AssessmentRecord copyWithCompanion(AssessmentsCompanion data) {
    return AssessmentRecord(
      id: data.id.present ? data.id.value : this.id,
      cseId: data.cseId.present ? data.cseId.value : this.cseId,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      periodStart:
          data.periodStart.present ? data.periodStart.value : this.periodStart,
      periodEnd: data.periodEnd.present ? data.periodEnd.value : this.periodEnd,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdByUserId: data.createdByUserId.present
          ? data.createdByUserId.value
          : this.createdByUserId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssessmentRecord(')
          ..write('id: $id, ')
          ..write('cseId: $cseId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('periodStart: $periodStart, ')
          ..write('periodEnd: $periodEnd, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdByUserId: $createdByUserId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cseId, name, description, periodStart,
      periodEnd, status, createdAt, updatedAt, createdByUserId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssessmentRecord &&
          other.id == this.id &&
          other.cseId == this.cseId &&
          other.name == this.name &&
          other.description == this.description &&
          other.periodStart == this.periodStart &&
          other.periodEnd == this.periodEnd &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.createdByUserId == this.createdByUserId);
}

class AssessmentsCompanion extends UpdateCompanion<AssessmentRecord> {
  final Value<String> id;
  final Value<String> cseId;
  final Value<String> name;
  final Value<String?> description;
  final Value<DateTime> periodStart;
  final Value<DateTime> periodEnd;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> createdByUserId;
  final Value<int> rowid;
  const AssessmentsCompanion({
    this.id = const Value.absent(),
    this.cseId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.periodStart = const Value.absent(),
    this.periodEnd = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdByUserId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssessmentsCompanion.insert({
    required String id,
    required String cseId,
    required String name,
    this.description = const Value.absent(),
    required DateTime periodStart,
    required DateTime periodEnd,
    this.status = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.createdByUserId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        cseId = Value(cseId),
        name = Value(name),
        periodStart = Value(periodStart),
        periodEnd = Value(periodEnd),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<AssessmentRecord> custom({
    Expression<String>? id,
    Expression<String>? cseId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<DateTime>? periodStart,
    Expression<DateTime>? periodEnd,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? createdByUserId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cseId != null) 'cse_id': cseId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (periodStart != null) 'period_start': periodStart,
      if (periodEnd != null) 'period_end': periodEnd,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdByUserId != null) 'created_by_user_id': createdByUserId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssessmentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? cseId,
      Value<String>? name,
      Value<String?>? description,
      Value<DateTime>? periodStart,
      Value<DateTime>? periodEnd,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String?>? createdByUserId,
      Value<int>? rowid}) {
    return AssessmentsCompanion(
      id: id ?? this.id,
      cseId: cseId ?? this.cseId,
      name: name ?? this.name,
      description: description ?? this.description,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cseId.present) {
      map['cse_id'] = Variable<String>(cseId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (periodStart.present) {
      map['period_start'] = Variable<DateTime>(periodStart.value);
    }
    if (periodEnd.present) {
      map['period_end'] = Variable<DateTime>(periodEnd.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdByUserId.present) {
      map['created_by_user_id'] = Variable<String>(createdByUserId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssessmentsCompanion(')
          ..write('id: $id, ')
          ..write('cseId: $cseId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('periodStart: $periodStart, ')
          ..write('periodEnd: $periodEnd, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdByUserId: $createdByUserId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DatasetVersionsTable extends DatasetVersions
    with TableInfo<$DatasetVersionsTable, DatasetVersionRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DatasetVersionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cseIdMeta = const VerificationMeta('cseId');
  @override
  late final GeneratedColumn<String> cseId = GeneratedColumn<String>(
      'cse_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES cses (id) ON DELETE RESTRICT'));
  static const VerificationMeta _assessmentIdMeta =
      const VerificationMeta('assessmentId');
  @override
  late final GeneratedColumn<String> assessmentId = GeneratedColumn<String>(
      'assessment_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES assessments (id) ON DELETE SET NULL'));
  static const VerificationMeta _batchIdMeta =
      const VerificationMeta('batchId');
  @override
  late final GeneratedColumn<String> batchId = GeneratedColumn<String>(
      'batch_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _versionTagMeta =
      const VerificationMeta('versionTag');
  @override
  late final GeneratedColumn<String> versionTag = GeneratedColumn<String>(
      'version_tag', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _datasetTypeMeta =
      const VerificationMeta('datasetType');
  @override
  late final GeneratedColumn<String> datasetType = GeneratedColumn<String>(
      'dataset_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceFilenameMeta =
      const VerificationMeta('sourceFilename');
  @override
  late final GeneratedColumn<String> sourceFilename = GeneratedColumn<String>(
      'source_filename', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentHashMeta =
      const VerificationMeta('contentHash');
  @override
  late final GeneratedColumn<String> contentHash = GeneratedColumn<String>(
      'content_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recordCountMeta =
      const VerificationMeta('recordCount');
  @override
  late final GeneratedColumn<int> recordCount = GeneratedColumn<int>(
      'record_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isImmutableMeta =
      const VerificationMeta('isImmutable');
  @override
  late final GeneratedColumn<bool> isImmutable = GeneratedColumn<bool>(
      'is_immutable', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_immutable" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdByUserIdMeta =
      const VerificationMeta('createdByUserId');
  @override
  late final GeneratedColumn<String> createdByUserId = GeneratedColumn<String>(
      'created_by_user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        cseId,
        assessmentId,
        batchId,
        versionTag,
        datasetType,
        sourceFilename,
        contentHash,
        recordCount,
        isImmutable,
        createdAt,
        createdByUserId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dataset_versions';
  @override
  VerificationContext validateIntegrity(
      Insertable<DatasetVersionRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cse_id')) {
      context.handle(
          _cseIdMeta, cseId.isAcceptableOrUnknown(data['cse_id']!, _cseIdMeta));
    } else if (isInserting) {
      context.missing(_cseIdMeta);
    }
    if (data.containsKey('assessment_id')) {
      context.handle(
          _assessmentIdMeta,
          assessmentId.isAcceptableOrUnknown(
              data['assessment_id']!, _assessmentIdMeta));
    }
    if (data.containsKey('batch_id')) {
      context.handle(_batchIdMeta,
          batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta));
    }
    if (data.containsKey('version_tag')) {
      context.handle(
          _versionTagMeta,
          versionTag.isAcceptableOrUnknown(
              data['version_tag']!, _versionTagMeta));
    } else if (isInserting) {
      context.missing(_versionTagMeta);
    }
    if (data.containsKey('dataset_type')) {
      context.handle(
          _datasetTypeMeta,
          datasetType.isAcceptableOrUnknown(
              data['dataset_type']!, _datasetTypeMeta));
    } else if (isInserting) {
      context.missing(_datasetTypeMeta);
    }
    if (data.containsKey('source_filename')) {
      context.handle(
          _sourceFilenameMeta,
          sourceFilename.isAcceptableOrUnknown(
              data['source_filename']!, _sourceFilenameMeta));
    } else if (isInserting) {
      context.missing(_sourceFilenameMeta);
    }
    if (data.containsKey('content_hash')) {
      context.handle(
          _contentHashMeta,
          contentHash.isAcceptableOrUnknown(
              data['content_hash']!, _contentHashMeta));
    } else if (isInserting) {
      context.missing(_contentHashMeta);
    }
    if (data.containsKey('record_count')) {
      context.handle(
          _recordCountMeta,
          recordCount.isAcceptableOrUnknown(
              data['record_count']!, _recordCountMeta));
    }
    if (data.containsKey('is_immutable')) {
      context.handle(
          _isImmutableMeta,
          isImmutable.isAcceptableOrUnknown(
              data['is_immutable']!, _isImmutableMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by_user_id')) {
      context.handle(
          _createdByUserIdMeta,
          createdByUserId.isAcceptableOrUnknown(
              data['created_by_user_id']!, _createdByUserIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DatasetVersionRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DatasetVersionRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      cseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cse_id'])!,
      assessmentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}assessment_id']),
      batchId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}batch_id']),
      versionTag: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}version_tag'])!,
      datasetType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dataset_type'])!,
      sourceFilename: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}source_filename'])!,
      contentHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_hash'])!,
      recordCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}record_count'])!,
      isImmutable: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_immutable'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdByUserId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}created_by_user_id']),
    );
  }

  @override
  $DatasetVersionsTable createAlias(String alias) {
    return $DatasetVersionsTable(attachedDatabase, alias);
  }
}

class DatasetVersionRecord extends DataClass
    implements Insertable<DatasetVersionRecord> {
  final String id;
  final String cseId;
  final String? assessmentId;
  final String? batchId;
  final String versionTag;
  final String datasetType;
  final String sourceFilename;
  final String contentHash;
  final int recordCount;
  final bool isImmutable;
  final DateTime createdAt;
  final String? createdByUserId;
  const DatasetVersionRecord(
      {required this.id,
      required this.cseId,
      this.assessmentId,
      this.batchId,
      required this.versionTag,
      required this.datasetType,
      required this.sourceFilename,
      required this.contentHash,
      required this.recordCount,
      required this.isImmutable,
      required this.createdAt,
      this.createdByUserId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cse_id'] = Variable<String>(cseId);
    if (!nullToAbsent || assessmentId != null) {
      map['assessment_id'] = Variable<String>(assessmentId);
    }
    if (!nullToAbsent || batchId != null) {
      map['batch_id'] = Variable<String>(batchId);
    }
    map['version_tag'] = Variable<String>(versionTag);
    map['dataset_type'] = Variable<String>(datasetType);
    map['source_filename'] = Variable<String>(sourceFilename);
    map['content_hash'] = Variable<String>(contentHash);
    map['record_count'] = Variable<int>(recordCount);
    map['is_immutable'] = Variable<bool>(isImmutable);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || createdByUserId != null) {
      map['created_by_user_id'] = Variable<String>(createdByUserId);
    }
    return map;
  }

  DatasetVersionsCompanion toCompanion(bool nullToAbsent) {
    return DatasetVersionsCompanion(
      id: Value(id),
      cseId: Value(cseId),
      assessmentId: assessmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(assessmentId),
      batchId: batchId == null && nullToAbsent
          ? const Value.absent()
          : Value(batchId),
      versionTag: Value(versionTag),
      datasetType: Value(datasetType),
      sourceFilename: Value(sourceFilename),
      contentHash: Value(contentHash),
      recordCount: Value(recordCount),
      isImmutable: Value(isImmutable),
      createdAt: Value(createdAt),
      createdByUserId: createdByUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(createdByUserId),
    );
  }

  factory DatasetVersionRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DatasetVersionRecord(
      id: serializer.fromJson<String>(json['id']),
      cseId: serializer.fromJson<String>(json['cseId']),
      assessmentId: serializer.fromJson<String?>(json['assessmentId']),
      batchId: serializer.fromJson<String?>(json['batchId']),
      versionTag: serializer.fromJson<String>(json['versionTag']),
      datasetType: serializer.fromJson<String>(json['datasetType']),
      sourceFilename: serializer.fromJson<String>(json['sourceFilename']),
      contentHash: serializer.fromJson<String>(json['contentHash']),
      recordCount: serializer.fromJson<int>(json['recordCount']),
      isImmutable: serializer.fromJson<bool>(json['isImmutable']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdByUserId: serializer.fromJson<String?>(json['createdByUserId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cseId': serializer.toJson<String>(cseId),
      'assessmentId': serializer.toJson<String?>(assessmentId),
      'batchId': serializer.toJson<String?>(batchId),
      'versionTag': serializer.toJson<String>(versionTag),
      'datasetType': serializer.toJson<String>(datasetType),
      'sourceFilename': serializer.toJson<String>(sourceFilename),
      'contentHash': serializer.toJson<String>(contentHash),
      'recordCount': serializer.toJson<int>(recordCount),
      'isImmutable': serializer.toJson<bool>(isImmutable),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdByUserId': serializer.toJson<String?>(createdByUserId),
    };
  }

  DatasetVersionRecord copyWith(
          {String? id,
          String? cseId,
          Value<String?> assessmentId = const Value.absent(),
          Value<String?> batchId = const Value.absent(),
          String? versionTag,
          String? datasetType,
          String? sourceFilename,
          String? contentHash,
          int? recordCount,
          bool? isImmutable,
          DateTime? createdAt,
          Value<String?> createdByUserId = const Value.absent()}) =>
      DatasetVersionRecord(
        id: id ?? this.id,
        cseId: cseId ?? this.cseId,
        assessmentId:
            assessmentId.present ? assessmentId.value : this.assessmentId,
        batchId: batchId.present ? batchId.value : this.batchId,
        versionTag: versionTag ?? this.versionTag,
        datasetType: datasetType ?? this.datasetType,
        sourceFilename: sourceFilename ?? this.sourceFilename,
        contentHash: contentHash ?? this.contentHash,
        recordCount: recordCount ?? this.recordCount,
        isImmutable: isImmutable ?? this.isImmutable,
        createdAt: createdAt ?? this.createdAt,
        createdByUserId: createdByUserId.present
            ? createdByUserId.value
            : this.createdByUserId,
      );
  DatasetVersionRecord copyWithCompanion(DatasetVersionsCompanion data) {
    return DatasetVersionRecord(
      id: data.id.present ? data.id.value : this.id,
      cseId: data.cseId.present ? data.cseId.value : this.cseId,
      assessmentId: data.assessmentId.present
          ? data.assessmentId.value
          : this.assessmentId,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      versionTag:
          data.versionTag.present ? data.versionTag.value : this.versionTag,
      datasetType:
          data.datasetType.present ? data.datasetType.value : this.datasetType,
      sourceFilename: data.sourceFilename.present
          ? data.sourceFilename.value
          : this.sourceFilename,
      contentHash:
          data.contentHash.present ? data.contentHash.value : this.contentHash,
      recordCount:
          data.recordCount.present ? data.recordCount.value : this.recordCount,
      isImmutable:
          data.isImmutable.present ? data.isImmutable.value : this.isImmutable,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdByUserId: data.createdByUserId.present
          ? data.createdByUserId.value
          : this.createdByUserId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DatasetVersionRecord(')
          ..write('id: $id, ')
          ..write('cseId: $cseId, ')
          ..write('assessmentId: $assessmentId, ')
          ..write('batchId: $batchId, ')
          ..write('versionTag: $versionTag, ')
          ..write('datasetType: $datasetType, ')
          ..write('sourceFilename: $sourceFilename, ')
          ..write('contentHash: $contentHash, ')
          ..write('recordCount: $recordCount, ')
          ..write('isImmutable: $isImmutable, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdByUserId: $createdByUserId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      cseId,
      assessmentId,
      batchId,
      versionTag,
      datasetType,
      sourceFilename,
      contentHash,
      recordCount,
      isImmutable,
      createdAt,
      createdByUserId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DatasetVersionRecord &&
          other.id == this.id &&
          other.cseId == this.cseId &&
          other.assessmentId == this.assessmentId &&
          other.batchId == this.batchId &&
          other.versionTag == this.versionTag &&
          other.datasetType == this.datasetType &&
          other.sourceFilename == this.sourceFilename &&
          other.contentHash == this.contentHash &&
          other.recordCount == this.recordCount &&
          other.isImmutable == this.isImmutable &&
          other.createdAt == this.createdAt &&
          other.createdByUserId == this.createdByUserId);
}

class DatasetVersionsCompanion extends UpdateCompanion<DatasetVersionRecord> {
  final Value<String> id;
  final Value<String> cseId;
  final Value<String?> assessmentId;
  final Value<String?> batchId;
  final Value<String> versionTag;
  final Value<String> datasetType;
  final Value<String> sourceFilename;
  final Value<String> contentHash;
  final Value<int> recordCount;
  final Value<bool> isImmutable;
  final Value<DateTime> createdAt;
  final Value<String?> createdByUserId;
  final Value<int> rowid;
  const DatasetVersionsCompanion({
    this.id = const Value.absent(),
    this.cseId = const Value.absent(),
    this.assessmentId = const Value.absent(),
    this.batchId = const Value.absent(),
    this.versionTag = const Value.absent(),
    this.datasetType = const Value.absent(),
    this.sourceFilename = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.recordCount = const Value.absent(),
    this.isImmutable = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdByUserId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DatasetVersionsCompanion.insert({
    required String id,
    required String cseId,
    this.assessmentId = const Value.absent(),
    this.batchId = const Value.absent(),
    required String versionTag,
    required String datasetType,
    required String sourceFilename,
    required String contentHash,
    this.recordCount = const Value.absent(),
    this.isImmutable = const Value.absent(),
    required DateTime createdAt,
    this.createdByUserId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        cseId = Value(cseId),
        versionTag = Value(versionTag),
        datasetType = Value(datasetType),
        sourceFilename = Value(sourceFilename),
        contentHash = Value(contentHash),
        createdAt = Value(createdAt);
  static Insertable<DatasetVersionRecord> custom({
    Expression<String>? id,
    Expression<String>? cseId,
    Expression<String>? assessmentId,
    Expression<String>? batchId,
    Expression<String>? versionTag,
    Expression<String>? datasetType,
    Expression<String>? sourceFilename,
    Expression<String>? contentHash,
    Expression<int>? recordCount,
    Expression<bool>? isImmutable,
    Expression<DateTime>? createdAt,
    Expression<String>? createdByUserId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cseId != null) 'cse_id': cseId,
      if (assessmentId != null) 'assessment_id': assessmentId,
      if (batchId != null) 'batch_id': batchId,
      if (versionTag != null) 'version_tag': versionTag,
      if (datasetType != null) 'dataset_type': datasetType,
      if (sourceFilename != null) 'source_filename': sourceFilename,
      if (contentHash != null) 'content_hash': contentHash,
      if (recordCount != null) 'record_count': recordCount,
      if (isImmutable != null) 'is_immutable': isImmutable,
      if (createdAt != null) 'created_at': createdAt,
      if (createdByUserId != null) 'created_by_user_id': createdByUserId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DatasetVersionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? cseId,
      Value<String?>? assessmentId,
      Value<String?>? batchId,
      Value<String>? versionTag,
      Value<String>? datasetType,
      Value<String>? sourceFilename,
      Value<String>? contentHash,
      Value<int>? recordCount,
      Value<bool>? isImmutable,
      Value<DateTime>? createdAt,
      Value<String?>? createdByUserId,
      Value<int>? rowid}) {
    return DatasetVersionsCompanion(
      id: id ?? this.id,
      cseId: cseId ?? this.cseId,
      assessmentId: assessmentId ?? this.assessmentId,
      batchId: batchId ?? this.batchId,
      versionTag: versionTag ?? this.versionTag,
      datasetType: datasetType ?? this.datasetType,
      sourceFilename: sourceFilename ?? this.sourceFilename,
      contentHash: contentHash ?? this.contentHash,
      recordCount: recordCount ?? this.recordCount,
      isImmutable: isImmutable ?? this.isImmutable,
      createdAt: createdAt ?? this.createdAt,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cseId.present) {
      map['cse_id'] = Variable<String>(cseId.value);
    }
    if (assessmentId.present) {
      map['assessment_id'] = Variable<String>(assessmentId.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<String>(batchId.value);
    }
    if (versionTag.present) {
      map['version_tag'] = Variable<String>(versionTag.value);
    }
    if (datasetType.present) {
      map['dataset_type'] = Variable<String>(datasetType.value);
    }
    if (sourceFilename.present) {
      map['source_filename'] = Variable<String>(sourceFilename.value);
    }
    if (contentHash.present) {
      map['content_hash'] = Variable<String>(contentHash.value);
    }
    if (recordCount.present) {
      map['record_count'] = Variable<int>(recordCount.value);
    }
    if (isImmutable.present) {
      map['is_immutable'] = Variable<bool>(isImmutable.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdByUserId.present) {
      map['created_by_user_id'] = Variable<String>(createdByUserId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DatasetVersionsCompanion(')
          ..write('id: $id, ')
          ..write('cseId: $cseId, ')
          ..write('assessmentId: $assessmentId, ')
          ..write('batchId: $batchId, ')
          ..write('versionTag: $versionTag, ')
          ..write('datasetType: $datasetType, ')
          ..write('sourceFilename: $sourceFilename, ')
          ..write('contentHash: $contentHash, ')
          ..write('recordCount: $recordCount, ')
          ..write('isImmutable: $isImmutable, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdByUserId: $createdByUserId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnalysisRunsTable extends AnalysisRuns
    with TableInfo<$AnalysisRunsTable, AnalysisRunRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnalysisRunsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cseIdMeta = const VerificationMeta('cseId');
  @override
  late final GeneratedColumn<String> cseId = GeneratedColumn<String>(
      'cse_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES cses (id) ON DELETE RESTRICT'));
  static const VerificationMeta _assessmentIdMeta =
      const VerificationMeta('assessmentId');
  @override
  late final GeneratedColumn<String> assessmentId = GeneratedColumn<String>(
      'assessment_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES assessments (id) ON DELETE SET NULL'));
  static const VerificationMeta _datasetVersionIdMeta =
      const VerificationMeta('datasetVersionId');
  @override
  late final GeneratedColumn<String> datasetVersionId = GeneratedColumn<String>(
      'dataset_version_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES dataset_versions (id) ON DELETE SET NULL'));
  static const VerificationMeta _obsStartMeta =
      const VerificationMeta('obsStart');
  @override
  late final GeneratedColumn<DateTime> obsStart = GeneratedColumn<DateTime>(
      'obs_start', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _obsEndMeta = const VerificationMeta('obsEnd');
  @override
  late final GeneratedColumn<DateTime> obsEnd = GeneratedColumn<DateTime>(
      'obs_end', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _engineVersionMeta =
      const VerificationMeta('engineVersion');
  @override
  late final GeneratedColumn<String> engineVersion = GeneratedColumn<String>(
      'engine_version', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('v2.0.0-phase5-canonical'));
  static const VerificationMeta _rulesEvaluatedMeta =
      const VerificationMeta('rulesEvaluated');
  @override
  late final GeneratedColumn<String> rulesEvaluated = GeneratedColumn<String>(
      'rules_evaluated', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('PENDING'));
  static const VerificationMeta _findingsCreatedMeta =
      const VerificationMeta('findingsCreated');
  @override
  late final GeneratedColumn<int> findingsCreated = GeneratedColumn<int>(
      'findings_created', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _baselinesPersistedMeta =
      const VerificationMeta('baselinesPersisted');
  @override
  late final GeneratedColumn<int> baselinesPersisted = GeneratedColumn<int>(
      'baselines_persisted', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _errorMessageMeta =
      const VerificationMeta('errorMessage');
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
      'error_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _executedByUserIdMeta =
      const VerificationMeta('executedByUserId');
  @override
  late final GeneratedColumn<String> executedByUserId = GeneratedColumn<String>(
      'executed_by_user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        cseId,
        assessmentId,
        datasetVersionId,
        obsStart,
        obsEnd,
        engineVersion,
        rulesEvaluated,
        status,
        findingsCreated,
        baselinesPersisted,
        errorMessage,
        startedAt,
        completedAt,
        executedByUserId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'analysis_runs';
  @override
  VerificationContext validateIntegrity(Insertable<AnalysisRunRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cse_id')) {
      context.handle(
          _cseIdMeta, cseId.isAcceptableOrUnknown(data['cse_id']!, _cseIdMeta));
    } else if (isInserting) {
      context.missing(_cseIdMeta);
    }
    if (data.containsKey('assessment_id')) {
      context.handle(
          _assessmentIdMeta,
          assessmentId.isAcceptableOrUnknown(
              data['assessment_id']!, _assessmentIdMeta));
    }
    if (data.containsKey('dataset_version_id')) {
      context.handle(
          _datasetVersionIdMeta,
          datasetVersionId.isAcceptableOrUnknown(
              data['dataset_version_id']!, _datasetVersionIdMeta));
    }
    if (data.containsKey('obs_start')) {
      context.handle(_obsStartMeta,
          obsStart.isAcceptableOrUnknown(data['obs_start']!, _obsStartMeta));
    }
    if (data.containsKey('obs_end')) {
      context.handle(_obsEndMeta,
          obsEnd.isAcceptableOrUnknown(data['obs_end']!, _obsEndMeta));
    }
    if (data.containsKey('engine_version')) {
      context.handle(
          _engineVersionMeta,
          engineVersion.isAcceptableOrUnknown(
              data['engine_version']!, _engineVersionMeta));
    }
    if (data.containsKey('rules_evaluated')) {
      context.handle(
          _rulesEvaluatedMeta,
          rulesEvaluated.isAcceptableOrUnknown(
              data['rules_evaluated']!, _rulesEvaluatedMeta));
    } else if (isInserting) {
      context.missing(_rulesEvaluatedMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('findings_created')) {
      context.handle(
          _findingsCreatedMeta,
          findingsCreated.isAcceptableOrUnknown(
              data['findings_created']!, _findingsCreatedMeta));
    }
    if (data.containsKey('baselines_persisted')) {
      context.handle(
          _baselinesPersistedMeta,
          baselinesPersisted.isAcceptableOrUnknown(
              data['baselines_persisted']!, _baselinesPersistedMeta));
    }
    if (data.containsKey('error_message')) {
      context.handle(
          _errorMessageMeta,
          errorMessage.isAcceptableOrUnknown(
              data['error_message']!, _errorMessageMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('executed_by_user_id')) {
      context.handle(
          _executedByUserIdMeta,
          executedByUserId.isAcceptableOrUnknown(
              data['executed_by_user_id']!, _executedByUserIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnalysisRunRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnalysisRunRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      cseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cse_id'])!,
      assessmentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}assessment_id']),
      datasetVersionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}dataset_version_id']),
      obsStart: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}obs_start']),
      obsEnd: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}obs_end']),
      engineVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}engine_version'])!,
      rulesEvaluated: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}rules_evaluated'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      findingsCreated: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}findings_created'])!,
      baselinesPersisted: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}baselines_persisted'])!,
      errorMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error_message']),
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      executedByUserId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}executed_by_user_id']),
    );
  }

  @override
  $AnalysisRunsTable createAlias(String alias) {
    return $AnalysisRunsTable(attachedDatabase, alias);
  }
}

class AnalysisRunRecord extends DataClass
    implements Insertable<AnalysisRunRecord> {
  final String id;
  final String cseId;
  final String? assessmentId;
  final String? datasetVersionId;
  final DateTime? obsStart;
  final DateTime? obsEnd;
  final String engineVersion;
  final String rulesEvaluated;
  final String status;
  final int findingsCreated;
  final int baselinesPersisted;
  final String? errorMessage;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String? executedByUserId;
  const AnalysisRunRecord(
      {required this.id,
      required this.cseId,
      this.assessmentId,
      this.datasetVersionId,
      this.obsStart,
      this.obsEnd,
      required this.engineVersion,
      required this.rulesEvaluated,
      required this.status,
      required this.findingsCreated,
      required this.baselinesPersisted,
      this.errorMessage,
      required this.startedAt,
      this.completedAt,
      this.executedByUserId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cse_id'] = Variable<String>(cseId);
    if (!nullToAbsent || assessmentId != null) {
      map['assessment_id'] = Variable<String>(assessmentId);
    }
    if (!nullToAbsent || datasetVersionId != null) {
      map['dataset_version_id'] = Variable<String>(datasetVersionId);
    }
    if (!nullToAbsent || obsStart != null) {
      map['obs_start'] = Variable<DateTime>(obsStart);
    }
    if (!nullToAbsent || obsEnd != null) {
      map['obs_end'] = Variable<DateTime>(obsEnd);
    }
    map['engine_version'] = Variable<String>(engineVersion);
    map['rules_evaluated'] = Variable<String>(rulesEvaluated);
    map['status'] = Variable<String>(status);
    map['findings_created'] = Variable<int>(findingsCreated);
    map['baselines_persisted'] = Variable<int>(baselinesPersisted);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || executedByUserId != null) {
      map['executed_by_user_id'] = Variable<String>(executedByUserId);
    }
    return map;
  }

  AnalysisRunsCompanion toCompanion(bool nullToAbsent) {
    return AnalysisRunsCompanion(
      id: Value(id),
      cseId: Value(cseId),
      assessmentId: assessmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(assessmentId),
      datasetVersionId: datasetVersionId == null && nullToAbsent
          ? const Value.absent()
          : Value(datasetVersionId),
      obsStart: obsStart == null && nullToAbsent
          ? const Value.absent()
          : Value(obsStart),
      obsEnd:
          obsEnd == null && nullToAbsent ? const Value.absent() : Value(obsEnd),
      engineVersion: Value(engineVersion),
      rulesEvaluated: Value(rulesEvaluated),
      status: Value(status),
      findingsCreated: Value(findingsCreated),
      baselinesPersisted: Value(baselinesPersisted),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      executedByUserId: executedByUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(executedByUserId),
    );
  }

  factory AnalysisRunRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnalysisRunRecord(
      id: serializer.fromJson<String>(json['id']),
      cseId: serializer.fromJson<String>(json['cseId']),
      assessmentId: serializer.fromJson<String?>(json['assessmentId']),
      datasetVersionId: serializer.fromJson<String?>(json['datasetVersionId']),
      obsStart: serializer.fromJson<DateTime?>(json['obsStart']),
      obsEnd: serializer.fromJson<DateTime?>(json['obsEnd']),
      engineVersion: serializer.fromJson<String>(json['engineVersion']),
      rulesEvaluated: serializer.fromJson<String>(json['rulesEvaluated']),
      status: serializer.fromJson<String>(json['status']),
      findingsCreated: serializer.fromJson<int>(json['findingsCreated']),
      baselinesPersisted: serializer.fromJson<int>(json['baselinesPersisted']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      executedByUserId: serializer.fromJson<String?>(json['executedByUserId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cseId': serializer.toJson<String>(cseId),
      'assessmentId': serializer.toJson<String?>(assessmentId),
      'datasetVersionId': serializer.toJson<String?>(datasetVersionId),
      'obsStart': serializer.toJson<DateTime?>(obsStart),
      'obsEnd': serializer.toJson<DateTime?>(obsEnd),
      'engineVersion': serializer.toJson<String>(engineVersion),
      'rulesEvaluated': serializer.toJson<String>(rulesEvaluated),
      'status': serializer.toJson<String>(status),
      'findingsCreated': serializer.toJson<int>(findingsCreated),
      'baselinesPersisted': serializer.toJson<int>(baselinesPersisted),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'executedByUserId': serializer.toJson<String?>(executedByUserId),
    };
  }

  AnalysisRunRecord copyWith(
          {String? id,
          String? cseId,
          Value<String?> assessmentId = const Value.absent(),
          Value<String?> datasetVersionId = const Value.absent(),
          Value<DateTime?> obsStart = const Value.absent(),
          Value<DateTime?> obsEnd = const Value.absent(),
          String? engineVersion,
          String? rulesEvaluated,
          String? status,
          int? findingsCreated,
          int? baselinesPersisted,
          Value<String?> errorMessage = const Value.absent(),
          DateTime? startedAt,
          Value<DateTime?> completedAt = const Value.absent(),
          Value<String?> executedByUserId = const Value.absent()}) =>
      AnalysisRunRecord(
        id: id ?? this.id,
        cseId: cseId ?? this.cseId,
        assessmentId:
            assessmentId.present ? assessmentId.value : this.assessmentId,
        datasetVersionId: datasetVersionId.present
            ? datasetVersionId.value
            : this.datasetVersionId,
        obsStart: obsStart.present ? obsStart.value : this.obsStart,
        obsEnd: obsEnd.present ? obsEnd.value : this.obsEnd,
        engineVersion: engineVersion ?? this.engineVersion,
        rulesEvaluated: rulesEvaluated ?? this.rulesEvaluated,
        status: status ?? this.status,
        findingsCreated: findingsCreated ?? this.findingsCreated,
        baselinesPersisted: baselinesPersisted ?? this.baselinesPersisted,
        errorMessage:
            errorMessage.present ? errorMessage.value : this.errorMessage,
        startedAt: startedAt ?? this.startedAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        executedByUserId: executedByUserId.present
            ? executedByUserId.value
            : this.executedByUserId,
      );
  AnalysisRunRecord copyWithCompanion(AnalysisRunsCompanion data) {
    return AnalysisRunRecord(
      id: data.id.present ? data.id.value : this.id,
      cseId: data.cseId.present ? data.cseId.value : this.cseId,
      assessmentId: data.assessmentId.present
          ? data.assessmentId.value
          : this.assessmentId,
      datasetVersionId: data.datasetVersionId.present
          ? data.datasetVersionId.value
          : this.datasetVersionId,
      obsStart: data.obsStart.present ? data.obsStart.value : this.obsStart,
      obsEnd: data.obsEnd.present ? data.obsEnd.value : this.obsEnd,
      engineVersion: data.engineVersion.present
          ? data.engineVersion.value
          : this.engineVersion,
      rulesEvaluated: data.rulesEvaluated.present
          ? data.rulesEvaluated.value
          : this.rulesEvaluated,
      status: data.status.present ? data.status.value : this.status,
      findingsCreated: data.findingsCreated.present
          ? data.findingsCreated.value
          : this.findingsCreated,
      baselinesPersisted: data.baselinesPersisted.present
          ? data.baselinesPersisted.value
          : this.baselinesPersisted,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      executedByUserId: data.executedByUserId.present
          ? data.executedByUserId.value
          : this.executedByUserId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisRunRecord(')
          ..write('id: $id, ')
          ..write('cseId: $cseId, ')
          ..write('assessmentId: $assessmentId, ')
          ..write('datasetVersionId: $datasetVersionId, ')
          ..write('obsStart: $obsStart, ')
          ..write('obsEnd: $obsEnd, ')
          ..write('engineVersion: $engineVersion, ')
          ..write('rulesEvaluated: $rulesEvaluated, ')
          ..write('status: $status, ')
          ..write('findingsCreated: $findingsCreated, ')
          ..write('baselinesPersisted: $baselinesPersisted, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('executedByUserId: $executedByUserId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      cseId,
      assessmentId,
      datasetVersionId,
      obsStart,
      obsEnd,
      engineVersion,
      rulesEvaluated,
      status,
      findingsCreated,
      baselinesPersisted,
      errorMessage,
      startedAt,
      completedAt,
      executedByUserId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnalysisRunRecord &&
          other.id == this.id &&
          other.cseId == this.cseId &&
          other.assessmentId == this.assessmentId &&
          other.datasetVersionId == this.datasetVersionId &&
          other.obsStart == this.obsStart &&
          other.obsEnd == this.obsEnd &&
          other.engineVersion == this.engineVersion &&
          other.rulesEvaluated == this.rulesEvaluated &&
          other.status == this.status &&
          other.findingsCreated == this.findingsCreated &&
          other.baselinesPersisted == this.baselinesPersisted &&
          other.errorMessage == this.errorMessage &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.executedByUserId == this.executedByUserId);
}

class AnalysisRunsCompanion extends UpdateCompanion<AnalysisRunRecord> {
  final Value<String> id;
  final Value<String> cseId;
  final Value<String?> assessmentId;
  final Value<String?> datasetVersionId;
  final Value<DateTime?> obsStart;
  final Value<DateTime?> obsEnd;
  final Value<String> engineVersion;
  final Value<String> rulesEvaluated;
  final Value<String> status;
  final Value<int> findingsCreated;
  final Value<int> baselinesPersisted;
  final Value<String?> errorMessage;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<String?> executedByUserId;
  final Value<int> rowid;
  const AnalysisRunsCompanion({
    this.id = const Value.absent(),
    this.cseId = const Value.absent(),
    this.assessmentId = const Value.absent(),
    this.datasetVersionId = const Value.absent(),
    this.obsStart = const Value.absent(),
    this.obsEnd = const Value.absent(),
    this.engineVersion = const Value.absent(),
    this.rulesEvaluated = const Value.absent(),
    this.status = const Value.absent(),
    this.findingsCreated = const Value.absent(),
    this.baselinesPersisted = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.executedByUserId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnalysisRunsCompanion.insert({
    required String id,
    required String cseId,
    this.assessmentId = const Value.absent(),
    this.datasetVersionId = const Value.absent(),
    this.obsStart = const Value.absent(),
    this.obsEnd = const Value.absent(),
    this.engineVersion = const Value.absent(),
    required String rulesEvaluated,
    this.status = const Value.absent(),
    this.findingsCreated = const Value.absent(),
    this.baselinesPersisted = const Value.absent(),
    this.errorMessage = const Value.absent(),
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    this.executedByUserId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        cseId = Value(cseId),
        rulesEvaluated = Value(rulesEvaluated),
        startedAt = Value(startedAt);
  static Insertable<AnalysisRunRecord> custom({
    Expression<String>? id,
    Expression<String>? cseId,
    Expression<String>? assessmentId,
    Expression<String>? datasetVersionId,
    Expression<DateTime>? obsStart,
    Expression<DateTime>? obsEnd,
    Expression<String>? engineVersion,
    Expression<String>? rulesEvaluated,
    Expression<String>? status,
    Expression<int>? findingsCreated,
    Expression<int>? baselinesPersisted,
    Expression<String>? errorMessage,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<String>? executedByUserId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cseId != null) 'cse_id': cseId,
      if (assessmentId != null) 'assessment_id': assessmentId,
      if (datasetVersionId != null) 'dataset_version_id': datasetVersionId,
      if (obsStart != null) 'obs_start': obsStart,
      if (obsEnd != null) 'obs_end': obsEnd,
      if (engineVersion != null) 'engine_version': engineVersion,
      if (rulesEvaluated != null) 'rules_evaluated': rulesEvaluated,
      if (status != null) 'status': status,
      if (findingsCreated != null) 'findings_created': findingsCreated,
      if (baselinesPersisted != null) 'baselines_persisted': baselinesPersisted,
      if (errorMessage != null) 'error_message': errorMessage,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (executedByUserId != null) 'executed_by_user_id': executedByUserId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnalysisRunsCompanion copyWith(
      {Value<String>? id,
      Value<String>? cseId,
      Value<String?>? assessmentId,
      Value<String?>? datasetVersionId,
      Value<DateTime?>? obsStart,
      Value<DateTime?>? obsEnd,
      Value<String>? engineVersion,
      Value<String>? rulesEvaluated,
      Value<String>? status,
      Value<int>? findingsCreated,
      Value<int>? baselinesPersisted,
      Value<String?>? errorMessage,
      Value<DateTime>? startedAt,
      Value<DateTime?>? completedAt,
      Value<String?>? executedByUserId,
      Value<int>? rowid}) {
    return AnalysisRunsCompanion(
      id: id ?? this.id,
      cseId: cseId ?? this.cseId,
      assessmentId: assessmentId ?? this.assessmentId,
      datasetVersionId: datasetVersionId ?? this.datasetVersionId,
      obsStart: obsStart ?? this.obsStart,
      obsEnd: obsEnd ?? this.obsEnd,
      engineVersion: engineVersion ?? this.engineVersion,
      rulesEvaluated: rulesEvaluated ?? this.rulesEvaluated,
      status: status ?? this.status,
      findingsCreated: findingsCreated ?? this.findingsCreated,
      baselinesPersisted: baselinesPersisted ?? this.baselinesPersisted,
      errorMessage: errorMessage ?? this.errorMessage,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      executedByUserId: executedByUserId ?? this.executedByUserId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cseId.present) {
      map['cse_id'] = Variable<String>(cseId.value);
    }
    if (assessmentId.present) {
      map['assessment_id'] = Variable<String>(assessmentId.value);
    }
    if (datasetVersionId.present) {
      map['dataset_version_id'] = Variable<String>(datasetVersionId.value);
    }
    if (obsStart.present) {
      map['obs_start'] = Variable<DateTime>(obsStart.value);
    }
    if (obsEnd.present) {
      map['obs_end'] = Variable<DateTime>(obsEnd.value);
    }
    if (engineVersion.present) {
      map['engine_version'] = Variable<String>(engineVersion.value);
    }
    if (rulesEvaluated.present) {
      map['rules_evaluated'] = Variable<String>(rulesEvaluated.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (findingsCreated.present) {
      map['findings_created'] = Variable<int>(findingsCreated.value);
    }
    if (baselinesPersisted.present) {
      map['baselines_persisted'] = Variable<int>(baselinesPersisted.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (executedByUserId.present) {
      map['executed_by_user_id'] = Variable<String>(executedByUserId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisRunsCompanion(')
          ..write('id: $id, ')
          ..write('cseId: $cseId, ')
          ..write('assessmentId: $assessmentId, ')
          ..write('datasetVersionId: $datasetVersionId, ')
          ..write('obsStart: $obsStart, ')
          ..write('obsEnd: $obsEnd, ')
          ..write('engineVersion: $engineVersion, ')
          ..write('rulesEvaluated: $rulesEvaluated, ')
          ..write('status: $status, ')
          ..write('findingsCreated: $findingsCreated, ')
          ..write('baselinesPersisted: $baselinesPersisted, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('executedByUserId: $executedByUserId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FindingsTable extends Findings
    with TableInfo<$FindingsTable, FindingRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FindingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _findingCodeMeta =
      const VerificationMeta('findingCode');
  @override
  late final GeneratedColumn<String> findingCode = GeneratedColumn<String>(
      'finding_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cseIdMeta = const VerificationMeta('cseId');
  @override
  late final GeneratedColumn<String> cseId = GeneratedColumn<String>(
      'cse_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES cses (id) ON DELETE RESTRICT'));
  static const VerificationMeta _batchIdMeta =
      const VerificationMeta('batchId');
  @override
  late final GeneratedColumn<String> batchId = GeneratedColumn<String>(
      'batch_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _analysisRunIdMeta =
      const VerificationMeta('analysisRunId');
  @override
  late final GeneratedColumn<String> analysisRunId = GeneratedColumn<String>(
      'analysis_run_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES analysis_runs (id) ON DELETE SET NULL'));
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _severityMeta =
      const VerificationMeta('severity');
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
      'severity', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rationaleMeta =
      const VerificationMeta('rationale');
  @override
  late final GeneratedColumn<String> rationale = GeneratedColumn<String>(
      'rationale', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _detectionMethodMeta =
      const VerificationMeta('detectionMethod');
  @override
  late final GeneratedColumn<String> detectionMethod = GeneratedColumn<String>(
      'detection_method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _metricsJsonMeta =
      const VerificationMeta('metricsJson');
  @override
  late final GeneratedColumn<String> metricsJson = GeneratedColumn<String>(
      'metrics_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('NEW'));
  static const VerificationMeta _detectedAtMeta =
      const VerificationMeta('detectedAt');
  @override
  late final GeneratedColumn<DateTime> detectedAt = GeneratedColumn<DateTime>(
      'detected_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        findingCode,
        cseId,
        batchId,
        analysisRunId,
        category,
        severity,
        title,
        description,
        rationale,
        detectionMethod,
        metricsJson,
        status,
        detectedAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'findings';
  @override
  VerificationContext validateIntegrity(Insertable<FindingRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('finding_code')) {
      context.handle(
          _findingCodeMeta,
          findingCode.isAcceptableOrUnknown(
              data['finding_code']!, _findingCodeMeta));
    } else if (isInserting) {
      context.missing(_findingCodeMeta);
    }
    if (data.containsKey('cse_id')) {
      context.handle(
          _cseIdMeta, cseId.isAcceptableOrUnknown(data['cse_id']!, _cseIdMeta));
    } else if (isInserting) {
      context.missing(_cseIdMeta);
    }
    if (data.containsKey('batch_id')) {
      context.handle(_batchIdMeta,
          batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta));
    }
    if (data.containsKey('analysis_run_id')) {
      context.handle(
          _analysisRunIdMeta,
          analysisRunId.isAcceptableOrUnknown(
              data['analysis_run_id']!, _analysisRunIdMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(_severityMeta,
          severity.isAcceptableOrUnknown(data['severity']!, _severityMeta));
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('rationale')) {
      context.handle(_rationaleMeta,
          rationale.isAcceptableOrUnknown(data['rationale']!, _rationaleMeta));
    } else if (isInserting) {
      context.missing(_rationaleMeta);
    }
    if (data.containsKey('detection_method')) {
      context.handle(
          _detectionMethodMeta,
          detectionMethod.isAcceptableOrUnknown(
              data['detection_method']!, _detectionMethodMeta));
    } else if (isInserting) {
      context.missing(_detectionMethodMeta);
    }
    if (data.containsKey('metrics_json')) {
      context.handle(
          _metricsJsonMeta,
          metricsJson.isAcceptableOrUnknown(
              data['metrics_json']!, _metricsJsonMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('detected_at')) {
      context.handle(
          _detectedAtMeta,
          detectedAt.isAcceptableOrUnknown(
              data['detected_at']!, _detectedAtMeta));
    } else if (isInserting) {
      context.missing(_detectedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {findingCode},
      ];
  @override
  FindingRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FindingRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      findingCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}finding_code'])!,
      cseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cse_id'])!,
      batchId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}batch_id']),
      analysisRunId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}analysis_run_id']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      severity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}severity'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      rationale: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rationale'])!,
      detectionMethod: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}detection_method'])!,
      metricsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metrics_json']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      detectedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}detected_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $FindingsTable createAlias(String alias) {
    return $FindingsTable(attachedDatabase, alias);
  }
}

class FindingRecord extends DataClass implements Insertable<FindingRecord> {
  final String id;
  final String findingCode;
  final String cseId;
  final String? batchId;
  final String? analysisRunId;
  final String category;
  final String severity;
  final String title;
  final String description;
  final String rationale;
  final String detectionMethod;
  final String? metricsJson;
  final String status;
  final DateTime detectedAt;
  final DateTime updatedAt;
  const FindingRecord(
      {required this.id,
      required this.findingCode,
      required this.cseId,
      this.batchId,
      this.analysisRunId,
      required this.category,
      required this.severity,
      required this.title,
      required this.description,
      required this.rationale,
      required this.detectionMethod,
      this.metricsJson,
      required this.status,
      required this.detectedAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['finding_code'] = Variable<String>(findingCode);
    map['cse_id'] = Variable<String>(cseId);
    if (!nullToAbsent || batchId != null) {
      map['batch_id'] = Variable<String>(batchId);
    }
    if (!nullToAbsent || analysisRunId != null) {
      map['analysis_run_id'] = Variable<String>(analysisRunId);
    }
    map['category'] = Variable<String>(category);
    map['severity'] = Variable<String>(severity);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['rationale'] = Variable<String>(rationale);
    map['detection_method'] = Variable<String>(detectionMethod);
    if (!nullToAbsent || metricsJson != null) {
      map['metrics_json'] = Variable<String>(metricsJson);
    }
    map['status'] = Variable<String>(status);
    map['detected_at'] = Variable<DateTime>(detectedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FindingsCompanion toCompanion(bool nullToAbsent) {
    return FindingsCompanion(
      id: Value(id),
      findingCode: Value(findingCode),
      cseId: Value(cseId),
      batchId: batchId == null && nullToAbsent
          ? const Value.absent()
          : Value(batchId),
      analysisRunId: analysisRunId == null && nullToAbsent
          ? const Value.absent()
          : Value(analysisRunId),
      category: Value(category),
      severity: Value(severity),
      title: Value(title),
      description: Value(description),
      rationale: Value(rationale),
      detectionMethod: Value(detectionMethod),
      metricsJson: metricsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(metricsJson),
      status: Value(status),
      detectedAt: Value(detectedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FindingRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FindingRecord(
      id: serializer.fromJson<String>(json['id']),
      findingCode: serializer.fromJson<String>(json['findingCode']),
      cseId: serializer.fromJson<String>(json['cseId']),
      batchId: serializer.fromJson<String?>(json['batchId']),
      analysisRunId: serializer.fromJson<String?>(json['analysisRunId']),
      category: serializer.fromJson<String>(json['category']),
      severity: serializer.fromJson<String>(json['severity']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      rationale: serializer.fromJson<String>(json['rationale']),
      detectionMethod: serializer.fromJson<String>(json['detectionMethod']),
      metricsJson: serializer.fromJson<String?>(json['metricsJson']),
      status: serializer.fromJson<String>(json['status']),
      detectedAt: serializer.fromJson<DateTime>(json['detectedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'findingCode': serializer.toJson<String>(findingCode),
      'cseId': serializer.toJson<String>(cseId),
      'batchId': serializer.toJson<String?>(batchId),
      'analysisRunId': serializer.toJson<String?>(analysisRunId),
      'category': serializer.toJson<String>(category),
      'severity': serializer.toJson<String>(severity),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'rationale': serializer.toJson<String>(rationale),
      'detectionMethod': serializer.toJson<String>(detectionMethod),
      'metricsJson': serializer.toJson<String?>(metricsJson),
      'status': serializer.toJson<String>(status),
      'detectedAt': serializer.toJson<DateTime>(detectedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FindingRecord copyWith(
          {String? id,
          String? findingCode,
          String? cseId,
          Value<String?> batchId = const Value.absent(),
          Value<String?> analysisRunId = const Value.absent(),
          String? category,
          String? severity,
          String? title,
          String? description,
          String? rationale,
          String? detectionMethod,
          Value<String?> metricsJson = const Value.absent(),
          String? status,
          DateTime? detectedAt,
          DateTime? updatedAt}) =>
      FindingRecord(
        id: id ?? this.id,
        findingCode: findingCode ?? this.findingCode,
        cseId: cseId ?? this.cseId,
        batchId: batchId.present ? batchId.value : this.batchId,
        analysisRunId:
            analysisRunId.present ? analysisRunId.value : this.analysisRunId,
        category: category ?? this.category,
        severity: severity ?? this.severity,
        title: title ?? this.title,
        description: description ?? this.description,
        rationale: rationale ?? this.rationale,
        detectionMethod: detectionMethod ?? this.detectionMethod,
        metricsJson: metricsJson.present ? metricsJson.value : this.metricsJson,
        status: status ?? this.status,
        detectedAt: detectedAt ?? this.detectedAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  FindingRecord copyWithCompanion(FindingsCompanion data) {
    return FindingRecord(
      id: data.id.present ? data.id.value : this.id,
      findingCode:
          data.findingCode.present ? data.findingCode.value : this.findingCode,
      cseId: data.cseId.present ? data.cseId.value : this.cseId,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      analysisRunId: data.analysisRunId.present
          ? data.analysisRunId.value
          : this.analysisRunId,
      category: data.category.present ? data.category.value : this.category,
      severity: data.severity.present ? data.severity.value : this.severity,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      rationale: data.rationale.present ? data.rationale.value : this.rationale,
      detectionMethod: data.detectionMethod.present
          ? data.detectionMethod.value
          : this.detectionMethod,
      metricsJson:
          data.metricsJson.present ? data.metricsJson.value : this.metricsJson,
      status: data.status.present ? data.status.value : this.status,
      detectedAt:
          data.detectedAt.present ? data.detectedAt.value : this.detectedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FindingRecord(')
          ..write('id: $id, ')
          ..write('findingCode: $findingCode, ')
          ..write('cseId: $cseId, ')
          ..write('batchId: $batchId, ')
          ..write('analysisRunId: $analysisRunId, ')
          ..write('category: $category, ')
          ..write('severity: $severity, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('rationale: $rationale, ')
          ..write('detectionMethod: $detectionMethod, ')
          ..write('metricsJson: $metricsJson, ')
          ..write('status: $status, ')
          ..write('detectedAt: $detectedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      findingCode,
      cseId,
      batchId,
      analysisRunId,
      category,
      severity,
      title,
      description,
      rationale,
      detectionMethod,
      metricsJson,
      status,
      detectedAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FindingRecord &&
          other.id == this.id &&
          other.findingCode == this.findingCode &&
          other.cseId == this.cseId &&
          other.batchId == this.batchId &&
          other.analysisRunId == this.analysisRunId &&
          other.category == this.category &&
          other.severity == this.severity &&
          other.title == this.title &&
          other.description == this.description &&
          other.rationale == this.rationale &&
          other.detectionMethod == this.detectionMethod &&
          other.metricsJson == this.metricsJson &&
          other.status == this.status &&
          other.detectedAt == this.detectedAt &&
          other.updatedAt == this.updatedAt);
}

class FindingsCompanion extends UpdateCompanion<FindingRecord> {
  final Value<String> id;
  final Value<String> findingCode;
  final Value<String> cseId;
  final Value<String?> batchId;
  final Value<String?> analysisRunId;
  final Value<String> category;
  final Value<String> severity;
  final Value<String> title;
  final Value<String> description;
  final Value<String> rationale;
  final Value<String> detectionMethod;
  final Value<String?> metricsJson;
  final Value<String> status;
  final Value<DateTime> detectedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const FindingsCompanion({
    this.id = const Value.absent(),
    this.findingCode = const Value.absent(),
    this.cseId = const Value.absent(),
    this.batchId = const Value.absent(),
    this.analysisRunId = const Value.absent(),
    this.category = const Value.absent(),
    this.severity = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.rationale = const Value.absent(),
    this.detectionMethod = const Value.absent(),
    this.metricsJson = const Value.absent(),
    this.status = const Value.absent(),
    this.detectedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FindingsCompanion.insert({
    required String id,
    required String findingCode,
    required String cseId,
    this.batchId = const Value.absent(),
    this.analysisRunId = const Value.absent(),
    required String category,
    required String severity,
    required String title,
    required String description,
    required String rationale,
    required String detectionMethod,
    this.metricsJson = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime detectedAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        findingCode = Value(findingCode),
        cseId = Value(cseId),
        category = Value(category),
        severity = Value(severity),
        title = Value(title),
        description = Value(description),
        rationale = Value(rationale),
        detectionMethod = Value(detectionMethod),
        detectedAt = Value(detectedAt),
        updatedAt = Value(updatedAt);
  static Insertable<FindingRecord> custom({
    Expression<String>? id,
    Expression<String>? findingCode,
    Expression<String>? cseId,
    Expression<String>? batchId,
    Expression<String>? analysisRunId,
    Expression<String>? category,
    Expression<String>? severity,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? rationale,
    Expression<String>? detectionMethod,
    Expression<String>? metricsJson,
    Expression<String>? status,
    Expression<DateTime>? detectedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (findingCode != null) 'finding_code': findingCode,
      if (cseId != null) 'cse_id': cseId,
      if (batchId != null) 'batch_id': batchId,
      if (analysisRunId != null) 'analysis_run_id': analysisRunId,
      if (category != null) 'category': category,
      if (severity != null) 'severity': severity,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (rationale != null) 'rationale': rationale,
      if (detectionMethod != null) 'detection_method': detectionMethod,
      if (metricsJson != null) 'metrics_json': metricsJson,
      if (status != null) 'status': status,
      if (detectedAt != null) 'detected_at': detectedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FindingsCompanion copyWith(
      {Value<String>? id,
      Value<String>? findingCode,
      Value<String>? cseId,
      Value<String?>? batchId,
      Value<String?>? analysisRunId,
      Value<String>? category,
      Value<String>? severity,
      Value<String>? title,
      Value<String>? description,
      Value<String>? rationale,
      Value<String>? detectionMethod,
      Value<String?>? metricsJson,
      Value<String>? status,
      Value<DateTime>? detectedAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return FindingsCompanion(
      id: id ?? this.id,
      findingCode: findingCode ?? this.findingCode,
      cseId: cseId ?? this.cseId,
      batchId: batchId ?? this.batchId,
      analysisRunId: analysisRunId ?? this.analysisRunId,
      category: category ?? this.category,
      severity: severity ?? this.severity,
      title: title ?? this.title,
      description: description ?? this.description,
      rationale: rationale ?? this.rationale,
      detectionMethod: detectionMethod ?? this.detectionMethod,
      metricsJson: metricsJson ?? this.metricsJson,
      status: status ?? this.status,
      detectedAt: detectedAt ?? this.detectedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (findingCode.present) {
      map['finding_code'] = Variable<String>(findingCode.value);
    }
    if (cseId.present) {
      map['cse_id'] = Variable<String>(cseId.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<String>(batchId.value);
    }
    if (analysisRunId.present) {
      map['analysis_run_id'] = Variable<String>(analysisRunId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rationale.present) {
      map['rationale'] = Variable<String>(rationale.value);
    }
    if (detectionMethod.present) {
      map['detection_method'] = Variable<String>(detectionMethod.value);
    }
    if (metricsJson.present) {
      map['metrics_json'] = Variable<String>(metricsJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (detectedAt.present) {
      map['detected_at'] = Variable<DateTime>(detectedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FindingsCompanion(')
          ..write('id: $id, ')
          ..write('findingCode: $findingCode, ')
          ..write('cseId: $cseId, ')
          ..write('batchId: $batchId, ')
          ..write('analysisRunId: $analysisRunId, ')
          ..write('category: $category, ')
          ..write('severity: $severity, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('rationale: $rationale, ')
          ..write('detectionMethod: $detectionMethod, ')
          ..write('metricsJson: $metricsJson, ')
          ..write('status: $status, ')
          ..write('detectedAt: $detectedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssetsTable extends Assets with TableInfo<$AssetsTable, AssetRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cseIdMeta = const VerificationMeta('cseId');
  @override
  late final GeneratedColumn<String> cseId = GeneratedColumn<String>(
      'cse_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES cses (id) ON DELETE CASCADE'));
  static const VerificationMeta _assetIdentifierMeta =
      const VerificationMeta('assetIdentifier');
  @override
  late final GeneratedColumn<String> assetIdentifier = GeneratedColumn<String>(
      'asset_identifier', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _assetTypeMeta =
      const VerificationMeta('assetType');
  @override
  late final GeneratedColumn<String> assetType = GeneratedColumn<String>(
      'asset_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('SERVER'));
  static const VerificationMeta _ipAddressMeta =
      const VerificationMeta('ipAddress');
  @override
  late final GeneratedColumn<String> ipAddress = GeneratedColumn<String>(
      'ip_address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _hostnameMeta =
      const VerificationMeta('hostname');
  @override
  late final GeneratedColumn<String> hostname = GeneratedColumn<String>(
      'hostname', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _criticalityMeta =
      const VerificationMeta('criticality');
  @override
  late final GeneratedColumn<String> criticality = GeneratedColumn<String>(
      'criticality', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('MEDIUM'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        cseId,
        assetIdentifier,
        name,
        assetType,
        ipAddress,
        hostname,
        criticality,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assets';
  @override
  VerificationContext validateIntegrity(Insertable<AssetRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cse_id')) {
      context.handle(
          _cseIdMeta, cseId.isAcceptableOrUnknown(data['cse_id']!, _cseIdMeta));
    } else if (isInserting) {
      context.missing(_cseIdMeta);
    }
    if (data.containsKey('asset_identifier')) {
      context.handle(
          _assetIdentifierMeta,
          assetIdentifier.isAcceptableOrUnknown(
              data['asset_identifier']!, _assetIdentifierMeta));
    } else if (isInserting) {
      context.missing(_assetIdentifierMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('asset_type')) {
      context.handle(_assetTypeMeta,
          assetType.isAcceptableOrUnknown(data['asset_type']!, _assetTypeMeta));
    }
    if (data.containsKey('ip_address')) {
      context.handle(_ipAddressMeta,
          ipAddress.isAcceptableOrUnknown(data['ip_address']!, _ipAddressMeta));
    }
    if (data.containsKey('hostname')) {
      context.handle(_hostnameMeta,
          hostname.isAcceptableOrUnknown(data['hostname']!, _hostnameMeta));
    }
    if (data.containsKey('criticality')) {
      context.handle(
          _criticalityMeta,
          criticality.isAcceptableOrUnknown(
              data['criticality']!, _criticalityMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssetRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      cseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cse_id'])!,
      assetIdentifier: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}asset_identifier'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      assetType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}asset_type'])!,
      ipAddress: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ip_address']),
      hostname: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hostname']),
      criticality: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}criticality'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AssetsTable createAlias(String alias) {
    return $AssetsTable(attachedDatabase, alias);
  }
}

class AssetRecord extends DataClass implements Insertable<AssetRecord> {
  final String id;
  final String cseId;
  final String assetIdentifier;
  final String name;
  final String assetType;
  final String? ipAddress;
  final String? hostname;
  final String criticality;
  final DateTime createdAt;
  const AssetRecord(
      {required this.id,
      required this.cseId,
      required this.assetIdentifier,
      required this.name,
      required this.assetType,
      this.ipAddress,
      this.hostname,
      required this.criticality,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cse_id'] = Variable<String>(cseId);
    map['asset_identifier'] = Variable<String>(assetIdentifier);
    map['name'] = Variable<String>(name);
    map['asset_type'] = Variable<String>(assetType);
    if (!nullToAbsent || ipAddress != null) {
      map['ip_address'] = Variable<String>(ipAddress);
    }
    if (!nullToAbsent || hostname != null) {
      map['hostname'] = Variable<String>(hostname);
    }
    map['criticality'] = Variable<String>(criticality);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AssetsCompanion toCompanion(bool nullToAbsent) {
    return AssetsCompanion(
      id: Value(id),
      cseId: Value(cseId),
      assetIdentifier: Value(assetIdentifier),
      name: Value(name),
      assetType: Value(assetType),
      ipAddress: ipAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(ipAddress),
      hostname: hostname == null && nullToAbsent
          ? const Value.absent()
          : Value(hostname),
      criticality: Value(criticality),
      createdAt: Value(createdAt),
    );
  }

  factory AssetRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetRecord(
      id: serializer.fromJson<String>(json['id']),
      cseId: serializer.fromJson<String>(json['cseId']),
      assetIdentifier: serializer.fromJson<String>(json['assetIdentifier']),
      name: serializer.fromJson<String>(json['name']),
      assetType: serializer.fromJson<String>(json['assetType']),
      ipAddress: serializer.fromJson<String?>(json['ipAddress']),
      hostname: serializer.fromJson<String?>(json['hostname']),
      criticality: serializer.fromJson<String>(json['criticality']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cseId': serializer.toJson<String>(cseId),
      'assetIdentifier': serializer.toJson<String>(assetIdentifier),
      'name': serializer.toJson<String>(name),
      'assetType': serializer.toJson<String>(assetType),
      'ipAddress': serializer.toJson<String?>(ipAddress),
      'hostname': serializer.toJson<String?>(hostname),
      'criticality': serializer.toJson<String>(criticality),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AssetRecord copyWith(
          {String? id,
          String? cseId,
          String? assetIdentifier,
          String? name,
          String? assetType,
          Value<String?> ipAddress = const Value.absent(),
          Value<String?> hostname = const Value.absent(),
          String? criticality,
          DateTime? createdAt}) =>
      AssetRecord(
        id: id ?? this.id,
        cseId: cseId ?? this.cseId,
        assetIdentifier: assetIdentifier ?? this.assetIdentifier,
        name: name ?? this.name,
        assetType: assetType ?? this.assetType,
        ipAddress: ipAddress.present ? ipAddress.value : this.ipAddress,
        hostname: hostname.present ? hostname.value : this.hostname,
        criticality: criticality ?? this.criticality,
        createdAt: createdAt ?? this.createdAt,
      );
  AssetRecord copyWithCompanion(AssetsCompanion data) {
    return AssetRecord(
      id: data.id.present ? data.id.value : this.id,
      cseId: data.cseId.present ? data.cseId.value : this.cseId,
      assetIdentifier: data.assetIdentifier.present
          ? data.assetIdentifier.value
          : this.assetIdentifier,
      name: data.name.present ? data.name.value : this.name,
      assetType: data.assetType.present ? data.assetType.value : this.assetType,
      ipAddress: data.ipAddress.present ? data.ipAddress.value : this.ipAddress,
      hostname: data.hostname.present ? data.hostname.value : this.hostname,
      criticality:
          data.criticality.present ? data.criticality.value : this.criticality,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssetRecord(')
          ..write('id: $id, ')
          ..write('cseId: $cseId, ')
          ..write('assetIdentifier: $assetIdentifier, ')
          ..write('name: $name, ')
          ..write('assetType: $assetType, ')
          ..write('ipAddress: $ipAddress, ')
          ..write('hostname: $hostname, ')
          ..write('criticality: $criticality, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cseId, assetIdentifier, name, assetType,
      ipAddress, hostname, criticality, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetRecord &&
          other.id == this.id &&
          other.cseId == this.cseId &&
          other.assetIdentifier == this.assetIdentifier &&
          other.name == this.name &&
          other.assetType == this.assetType &&
          other.ipAddress == this.ipAddress &&
          other.hostname == this.hostname &&
          other.criticality == this.criticality &&
          other.createdAt == this.createdAt);
}

class AssetsCompanion extends UpdateCompanion<AssetRecord> {
  final Value<String> id;
  final Value<String> cseId;
  final Value<String> assetIdentifier;
  final Value<String> name;
  final Value<String> assetType;
  final Value<String?> ipAddress;
  final Value<String?> hostname;
  final Value<String> criticality;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AssetsCompanion({
    this.id = const Value.absent(),
    this.cseId = const Value.absent(),
    this.assetIdentifier = const Value.absent(),
    this.name = const Value.absent(),
    this.assetType = const Value.absent(),
    this.ipAddress = const Value.absent(),
    this.hostname = const Value.absent(),
    this.criticality = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetsCompanion.insert({
    required String id,
    required String cseId,
    required String assetIdentifier,
    required String name,
    this.assetType = const Value.absent(),
    this.ipAddress = const Value.absent(),
    this.hostname = const Value.absent(),
    this.criticality = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        cseId = Value(cseId),
        assetIdentifier = Value(assetIdentifier),
        name = Value(name),
        createdAt = Value(createdAt);
  static Insertable<AssetRecord> custom({
    Expression<String>? id,
    Expression<String>? cseId,
    Expression<String>? assetIdentifier,
    Expression<String>? name,
    Expression<String>? assetType,
    Expression<String>? ipAddress,
    Expression<String>? hostname,
    Expression<String>? criticality,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cseId != null) 'cse_id': cseId,
      if (assetIdentifier != null) 'asset_identifier': assetIdentifier,
      if (name != null) 'name': name,
      if (assetType != null) 'asset_type': assetType,
      if (ipAddress != null) 'ip_address': ipAddress,
      if (hostname != null) 'hostname': hostname,
      if (criticality != null) 'criticality': criticality,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetsCompanion copyWith(
      {Value<String>? id,
      Value<String>? cseId,
      Value<String>? assetIdentifier,
      Value<String>? name,
      Value<String>? assetType,
      Value<String?>? ipAddress,
      Value<String?>? hostname,
      Value<String>? criticality,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return AssetsCompanion(
      id: id ?? this.id,
      cseId: cseId ?? this.cseId,
      assetIdentifier: assetIdentifier ?? this.assetIdentifier,
      name: name ?? this.name,
      assetType: assetType ?? this.assetType,
      ipAddress: ipAddress ?? this.ipAddress,
      hostname: hostname ?? this.hostname,
      criticality: criticality ?? this.criticality,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cseId.present) {
      map['cse_id'] = Variable<String>(cseId.value);
    }
    if (assetIdentifier.present) {
      map['asset_identifier'] = Variable<String>(assetIdentifier.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (assetType.present) {
      map['asset_type'] = Variable<String>(assetType.value);
    }
    if (ipAddress.present) {
      map['ip_address'] = Variable<String>(ipAddress.value);
    }
    if (hostname.present) {
      map['hostname'] = Variable<String>(hostname.value);
    }
    if (criticality.present) {
      map['criticality'] = Variable<String>(criticality.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetsCompanion(')
          ..write('id: $id, ')
          ..write('cseId: $cseId, ')
          ..write('assetIdentifier: $assetIdentifier, ')
          ..write('name: $name, ')
          ..write('assetType: $assetType, ')
          ..write('ipAddress: $ipAddress, ')
          ..write('hostname: $hostname, ')
          ..write('criticality: $criticality, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlertsTable extends Alerts with TableInfo<$AlertsTable, AlertRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlertsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cseIdMeta = const VerificationMeta('cseId');
  @override
  late final GeneratedColumn<String> cseId = GeneratedColumn<String>(
      'cse_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES cses (id) ON DELETE RESTRICT'));
  static const VerificationMeta _batchIdMeta =
      const VerificationMeta('batchId');
  @override
  late final GeneratedColumn<String> batchId = GeneratedColumn<String>(
      'batch_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _assetIdMeta =
      const VerificationMeta('assetId');
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
      'asset_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES assets (id) ON DELETE SET NULL'));
  static const VerificationMeta _externalAlertIdMeta =
      const VerificationMeta('externalAlertId');
  @override
  late final GeneratedColumn<String> externalAlertId = GeneratedColumn<String>(
      'external_alert_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _severityMeta =
      const VerificationMeta('severity');
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
      'severity', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('NEW'));
  static const VerificationMeta _dispositionMeta =
      const VerificationMeta('disposition');
  @override
  late final GeneratedColumn<String> disposition = GeneratedColumn<String>(
      'disposition', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _targetAssetNameMeta =
      const VerificationMeta('targetAssetName');
  @override
  late final GeneratedColumn<String> targetAssetName = GeneratedColumn<String>(
      'target_asset_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _detectedAtMeta =
      const VerificationMeta('detectedAt');
  @override
  late final GeneratedColumn<DateTime> detectedAt = GeneratedColumn<DateTime>(
      'detected_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _closedAtMeta =
      const VerificationMeta('closedAt');
  @override
  late final GeneratedColumn<DateTime> closedAt = GeneratedColumn<DateTime>(
      'closed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _rawMetadataMeta =
      const VerificationMeta('rawMetadata');
  @override
  late final GeneratedColumn<String> rawMetadata = GeneratedColumn<String>(
      'raw_metadata', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        cseId,
        batchId,
        assetId,
        externalAlertId,
        title,
        category,
        severity,
        status,
        disposition,
        targetAssetName,
        detectedAt,
        closedAt,
        rawMetadata,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alerts';
  @override
  VerificationContext validateIntegrity(Insertable<AlertRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cse_id')) {
      context.handle(
          _cseIdMeta, cseId.isAcceptableOrUnknown(data['cse_id']!, _cseIdMeta));
    } else if (isInserting) {
      context.missing(_cseIdMeta);
    }
    if (data.containsKey('batch_id')) {
      context.handle(_batchIdMeta,
          batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta));
    }
    if (data.containsKey('asset_id')) {
      context.handle(_assetIdMeta,
          assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta));
    }
    if (data.containsKey('external_alert_id')) {
      context.handle(
          _externalAlertIdMeta,
          externalAlertId.isAcceptableOrUnknown(
              data['external_alert_id']!, _externalAlertIdMeta));
    } else if (isInserting) {
      context.missing(_externalAlertIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(_severityMeta,
          severity.isAcceptableOrUnknown(data['severity']!, _severityMeta));
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('disposition')) {
      context.handle(
          _dispositionMeta,
          disposition.isAcceptableOrUnknown(
              data['disposition']!, _dispositionMeta));
    }
    if (data.containsKey('target_asset_name')) {
      context.handle(
          _targetAssetNameMeta,
          targetAssetName.isAcceptableOrUnknown(
              data['target_asset_name']!, _targetAssetNameMeta));
    }
    if (data.containsKey('detected_at')) {
      context.handle(
          _detectedAtMeta,
          detectedAt.isAcceptableOrUnknown(
              data['detected_at']!, _detectedAtMeta));
    } else if (isInserting) {
      context.missing(_detectedAtMeta);
    }
    if (data.containsKey('closed_at')) {
      context.handle(_closedAtMeta,
          closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta));
    }
    if (data.containsKey('raw_metadata')) {
      context.handle(
          _rawMetadataMeta,
          rawMetadata.isAcceptableOrUnknown(
              data['raw_metadata']!, _rawMetadataMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AlertRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlertRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      cseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cse_id'])!,
      batchId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}batch_id']),
      assetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}asset_id']),
      externalAlertId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}external_alert_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      severity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}severity'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      disposition: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}disposition']),
      targetAssetName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}target_asset_name']),
      detectedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}detected_at'])!,
      closedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}closed_at']),
      rawMetadata: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}raw_metadata']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AlertsTable createAlias(String alias) {
    return $AlertsTable(attachedDatabase, alias);
  }
}

class AlertRecord extends DataClass implements Insertable<AlertRecord> {
  final String id;
  final String cseId;
  final String? batchId;
  final String? assetId;
  final String externalAlertId;
  final String title;
  final String category;
  final String severity;
  final String status;
  final String? disposition;
  final String? targetAssetName;
  final DateTime detectedAt;
  final DateTime? closedAt;
  final String? rawMetadata;
  final DateTime createdAt;
  const AlertRecord(
      {required this.id,
      required this.cseId,
      this.batchId,
      this.assetId,
      required this.externalAlertId,
      required this.title,
      required this.category,
      required this.severity,
      required this.status,
      this.disposition,
      this.targetAssetName,
      required this.detectedAt,
      this.closedAt,
      this.rawMetadata,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cse_id'] = Variable<String>(cseId);
    if (!nullToAbsent || batchId != null) {
      map['batch_id'] = Variable<String>(batchId);
    }
    if (!nullToAbsent || assetId != null) {
      map['asset_id'] = Variable<String>(assetId);
    }
    map['external_alert_id'] = Variable<String>(externalAlertId);
    map['title'] = Variable<String>(title);
    map['category'] = Variable<String>(category);
    map['severity'] = Variable<String>(severity);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || disposition != null) {
      map['disposition'] = Variable<String>(disposition);
    }
    if (!nullToAbsent || targetAssetName != null) {
      map['target_asset_name'] = Variable<String>(targetAssetName);
    }
    map['detected_at'] = Variable<DateTime>(detectedAt);
    if (!nullToAbsent || closedAt != null) {
      map['closed_at'] = Variable<DateTime>(closedAt);
    }
    if (!nullToAbsent || rawMetadata != null) {
      map['raw_metadata'] = Variable<String>(rawMetadata);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AlertsCompanion toCompanion(bool nullToAbsent) {
    return AlertsCompanion(
      id: Value(id),
      cseId: Value(cseId),
      batchId: batchId == null && nullToAbsent
          ? const Value.absent()
          : Value(batchId),
      assetId: assetId == null && nullToAbsent
          ? const Value.absent()
          : Value(assetId),
      externalAlertId: Value(externalAlertId),
      title: Value(title),
      category: Value(category),
      severity: Value(severity),
      status: Value(status),
      disposition: disposition == null && nullToAbsent
          ? const Value.absent()
          : Value(disposition),
      targetAssetName: targetAssetName == null && nullToAbsent
          ? const Value.absent()
          : Value(targetAssetName),
      detectedAt: Value(detectedAt),
      closedAt: closedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(closedAt),
      rawMetadata: rawMetadata == null && nullToAbsent
          ? const Value.absent()
          : Value(rawMetadata),
      createdAt: Value(createdAt),
    );
  }

  factory AlertRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlertRecord(
      id: serializer.fromJson<String>(json['id']),
      cseId: serializer.fromJson<String>(json['cseId']),
      batchId: serializer.fromJson<String?>(json['batchId']),
      assetId: serializer.fromJson<String?>(json['assetId']),
      externalAlertId: serializer.fromJson<String>(json['externalAlertId']),
      title: serializer.fromJson<String>(json['title']),
      category: serializer.fromJson<String>(json['category']),
      severity: serializer.fromJson<String>(json['severity']),
      status: serializer.fromJson<String>(json['status']),
      disposition: serializer.fromJson<String?>(json['disposition']),
      targetAssetName: serializer.fromJson<String?>(json['targetAssetName']),
      detectedAt: serializer.fromJson<DateTime>(json['detectedAt']),
      closedAt: serializer.fromJson<DateTime?>(json['closedAt']),
      rawMetadata: serializer.fromJson<String?>(json['rawMetadata']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cseId': serializer.toJson<String>(cseId),
      'batchId': serializer.toJson<String?>(batchId),
      'assetId': serializer.toJson<String?>(assetId),
      'externalAlertId': serializer.toJson<String>(externalAlertId),
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<String>(category),
      'severity': serializer.toJson<String>(severity),
      'status': serializer.toJson<String>(status),
      'disposition': serializer.toJson<String?>(disposition),
      'targetAssetName': serializer.toJson<String?>(targetAssetName),
      'detectedAt': serializer.toJson<DateTime>(detectedAt),
      'closedAt': serializer.toJson<DateTime?>(closedAt),
      'rawMetadata': serializer.toJson<String?>(rawMetadata),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AlertRecord copyWith(
          {String? id,
          String? cseId,
          Value<String?> batchId = const Value.absent(),
          Value<String?> assetId = const Value.absent(),
          String? externalAlertId,
          String? title,
          String? category,
          String? severity,
          String? status,
          Value<String?> disposition = const Value.absent(),
          Value<String?> targetAssetName = const Value.absent(),
          DateTime? detectedAt,
          Value<DateTime?> closedAt = const Value.absent(),
          Value<String?> rawMetadata = const Value.absent(),
          DateTime? createdAt}) =>
      AlertRecord(
        id: id ?? this.id,
        cseId: cseId ?? this.cseId,
        batchId: batchId.present ? batchId.value : this.batchId,
        assetId: assetId.present ? assetId.value : this.assetId,
        externalAlertId: externalAlertId ?? this.externalAlertId,
        title: title ?? this.title,
        category: category ?? this.category,
        severity: severity ?? this.severity,
        status: status ?? this.status,
        disposition: disposition.present ? disposition.value : this.disposition,
        targetAssetName: targetAssetName.present
            ? targetAssetName.value
            : this.targetAssetName,
        detectedAt: detectedAt ?? this.detectedAt,
        closedAt: closedAt.present ? closedAt.value : this.closedAt,
        rawMetadata: rawMetadata.present ? rawMetadata.value : this.rawMetadata,
        createdAt: createdAt ?? this.createdAt,
      );
  AlertRecord copyWithCompanion(AlertsCompanion data) {
    return AlertRecord(
      id: data.id.present ? data.id.value : this.id,
      cseId: data.cseId.present ? data.cseId.value : this.cseId,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      externalAlertId: data.externalAlertId.present
          ? data.externalAlertId.value
          : this.externalAlertId,
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
      severity: data.severity.present ? data.severity.value : this.severity,
      status: data.status.present ? data.status.value : this.status,
      disposition:
          data.disposition.present ? data.disposition.value : this.disposition,
      targetAssetName: data.targetAssetName.present
          ? data.targetAssetName.value
          : this.targetAssetName,
      detectedAt:
          data.detectedAt.present ? data.detectedAt.value : this.detectedAt,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
      rawMetadata:
          data.rawMetadata.present ? data.rawMetadata.value : this.rawMetadata,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlertRecord(')
          ..write('id: $id, ')
          ..write('cseId: $cseId, ')
          ..write('batchId: $batchId, ')
          ..write('assetId: $assetId, ')
          ..write('externalAlertId: $externalAlertId, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('severity: $severity, ')
          ..write('status: $status, ')
          ..write('disposition: $disposition, ')
          ..write('targetAssetName: $targetAssetName, ')
          ..write('detectedAt: $detectedAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('rawMetadata: $rawMetadata, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      cseId,
      batchId,
      assetId,
      externalAlertId,
      title,
      category,
      severity,
      status,
      disposition,
      targetAssetName,
      detectedAt,
      closedAt,
      rawMetadata,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlertRecord &&
          other.id == this.id &&
          other.cseId == this.cseId &&
          other.batchId == this.batchId &&
          other.assetId == this.assetId &&
          other.externalAlertId == this.externalAlertId &&
          other.title == this.title &&
          other.category == this.category &&
          other.severity == this.severity &&
          other.status == this.status &&
          other.disposition == this.disposition &&
          other.targetAssetName == this.targetAssetName &&
          other.detectedAt == this.detectedAt &&
          other.closedAt == this.closedAt &&
          other.rawMetadata == this.rawMetadata &&
          other.createdAt == this.createdAt);
}

class AlertsCompanion extends UpdateCompanion<AlertRecord> {
  final Value<String> id;
  final Value<String> cseId;
  final Value<String?> batchId;
  final Value<String?> assetId;
  final Value<String> externalAlertId;
  final Value<String> title;
  final Value<String> category;
  final Value<String> severity;
  final Value<String> status;
  final Value<String?> disposition;
  final Value<String?> targetAssetName;
  final Value<DateTime> detectedAt;
  final Value<DateTime?> closedAt;
  final Value<String?> rawMetadata;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AlertsCompanion({
    this.id = const Value.absent(),
    this.cseId = const Value.absent(),
    this.batchId = const Value.absent(),
    this.assetId = const Value.absent(),
    this.externalAlertId = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.severity = const Value.absent(),
    this.status = const Value.absent(),
    this.disposition = const Value.absent(),
    this.targetAssetName = const Value.absent(),
    this.detectedAt = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.rawMetadata = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlertsCompanion.insert({
    required String id,
    required String cseId,
    this.batchId = const Value.absent(),
    this.assetId = const Value.absent(),
    required String externalAlertId,
    required String title,
    required String category,
    required String severity,
    this.status = const Value.absent(),
    this.disposition = const Value.absent(),
    this.targetAssetName = const Value.absent(),
    required DateTime detectedAt,
    this.closedAt = const Value.absent(),
    this.rawMetadata = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        cseId = Value(cseId),
        externalAlertId = Value(externalAlertId),
        title = Value(title),
        category = Value(category),
        severity = Value(severity),
        detectedAt = Value(detectedAt),
        createdAt = Value(createdAt);
  static Insertable<AlertRecord> custom({
    Expression<String>? id,
    Expression<String>? cseId,
    Expression<String>? batchId,
    Expression<String>? assetId,
    Expression<String>? externalAlertId,
    Expression<String>? title,
    Expression<String>? category,
    Expression<String>? severity,
    Expression<String>? status,
    Expression<String>? disposition,
    Expression<String>? targetAssetName,
    Expression<DateTime>? detectedAt,
    Expression<DateTime>? closedAt,
    Expression<String>? rawMetadata,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cseId != null) 'cse_id': cseId,
      if (batchId != null) 'batch_id': batchId,
      if (assetId != null) 'asset_id': assetId,
      if (externalAlertId != null) 'external_alert_id': externalAlertId,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (severity != null) 'severity': severity,
      if (status != null) 'status': status,
      if (disposition != null) 'disposition': disposition,
      if (targetAssetName != null) 'target_asset_name': targetAssetName,
      if (detectedAt != null) 'detected_at': detectedAt,
      if (closedAt != null) 'closed_at': closedAt,
      if (rawMetadata != null) 'raw_metadata': rawMetadata,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlertsCompanion copyWith(
      {Value<String>? id,
      Value<String>? cseId,
      Value<String?>? batchId,
      Value<String?>? assetId,
      Value<String>? externalAlertId,
      Value<String>? title,
      Value<String>? category,
      Value<String>? severity,
      Value<String>? status,
      Value<String?>? disposition,
      Value<String?>? targetAssetName,
      Value<DateTime>? detectedAt,
      Value<DateTime?>? closedAt,
      Value<String?>? rawMetadata,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return AlertsCompanion(
      id: id ?? this.id,
      cseId: cseId ?? this.cseId,
      batchId: batchId ?? this.batchId,
      assetId: assetId ?? this.assetId,
      externalAlertId: externalAlertId ?? this.externalAlertId,
      title: title ?? this.title,
      category: category ?? this.category,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      disposition: disposition ?? this.disposition,
      targetAssetName: targetAssetName ?? this.targetAssetName,
      detectedAt: detectedAt ?? this.detectedAt,
      closedAt: closedAt ?? this.closedAt,
      rawMetadata: rawMetadata ?? this.rawMetadata,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cseId.present) {
      map['cse_id'] = Variable<String>(cseId.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<String>(batchId.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (externalAlertId.present) {
      map['external_alert_id'] = Variable<String>(externalAlertId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (disposition.present) {
      map['disposition'] = Variable<String>(disposition.value);
    }
    if (targetAssetName.present) {
      map['target_asset_name'] = Variable<String>(targetAssetName.value);
    }
    if (detectedAt.present) {
      map['detected_at'] = Variable<DateTime>(detectedAt.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<DateTime>(closedAt.value);
    }
    if (rawMetadata.present) {
      map['raw_metadata'] = Variable<String>(rawMetadata.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlertsCompanion(')
          ..write('id: $id, ')
          ..write('cseId: $cseId, ')
          ..write('batchId: $batchId, ')
          ..write('assetId: $assetId, ')
          ..write('externalAlertId: $externalAlertId, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('severity: $severity, ')
          ..write('status: $status, ')
          ..write('disposition: $disposition, ')
          ..write('targetAssetName: $targetAssetName, ')
          ..write('detectedAt: $detectedAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('rawMetadata: $rawMetadata, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CasesTable extends Cases with TableInfo<$CasesTable, CaseRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cseIdMeta = const VerificationMeta('cseId');
  @override
  late final GeneratedColumn<String> cseId = GeneratedColumn<String>(
      'cse_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES cses (id) ON DELETE RESTRICT'));
  static const VerificationMeta _batchIdMeta =
      const VerificationMeta('batchId');
  @override
  late final GeneratedColumn<String> batchId = GeneratedColumn<String>(
      'batch_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _alertIdMeta =
      const VerificationMeta('alertId');
  @override
  late final GeneratedColumn<String> alertId = GeneratedColumn<String>(
      'alert_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES alerts (id) ON DELETE SET NULL'));
  static const VerificationMeta _externalCaseIdMeta =
      const VerificationMeta('externalCaseId');
  @override
  late final GeneratedColumn<String> externalCaseId = GeneratedColumn<String>(
      'external_case_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('OPEN'));
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
      'priority', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('MEDIUM'));
  static const VerificationMeta _summaryMeta =
      const VerificationMeta('summary');
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
      'summary', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _openedAtMeta =
      const VerificationMeta('openedAt');
  @override
  late final GeneratedColumn<DateTime> openedAt = GeneratedColumn<DateTime>(
      'opened_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _closedAtMeta =
      const VerificationMeta('closedAt');
  @override
  late final GeneratedColumn<DateTime> closedAt = GeneratedColumn<DateTime>(
      'closed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        cseId,
        batchId,
        alertId,
        externalCaseId,
        title,
        status,
        priority,
        summary,
        openedAt,
        closedAt,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cases';
  @override
  VerificationContext validateIntegrity(Insertable<CaseRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cse_id')) {
      context.handle(
          _cseIdMeta, cseId.isAcceptableOrUnknown(data['cse_id']!, _cseIdMeta));
    } else if (isInserting) {
      context.missing(_cseIdMeta);
    }
    if (data.containsKey('batch_id')) {
      context.handle(_batchIdMeta,
          batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta));
    }
    if (data.containsKey('alert_id')) {
      context.handle(_alertIdMeta,
          alertId.isAcceptableOrUnknown(data['alert_id']!, _alertIdMeta));
    }
    if (data.containsKey('external_case_id')) {
      context.handle(
          _externalCaseIdMeta,
          externalCaseId.isAcceptableOrUnknown(
              data['external_case_id']!, _externalCaseIdMeta));
    } else if (isInserting) {
      context.missing(_externalCaseIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('summary')) {
      context.handle(_summaryMeta,
          summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta));
    }
    if (data.containsKey('opened_at')) {
      context.handle(_openedAtMeta,
          openedAt.isAcceptableOrUnknown(data['opened_at']!, _openedAtMeta));
    } else if (isInserting) {
      context.missing(_openedAtMeta);
    }
    if (data.containsKey('closed_at')) {
      context.handle(_closedAtMeta,
          closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CaseRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CaseRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      cseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cse_id'])!,
      batchId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}batch_id']),
      alertId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alert_id']),
      externalCaseId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}external_case_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}priority'])!,
      summary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary']),
      openedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}opened_at'])!,
      closedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}closed_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CasesTable createAlias(String alias) {
    return $CasesTable(attachedDatabase, alias);
  }
}

class CaseRecord extends DataClass implements Insertable<CaseRecord> {
  final String id;
  final String cseId;
  final String? batchId;
  final String? alertId;
  final String externalCaseId;
  final String title;
  final String status;
  final String priority;
  final String? summary;
  final DateTime openedAt;
  final DateTime? closedAt;
  final DateTime createdAt;
  const CaseRecord(
      {required this.id,
      required this.cseId,
      this.batchId,
      this.alertId,
      required this.externalCaseId,
      required this.title,
      required this.status,
      required this.priority,
      this.summary,
      required this.openedAt,
      this.closedAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cse_id'] = Variable<String>(cseId);
    if (!nullToAbsent || batchId != null) {
      map['batch_id'] = Variable<String>(batchId);
    }
    if (!nullToAbsent || alertId != null) {
      map['alert_id'] = Variable<String>(alertId);
    }
    map['external_case_id'] = Variable<String>(externalCaseId);
    map['title'] = Variable<String>(title);
    map['status'] = Variable<String>(status);
    map['priority'] = Variable<String>(priority);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    map['opened_at'] = Variable<DateTime>(openedAt);
    if (!nullToAbsent || closedAt != null) {
      map['closed_at'] = Variable<DateTime>(closedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CasesCompanion toCompanion(bool nullToAbsent) {
    return CasesCompanion(
      id: Value(id),
      cseId: Value(cseId),
      batchId: batchId == null && nullToAbsent
          ? const Value.absent()
          : Value(batchId),
      alertId: alertId == null && nullToAbsent
          ? const Value.absent()
          : Value(alertId),
      externalCaseId: Value(externalCaseId),
      title: Value(title),
      status: Value(status),
      priority: Value(priority),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      openedAt: Value(openedAt),
      closedAt: closedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(closedAt),
      createdAt: Value(createdAt),
    );
  }

  factory CaseRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CaseRecord(
      id: serializer.fromJson<String>(json['id']),
      cseId: serializer.fromJson<String>(json['cseId']),
      batchId: serializer.fromJson<String?>(json['batchId']),
      alertId: serializer.fromJson<String?>(json['alertId']),
      externalCaseId: serializer.fromJson<String>(json['externalCaseId']),
      title: serializer.fromJson<String>(json['title']),
      status: serializer.fromJson<String>(json['status']),
      priority: serializer.fromJson<String>(json['priority']),
      summary: serializer.fromJson<String?>(json['summary']),
      openedAt: serializer.fromJson<DateTime>(json['openedAt']),
      closedAt: serializer.fromJson<DateTime?>(json['closedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cseId': serializer.toJson<String>(cseId),
      'batchId': serializer.toJson<String?>(batchId),
      'alertId': serializer.toJson<String?>(alertId),
      'externalCaseId': serializer.toJson<String>(externalCaseId),
      'title': serializer.toJson<String>(title),
      'status': serializer.toJson<String>(status),
      'priority': serializer.toJson<String>(priority),
      'summary': serializer.toJson<String?>(summary),
      'openedAt': serializer.toJson<DateTime>(openedAt),
      'closedAt': serializer.toJson<DateTime?>(closedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CaseRecord copyWith(
          {String? id,
          String? cseId,
          Value<String?> batchId = const Value.absent(),
          Value<String?> alertId = const Value.absent(),
          String? externalCaseId,
          String? title,
          String? status,
          String? priority,
          Value<String?> summary = const Value.absent(),
          DateTime? openedAt,
          Value<DateTime?> closedAt = const Value.absent(),
          DateTime? createdAt}) =>
      CaseRecord(
        id: id ?? this.id,
        cseId: cseId ?? this.cseId,
        batchId: batchId.present ? batchId.value : this.batchId,
        alertId: alertId.present ? alertId.value : this.alertId,
        externalCaseId: externalCaseId ?? this.externalCaseId,
        title: title ?? this.title,
        status: status ?? this.status,
        priority: priority ?? this.priority,
        summary: summary.present ? summary.value : this.summary,
        openedAt: openedAt ?? this.openedAt,
        closedAt: closedAt.present ? closedAt.value : this.closedAt,
        createdAt: createdAt ?? this.createdAt,
      );
  CaseRecord copyWithCompanion(CasesCompanion data) {
    return CaseRecord(
      id: data.id.present ? data.id.value : this.id,
      cseId: data.cseId.present ? data.cseId.value : this.cseId,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      alertId: data.alertId.present ? data.alertId.value : this.alertId,
      externalCaseId: data.externalCaseId.present
          ? data.externalCaseId.value
          : this.externalCaseId,
      title: data.title.present ? data.title.value : this.title,
      status: data.status.present ? data.status.value : this.status,
      priority: data.priority.present ? data.priority.value : this.priority,
      summary: data.summary.present ? data.summary.value : this.summary,
      openedAt: data.openedAt.present ? data.openedAt.value : this.openedAt,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CaseRecord(')
          ..write('id: $id, ')
          ..write('cseId: $cseId, ')
          ..write('batchId: $batchId, ')
          ..write('alertId: $alertId, ')
          ..write('externalCaseId: $externalCaseId, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('summary: $summary, ')
          ..write('openedAt: $openedAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cseId, batchId, alertId, externalCaseId,
      title, status, priority, summary, openedAt, closedAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CaseRecord &&
          other.id == this.id &&
          other.cseId == this.cseId &&
          other.batchId == this.batchId &&
          other.alertId == this.alertId &&
          other.externalCaseId == this.externalCaseId &&
          other.title == this.title &&
          other.status == this.status &&
          other.priority == this.priority &&
          other.summary == this.summary &&
          other.openedAt == this.openedAt &&
          other.closedAt == this.closedAt &&
          other.createdAt == this.createdAt);
}

class CasesCompanion extends UpdateCompanion<CaseRecord> {
  final Value<String> id;
  final Value<String> cseId;
  final Value<String?> batchId;
  final Value<String?> alertId;
  final Value<String> externalCaseId;
  final Value<String> title;
  final Value<String> status;
  final Value<String> priority;
  final Value<String?> summary;
  final Value<DateTime> openedAt;
  final Value<DateTime?> closedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CasesCompanion({
    this.id = const Value.absent(),
    this.cseId = const Value.absent(),
    this.batchId = const Value.absent(),
    this.alertId = const Value.absent(),
    this.externalCaseId = const Value.absent(),
    this.title = const Value.absent(),
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.summary = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CasesCompanion.insert({
    required String id,
    required String cseId,
    this.batchId = const Value.absent(),
    this.alertId = const Value.absent(),
    required String externalCaseId,
    required String title,
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.summary = const Value.absent(),
    required DateTime openedAt,
    this.closedAt = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        cseId = Value(cseId),
        externalCaseId = Value(externalCaseId),
        title = Value(title),
        openedAt = Value(openedAt),
        createdAt = Value(createdAt);
  static Insertable<CaseRecord> custom({
    Expression<String>? id,
    Expression<String>? cseId,
    Expression<String>? batchId,
    Expression<String>? alertId,
    Expression<String>? externalCaseId,
    Expression<String>? title,
    Expression<String>? status,
    Expression<String>? priority,
    Expression<String>? summary,
    Expression<DateTime>? openedAt,
    Expression<DateTime>? closedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cseId != null) 'cse_id': cseId,
      if (batchId != null) 'batch_id': batchId,
      if (alertId != null) 'alert_id': alertId,
      if (externalCaseId != null) 'external_case_id': externalCaseId,
      if (title != null) 'title': title,
      if (status != null) 'status': status,
      if (priority != null) 'priority': priority,
      if (summary != null) 'summary': summary,
      if (openedAt != null) 'opened_at': openedAt,
      if (closedAt != null) 'closed_at': closedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CasesCompanion copyWith(
      {Value<String>? id,
      Value<String>? cseId,
      Value<String?>? batchId,
      Value<String?>? alertId,
      Value<String>? externalCaseId,
      Value<String>? title,
      Value<String>? status,
      Value<String>? priority,
      Value<String?>? summary,
      Value<DateTime>? openedAt,
      Value<DateTime?>? closedAt,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return CasesCompanion(
      id: id ?? this.id,
      cseId: cseId ?? this.cseId,
      batchId: batchId ?? this.batchId,
      alertId: alertId ?? this.alertId,
      externalCaseId: externalCaseId ?? this.externalCaseId,
      title: title ?? this.title,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      summary: summary ?? this.summary,
      openedAt: openedAt ?? this.openedAt,
      closedAt: closedAt ?? this.closedAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cseId.present) {
      map['cse_id'] = Variable<String>(cseId.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<String>(batchId.value);
    }
    if (alertId.present) {
      map['alert_id'] = Variable<String>(alertId.value);
    }
    if (externalCaseId.present) {
      map['external_case_id'] = Variable<String>(externalCaseId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (openedAt.present) {
      map['opened_at'] = Variable<DateTime>(openedAt.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<DateTime>(closedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CasesCompanion(')
          ..write('id: $id, ')
          ..write('cseId: $cseId, ')
          ..write('batchId: $batchId, ')
          ..write('alertId: $alertId, ')
          ..write('externalCaseId: $externalCaseId, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('summary: $summary, ')
          ..write('openedAt: $openedAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InvestigationsTable extends Investigations
    with TableInfo<$InvestigationsTable, InvestigationRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvestigationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _caseIdMeta = const VerificationMeta('caseId');
  @override
  late final GeneratedColumn<String> caseId = GeneratedColumn<String>(
      'case_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES cases (id) ON DELETE CASCADE'));
  static const VerificationMeta _externalInvestigationIdMeta =
      const VerificationMeta('externalInvestigationId');
  @override
  late final GeneratedColumn<String> externalInvestigationId =
      GeneratedColumn<String>('external_investigation_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _investigatorRefMeta =
      const VerificationMeta('investigatorRef');
  @override
  late final GeneratedColumn<String> investigatorRef = GeneratedColumn<String>(
      'investigator_ref', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _actionTypeMeta =
      const VerificationMeta('actionType');
  @override
  late final GeneratedColumn<String> actionType = GeneratedColumn<String>(
      'action_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _evidenceCountMeta =
      const VerificationMeta('evidenceCount');
  @override
  late final GeneratedColumn<int> evidenceCount = GeneratedColumn<int>(
      'evidence_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        caseId,
        externalInvestigationId,
        investigatorRef,
        actionType,
        notes,
        startedAt,
        completedAt,
        evidenceCount,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'investigations';
  @override
  VerificationContext validateIntegrity(
      Insertable<InvestigationRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('case_id')) {
      context.handle(_caseIdMeta,
          caseId.isAcceptableOrUnknown(data['case_id']!, _caseIdMeta));
    } else if (isInserting) {
      context.missing(_caseIdMeta);
    }
    if (data.containsKey('external_investigation_id')) {
      context.handle(
          _externalInvestigationIdMeta,
          externalInvestigationId.isAcceptableOrUnknown(
              data['external_investigation_id']!,
              _externalInvestigationIdMeta));
    }
    if (data.containsKey('investigator_ref')) {
      context.handle(
          _investigatorRefMeta,
          investigatorRef.isAcceptableOrUnknown(
              data['investigator_ref']!, _investigatorRefMeta));
    }
    if (data.containsKey('action_type')) {
      context.handle(
          _actionTypeMeta,
          actionType.isAcceptableOrUnknown(
              data['action_type']!, _actionTypeMeta));
    } else if (isInserting) {
      context.missing(_actionTypeMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('evidence_count')) {
      context.handle(
          _evidenceCountMeta,
          evidenceCount.isAcceptableOrUnknown(
              data['evidence_count']!, _evidenceCountMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InvestigationRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvestigationRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      caseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}case_id'])!,
      externalInvestigationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}external_investigation_id']),
      investigatorRef: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}investigator_ref']),
      actionType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action_type'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      evidenceCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}evidence_count'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $InvestigationsTable createAlias(String alias) {
    return $InvestigationsTable(attachedDatabase, alias);
  }
}

class InvestigationRecord extends DataClass
    implements Insertable<InvestigationRecord> {
  final String id;
  final String caseId;
  final String? externalInvestigationId;
  final String? investigatorRef;
  final String actionType;
  final String? notes;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int evidenceCount;
  final DateTime createdAt;
  const InvestigationRecord(
      {required this.id,
      required this.caseId,
      this.externalInvestigationId,
      this.investigatorRef,
      required this.actionType,
      this.notes,
      required this.startedAt,
      this.completedAt,
      required this.evidenceCount,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['case_id'] = Variable<String>(caseId);
    if (!nullToAbsent || externalInvestigationId != null) {
      map['external_investigation_id'] =
          Variable<String>(externalInvestigationId);
    }
    if (!nullToAbsent || investigatorRef != null) {
      map['investigator_ref'] = Variable<String>(investigatorRef);
    }
    map['action_type'] = Variable<String>(actionType);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['evidence_count'] = Variable<int>(evidenceCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  InvestigationsCompanion toCompanion(bool nullToAbsent) {
    return InvestigationsCompanion(
      id: Value(id),
      caseId: Value(caseId),
      externalInvestigationId: externalInvestigationId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalInvestigationId),
      investigatorRef: investigatorRef == null && nullToAbsent
          ? const Value.absent()
          : Value(investigatorRef),
      actionType: Value(actionType),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      evidenceCount: Value(evidenceCount),
      createdAt: Value(createdAt),
    );
  }

  factory InvestigationRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvestigationRecord(
      id: serializer.fromJson<String>(json['id']),
      caseId: serializer.fromJson<String>(json['caseId']),
      externalInvestigationId:
          serializer.fromJson<String?>(json['externalInvestigationId']),
      investigatorRef: serializer.fromJson<String?>(json['investigatorRef']),
      actionType: serializer.fromJson<String>(json['actionType']),
      notes: serializer.fromJson<String?>(json['notes']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      evidenceCount: serializer.fromJson<int>(json['evidenceCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'caseId': serializer.toJson<String>(caseId),
      'externalInvestigationId':
          serializer.toJson<String?>(externalInvestigationId),
      'investigatorRef': serializer.toJson<String?>(investigatorRef),
      'actionType': serializer.toJson<String>(actionType),
      'notes': serializer.toJson<String?>(notes),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'evidenceCount': serializer.toJson<int>(evidenceCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  InvestigationRecord copyWith(
          {String? id,
          String? caseId,
          Value<String?> externalInvestigationId = const Value.absent(),
          Value<String?> investigatorRef = const Value.absent(),
          String? actionType,
          Value<String?> notes = const Value.absent(),
          DateTime? startedAt,
          Value<DateTime?> completedAt = const Value.absent(),
          int? evidenceCount,
          DateTime? createdAt}) =>
      InvestigationRecord(
        id: id ?? this.id,
        caseId: caseId ?? this.caseId,
        externalInvestigationId: externalInvestigationId.present
            ? externalInvestigationId.value
            : this.externalInvestigationId,
        investigatorRef: investigatorRef.present
            ? investigatorRef.value
            : this.investigatorRef,
        actionType: actionType ?? this.actionType,
        notes: notes.present ? notes.value : this.notes,
        startedAt: startedAt ?? this.startedAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        evidenceCount: evidenceCount ?? this.evidenceCount,
        createdAt: createdAt ?? this.createdAt,
      );
  InvestigationRecord copyWithCompanion(InvestigationsCompanion data) {
    return InvestigationRecord(
      id: data.id.present ? data.id.value : this.id,
      caseId: data.caseId.present ? data.caseId.value : this.caseId,
      externalInvestigationId: data.externalInvestigationId.present
          ? data.externalInvestigationId.value
          : this.externalInvestigationId,
      investigatorRef: data.investigatorRef.present
          ? data.investigatorRef.value
          : this.investigatorRef,
      actionType:
          data.actionType.present ? data.actionType.value : this.actionType,
      notes: data.notes.present ? data.notes.value : this.notes,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      evidenceCount: data.evidenceCount.present
          ? data.evidenceCount.value
          : this.evidenceCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvestigationRecord(')
          ..write('id: $id, ')
          ..write('caseId: $caseId, ')
          ..write('externalInvestigationId: $externalInvestigationId, ')
          ..write('investigatorRef: $investigatorRef, ')
          ..write('actionType: $actionType, ')
          ..write('notes: $notes, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('evidenceCount: $evidenceCount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      caseId,
      externalInvestigationId,
      investigatorRef,
      actionType,
      notes,
      startedAt,
      completedAt,
      evidenceCount,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvestigationRecord &&
          other.id == this.id &&
          other.caseId == this.caseId &&
          other.externalInvestigationId == this.externalInvestigationId &&
          other.investigatorRef == this.investigatorRef &&
          other.actionType == this.actionType &&
          other.notes == this.notes &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.evidenceCount == this.evidenceCount &&
          other.createdAt == this.createdAt);
}

class InvestigationsCompanion extends UpdateCompanion<InvestigationRecord> {
  final Value<String> id;
  final Value<String> caseId;
  final Value<String?> externalInvestigationId;
  final Value<String?> investigatorRef;
  final Value<String> actionType;
  final Value<String?> notes;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<int> evidenceCount;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const InvestigationsCompanion({
    this.id = const Value.absent(),
    this.caseId = const Value.absent(),
    this.externalInvestigationId = const Value.absent(),
    this.investigatorRef = const Value.absent(),
    this.actionType = const Value.absent(),
    this.notes = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.evidenceCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvestigationsCompanion.insert({
    required String id,
    required String caseId,
    this.externalInvestigationId = const Value.absent(),
    this.investigatorRef = const Value.absent(),
    required String actionType,
    this.notes = const Value.absent(),
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    this.evidenceCount = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        caseId = Value(caseId),
        actionType = Value(actionType),
        startedAt = Value(startedAt),
        createdAt = Value(createdAt);
  static Insertable<InvestigationRecord> custom({
    Expression<String>? id,
    Expression<String>? caseId,
    Expression<String>? externalInvestigationId,
    Expression<String>? investigatorRef,
    Expression<String>? actionType,
    Expression<String>? notes,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? evidenceCount,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (caseId != null) 'case_id': caseId,
      if (externalInvestigationId != null)
        'external_investigation_id': externalInvestigationId,
      if (investigatorRef != null) 'investigator_ref': investigatorRef,
      if (actionType != null) 'action_type': actionType,
      if (notes != null) 'notes': notes,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (evidenceCount != null) 'evidence_count': evidenceCount,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvestigationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? caseId,
      Value<String?>? externalInvestigationId,
      Value<String?>? investigatorRef,
      Value<String>? actionType,
      Value<String?>? notes,
      Value<DateTime>? startedAt,
      Value<DateTime?>? completedAt,
      Value<int>? evidenceCount,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return InvestigationsCompanion(
      id: id ?? this.id,
      caseId: caseId ?? this.caseId,
      externalInvestigationId:
          externalInvestigationId ?? this.externalInvestigationId,
      investigatorRef: investigatorRef ?? this.investigatorRef,
      actionType: actionType ?? this.actionType,
      notes: notes ?? this.notes,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      evidenceCount: evidenceCount ?? this.evidenceCount,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (caseId.present) {
      map['case_id'] = Variable<String>(caseId.value);
    }
    if (externalInvestigationId.present) {
      map['external_investigation_id'] =
          Variable<String>(externalInvestigationId.value);
    }
    if (investigatorRef.present) {
      map['investigator_ref'] = Variable<String>(investigatorRef.value);
    }
    if (actionType.present) {
      map['action_type'] = Variable<String>(actionType.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (evidenceCount.present) {
      map['evidence_count'] = Variable<int>(evidenceCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvestigationsCompanion(')
          ..write('id: $id, ')
          ..write('caseId: $caseId, ')
          ..write('externalInvestigationId: $externalInvestigationId, ')
          ..write('investigatorRef: $investigatorRef, ')
          ..write('actionType: $actionType, ')
          ..write('notes: $notes, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('evidenceCount: $evidenceCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EscalationsTable extends Escalations
    with TableInfo<$EscalationsTable, EscalationRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EscalationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _caseIdMeta = const VerificationMeta('caseId');
  @override
  late final GeneratedColumn<String> caseId = GeneratedColumn<String>(
      'case_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES cases (id) ON DELETE CASCADE'));
  static const VerificationMeta _alertIdMeta =
      const VerificationMeta('alertId');
  @override
  late final GeneratedColumn<String> alertId = GeneratedColumn<String>(
      'alert_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES alerts (id) ON DELETE SET NULL'));
  static const VerificationMeta _escalationLevelMeta =
      const VerificationMeta('escalationLevel');
  @override
  late final GeneratedColumn<String> escalationLevel = GeneratedColumn<String>(
      'escalation_level', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('PENDING'));
  static const VerificationMeta _escalatedAtMeta =
      const VerificationMeta('escalatedAt');
  @override
  late final GeneratedColumn<DateTime> escalatedAt = GeneratedColumn<DateTime>(
      'escalated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        caseId,
        alertId,
        escalationLevel,
        reason,
        status,
        escalatedAt,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'escalations';
  @override
  VerificationContext validateIntegrity(Insertable<EscalationRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('case_id')) {
      context.handle(_caseIdMeta,
          caseId.isAcceptableOrUnknown(data['case_id']!, _caseIdMeta));
    } else if (isInserting) {
      context.missing(_caseIdMeta);
    }
    if (data.containsKey('alert_id')) {
      context.handle(_alertIdMeta,
          alertId.isAcceptableOrUnknown(data['alert_id']!, _alertIdMeta));
    }
    if (data.containsKey('escalation_level')) {
      context.handle(
          _escalationLevelMeta,
          escalationLevel.isAcceptableOrUnknown(
              data['escalation_level']!, _escalationLevelMeta));
    } else if (isInserting) {
      context.missing(_escalationLevelMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('escalated_at')) {
      context.handle(
          _escalatedAtMeta,
          escalatedAt.isAcceptableOrUnknown(
              data['escalated_at']!, _escalatedAtMeta));
    } else if (isInserting) {
      context.missing(_escalatedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EscalationRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EscalationRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      caseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}case_id'])!,
      alertId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alert_id']),
      escalationLevel: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}escalation_level'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      escalatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}escalated_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $EscalationsTable createAlias(String alias) {
    return $EscalationsTable(attachedDatabase, alias);
  }
}

class EscalationRecord extends DataClass
    implements Insertable<EscalationRecord> {
  final String id;
  final String caseId;
  final String? alertId;
  final String escalationLevel;
  final String? reason;
  final String status;
  final DateTime escalatedAt;
  final DateTime createdAt;
  const EscalationRecord(
      {required this.id,
      required this.caseId,
      this.alertId,
      required this.escalationLevel,
      this.reason,
      required this.status,
      required this.escalatedAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['case_id'] = Variable<String>(caseId);
    if (!nullToAbsent || alertId != null) {
      map['alert_id'] = Variable<String>(alertId);
    }
    map['escalation_level'] = Variable<String>(escalationLevel);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    map['status'] = Variable<String>(status);
    map['escalated_at'] = Variable<DateTime>(escalatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EscalationsCompanion toCompanion(bool nullToAbsent) {
    return EscalationsCompanion(
      id: Value(id),
      caseId: Value(caseId),
      alertId: alertId == null && nullToAbsent
          ? const Value.absent()
          : Value(alertId),
      escalationLevel: Value(escalationLevel),
      reason:
          reason == null && nullToAbsent ? const Value.absent() : Value(reason),
      status: Value(status),
      escalatedAt: Value(escalatedAt),
      createdAt: Value(createdAt),
    );
  }

  factory EscalationRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EscalationRecord(
      id: serializer.fromJson<String>(json['id']),
      caseId: serializer.fromJson<String>(json['caseId']),
      alertId: serializer.fromJson<String?>(json['alertId']),
      escalationLevel: serializer.fromJson<String>(json['escalationLevel']),
      reason: serializer.fromJson<String?>(json['reason']),
      status: serializer.fromJson<String>(json['status']),
      escalatedAt: serializer.fromJson<DateTime>(json['escalatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'caseId': serializer.toJson<String>(caseId),
      'alertId': serializer.toJson<String?>(alertId),
      'escalationLevel': serializer.toJson<String>(escalationLevel),
      'reason': serializer.toJson<String?>(reason),
      'status': serializer.toJson<String>(status),
      'escalatedAt': serializer.toJson<DateTime>(escalatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EscalationRecord copyWith(
          {String? id,
          String? caseId,
          Value<String?> alertId = const Value.absent(),
          String? escalationLevel,
          Value<String?> reason = const Value.absent(),
          String? status,
          DateTime? escalatedAt,
          DateTime? createdAt}) =>
      EscalationRecord(
        id: id ?? this.id,
        caseId: caseId ?? this.caseId,
        alertId: alertId.present ? alertId.value : this.alertId,
        escalationLevel: escalationLevel ?? this.escalationLevel,
        reason: reason.present ? reason.value : this.reason,
        status: status ?? this.status,
        escalatedAt: escalatedAt ?? this.escalatedAt,
        createdAt: createdAt ?? this.createdAt,
      );
  EscalationRecord copyWithCompanion(EscalationsCompanion data) {
    return EscalationRecord(
      id: data.id.present ? data.id.value : this.id,
      caseId: data.caseId.present ? data.caseId.value : this.caseId,
      alertId: data.alertId.present ? data.alertId.value : this.alertId,
      escalationLevel: data.escalationLevel.present
          ? data.escalationLevel.value
          : this.escalationLevel,
      reason: data.reason.present ? data.reason.value : this.reason,
      status: data.status.present ? data.status.value : this.status,
      escalatedAt:
          data.escalatedAt.present ? data.escalatedAt.value : this.escalatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EscalationRecord(')
          ..write('id: $id, ')
          ..write('caseId: $caseId, ')
          ..write('alertId: $alertId, ')
          ..write('escalationLevel: $escalationLevel, ')
          ..write('reason: $reason, ')
          ..write('status: $status, ')
          ..write('escalatedAt: $escalatedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, caseId, alertId, escalationLevel, reason,
      status, escalatedAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EscalationRecord &&
          other.id == this.id &&
          other.caseId == this.caseId &&
          other.alertId == this.alertId &&
          other.escalationLevel == this.escalationLevel &&
          other.reason == this.reason &&
          other.status == this.status &&
          other.escalatedAt == this.escalatedAt &&
          other.createdAt == this.createdAt);
}

class EscalationsCompanion extends UpdateCompanion<EscalationRecord> {
  final Value<String> id;
  final Value<String> caseId;
  final Value<String?> alertId;
  final Value<String> escalationLevel;
  final Value<String?> reason;
  final Value<String> status;
  final Value<DateTime> escalatedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const EscalationsCompanion({
    this.id = const Value.absent(),
    this.caseId = const Value.absent(),
    this.alertId = const Value.absent(),
    this.escalationLevel = const Value.absent(),
    this.reason = const Value.absent(),
    this.status = const Value.absent(),
    this.escalatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EscalationsCompanion.insert({
    required String id,
    required String caseId,
    this.alertId = const Value.absent(),
    required String escalationLevel,
    this.reason = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime escalatedAt,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        caseId = Value(caseId),
        escalationLevel = Value(escalationLevel),
        escalatedAt = Value(escalatedAt),
        createdAt = Value(createdAt);
  static Insertable<EscalationRecord> custom({
    Expression<String>? id,
    Expression<String>? caseId,
    Expression<String>? alertId,
    Expression<String>? escalationLevel,
    Expression<String>? reason,
    Expression<String>? status,
    Expression<DateTime>? escalatedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (caseId != null) 'case_id': caseId,
      if (alertId != null) 'alert_id': alertId,
      if (escalationLevel != null) 'escalation_level': escalationLevel,
      if (reason != null) 'reason': reason,
      if (status != null) 'status': status,
      if (escalatedAt != null) 'escalated_at': escalatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EscalationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? caseId,
      Value<String?>? alertId,
      Value<String>? escalationLevel,
      Value<String?>? reason,
      Value<String>? status,
      Value<DateTime>? escalatedAt,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return EscalationsCompanion(
      id: id ?? this.id,
      caseId: caseId ?? this.caseId,
      alertId: alertId ?? this.alertId,
      escalationLevel: escalationLevel ?? this.escalationLevel,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      escalatedAt: escalatedAt ?? this.escalatedAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (caseId.present) {
      map['case_id'] = Variable<String>(caseId.value);
    }
    if (alertId.present) {
      map['alert_id'] = Variable<String>(alertId.value);
    }
    if (escalationLevel.present) {
      map['escalation_level'] = Variable<String>(escalationLevel.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (escalatedAt.present) {
      map['escalated_at'] = Variable<DateTime>(escalatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EscalationsCompanion(')
          ..write('id: $id, ')
          ..write('caseId: $caseId, ')
          ..write('alertId: $alertId, ')
          ..write('escalationLevel: $escalationLevel, ')
          ..write('reason: $reason, ')
          ..write('status: $status, ')
          ..write('escalatedAt: $escalatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MonitoringCoveragesTable extends MonitoringCoverages
    with TableInfo<$MonitoringCoveragesTable, MonitoringCoverageRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonitoringCoveragesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cseIdMeta = const VerificationMeta('cseId');
  @override
  late final GeneratedColumn<String> cseId = GeneratedColumn<String>(
      'cse_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES cses (id) ON DELETE RESTRICT'));
  static const VerificationMeta _logSourceCategoryMeta =
      const VerificationMeta('logSourceCategory');
  @override
  late final GeneratedColumn<String> logSourceCategory =
      GeneratedColumn<String>('log_source_category', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isExpectedMeta =
      const VerificationMeta('isExpected');
  @override
  late final GeneratedColumn<bool> isExpected = GeneratedColumn<bool>(
      'is_expected', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_expected" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _lastReceivedAtMeta =
      const VerificationMeta('lastReceivedAt');
  @override
  late final GeneratedColumn<DateTime> lastReceivedAt =
      GeneratedColumn<DateTime>('last_received_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _coveragePercentageMeta =
      const VerificationMeta('coveragePercentage');
  @override
  late final GeneratedColumn<double> coveragePercentage =
      GeneratedColumn<double>('coverage_percentage', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _periodStartMeta =
      const VerificationMeta('periodStart');
  @override
  late final GeneratedColumn<DateTime> periodStart = GeneratedColumn<DateTime>(
      'period_start', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _periodEndMeta =
      const VerificationMeta('periodEnd');
  @override
  late final GeneratedColumn<DateTime> periodEnd = GeneratedColumn<DateTime>(
      'period_end', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        cseId,
        logSourceCategory,
        isExpected,
        isActive,
        lastReceivedAt,
        coveragePercentage,
        periodStart,
        periodEnd,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monitoring_coverages';
  @override
  VerificationContext validateIntegrity(
      Insertable<MonitoringCoverageRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cse_id')) {
      context.handle(
          _cseIdMeta, cseId.isAcceptableOrUnknown(data['cse_id']!, _cseIdMeta));
    } else if (isInserting) {
      context.missing(_cseIdMeta);
    }
    if (data.containsKey('log_source_category')) {
      context.handle(
          _logSourceCategoryMeta,
          logSourceCategory.isAcceptableOrUnknown(
              data['log_source_category']!, _logSourceCategoryMeta));
    } else if (isInserting) {
      context.missing(_logSourceCategoryMeta);
    }
    if (data.containsKey('is_expected')) {
      context.handle(
          _isExpectedMeta,
          isExpected.isAcceptableOrUnknown(
              data['is_expected']!, _isExpectedMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('last_received_at')) {
      context.handle(
          _lastReceivedAtMeta,
          lastReceivedAt.isAcceptableOrUnknown(
              data['last_received_at']!, _lastReceivedAtMeta));
    }
    if (data.containsKey('coverage_percentage')) {
      context.handle(
          _coveragePercentageMeta,
          coveragePercentage.isAcceptableOrUnknown(
              data['coverage_percentage']!, _coveragePercentageMeta));
    }
    if (data.containsKey('period_start')) {
      context.handle(
          _periodStartMeta,
          periodStart.isAcceptableOrUnknown(
              data['period_start']!, _periodStartMeta));
    }
    if (data.containsKey('period_end')) {
      context.handle(_periodEndMeta,
          periodEnd.isAcceptableOrUnknown(data['period_end']!, _periodEndMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MonitoringCoverageRecord map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonitoringCoverageRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      cseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cse_id'])!,
      logSourceCategory: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}log_source_category'])!,
      isExpected: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_expected'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      lastReceivedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_received_at']),
      coveragePercentage: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}coverage_percentage']),
      periodStart: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}period_start']),
      periodEnd: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}period_end']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $MonitoringCoveragesTable createAlias(String alias) {
    return $MonitoringCoveragesTable(attachedDatabase, alias);
  }
}

class MonitoringCoverageRecord extends DataClass
    implements Insertable<MonitoringCoverageRecord> {
  final String id;
  final String cseId;
  final String logSourceCategory;
  final bool isExpected;
  final bool isActive;
  final DateTime? lastReceivedAt;
  final double? coveragePercentage;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final DateTime createdAt;
  const MonitoringCoverageRecord(
      {required this.id,
      required this.cseId,
      required this.logSourceCategory,
      required this.isExpected,
      required this.isActive,
      this.lastReceivedAt,
      this.coveragePercentage,
      this.periodStart,
      this.periodEnd,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cse_id'] = Variable<String>(cseId);
    map['log_source_category'] = Variable<String>(logSourceCategory);
    map['is_expected'] = Variable<bool>(isExpected);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || lastReceivedAt != null) {
      map['last_received_at'] = Variable<DateTime>(lastReceivedAt);
    }
    if (!nullToAbsent || coveragePercentage != null) {
      map['coverage_percentage'] = Variable<double>(coveragePercentage);
    }
    if (!nullToAbsent || periodStart != null) {
      map['period_start'] = Variable<DateTime>(periodStart);
    }
    if (!nullToAbsent || periodEnd != null) {
      map['period_end'] = Variable<DateTime>(periodEnd);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MonitoringCoveragesCompanion toCompanion(bool nullToAbsent) {
    return MonitoringCoveragesCompanion(
      id: Value(id),
      cseId: Value(cseId),
      logSourceCategory: Value(logSourceCategory),
      isExpected: Value(isExpected),
      isActive: Value(isActive),
      lastReceivedAt: lastReceivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReceivedAt),
      coveragePercentage: coveragePercentage == null && nullToAbsent
          ? const Value.absent()
          : Value(coveragePercentage),
      periodStart: periodStart == null && nullToAbsent
          ? const Value.absent()
          : Value(periodStart),
      periodEnd: periodEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(periodEnd),
      createdAt: Value(createdAt),
    );
  }

  factory MonitoringCoverageRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonitoringCoverageRecord(
      id: serializer.fromJson<String>(json['id']),
      cseId: serializer.fromJson<String>(json['cseId']),
      logSourceCategory: serializer.fromJson<String>(json['logSourceCategory']),
      isExpected: serializer.fromJson<bool>(json['isExpected']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      lastReceivedAt: serializer.fromJson<DateTime?>(json['lastReceivedAt']),
      coveragePercentage:
          serializer.fromJson<double?>(json['coveragePercentage']),
      periodStart: serializer.fromJson<DateTime?>(json['periodStart']),
      periodEnd: serializer.fromJson<DateTime?>(json['periodEnd']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cseId': serializer.toJson<String>(cseId),
      'logSourceCategory': serializer.toJson<String>(logSourceCategory),
      'isExpected': serializer.toJson<bool>(isExpected),
      'isActive': serializer.toJson<bool>(isActive),
      'lastReceivedAt': serializer.toJson<DateTime?>(lastReceivedAt),
      'coveragePercentage': serializer.toJson<double?>(coveragePercentage),
      'periodStart': serializer.toJson<DateTime?>(periodStart),
      'periodEnd': serializer.toJson<DateTime?>(periodEnd),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MonitoringCoverageRecord copyWith(
          {String? id,
          String? cseId,
          String? logSourceCategory,
          bool? isExpected,
          bool? isActive,
          Value<DateTime?> lastReceivedAt = const Value.absent(),
          Value<double?> coveragePercentage = const Value.absent(),
          Value<DateTime?> periodStart = const Value.absent(),
          Value<DateTime?> periodEnd = const Value.absent(),
          DateTime? createdAt}) =>
      MonitoringCoverageRecord(
        id: id ?? this.id,
        cseId: cseId ?? this.cseId,
        logSourceCategory: logSourceCategory ?? this.logSourceCategory,
        isExpected: isExpected ?? this.isExpected,
        isActive: isActive ?? this.isActive,
        lastReceivedAt:
            lastReceivedAt.present ? lastReceivedAt.value : this.lastReceivedAt,
        coveragePercentage: coveragePercentage.present
            ? coveragePercentage.value
            : this.coveragePercentage,
        periodStart: periodStart.present ? periodStart.value : this.periodStart,
        periodEnd: periodEnd.present ? periodEnd.value : this.periodEnd,
        createdAt: createdAt ?? this.createdAt,
      );
  MonitoringCoverageRecord copyWithCompanion(
      MonitoringCoveragesCompanion data) {
    return MonitoringCoverageRecord(
      id: data.id.present ? data.id.value : this.id,
      cseId: data.cseId.present ? data.cseId.value : this.cseId,
      logSourceCategory: data.logSourceCategory.present
          ? data.logSourceCategory.value
          : this.logSourceCategory,
      isExpected:
          data.isExpected.present ? data.isExpected.value : this.isExpected,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      lastReceivedAt: data.lastReceivedAt.present
          ? data.lastReceivedAt.value
          : this.lastReceivedAt,
      coveragePercentage: data.coveragePercentage.present
          ? data.coveragePercentage.value
          : this.coveragePercentage,
      periodStart:
          data.periodStart.present ? data.periodStart.value : this.periodStart,
      periodEnd: data.periodEnd.present ? data.periodEnd.value : this.periodEnd,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonitoringCoverageRecord(')
          ..write('id: $id, ')
          ..write('cseId: $cseId, ')
          ..write('logSourceCategory: $logSourceCategory, ')
          ..write('isExpected: $isExpected, ')
          ..write('isActive: $isActive, ')
          ..write('lastReceivedAt: $lastReceivedAt, ')
          ..write('coveragePercentage: $coveragePercentage, ')
          ..write('periodStart: $periodStart, ')
          ..write('periodEnd: $periodEnd, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      cseId,
      logSourceCategory,
      isExpected,
      isActive,
      lastReceivedAt,
      coveragePercentage,
      periodStart,
      periodEnd,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonitoringCoverageRecord &&
          other.id == this.id &&
          other.cseId == this.cseId &&
          other.logSourceCategory == this.logSourceCategory &&
          other.isExpected == this.isExpected &&
          other.isActive == this.isActive &&
          other.lastReceivedAt == this.lastReceivedAt &&
          other.coveragePercentage == this.coveragePercentage &&
          other.periodStart == this.periodStart &&
          other.periodEnd == this.periodEnd &&
          other.createdAt == this.createdAt);
}

class MonitoringCoveragesCompanion
    extends UpdateCompanion<MonitoringCoverageRecord> {
  final Value<String> id;
  final Value<String> cseId;
  final Value<String> logSourceCategory;
  final Value<bool> isExpected;
  final Value<bool> isActive;
  final Value<DateTime?> lastReceivedAt;
  final Value<double?> coveragePercentage;
  final Value<DateTime?> periodStart;
  final Value<DateTime?> periodEnd;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MonitoringCoveragesCompanion({
    this.id = const Value.absent(),
    this.cseId = const Value.absent(),
    this.logSourceCategory = const Value.absent(),
    this.isExpected = const Value.absent(),
    this.isActive = const Value.absent(),
    this.lastReceivedAt = const Value.absent(),
    this.coveragePercentage = const Value.absent(),
    this.periodStart = const Value.absent(),
    this.periodEnd = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MonitoringCoveragesCompanion.insert({
    required String id,
    required String cseId,
    required String logSourceCategory,
    this.isExpected = const Value.absent(),
    this.isActive = const Value.absent(),
    this.lastReceivedAt = const Value.absent(),
    this.coveragePercentage = const Value.absent(),
    this.periodStart = const Value.absent(),
    this.periodEnd = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        cseId = Value(cseId),
        logSourceCategory = Value(logSourceCategory),
        createdAt = Value(createdAt);
  static Insertable<MonitoringCoverageRecord> custom({
    Expression<String>? id,
    Expression<String>? cseId,
    Expression<String>? logSourceCategory,
    Expression<bool>? isExpected,
    Expression<bool>? isActive,
    Expression<DateTime>? lastReceivedAt,
    Expression<double>? coveragePercentage,
    Expression<DateTime>? periodStart,
    Expression<DateTime>? periodEnd,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cseId != null) 'cse_id': cseId,
      if (logSourceCategory != null) 'log_source_category': logSourceCategory,
      if (isExpected != null) 'is_expected': isExpected,
      if (isActive != null) 'is_active': isActive,
      if (lastReceivedAt != null) 'last_received_at': lastReceivedAt,
      if (coveragePercentage != null) 'coverage_percentage': coveragePercentage,
      if (periodStart != null) 'period_start': periodStart,
      if (periodEnd != null) 'period_end': periodEnd,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MonitoringCoveragesCompanion copyWith(
      {Value<String>? id,
      Value<String>? cseId,
      Value<String>? logSourceCategory,
      Value<bool>? isExpected,
      Value<bool>? isActive,
      Value<DateTime?>? lastReceivedAt,
      Value<double?>? coveragePercentage,
      Value<DateTime?>? periodStart,
      Value<DateTime?>? periodEnd,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return MonitoringCoveragesCompanion(
      id: id ?? this.id,
      cseId: cseId ?? this.cseId,
      logSourceCategory: logSourceCategory ?? this.logSourceCategory,
      isExpected: isExpected ?? this.isExpected,
      isActive: isActive ?? this.isActive,
      lastReceivedAt: lastReceivedAt ?? this.lastReceivedAt,
      coveragePercentage: coveragePercentage ?? this.coveragePercentage,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cseId.present) {
      map['cse_id'] = Variable<String>(cseId.value);
    }
    if (logSourceCategory.present) {
      map['log_source_category'] = Variable<String>(logSourceCategory.value);
    }
    if (isExpected.present) {
      map['is_expected'] = Variable<bool>(isExpected.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (lastReceivedAt.present) {
      map['last_received_at'] = Variable<DateTime>(lastReceivedAt.value);
    }
    if (coveragePercentage.present) {
      map['coverage_percentage'] = Variable<double>(coveragePercentage.value);
    }
    if (periodStart.present) {
      map['period_start'] = Variable<DateTime>(periodStart.value);
    }
    if (periodEnd.present) {
      map['period_end'] = Variable<DateTime>(periodEnd.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonitoringCoveragesCompanion(')
          ..write('id: $id, ')
          ..write('cseId: $cseId, ')
          ..write('logSourceCategory: $logSourceCategory, ')
          ..write('isExpected: $isExpected, ')
          ..write('isActive: $isActive, ')
          ..write('lastReceivedAt: $lastReceivedAt, ')
          ..write('coveragePercentage: $coveragePercentage, ')
          ..write('periodStart: $periodStart, ')
          ..write('periodEnd: $periodEnd, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FindingEvidencesTable extends FindingEvidences
    with TableInfo<$FindingEvidencesTable, FindingEvidenceRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FindingEvidencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _findingIdMeta =
      const VerificationMeta('findingId');
  @override
  late final GeneratedColumn<String> findingId = GeneratedColumn<String>(
      'finding_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES findings (id) ON DELETE CASCADE'));
  static const VerificationMeta _evidenceTypeMeta =
      const VerificationMeta('evidenceType');
  @override
  late final GeneratedColumn<String> evidenceType = GeneratedColumn<String>(
      'evidence_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _alertIdMeta =
      const VerificationMeta('alertId');
  @override
  late final GeneratedColumn<String> alertId = GeneratedColumn<String>(
      'alert_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES alerts (id) ON DELETE SET NULL'));
  static const VerificationMeta _caseIdMeta = const VerificationMeta('caseId');
  @override
  late final GeneratedColumn<String> caseId = GeneratedColumn<String>(
      'case_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES cases (id) ON DELETE SET NULL'));
  static const VerificationMeta _investigationIdMeta =
      const VerificationMeta('investigationId');
  @override
  late final GeneratedColumn<String> investigationId = GeneratedColumn<String>(
      'investigation_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES investigations (id) ON DELETE SET NULL'));
  static const VerificationMeta _escalationIdMeta =
      const VerificationMeta('escalationId');
  @override
  late final GeneratedColumn<String> escalationId = GeneratedColumn<String>(
      'escalation_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES escalations (id) ON DELETE SET NULL'));
  static const VerificationMeta _coverageIdMeta =
      const VerificationMeta('coverageId');
  @override
  late final GeneratedColumn<String> coverageId = GeneratedColumn<String>(
      'coverage_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES monitoring_coverages (id) ON DELETE SET NULL'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        findingId,
        evidenceType,
        alertId,
        caseId,
        investigationId,
        escalationId,
        coverageId,
        notes,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'finding_evidences';
  @override
  VerificationContext validateIntegrity(
      Insertable<FindingEvidenceRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('finding_id')) {
      context.handle(_findingIdMeta,
          findingId.isAcceptableOrUnknown(data['finding_id']!, _findingIdMeta));
    } else if (isInserting) {
      context.missing(_findingIdMeta);
    }
    if (data.containsKey('evidence_type')) {
      context.handle(
          _evidenceTypeMeta,
          evidenceType.isAcceptableOrUnknown(
              data['evidence_type']!, _evidenceTypeMeta));
    } else if (isInserting) {
      context.missing(_evidenceTypeMeta);
    }
    if (data.containsKey('alert_id')) {
      context.handle(_alertIdMeta,
          alertId.isAcceptableOrUnknown(data['alert_id']!, _alertIdMeta));
    }
    if (data.containsKey('case_id')) {
      context.handle(_caseIdMeta,
          caseId.isAcceptableOrUnknown(data['case_id']!, _caseIdMeta));
    }
    if (data.containsKey('investigation_id')) {
      context.handle(
          _investigationIdMeta,
          investigationId.isAcceptableOrUnknown(
              data['investigation_id']!, _investigationIdMeta));
    }
    if (data.containsKey('escalation_id')) {
      context.handle(
          _escalationIdMeta,
          escalationId.isAcceptableOrUnknown(
              data['escalation_id']!, _escalationIdMeta));
    }
    if (data.containsKey('coverage_id')) {
      context.handle(
          _coverageIdMeta,
          coverageId.isAcceptableOrUnknown(
              data['coverage_id']!, _coverageIdMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FindingEvidenceRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FindingEvidenceRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      findingId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}finding_id'])!,
      evidenceType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}evidence_type'])!,
      alertId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alert_id']),
      caseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}case_id']),
      investigationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}investigation_id']),
      escalationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}escalation_id']),
      coverageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}coverage_id']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $FindingEvidencesTable createAlias(String alias) {
    return $FindingEvidencesTable(attachedDatabase, alias);
  }
}

class FindingEvidenceRecord extends DataClass
    implements Insertable<FindingEvidenceRecord> {
  final String id;
  final String findingId;
  final String evidenceType;
  final String? alertId;
  final String? caseId;
  final String? investigationId;
  final String? escalationId;
  final String? coverageId;
  final String? notes;
  final DateTime createdAt;
  const FindingEvidenceRecord(
      {required this.id,
      required this.findingId,
      required this.evidenceType,
      this.alertId,
      this.caseId,
      this.investigationId,
      this.escalationId,
      this.coverageId,
      this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['finding_id'] = Variable<String>(findingId);
    map['evidence_type'] = Variable<String>(evidenceType);
    if (!nullToAbsent || alertId != null) {
      map['alert_id'] = Variable<String>(alertId);
    }
    if (!nullToAbsent || caseId != null) {
      map['case_id'] = Variable<String>(caseId);
    }
    if (!nullToAbsent || investigationId != null) {
      map['investigation_id'] = Variable<String>(investigationId);
    }
    if (!nullToAbsent || escalationId != null) {
      map['escalation_id'] = Variable<String>(escalationId);
    }
    if (!nullToAbsent || coverageId != null) {
      map['coverage_id'] = Variable<String>(coverageId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FindingEvidencesCompanion toCompanion(bool nullToAbsent) {
    return FindingEvidencesCompanion(
      id: Value(id),
      findingId: Value(findingId),
      evidenceType: Value(evidenceType),
      alertId: alertId == null && nullToAbsent
          ? const Value.absent()
          : Value(alertId),
      caseId:
          caseId == null && nullToAbsent ? const Value.absent() : Value(caseId),
      investigationId: investigationId == null && nullToAbsent
          ? const Value.absent()
          : Value(investigationId),
      escalationId: escalationId == null && nullToAbsent
          ? const Value.absent()
          : Value(escalationId),
      coverageId: coverageId == null && nullToAbsent
          ? const Value.absent()
          : Value(coverageId),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory FindingEvidenceRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FindingEvidenceRecord(
      id: serializer.fromJson<String>(json['id']),
      findingId: serializer.fromJson<String>(json['findingId']),
      evidenceType: serializer.fromJson<String>(json['evidenceType']),
      alertId: serializer.fromJson<String?>(json['alertId']),
      caseId: serializer.fromJson<String?>(json['caseId']),
      investigationId: serializer.fromJson<String?>(json['investigationId']),
      escalationId: serializer.fromJson<String?>(json['escalationId']),
      coverageId: serializer.fromJson<String?>(json['coverageId']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'findingId': serializer.toJson<String>(findingId),
      'evidenceType': serializer.toJson<String>(evidenceType),
      'alertId': serializer.toJson<String?>(alertId),
      'caseId': serializer.toJson<String?>(caseId),
      'investigationId': serializer.toJson<String?>(investigationId),
      'escalationId': serializer.toJson<String?>(escalationId),
      'coverageId': serializer.toJson<String?>(coverageId),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FindingEvidenceRecord copyWith(
          {String? id,
          String? findingId,
          String? evidenceType,
          Value<String?> alertId = const Value.absent(),
          Value<String?> caseId = const Value.absent(),
          Value<String?> investigationId = const Value.absent(),
          Value<String?> escalationId = const Value.absent(),
          Value<String?> coverageId = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      FindingEvidenceRecord(
        id: id ?? this.id,
        findingId: findingId ?? this.findingId,
        evidenceType: evidenceType ?? this.evidenceType,
        alertId: alertId.present ? alertId.value : this.alertId,
        caseId: caseId.present ? caseId.value : this.caseId,
        investigationId: investigationId.present
            ? investigationId.value
            : this.investigationId,
        escalationId:
            escalationId.present ? escalationId.value : this.escalationId,
        coverageId: coverageId.present ? coverageId.value : this.coverageId,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  FindingEvidenceRecord copyWithCompanion(FindingEvidencesCompanion data) {
    return FindingEvidenceRecord(
      id: data.id.present ? data.id.value : this.id,
      findingId: data.findingId.present ? data.findingId.value : this.findingId,
      evidenceType: data.evidenceType.present
          ? data.evidenceType.value
          : this.evidenceType,
      alertId: data.alertId.present ? data.alertId.value : this.alertId,
      caseId: data.caseId.present ? data.caseId.value : this.caseId,
      investigationId: data.investigationId.present
          ? data.investigationId.value
          : this.investigationId,
      escalationId: data.escalationId.present
          ? data.escalationId.value
          : this.escalationId,
      coverageId:
          data.coverageId.present ? data.coverageId.value : this.coverageId,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FindingEvidenceRecord(')
          ..write('id: $id, ')
          ..write('findingId: $findingId, ')
          ..write('evidenceType: $evidenceType, ')
          ..write('alertId: $alertId, ')
          ..write('caseId: $caseId, ')
          ..write('investigationId: $investigationId, ')
          ..write('escalationId: $escalationId, ')
          ..write('coverageId: $coverageId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, findingId, evidenceType, alertId, caseId,
      investigationId, escalationId, coverageId, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FindingEvidenceRecord &&
          other.id == this.id &&
          other.findingId == this.findingId &&
          other.evidenceType == this.evidenceType &&
          other.alertId == this.alertId &&
          other.caseId == this.caseId &&
          other.investigationId == this.investigationId &&
          other.escalationId == this.escalationId &&
          other.coverageId == this.coverageId &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class FindingEvidencesCompanion extends UpdateCompanion<FindingEvidenceRecord> {
  final Value<String> id;
  final Value<String> findingId;
  final Value<String> evidenceType;
  final Value<String?> alertId;
  final Value<String?> caseId;
  final Value<String?> investigationId;
  final Value<String?> escalationId;
  final Value<String?> coverageId;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const FindingEvidencesCompanion({
    this.id = const Value.absent(),
    this.findingId = const Value.absent(),
    this.evidenceType = const Value.absent(),
    this.alertId = const Value.absent(),
    this.caseId = const Value.absent(),
    this.investigationId = const Value.absent(),
    this.escalationId = const Value.absent(),
    this.coverageId = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FindingEvidencesCompanion.insert({
    required String id,
    required String findingId,
    required String evidenceType,
    this.alertId = const Value.absent(),
    this.caseId = const Value.absent(),
    this.investigationId = const Value.absent(),
    this.escalationId = const Value.absent(),
    this.coverageId = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        findingId = Value(findingId),
        evidenceType = Value(evidenceType),
        createdAt = Value(createdAt);
  static Insertable<FindingEvidenceRecord> custom({
    Expression<String>? id,
    Expression<String>? findingId,
    Expression<String>? evidenceType,
    Expression<String>? alertId,
    Expression<String>? caseId,
    Expression<String>? investigationId,
    Expression<String>? escalationId,
    Expression<String>? coverageId,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (findingId != null) 'finding_id': findingId,
      if (evidenceType != null) 'evidence_type': evidenceType,
      if (alertId != null) 'alert_id': alertId,
      if (caseId != null) 'case_id': caseId,
      if (investigationId != null) 'investigation_id': investigationId,
      if (escalationId != null) 'escalation_id': escalationId,
      if (coverageId != null) 'coverage_id': coverageId,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FindingEvidencesCompanion copyWith(
      {Value<String>? id,
      Value<String>? findingId,
      Value<String>? evidenceType,
      Value<String?>? alertId,
      Value<String?>? caseId,
      Value<String?>? investigationId,
      Value<String?>? escalationId,
      Value<String?>? coverageId,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return FindingEvidencesCompanion(
      id: id ?? this.id,
      findingId: findingId ?? this.findingId,
      evidenceType: evidenceType ?? this.evidenceType,
      alertId: alertId ?? this.alertId,
      caseId: caseId ?? this.caseId,
      investigationId: investigationId ?? this.investigationId,
      escalationId: escalationId ?? this.escalationId,
      coverageId: coverageId ?? this.coverageId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (findingId.present) {
      map['finding_id'] = Variable<String>(findingId.value);
    }
    if (evidenceType.present) {
      map['evidence_type'] = Variable<String>(evidenceType.value);
    }
    if (alertId.present) {
      map['alert_id'] = Variable<String>(alertId.value);
    }
    if (caseId.present) {
      map['case_id'] = Variable<String>(caseId.value);
    }
    if (investigationId.present) {
      map['investigation_id'] = Variable<String>(investigationId.value);
    }
    if (escalationId.present) {
      map['escalation_id'] = Variable<String>(escalationId.value);
    }
    if (coverageId.present) {
      map['coverage_id'] = Variable<String>(coverageId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FindingEvidencesCompanion(')
          ..write('id: $id, ')
          ..write('findingId: $findingId, ')
          ..write('evidenceType: $evidenceType, ')
          ..write('alertId: $alertId, ')
          ..write('caseId: $caseId, ')
          ..write('investigationId: $investigationId, ')
          ..write('escalationId: $escalationId, ')
          ..write('coverageId: $coverageId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FindingReviewHistoriesTable extends FindingReviewHistories
    with TableInfo<$FindingReviewHistoriesTable, FindingReviewHistoryRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FindingReviewHistoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _findingIdMeta =
      const VerificationMeta('findingId');
  @override
  late final GeneratedColumn<String> findingId = GeneratedColumn<String>(
      'finding_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES findings (id) ON DELETE RESTRICT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cseIdMeta = const VerificationMeta('cseId');
  @override
  late final GeneratedColumn<String> cseId = GeneratedColumn<String>(
      'cse_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES cses (id) ON DELETE RESTRICT'));
  static const VerificationMeta _actionTypeMeta =
      const VerificationMeta('actionType');
  @override
  late final GeneratedColumn<String> actionType = GeneratedColumn<String>(
      'action_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _previousStatusMeta =
      const VerificationMeta('previousStatus');
  @override
  late final GeneratedColumn<String> previousStatus = GeneratedColumn<String>(
      'previous_status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _newStatusMeta =
      const VerificationMeta('newStatus');
  @override
  late final GeneratedColumn<String> newStatus = GeneratedColumn<String>(
      'new_status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _noteTextMeta =
      const VerificationMeta('noteText');
  @override
  late final GeneratedColumn<String> noteText = GeneratedColumn<String>(
      'note_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _evidenceRequestDetailsMeta =
      const VerificationMeta('evidenceRequestDetails');
  @override
  late final GeneratedColumn<String> evidenceRequestDetails =
      GeneratedColumn<String>('evidence_request_details', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        findingId,
        userId,
        cseId,
        actionType,
        previousStatus,
        newStatus,
        noteText,
        evidenceRequestDetails,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'finding_review_histories';
  @override
  VerificationContext validateIntegrity(
      Insertable<FindingReviewHistoryRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('finding_id')) {
      context.handle(_findingIdMeta,
          findingId.isAcceptableOrUnknown(data['finding_id']!, _findingIdMeta));
    } else if (isInserting) {
      context.missing(_findingIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('cse_id')) {
      context.handle(
          _cseIdMeta, cseId.isAcceptableOrUnknown(data['cse_id']!, _cseIdMeta));
    } else if (isInserting) {
      context.missing(_cseIdMeta);
    }
    if (data.containsKey('action_type')) {
      context.handle(
          _actionTypeMeta,
          actionType.isAcceptableOrUnknown(
              data['action_type']!, _actionTypeMeta));
    } else if (isInserting) {
      context.missing(_actionTypeMeta);
    }
    if (data.containsKey('previous_status')) {
      context.handle(
          _previousStatusMeta,
          previousStatus.isAcceptableOrUnknown(
              data['previous_status']!, _previousStatusMeta));
    }
    if (data.containsKey('new_status')) {
      context.handle(_newStatusMeta,
          newStatus.isAcceptableOrUnknown(data['new_status']!, _newStatusMeta));
    }
    if (data.containsKey('note_text')) {
      context.handle(_noteTextMeta,
          noteText.isAcceptableOrUnknown(data['note_text']!, _noteTextMeta));
    }
    if (data.containsKey('evidence_request_details')) {
      context.handle(
          _evidenceRequestDetailsMeta,
          evidenceRequestDetails.isAcceptableOrUnknown(
              data['evidence_request_details']!, _evidenceRequestDetailsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FindingReviewHistoryRecord map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FindingReviewHistoryRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      findingId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}finding_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      cseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cse_id'])!,
      actionType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action_type'])!,
      previousStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}previous_status']),
      newStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}new_status']),
      noteText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note_text']),
      evidenceRequestDetails: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}evidence_request_details']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $FindingReviewHistoriesTable createAlias(String alias) {
    return $FindingReviewHistoriesTable(attachedDatabase, alias);
  }
}

class FindingReviewHistoryRecord extends DataClass
    implements Insertable<FindingReviewHistoryRecord> {
  final String id;
  final String findingId;
  final String? userId;
  final String cseId;
  final String actionType;
  final String? previousStatus;
  final String? newStatus;
  final String? noteText;
  final String? evidenceRequestDetails;
  final DateTime createdAt;
  const FindingReviewHistoryRecord(
      {required this.id,
      required this.findingId,
      this.userId,
      required this.cseId,
      required this.actionType,
      this.previousStatus,
      this.newStatus,
      this.noteText,
      this.evidenceRequestDetails,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['finding_id'] = Variable<String>(findingId);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['cse_id'] = Variable<String>(cseId);
    map['action_type'] = Variable<String>(actionType);
    if (!nullToAbsent || previousStatus != null) {
      map['previous_status'] = Variable<String>(previousStatus);
    }
    if (!nullToAbsent || newStatus != null) {
      map['new_status'] = Variable<String>(newStatus);
    }
    if (!nullToAbsent || noteText != null) {
      map['note_text'] = Variable<String>(noteText);
    }
    if (!nullToAbsent || evidenceRequestDetails != null) {
      map['evidence_request_details'] =
          Variable<String>(evidenceRequestDetails);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FindingReviewHistoriesCompanion toCompanion(bool nullToAbsent) {
    return FindingReviewHistoriesCompanion(
      id: Value(id),
      findingId: Value(findingId),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      cseId: Value(cseId),
      actionType: Value(actionType),
      previousStatus: previousStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(previousStatus),
      newStatus: newStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(newStatus),
      noteText: noteText == null && nullToAbsent
          ? const Value.absent()
          : Value(noteText),
      evidenceRequestDetails: evidenceRequestDetails == null && nullToAbsent
          ? const Value.absent()
          : Value(evidenceRequestDetails),
      createdAt: Value(createdAt),
    );
  }

  factory FindingReviewHistoryRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FindingReviewHistoryRecord(
      id: serializer.fromJson<String>(json['id']),
      findingId: serializer.fromJson<String>(json['findingId']),
      userId: serializer.fromJson<String?>(json['userId']),
      cseId: serializer.fromJson<String>(json['cseId']),
      actionType: serializer.fromJson<String>(json['actionType']),
      previousStatus: serializer.fromJson<String?>(json['previousStatus']),
      newStatus: serializer.fromJson<String?>(json['newStatus']),
      noteText: serializer.fromJson<String?>(json['noteText']),
      evidenceRequestDetails:
          serializer.fromJson<String?>(json['evidenceRequestDetails']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'findingId': serializer.toJson<String>(findingId),
      'userId': serializer.toJson<String?>(userId),
      'cseId': serializer.toJson<String>(cseId),
      'actionType': serializer.toJson<String>(actionType),
      'previousStatus': serializer.toJson<String?>(previousStatus),
      'newStatus': serializer.toJson<String?>(newStatus),
      'noteText': serializer.toJson<String?>(noteText),
      'evidenceRequestDetails':
          serializer.toJson<String?>(evidenceRequestDetails),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FindingReviewHistoryRecord copyWith(
          {String? id,
          String? findingId,
          Value<String?> userId = const Value.absent(),
          String? cseId,
          String? actionType,
          Value<String?> previousStatus = const Value.absent(),
          Value<String?> newStatus = const Value.absent(),
          Value<String?> noteText = const Value.absent(),
          Value<String?> evidenceRequestDetails = const Value.absent(),
          DateTime? createdAt}) =>
      FindingReviewHistoryRecord(
        id: id ?? this.id,
        findingId: findingId ?? this.findingId,
        userId: userId.present ? userId.value : this.userId,
        cseId: cseId ?? this.cseId,
        actionType: actionType ?? this.actionType,
        previousStatus:
            previousStatus.present ? previousStatus.value : this.previousStatus,
        newStatus: newStatus.present ? newStatus.value : this.newStatus,
        noteText: noteText.present ? noteText.value : this.noteText,
        evidenceRequestDetails: evidenceRequestDetails.present
            ? evidenceRequestDetails.value
            : this.evidenceRequestDetails,
        createdAt: createdAt ?? this.createdAt,
      );
  FindingReviewHistoryRecord copyWithCompanion(
      FindingReviewHistoriesCompanion data) {
    return FindingReviewHistoryRecord(
      id: data.id.present ? data.id.value : this.id,
      findingId: data.findingId.present ? data.findingId.value : this.findingId,
      userId: data.userId.present ? data.userId.value : this.userId,
      cseId: data.cseId.present ? data.cseId.value : this.cseId,
      actionType:
          data.actionType.present ? data.actionType.value : this.actionType,
      previousStatus: data.previousStatus.present
          ? data.previousStatus.value
          : this.previousStatus,
      newStatus: data.newStatus.present ? data.newStatus.value : this.newStatus,
      noteText: data.noteText.present ? data.noteText.value : this.noteText,
      evidenceRequestDetails: data.evidenceRequestDetails.present
          ? data.evidenceRequestDetails.value
          : this.evidenceRequestDetails,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FindingReviewHistoryRecord(')
          ..write('id: $id, ')
          ..write('findingId: $findingId, ')
          ..write('userId: $userId, ')
          ..write('cseId: $cseId, ')
          ..write('actionType: $actionType, ')
          ..write('previousStatus: $previousStatus, ')
          ..write('newStatus: $newStatus, ')
          ..write('noteText: $noteText, ')
          ..write('evidenceRequestDetails: $evidenceRequestDetails, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, findingId, userId, cseId, actionType,
      previousStatus, newStatus, noteText, evidenceRequestDetails, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FindingReviewHistoryRecord &&
          other.id == this.id &&
          other.findingId == this.findingId &&
          other.userId == this.userId &&
          other.cseId == this.cseId &&
          other.actionType == this.actionType &&
          other.previousStatus == this.previousStatus &&
          other.newStatus == this.newStatus &&
          other.noteText == this.noteText &&
          other.evidenceRequestDetails == this.evidenceRequestDetails &&
          other.createdAt == this.createdAt);
}

class FindingReviewHistoriesCompanion
    extends UpdateCompanion<FindingReviewHistoryRecord> {
  final Value<String> id;
  final Value<String> findingId;
  final Value<String?> userId;
  final Value<String> cseId;
  final Value<String> actionType;
  final Value<String?> previousStatus;
  final Value<String?> newStatus;
  final Value<String?> noteText;
  final Value<String?> evidenceRequestDetails;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const FindingReviewHistoriesCompanion({
    this.id = const Value.absent(),
    this.findingId = const Value.absent(),
    this.userId = const Value.absent(),
    this.cseId = const Value.absent(),
    this.actionType = const Value.absent(),
    this.previousStatus = const Value.absent(),
    this.newStatus = const Value.absent(),
    this.noteText = const Value.absent(),
    this.evidenceRequestDetails = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FindingReviewHistoriesCompanion.insert({
    required String id,
    required String findingId,
    this.userId = const Value.absent(),
    required String cseId,
    required String actionType,
    this.previousStatus = const Value.absent(),
    this.newStatus = const Value.absent(),
    this.noteText = const Value.absent(),
    this.evidenceRequestDetails = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        findingId = Value(findingId),
        cseId = Value(cseId),
        actionType = Value(actionType),
        createdAt = Value(createdAt);
  static Insertable<FindingReviewHistoryRecord> custom({
    Expression<String>? id,
    Expression<String>? findingId,
    Expression<String>? userId,
    Expression<String>? cseId,
    Expression<String>? actionType,
    Expression<String>? previousStatus,
    Expression<String>? newStatus,
    Expression<String>? noteText,
    Expression<String>? evidenceRequestDetails,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (findingId != null) 'finding_id': findingId,
      if (userId != null) 'user_id': userId,
      if (cseId != null) 'cse_id': cseId,
      if (actionType != null) 'action_type': actionType,
      if (previousStatus != null) 'previous_status': previousStatus,
      if (newStatus != null) 'new_status': newStatus,
      if (noteText != null) 'note_text': noteText,
      if (evidenceRequestDetails != null)
        'evidence_request_details': evidenceRequestDetails,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FindingReviewHistoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? findingId,
      Value<String?>? userId,
      Value<String>? cseId,
      Value<String>? actionType,
      Value<String?>? previousStatus,
      Value<String?>? newStatus,
      Value<String?>? noteText,
      Value<String?>? evidenceRequestDetails,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return FindingReviewHistoriesCompanion(
      id: id ?? this.id,
      findingId: findingId ?? this.findingId,
      userId: userId ?? this.userId,
      cseId: cseId ?? this.cseId,
      actionType: actionType ?? this.actionType,
      previousStatus: previousStatus ?? this.previousStatus,
      newStatus: newStatus ?? this.newStatus,
      noteText: noteText ?? this.noteText,
      evidenceRequestDetails:
          evidenceRequestDetails ?? this.evidenceRequestDetails,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (findingId.present) {
      map['finding_id'] = Variable<String>(findingId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (cseId.present) {
      map['cse_id'] = Variable<String>(cseId.value);
    }
    if (actionType.present) {
      map['action_type'] = Variable<String>(actionType.value);
    }
    if (previousStatus.present) {
      map['previous_status'] = Variable<String>(previousStatus.value);
    }
    if (newStatus.present) {
      map['new_status'] = Variable<String>(newStatus.value);
    }
    if (noteText.present) {
      map['note_text'] = Variable<String>(noteText.value);
    }
    if (evidenceRequestDetails.present) {
      map['evidence_request_details'] =
          Variable<String>(evidenceRequestDetails.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FindingReviewHistoriesCompanion(')
          ..write('id: $id, ')
          ..write('findingId: $findingId, ')
          ..write('userId: $userId, ')
          ..write('cseId: $cseId, ')
          ..write('actionType: $actionType, ')
          ..write('previousStatus: $previousStatus, ')
          ..write('newStatus: $newStatus, ')
          ..write('noteText: $noteText, ')
          ..write('evidenceRequestDetails: $evidenceRequestDetails, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReportRecordsTable extends ReportRecords
    with TableInfo<$ReportRecordsTable, ReportRecordData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReportRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reportCodeMeta =
      const VerificationMeta('reportCode');
  @override
  late final GeneratedColumn<String> reportCode = GeneratedColumn<String>(
      'report_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cseIdMeta = const VerificationMeta('cseId');
  @override
  late final GeneratedColumn<String> cseId = GeneratedColumn<String>(
      'cse_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES cses (id) ON DELETE RESTRICT'));
  static const VerificationMeta _assessmentIdMeta =
      const VerificationMeta('assessmentId');
  @override
  late final GeneratedColumn<String> assessmentId = GeneratedColumn<String>(
      'assessment_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES assessments (id) ON DELETE RESTRICT'));
  static const VerificationMeta _datasetVersionIdMeta =
      const VerificationMeta('datasetVersionId');
  @override
  late final GeneratedColumn<String> datasetVersionId = GeneratedColumn<String>(
      'dataset_version_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES dataset_versions (id) ON DELETE RESTRICT'));
  static const VerificationMeta _analysisRunIdMeta =
      const VerificationMeta('analysisRunId');
  @override
  late final GeneratedColumn<String> analysisRunId = GeneratedColumn<String>(
      'analysis_run_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES analysis_runs (id) ON DELETE RESTRICT'));
  static const VerificationMeta _obsStartMeta =
      const VerificationMeta('obsStart');
  @override
  late final GeneratedColumn<DateTime> obsStart = GeneratedColumn<DateTime>(
      'obs_start', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _obsEndMeta = const VerificationMeta('obsEnd');
  @override
  late final GeneratedColumn<DateTime> obsEnd = GeneratedColumn<DateTime>(
      'obs_end', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _generatedByUserIdMeta =
      const VerificationMeta('generatedByUserId');
  @override
  late final GeneratedColumn<String> generatedByUserId =
      GeneratedColumn<String>('generated_by_user_id', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _summaryJsonMeta =
      const VerificationMeta('summaryJson');
  @override
  late final GeneratedColumn<String> summaryJson = GeneratedColumn<String>(
      'summary_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _metadataJsonMeta =
      const VerificationMeta('metadataJson');
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
      'metadata_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        reportCode,
        cseId,
        assessmentId,
        datasetVersionId,
        analysisRunId,
        obsStart,
        obsEnd,
        generatedByUserId,
        createdAt,
        summaryJson,
        metadataJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'report_records';
  @override
  VerificationContext validateIntegrity(Insertable<ReportRecordData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('report_code')) {
      context.handle(
          _reportCodeMeta,
          reportCode.isAcceptableOrUnknown(
              data['report_code']!, _reportCodeMeta));
    } else if (isInserting) {
      context.missing(_reportCodeMeta);
    }
    if (data.containsKey('cse_id')) {
      context.handle(
          _cseIdMeta, cseId.isAcceptableOrUnknown(data['cse_id']!, _cseIdMeta));
    } else if (isInserting) {
      context.missing(_cseIdMeta);
    }
    if (data.containsKey('assessment_id')) {
      context.handle(
          _assessmentIdMeta,
          assessmentId.isAcceptableOrUnknown(
              data['assessment_id']!, _assessmentIdMeta));
    }
    if (data.containsKey('dataset_version_id')) {
      context.handle(
          _datasetVersionIdMeta,
          datasetVersionId.isAcceptableOrUnknown(
              data['dataset_version_id']!, _datasetVersionIdMeta));
    }
    if (data.containsKey('analysis_run_id')) {
      context.handle(
          _analysisRunIdMeta,
          analysisRunId.isAcceptableOrUnknown(
              data['analysis_run_id']!, _analysisRunIdMeta));
    }
    if (data.containsKey('obs_start')) {
      context.handle(_obsStartMeta,
          obsStart.isAcceptableOrUnknown(data['obs_start']!, _obsStartMeta));
    }
    if (data.containsKey('obs_end')) {
      context.handle(_obsEndMeta,
          obsEnd.isAcceptableOrUnknown(data['obs_end']!, _obsEndMeta));
    }
    if (data.containsKey('generated_by_user_id')) {
      context.handle(
          _generatedByUserIdMeta,
          generatedByUserId.isAcceptableOrUnknown(
              data['generated_by_user_id']!, _generatedByUserIdMeta));
    } else if (isInserting) {
      context.missing(_generatedByUserIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('summary_json')) {
      context.handle(
          _summaryJsonMeta,
          summaryJson.isAcceptableOrUnknown(
              data['summary_json']!, _summaryJsonMeta));
    } else if (isInserting) {
      context.missing(_summaryJsonMeta);
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
          _metadataJsonMeta,
          metadataJson.isAcceptableOrUnknown(
              data['metadata_json']!, _metadataJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {reportCode},
      ];
  @override
  ReportRecordData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReportRecordData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      reportCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}report_code'])!,
      cseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cse_id'])!,
      assessmentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}assessment_id']),
      datasetVersionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}dataset_version_id']),
      analysisRunId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}analysis_run_id']),
      obsStart: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}obs_start']),
      obsEnd: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}obs_end']),
      generatedByUserId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}generated_by_user_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      summaryJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary_json'])!,
      metadataJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata_json']),
    );
  }

  @override
  $ReportRecordsTable createAlias(String alias) {
    return $ReportRecordsTable(attachedDatabase, alias);
  }
}

class ReportRecordData extends DataClass
    implements Insertable<ReportRecordData> {
  final String id;
  final String reportCode;
  final String cseId;
  final String? assessmentId;
  final String? datasetVersionId;
  final String? analysisRunId;
  final DateTime? obsStart;
  final DateTime? obsEnd;
  final String generatedByUserId;
  final DateTime createdAt;
  final String summaryJson;
  final String? metadataJson;
  const ReportRecordData(
      {required this.id,
      required this.reportCode,
      required this.cseId,
      this.assessmentId,
      this.datasetVersionId,
      this.analysisRunId,
      this.obsStart,
      this.obsEnd,
      required this.generatedByUserId,
      required this.createdAt,
      required this.summaryJson,
      this.metadataJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['report_code'] = Variable<String>(reportCode);
    map['cse_id'] = Variable<String>(cseId);
    if (!nullToAbsent || assessmentId != null) {
      map['assessment_id'] = Variable<String>(assessmentId);
    }
    if (!nullToAbsent || datasetVersionId != null) {
      map['dataset_version_id'] = Variable<String>(datasetVersionId);
    }
    if (!nullToAbsent || analysisRunId != null) {
      map['analysis_run_id'] = Variable<String>(analysisRunId);
    }
    if (!nullToAbsent || obsStart != null) {
      map['obs_start'] = Variable<DateTime>(obsStart);
    }
    if (!nullToAbsent || obsEnd != null) {
      map['obs_end'] = Variable<DateTime>(obsEnd);
    }
    map['generated_by_user_id'] = Variable<String>(generatedByUserId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['summary_json'] = Variable<String>(summaryJson);
    if (!nullToAbsent || metadataJson != null) {
      map['metadata_json'] = Variable<String>(metadataJson);
    }
    return map;
  }

  ReportRecordsCompanion toCompanion(bool nullToAbsent) {
    return ReportRecordsCompanion(
      id: Value(id),
      reportCode: Value(reportCode),
      cseId: Value(cseId),
      assessmentId: assessmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(assessmentId),
      datasetVersionId: datasetVersionId == null && nullToAbsent
          ? const Value.absent()
          : Value(datasetVersionId),
      analysisRunId: analysisRunId == null && nullToAbsent
          ? const Value.absent()
          : Value(analysisRunId),
      obsStart: obsStart == null && nullToAbsent
          ? const Value.absent()
          : Value(obsStart),
      obsEnd:
          obsEnd == null && nullToAbsent ? const Value.absent() : Value(obsEnd),
      generatedByUserId: Value(generatedByUserId),
      createdAt: Value(createdAt),
      summaryJson: Value(summaryJson),
      metadataJson: metadataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(metadataJson),
    );
  }

  factory ReportRecordData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReportRecordData(
      id: serializer.fromJson<String>(json['id']),
      reportCode: serializer.fromJson<String>(json['reportCode']),
      cseId: serializer.fromJson<String>(json['cseId']),
      assessmentId: serializer.fromJson<String?>(json['assessmentId']),
      datasetVersionId: serializer.fromJson<String?>(json['datasetVersionId']),
      analysisRunId: serializer.fromJson<String?>(json['analysisRunId']),
      obsStart: serializer.fromJson<DateTime?>(json['obsStart']),
      obsEnd: serializer.fromJson<DateTime?>(json['obsEnd']),
      generatedByUserId: serializer.fromJson<String>(json['generatedByUserId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      summaryJson: serializer.fromJson<String>(json['summaryJson']),
      metadataJson: serializer.fromJson<String?>(json['metadataJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'reportCode': serializer.toJson<String>(reportCode),
      'cseId': serializer.toJson<String>(cseId),
      'assessmentId': serializer.toJson<String?>(assessmentId),
      'datasetVersionId': serializer.toJson<String?>(datasetVersionId),
      'analysisRunId': serializer.toJson<String?>(analysisRunId),
      'obsStart': serializer.toJson<DateTime?>(obsStart),
      'obsEnd': serializer.toJson<DateTime?>(obsEnd),
      'generatedByUserId': serializer.toJson<String>(generatedByUserId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'summaryJson': serializer.toJson<String>(summaryJson),
      'metadataJson': serializer.toJson<String?>(metadataJson),
    };
  }

  ReportRecordData copyWith(
          {String? id,
          String? reportCode,
          String? cseId,
          Value<String?> assessmentId = const Value.absent(),
          Value<String?> datasetVersionId = const Value.absent(),
          Value<String?> analysisRunId = const Value.absent(),
          Value<DateTime?> obsStart = const Value.absent(),
          Value<DateTime?> obsEnd = const Value.absent(),
          String? generatedByUserId,
          DateTime? createdAt,
          String? summaryJson,
          Value<String?> metadataJson = const Value.absent()}) =>
      ReportRecordData(
        id: id ?? this.id,
        reportCode: reportCode ?? this.reportCode,
        cseId: cseId ?? this.cseId,
        assessmentId:
            assessmentId.present ? assessmentId.value : this.assessmentId,
        datasetVersionId: datasetVersionId.present
            ? datasetVersionId.value
            : this.datasetVersionId,
        analysisRunId:
            analysisRunId.present ? analysisRunId.value : this.analysisRunId,
        obsStart: obsStart.present ? obsStart.value : this.obsStart,
        obsEnd: obsEnd.present ? obsEnd.value : this.obsEnd,
        generatedByUserId: generatedByUserId ?? this.generatedByUserId,
        createdAt: createdAt ?? this.createdAt,
        summaryJson: summaryJson ?? this.summaryJson,
        metadataJson:
            metadataJson.present ? metadataJson.value : this.metadataJson,
      );
  ReportRecordData copyWithCompanion(ReportRecordsCompanion data) {
    return ReportRecordData(
      id: data.id.present ? data.id.value : this.id,
      reportCode:
          data.reportCode.present ? data.reportCode.value : this.reportCode,
      cseId: data.cseId.present ? data.cseId.value : this.cseId,
      assessmentId: data.assessmentId.present
          ? data.assessmentId.value
          : this.assessmentId,
      datasetVersionId: data.datasetVersionId.present
          ? data.datasetVersionId.value
          : this.datasetVersionId,
      analysisRunId: data.analysisRunId.present
          ? data.analysisRunId.value
          : this.analysisRunId,
      obsStart: data.obsStart.present ? data.obsStart.value : this.obsStart,
      obsEnd: data.obsEnd.present ? data.obsEnd.value : this.obsEnd,
      generatedByUserId: data.generatedByUserId.present
          ? data.generatedByUserId.value
          : this.generatedByUserId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      summaryJson:
          data.summaryJson.present ? data.summaryJson.value : this.summaryJson,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReportRecordData(')
          ..write('id: $id, ')
          ..write('reportCode: $reportCode, ')
          ..write('cseId: $cseId, ')
          ..write('assessmentId: $assessmentId, ')
          ..write('datasetVersionId: $datasetVersionId, ')
          ..write('analysisRunId: $analysisRunId, ')
          ..write('obsStart: $obsStart, ')
          ..write('obsEnd: $obsEnd, ')
          ..write('generatedByUserId: $generatedByUserId, ')
          ..write('createdAt: $createdAt, ')
          ..write('summaryJson: $summaryJson, ')
          ..write('metadataJson: $metadataJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      reportCode,
      cseId,
      assessmentId,
      datasetVersionId,
      analysisRunId,
      obsStart,
      obsEnd,
      generatedByUserId,
      createdAt,
      summaryJson,
      metadataJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReportRecordData &&
          other.id == this.id &&
          other.reportCode == this.reportCode &&
          other.cseId == this.cseId &&
          other.assessmentId == this.assessmentId &&
          other.datasetVersionId == this.datasetVersionId &&
          other.analysisRunId == this.analysisRunId &&
          other.obsStart == this.obsStart &&
          other.obsEnd == this.obsEnd &&
          other.generatedByUserId == this.generatedByUserId &&
          other.createdAt == this.createdAt &&
          other.summaryJson == this.summaryJson &&
          other.metadataJson == this.metadataJson);
}

class ReportRecordsCompanion extends UpdateCompanion<ReportRecordData> {
  final Value<String> id;
  final Value<String> reportCode;
  final Value<String> cseId;
  final Value<String?> assessmentId;
  final Value<String?> datasetVersionId;
  final Value<String?> analysisRunId;
  final Value<DateTime?> obsStart;
  final Value<DateTime?> obsEnd;
  final Value<String> generatedByUserId;
  final Value<DateTime> createdAt;
  final Value<String> summaryJson;
  final Value<String?> metadataJson;
  final Value<int> rowid;
  const ReportRecordsCompanion({
    this.id = const Value.absent(),
    this.reportCode = const Value.absent(),
    this.cseId = const Value.absent(),
    this.assessmentId = const Value.absent(),
    this.datasetVersionId = const Value.absent(),
    this.analysisRunId = const Value.absent(),
    this.obsStart = const Value.absent(),
    this.obsEnd = const Value.absent(),
    this.generatedByUserId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.summaryJson = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReportRecordsCompanion.insert({
    required String id,
    required String reportCode,
    required String cseId,
    this.assessmentId = const Value.absent(),
    this.datasetVersionId = const Value.absent(),
    this.analysisRunId = const Value.absent(),
    this.obsStart = const Value.absent(),
    this.obsEnd = const Value.absent(),
    required String generatedByUserId,
    required DateTime createdAt,
    required String summaryJson,
    this.metadataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        reportCode = Value(reportCode),
        cseId = Value(cseId),
        generatedByUserId = Value(generatedByUserId),
        createdAt = Value(createdAt),
        summaryJson = Value(summaryJson);
  static Insertable<ReportRecordData> custom({
    Expression<String>? id,
    Expression<String>? reportCode,
    Expression<String>? cseId,
    Expression<String>? assessmentId,
    Expression<String>? datasetVersionId,
    Expression<String>? analysisRunId,
    Expression<DateTime>? obsStart,
    Expression<DateTime>? obsEnd,
    Expression<String>? generatedByUserId,
    Expression<DateTime>? createdAt,
    Expression<String>? summaryJson,
    Expression<String>? metadataJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reportCode != null) 'report_code': reportCode,
      if (cseId != null) 'cse_id': cseId,
      if (assessmentId != null) 'assessment_id': assessmentId,
      if (datasetVersionId != null) 'dataset_version_id': datasetVersionId,
      if (analysisRunId != null) 'analysis_run_id': analysisRunId,
      if (obsStart != null) 'obs_start': obsStart,
      if (obsEnd != null) 'obs_end': obsEnd,
      if (generatedByUserId != null) 'generated_by_user_id': generatedByUserId,
      if (createdAt != null) 'created_at': createdAt,
      if (summaryJson != null) 'summary_json': summaryJson,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReportRecordsCompanion copyWith(
      {Value<String>? id,
      Value<String>? reportCode,
      Value<String>? cseId,
      Value<String?>? assessmentId,
      Value<String?>? datasetVersionId,
      Value<String?>? analysisRunId,
      Value<DateTime?>? obsStart,
      Value<DateTime?>? obsEnd,
      Value<String>? generatedByUserId,
      Value<DateTime>? createdAt,
      Value<String>? summaryJson,
      Value<String?>? metadataJson,
      Value<int>? rowid}) {
    return ReportRecordsCompanion(
      id: id ?? this.id,
      reportCode: reportCode ?? this.reportCode,
      cseId: cseId ?? this.cseId,
      assessmentId: assessmentId ?? this.assessmentId,
      datasetVersionId: datasetVersionId ?? this.datasetVersionId,
      analysisRunId: analysisRunId ?? this.analysisRunId,
      obsStart: obsStart ?? this.obsStart,
      obsEnd: obsEnd ?? this.obsEnd,
      generatedByUserId: generatedByUserId ?? this.generatedByUserId,
      createdAt: createdAt ?? this.createdAt,
      summaryJson: summaryJson ?? this.summaryJson,
      metadataJson: metadataJson ?? this.metadataJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (reportCode.present) {
      map['report_code'] = Variable<String>(reportCode.value);
    }
    if (cseId.present) {
      map['cse_id'] = Variable<String>(cseId.value);
    }
    if (assessmentId.present) {
      map['assessment_id'] = Variable<String>(assessmentId.value);
    }
    if (datasetVersionId.present) {
      map['dataset_version_id'] = Variable<String>(datasetVersionId.value);
    }
    if (analysisRunId.present) {
      map['analysis_run_id'] = Variable<String>(analysisRunId.value);
    }
    if (obsStart.present) {
      map['obs_start'] = Variable<DateTime>(obsStart.value);
    }
    if (obsEnd.present) {
      map['obs_end'] = Variable<DateTime>(obsEnd.value);
    }
    if (generatedByUserId.present) {
      map['generated_by_user_id'] = Variable<String>(generatedByUserId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (summaryJson.present) {
      map['summary_json'] = Variable<String>(summaryJson.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReportRecordsCompanion(')
          ..write('id: $id, ')
          ..write('reportCode: $reportCode, ')
          ..write('cseId: $cseId, ')
          ..write('assessmentId: $assessmentId, ')
          ..write('datasetVersionId: $datasetVersionId, ')
          ..write('analysisRunId: $analysisRunId, ')
          ..write('obsStart: $obsStart, ')
          ..write('obsEnd: $obsEnd, ')
          ..write('generatedByUserId: $generatedByUserId, ')
          ..write('createdAt: $createdAt, ')
          ..write('summaryJson: $summaryJson, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CSEsTable cSEs = $CSEsTable(this);
  late final $AssessmentsTable assessments = $AssessmentsTable(this);
  late final $DatasetVersionsTable datasetVersions =
      $DatasetVersionsTable(this);
  late final $AnalysisRunsTable analysisRuns = $AnalysisRunsTable(this);
  late final $FindingsTable findings = $FindingsTable(this);
  late final $AssetsTable assets = $AssetsTable(this);
  late final $AlertsTable alerts = $AlertsTable(this);
  late final $CasesTable cases = $CasesTable(this);
  late final $InvestigationsTable investigations = $InvestigationsTable(this);
  late final $EscalationsTable escalations = $EscalationsTable(this);
  late final $MonitoringCoveragesTable monitoringCoverages =
      $MonitoringCoveragesTable(this);
  late final $FindingEvidencesTable findingEvidences =
      $FindingEvidencesTable(this);
  late final $FindingReviewHistoriesTable findingReviewHistories =
      $FindingReviewHistoriesTable(this);
  late final $ReportRecordsTable reportRecords = $ReportRecordsTable(this);
  late final Index idxCsesSector =
      Index('idx_cses_sector', 'CREATE INDEX idx_cses_sector ON cses (sector)');
  late final Index idxAssessmentsCseId = Index('idx_assessments_cse_id',
      'CREATE INDEX idx_assessments_cse_id ON assessments (cse_id)');
  late final Index idxAssessmentsPeriodStart = Index(
      'idx_assessments_period_start',
      'CREATE INDEX idx_assessments_period_start ON assessments (period_start)');
  late final Index idxAssessmentsPeriodEnd = Index('idx_assessments_period_end',
      'CREATE INDEX idx_assessments_period_end ON assessments (period_end)');
  late final Index idxAssessmentsStatus = Index('idx_assessments_status',
      'CREATE INDEX idx_assessments_status ON assessments (status)');
  late final Index idxDatasetVersionsCseId = Index(
      'idx_dataset_versions_cse_id',
      'CREATE INDEX idx_dataset_versions_cse_id ON dataset_versions (cse_id)');
  late final Index idxDatasetVersionsAssessmentId = Index(
      'idx_dataset_versions_assessment_id',
      'CREATE INDEX idx_dataset_versions_assessment_id ON dataset_versions (assessment_id)');
  late final Index idxDatasetVersionsVersionTag = Index(
      'idx_dataset_versions_version_tag',
      'CREATE INDEX idx_dataset_versions_version_tag ON dataset_versions (version_tag)');
  late final Index idxDatasetVersionsContentHash = Index(
      'idx_dataset_versions_content_hash',
      'CREATE INDEX idx_dataset_versions_content_hash ON dataset_versions (content_hash)');
  late final Index idxAnalysisRunsCseId = Index('idx_analysis_runs_cse_id',
      'CREATE INDEX idx_analysis_runs_cse_id ON analysis_runs (cse_id)');
  late final Index idxAnalysisRunsAssessmentId = Index(
      'idx_analysis_runs_assessment_id',
      'CREATE INDEX idx_analysis_runs_assessment_id ON analysis_runs (assessment_id)');
  late final Index idxAnalysisRunsDatasetVersionId = Index(
      'idx_analysis_runs_dataset_version_id',
      'CREATE INDEX idx_analysis_runs_dataset_version_id ON analysis_runs (dataset_version_id)');
  late final Index idxAnalysisRunsStatus = Index('idx_analysis_runs_status',
      'CREATE INDEX idx_analysis_runs_status ON analysis_runs (status)');
  late final Index idxFindingsCseId = Index('idx_findings_cse_id',
      'CREATE INDEX idx_findings_cse_id ON findings (cse_id)');
  late final Index idxFindingsAnalysisRunId = Index(
      'idx_findings_analysis_run_id',
      'CREATE INDEX idx_findings_analysis_run_id ON findings (analysis_run_id)');
  late final Index idxFindingsCategory = Index('idx_findings_category',
      'CREATE INDEX idx_findings_category ON findings (category)');
  late final Index idxFindingsSeverity = Index('idx_findings_severity',
      'CREATE INDEX idx_findings_severity ON findings (severity)');
  late final Index idxFindingsStatus = Index('idx_findings_status',
      'CREATE INDEX idx_findings_status ON findings (status)');
  late final Index idxFindingsDetectedAt = Index('idx_findings_detected_at',
      'CREATE INDEX idx_findings_detected_at ON findings (detected_at)');
  late final Index idxFindingEvidencesFindingId = Index(
      'idx_finding_evidences_finding_id',
      'CREATE INDEX idx_finding_evidences_finding_id ON finding_evidences (finding_id)');
  late final Index idxFindingEvidencesEvidenceType = Index(
      'idx_finding_evidences_evidence_type',
      'CREATE INDEX idx_finding_evidences_evidence_type ON finding_evidences (evidence_type)');
  late final Index idxFindingEvidencesAlertId = Index(
      'idx_finding_evidences_alert_id',
      'CREATE INDEX idx_finding_evidences_alert_id ON finding_evidences (alert_id)');
  late final Index idxFindingEvidencesCaseId = Index(
      'idx_finding_evidences_case_id',
      'CREATE INDEX idx_finding_evidences_case_id ON finding_evidences (case_id)');
  late final Index idxFindingReviewHistoriesFindingId = Index(
      'idx_finding_review_histories_finding_id',
      'CREATE INDEX idx_finding_review_histories_finding_id ON finding_review_histories (finding_id)');
  late final Index idxFindingReviewHistoriesCseId = Index(
      'idx_finding_review_histories_cse_id',
      'CREATE INDEX idx_finding_review_histories_cse_id ON finding_review_histories (cse_id)');
  late final Index idxFindingReviewHistoriesActionType = Index(
      'idx_finding_review_histories_action_type',
      'CREATE INDEX idx_finding_review_histories_action_type ON finding_review_histories (action_type)');
  late final Index idxFindingReviewHistoriesCreatedAt = Index(
      'idx_finding_review_histories_created_at',
      'CREATE INDEX idx_finding_review_histories_created_at ON finding_review_histories (created_at)');
  late final Index idxReportRecordsCseId = Index('idx_report_records_cse_id',
      'CREATE INDEX idx_report_records_cse_id ON report_records (cse_id)');
  late final Index idxReportRecordsAssessmentId = Index(
      'idx_report_records_assessment_id',
      'CREATE INDEX idx_report_records_assessment_id ON report_records (assessment_id)');
  late final Index idxAlertsCseId = Index(
      'idx_alerts_cse_id', 'CREATE INDEX idx_alerts_cse_id ON alerts (cse_id)');
  late final Index idxAlertsExternalAlertId = Index(
      'idx_alerts_external_alert_id',
      'CREATE INDEX idx_alerts_external_alert_id ON alerts (external_alert_id)');
  late final Index idxAlertsSeverity = Index('idx_alerts_severity',
      'CREATE INDEX idx_alerts_severity ON alerts (severity)');
  late final Index idxAlertsStatus = Index(
      'idx_alerts_status', 'CREATE INDEX idx_alerts_status ON alerts (status)');
  late final Index idxCasesCseId = Index(
      'idx_cases_cse_id', 'CREATE INDEX idx_cases_cse_id ON cases (cse_id)');
  late final Index idxCasesExternalCaseId = Index('idx_cases_external_case_id',
      'CREATE INDEX idx_cases_external_case_id ON cases (external_case_id)');
  late final Index idxCasesStatus = Index(
      'idx_cases_status', 'CREATE INDEX idx_cases_status ON cases (status)');
  late final Index idxInvestigationsCaseId = Index('idx_investigations_case_id',
      'CREATE INDEX idx_investigations_case_id ON investigations (case_id)');
  late final Index idxInvestigationsExternalId = Index(
      'idx_investigations_external_id',
      'CREATE INDEX idx_investigations_external_id ON investigations (external_investigation_id)');
  late final Index idxEscalationsCaseId = Index('idx_escalations_case_id',
      'CREATE INDEX idx_escalations_case_id ON escalations (case_id)');
  late final Index idxEscalationsAlertId = Index('idx_escalations_alert_id',
      'CREATE INDEX idx_escalations_alert_id ON escalations (alert_id)');
  late final Index idxCoveragesCseId = Index('idx_coverages_cse_id',
      'CREATE INDEX idx_coverages_cse_id ON monitoring_coverages (cse_id)');
  late final Index idxCoveragesCategory = Index('idx_coverages_category',
      'CREATE INDEX idx_coverages_category ON monitoring_coverages (log_source_category)');
  late final Index idxAssetsCseId = Index(
      'idx_assets_cse_id', 'CREATE INDEX idx_assets_cse_id ON assets (cse_id)');
  late final Index idxAssetsIdentifier = Index('idx_assets_identifier',
      'CREATE INDEX idx_assets_identifier ON assets (asset_identifier)');
  late final Index idxAssetsCriticality = Index('idx_assets_criticality',
      'CREATE INDEX idx_assets_criticality ON assets (criticality)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        cSEs,
        assessments,
        datasetVersions,
        analysisRuns,
        findings,
        assets,
        alerts,
        cases,
        investigations,
        escalations,
        monitoringCoverages,
        findingEvidences,
        findingReviewHistories,
        reportRecords,
        idxCsesSector,
        idxAssessmentsCseId,
        idxAssessmentsPeriodStart,
        idxAssessmentsPeriodEnd,
        idxAssessmentsStatus,
        idxDatasetVersionsCseId,
        idxDatasetVersionsAssessmentId,
        idxDatasetVersionsVersionTag,
        idxDatasetVersionsContentHash,
        idxAnalysisRunsCseId,
        idxAnalysisRunsAssessmentId,
        idxAnalysisRunsDatasetVersionId,
        idxAnalysisRunsStatus,
        idxFindingsCseId,
        idxFindingsAnalysisRunId,
        idxFindingsCategory,
        idxFindingsSeverity,
        idxFindingsStatus,
        idxFindingsDetectedAt,
        idxFindingEvidencesFindingId,
        idxFindingEvidencesEvidenceType,
        idxFindingEvidencesAlertId,
        idxFindingEvidencesCaseId,
        idxFindingReviewHistoriesFindingId,
        idxFindingReviewHistoriesCseId,
        idxFindingReviewHistoriesActionType,
        idxFindingReviewHistoriesCreatedAt,
        idxReportRecordsCseId,
        idxReportRecordsAssessmentId,
        idxAlertsCseId,
        idxAlertsExternalAlertId,
        idxAlertsSeverity,
        idxAlertsStatus,
        idxCasesCseId,
        idxCasesExternalCaseId,
        idxCasesStatus,
        idxInvestigationsCaseId,
        idxInvestigationsExternalId,
        idxEscalationsCaseId,
        idxEscalationsAlertId,
        idxCoveragesCseId,
        idxCoveragesCategory,
        idxAssetsCseId,
        idxAssetsIdentifier,
        idxAssetsCriticality
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('assessments',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('dataset_versions', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('assessments',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('analysis_runs', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('dataset_versions',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('analysis_runs', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('analysis_runs',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('findings', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('cses',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('assets', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('assets',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('alerts', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('alerts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('cases', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('cases',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('investigations', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('cases',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('escalations', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('alerts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('escalations', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('findings',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('finding_evidences', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('alerts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('finding_evidences', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('cases',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('finding_evidences', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('investigations',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('finding_evidences', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('escalations',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('finding_evidences', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('monitoring_coverages',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('finding_evidences', kind: UpdateKind.update),
            ],
          ),
        ],
      );
}

typedef $$CSEsTableCreateCompanionBuilder = CSEsCompanion Function({
  required String id,
  required String cseCode,
  required String name,
  required String sector,
  Value<String> criticalityTier,
  Value<String?> contactEmail,
  Value<bool> isActive,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$CSEsTableUpdateCompanionBuilder = CSEsCompanion Function({
  Value<String> id,
  Value<String> cseCode,
  Value<String> name,
  Value<String> sector,
  Value<String> criticalityTier,
  Value<String?> contactEmail,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$CSEsTableReferences
    extends BaseReferences<_$AppDatabase, $CSEsTable, CSERecord> {
  $$CSEsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AssessmentsTable, List<AssessmentRecord>>
      _assessmentsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.assessments,
              aliasName: 'cses__id__assessments__cse_id');

  $$AssessmentsTableProcessedTableManager get assessmentsRefs {
    final manager = $$AssessmentsTableTableManager($_db, $_db.assessments)
        .filter((f) => f.cseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_assessmentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DatasetVersionsTable, List<DatasetVersionRecord>>
      _datasetVersionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.datasetVersions,
              aliasName: 'cses__id__dataset_versions__cse_id');

  $$DatasetVersionsTableProcessedTableManager get datasetVersionsRefs {
    final manager =
        $$DatasetVersionsTableTableManager($_db, $_db.datasetVersions)
            .filter((f) => f.cseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_datasetVersionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AnalysisRunsTable, List<AnalysisRunRecord>>
      _analysisRunsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.analysisRuns,
              aliasName: 'cses__id__analysis_runs__cse_id');

  $$AnalysisRunsTableProcessedTableManager get analysisRunsRefs {
    final manager = $$AnalysisRunsTableTableManager($_db, $_db.analysisRuns)
        .filter((f) => f.cseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_analysisRunsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$FindingsTable, List<FindingRecord>>
      _findingsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.findings,
              aliasName: 'cses__id__findings__cse_id');

  $$FindingsTableProcessedTableManager get findingsRefs {
    final manager = $$FindingsTableTableManager($_db, $_db.findings)
        .filter((f) => f.cseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_findingsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AssetsTable, List<AssetRecord>> _assetsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.assets,
          aliasName: 'cses__id__assets__cse_id');

  $$AssetsTableProcessedTableManager get assetsRefs {
    final manager = $$AssetsTableTableManager($_db, $_db.assets)
        .filter((f) => f.cseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_assetsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AlertsTable, List<AlertRecord>> _alertsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.alerts,
          aliasName: 'cses__id__alerts__cse_id');

  $$AlertsTableProcessedTableManager get alertsRefs {
    final manager = $$AlertsTableTableManager($_db, $_db.alerts)
        .filter((f) => f.cseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_alertsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CasesTable, List<CaseRecord>> _casesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.cases,
          aliasName: 'cses__id__cases__cse_id');

  $$CasesTableProcessedTableManager get casesRefs {
    final manager = $$CasesTableTableManager($_db, $_db.cases)
        .filter((f) => f.cseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_casesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MonitoringCoveragesTable,
      List<MonitoringCoverageRecord>> _monitoringCoveragesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.monitoringCoverages,
          aliasName: 'cses__id__monitoring_coverages__cse_id');

  $$MonitoringCoveragesTableProcessedTableManager get monitoringCoveragesRefs {
    final manager =
        $$MonitoringCoveragesTableTableManager($_db, $_db.monitoringCoverages)
            .filter((f) => f.cseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_monitoringCoveragesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$FindingReviewHistoriesTable,
      List<FindingReviewHistoryRecord>> _findingReviewHistoriesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.findingReviewHistories,
          aliasName: 'cses__id__finding_review_histories__cse_id');

  $$FindingReviewHistoriesTableProcessedTableManager
      get findingReviewHistoriesRefs {
    final manager = $$FindingReviewHistoriesTableTableManager(
            $_db, $_db.findingReviewHistories)
        .filter((f) => f.cseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_findingReviewHistoriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ReportRecordsTable, List<ReportRecordData>>
      _reportRecordsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.reportRecords,
              aliasName: 'cses__id__report_records__cse_id');

  $$ReportRecordsTableProcessedTableManager get reportRecordsRefs {
    final manager = $$ReportRecordsTableTableManager($_db, $_db.reportRecords)
        .filter((f) => f.cseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_reportRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CSEsTableFilterComposer extends Composer<_$AppDatabase, $CSEsTable> {
  $$CSEsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cseCode => $composableBuilder(
      column: $table.cseCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sector => $composableBuilder(
      column: $table.sector, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get criticalityTier => $composableBuilder(
      column: $table.criticalityTier,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contactEmail => $composableBuilder(
      column: $table.contactEmail, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> assessmentsRefs(
      Expression<bool> Function($$AssessmentsTableFilterComposer f) f) {
    final $$AssessmentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.assessments,
        getReferencedColumn: (t) => t.cseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssessmentsTableFilterComposer(
              $db: $db,
              $table: $db.assessments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> datasetVersionsRefs(
      Expression<bool> Function($$DatasetVersionsTableFilterComposer f) f) {
    final $$DatasetVersionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.datasetVersions,
        getReferencedColumn: (t) => t.cseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DatasetVersionsTableFilterComposer(
              $db: $db,
              $table: $db.datasetVersions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> analysisRunsRefs(
      Expression<bool> Function($$AnalysisRunsTableFilterComposer f) f) {
    final $$AnalysisRunsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.analysisRuns,
        getReferencedColumn: (t) => t.cseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnalysisRunsTableFilterComposer(
              $db: $db,
              $table: $db.analysisRuns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> findingsRefs(
      Expression<bool> Function($$FindingsTableFilterComposer f) f) {
    final $$FindingsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.findings,
        getReferencedColumn: (t) => t.cseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FindingsTableFilterComposer(
              $db: $db,
              $table: $db.findings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> assetsRefs(
      Expression<bool> Function($$AssetsTableFilterComposer f) f) {
    final $$AssetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.cseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableFilterComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> alertsRefs(
      Expression<bool> Function($$AlertsTableFilterComposer f) f) {
    final $$AlertsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.alerts,
        getReferencedColumn: (t) => t.cseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AlertsTableFilterComposer(
              $db: $db,
              $table: $db.alerts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> casesRefs(
      Expression<bool> Function($$CasesTableFilterComposer f) f) {
    final $$CasesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.cases,
        getReferencedColumn: (t) => t.cseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CasesTableFilterComposer(
              $db: $db,
              $table: $db.cases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> monitoringCoveragesRefs(
      Expression<bool> Function($$MonitoringCoveragesTableFilterComposer f) f) {
    final $$MonitoringCoveragesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.monitoringCoverages,
        getReferencedColumn: (t) => t.cseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MonitoringCoveragesTableFilterComposer(
              $db: $db,
              $table: $db.monitoringCoverages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> findingReviewHistoriesRefs(
      Expression<bool> Function($$FindingReviewHistoriesTableFilterComposer f)
          f) {
    final $$FindingReviewHistoriesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.findingReviewHistories,
            getReferencedColumn: (t) => t.cseId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$FindingReviewHistoriesTableFilterComposer(
                  $db: $db,
                  $table: $db.findingReviewHistories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> reportRecordsRefs(
      Expression<bool> Function($$ReportRecordsTableFilterComposer f) f) {
    final $$ReportRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reportRecords,
        getReferencedColumn: (t) => t.cseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReportRecordsTableFilterComposer(
              $db: $db,
              $table: $db.reportRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CSEsTableOrderingComposer extends Composer<_$AppDatabase, $CSEsTable> {
  $$CSEsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cseCode => $composableBuilder(
      column: $table.cseCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sector => $composableBuilder(
      column: $table.sector, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get criticalityTier => $composableBuilder(
      column: $table.criticalityTier,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contactEmail => $composableBuilder(
      column: $table.contactEmail,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CSEsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CSEsTable> {
  $$CSEsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cseCode =>
      $composableBuilder(column: $table.cseCode, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get sector =>
      $composableBuilder(column: $table.sector, builder: (column) => column);

  GeneratedColumn<String> get criticalityTier => $composableBuilder(
      column: $table.criticalityTier, builder: (column) => column);

  GeneratedColumn<String> get contactEmail => $composableBuilder(
      column: $table.contactEmail, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> assessmentsRefs<T extends Object>(
      Expression<T> Function($$AssessmentsTableAnnotationComposer a) f) {
    final $$AssessmentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.assessments,
        getReferencedColumn: (t) => t.cseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssessmentsTableAnnotationComposer(
              $db: $db,
              $table: $db.assessments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> datasetVersionsRefs<T extends Object>(
      Expression<T> Function($$DatasetVersionsTableAnnotationComposer a) f) {
    final $$DatasetVersionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.datasetVersions,
        getReferencedColumn: (t) => t.cseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DatasetVersionsTableAnnotationComposer(
              $db: $db,
              $table: $db.datasetVersions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> analysisRunsRefs<T extends Object>(
      Expression<T> Function($$AnalysisRunsTableAnnotationComposer a) f) {
    final $$AnalysisRunsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.analysisRuns,
        getReferencedColumn: (t) => t.cseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnalysisRunsTableAnnotationComposer(
              $db: $db,
              $table: $db.analysisRuns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> findingsRefs<T extends Object>(
      Expression<T> Function($$FindingsTableAnnotationComposer a) f) {
    final $$FindingsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.findings,
        getReferencedColumn: (t) => t.cseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FindingsTableAnnotationComposer(
              $db: $db,
              $table: $db.findings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> assetsRefs<T extends Object>(
      Expression<T> Function($$AssetsTableAnnotationComposer a) f) {
    final $$AssetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.cseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableAnnotationComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> alertsRefs<T extends Object>(
      Expression<T> Function($$AlertsTableAnnotationComposer a) f) {
    final $$AlertsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.alerts,
        getReferencedColumn: (t) => t.cseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AlertsTableAnnotationComposer(
              $db: $db,
              $table: $db.alerts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> casesRefs<T extends Object>(
      Expression<T> Function($$CasesTableAnnotationComposer a) f) {
    final $$CasesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.cases,
        getReferencedColumn: (t) => t.cseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CasesTableAnnotationComposer(
              $db: $db,
              $table: $db.cases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> monitoringCoveragesRefs<T extends Object>(
      Expression<T> Function($$MonitoringCoveragesTableAnnotationComposer a)
          f) {
    final $$MonitoringCoveragesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.monitoringCoverages,
            getReferencedColumn: (t) => t.cseId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MonitoringCoveragesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.monitoringCoverages,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> findingReviewHistoriesRefs<T extends Object>(
      Expression<T> Function($$FindingReviewHistoriesTableAnnotationComposer a)
          f) {
    final $$FindingReviewHistoriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.findingReviewHistories,
            getReferencedColumn: (t) => t.cseId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$FindingReviewHistoriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.findingReviewHistories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> reportRecordsRefs<T extends Object>(
      Expression<T> Function($$ReportRecordsTableAnnotationComposer a) f) {
    final $$ReportRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reportRecords,
        getReferencedColumn: (t) => t.cseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReportRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.reportRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CSEsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CSEsTable,
    CSERecord,
    $$CSEsTableFilterComposer,
    $$CSEsTableOrderingComposer,
    $$CSEsTableAnnotationComposer,
    $$CSEsTableCreateCompanionBuilder,
    $$CSEsTableUpdateCompanionBuilder,
    (CSERecord, $$CSEsTableReferences),
    CSERecord,
    PrefetchHooks Function(
        {bool assessmentsRefs,
        bool datasetVersionsRefs,
        bool analysisRunsRefs,
        bool findingsRefs,
        bool assetsRefs,
        bool alertsRefs,
        bool casesRefs,
        bool monitoringCoveragesRefs,
        bool findingReviewHistoriesRefs,
        bool reportRecordsRefs})> {
  $$CSEsTableTableManager(_$AppDatabase db, $CSEsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CSEsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CSEsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CSEsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> cseCode = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> sector = const Value.absent(),
            Value<String> criticalityTier = const Value.absent(),
            Value<String?> contactEmail = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CSEsCompanion(
            id: id,
            cseCode: cseCode,
            name: name,
            sector: sector,
            criticalityTier: criticalityTier,
            contactEmail: contactEmail,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String cseCode,
            required String name,
            required String sector,
            Value<String> criticalityTier = const Value.absent(),
            Value<String?> contactEmail = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CSEsCompanion.insert(
            id: id,
            cseCode: cseCode,
            name: name,
            sector: sector,
            criticalityTier: criticalityTier,
            contactEmail: contactEmail,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$CSEsTable, CSERecord>(table),
                    $$CSEsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {assessmentsRefs = false,
              datasetVersionsRefs = false,
              analysisRunsRefs = false,
              findingsRefs = false,
              assetsRefs = false,
              alertsRefs = false,
              casesRefs = false,
              monitoringCoveragesRefs = false,
              findingReviewHistoriesRefs = false,
              reportRecordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (assessmentsRefs) db.assessments,
                if (datasetVersionsRefs) db.datasetVersions,
                if (analysisRunsRefs) db.analysisRuns,
                if (findingsRefs) db.findings,
                if (assetsRefs) db.assets,
                if (alertsRefs) db.alerts,
                if (casesRefs) db.cases,
                if (monitoringCoveragesRefs) db.monitoringCoverages,
                if (findingReviewHistoriesRefs) db.findingReviewHistories,
                if (reportRecordsRefs) db.reportRecords
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (assessmentsRefs)
                    await $_getPrefetchedData<CSERecord, $CSEsTable,
                            AssessmentRecord>(
                        currentTable: table,
                        referencedTable:
                            $$CSEsTableReferences._assessmentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CSEsTableReferences(db, table, p0)
                                .assessmentsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.cseId == item.id),
                        typedResults: items),
                  if (datasetVersionsRefs)
                    await $_getPrefetchedData<CSERecord, $CSEsTable,
                            DatasetVersionRecord>(
                        currentTable: table,
                        referencedTable:
                            $$CSEsTableReferences._datasetVersionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CSEsTableReferences(db, table, p0)
                                .datasetVersionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.cseId == item.id),
                        typedResults: items),
                  if (analysisRunsRefs)
                    await $_getPrefetchedData<CSERecord, $CSEsTable,
                            AnalysisRunRecord>(
                        currentTable: table,
                        referencedTable:
                            $$CSEsTableReferences._analysisRunsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CSEsTableReferences(db, table, p0)
                                .analysisRunsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.cseId == item.id),
                        typedResults: items),
                  if (findingsRefs)
                    await $_getPrefetchedData<CSERecord, $CSEsTable,
                            FindingRecord>(
                        currentTable: table,
                        referencedTable:
                            $$CSEsTableReferences._findingsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CSEsTableReferences(db, table, p0).findingsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.cseId == item.id),
                        typedResults: items),
                  if (assetsRefs)
                    await $_getPrefetchedData<CSERecord, $CSEsTable,
                            AssetRecord>(
                        currentTable: table,
                        referencedTable:
                            $$CSEsTableReferences._assetsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CSEsTableReferences(db, table, p0).assetsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.cseId == item.id),
                        typedResults: items),
                  if (alertsRefs)
                    await $_getPrefetchedData<CSERecord, $CSEsTable,
                            AlertRecord>(
                        currentTable: table,
                        referencedTable:
                            $$CSEsTableReferences._alertsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CSEsTableReferences(db, table, p0).alertsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.cseId == item.id),
                        typedResults: items),
                  if (casesRefs)
                    await $_getPrefetchedData<CSERecord, $CSEsTable,
                            CaseRecord>(
                        currentTable: table,
                        referencedTable:
                            $$CSEsTableReferences._casesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CSEsTableReferences(db, table, p0).casesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.cseId == item.id),
                        typedResults: items),
                  if (monitoringCoveragesRefs)
                    await $_getPrefetchedData<CSERecord, $CSEsTable,
                            MonitoringCoverageRecord>(
                        currentTable: table,
                        referencedTable: $$CSEsTableReferences
                            ._monitoringCoveragesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CSEsTableReferences(db, table, p0)
                                .monitoringCoveragesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.cseId == item.id),
                        typedResults: items),
                  if (findingReviewHistoriesRefs)
                    await $_getPrefetchedData<CSERecord, $CSEsTable, FindingReviewHistoryRecord>(
                        currentTable: table,
                        referencedTable: $$CSEsTableReferences
                            ._findingReviewHistoriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CSEsTableReferences(db, table, p0)
                                .findingReviewHistoriesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.cseId == item.id),
                        typedResults: items),
                  if (reportRecordsRefs)
                    await $_getPrefetchedData<CSERecord, $CSEsTable,
                            ReportRecordData>(
                        currentTable: table,
                        referencedTable:
                            $$CSEsTableReferences._reportRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CSEsTableReferences(db, table, p0)
                                .reportRecordsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.cseId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CSEsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CSEsTable,
    CSERecord,
    $$CSEsTableFilterComposer,
    $$CSEsTableOrderingComposer,
    $$CSEsTableAnnotationComposer,
    $$CSEsTableCreateCompanionBuilder,
    $$CSEsTableUpdateCompanionBuilder,
    (CSERecord, $$CSEsTableReferences),
    CSERecord,
    PrefetchHooks Function(
        {bool assessmentsRefs,
        bool datasetVersionsRefs,
        bool analysisRunsRefs,
        bool findingsRefs,
        bool assetsRefs,
        bool alertsRefs,
        bool casesRefs,
        bool monitoringCoveragesRefs,
        bool findingReviewHistoriesRefs,
        bool reportRecordsRefs})>;
typedef $$AssessmentsTableCreateCompanionBuilder = AssessmentsCompanion
    Function({
  required String id,
  required String cseId,
  required String name,
  Value<String?> description,
  required DateTime periodStart,
  required DateTime periodEnd,
  Value<String> status,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<String?> createdByUserId,
  Value<int> rowid,
});
typedef $$AssessmentsTableUpdateCompanionBuilder = AssessmentsCompanion
    Function({
  Value<String> id,
  Value<String> cseId,
  Value<String> name,
  Value<String?> description,
  Value<DateTime> periodStart,
  Value<DateTime> periodEnd,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String?> createdByUserId,
  Value<int> rowid,
});

final class $$AssessmentsTableReferences
    extends BaseReferences<_$AppDatabase, $AssessmentsTable, AssessmentRecord> {
  $$AssessmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CSEsTable _cseIdTable(_$AppDatabase db) =>
      db.cSEs.createAlias('assessments__cse_id__cses__id');

  $$CSEsTableProcessedTableManager get cseId {
    final $_column = $_itemColumn<String>('cse_id')!;

    final manager = $$CSEsTableTableManager($_db, $_db.cSEs)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$DatasetVersionsTable, List<DatasetVersionRecord>>
      _datasetVersionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.datasetVersions,
              aliasName: 'assessments__id__dataset_versions__assessment_id');

  $$DatasetVersionsTableProcessedTableManager get datasetVersionsRefs {
    final manager =
        $$DatasetVersionsTableTableManager($_db, $_db.datasetVersions).filter(
            (f) => f.assessmentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_datasetVersionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AnalysisRunsTable, List<AnalysisRunRecord>>
      _analysisRunsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.analysisRuns,
              aliasName: 'assessments__id__analysis_runs__assessment_id');

  $$AnalysisRunsTableProcessedTableManager get analysisRunsRefs {
    final manager = $$AnalysisRunsTableTableManager($_db, $_db.analysisRuns)
        .filter(
            (f) => f.assessmentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_analysisRunsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ReportRecordsTable, List<ReportRecordData>>
      _reportRecordsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.reportRecords,
              aliasName: 'assessments__id__report_records__assessment_id');

  $$ReportRecordsTableProcessedTableManager get reportRecordsRefs {
    final manager = $$ReportRecordsTableTableManager($_db, $_db.reportRecords)
        .filter(
            (f) => f.assessmentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_reportRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AssessmentsTableFilterComposer
    extends Composer<_$AppDatabase, $AssessmentsTable> {
  $$AssessmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get periodStart => $composableBuilder(
      column: $table.periodStart, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get periodEnd => $composableBuilder(
      column: $table.periodEnd, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdByUserId => $composableBuilder(
      column: $table.createdByUserId,
      builder: (column) => ColumnFilters(column));

  $$CSEsTableFilterComposer get cseId {
    final $$CSEsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableFilterComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> datasetVersionsRefs(
      Expression<bool> Function($$DatasetVersionsTableFilterComposer f) f) {
    final $$DatasetVersionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.datasetVersions,
        getReferencedColumn: (t) => t.assessmentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DatasetVersionsTableFilterComposer(
              $db: $db,
              $table: $db.datasetVersions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> analysisRunsRefs(
      Expression<bool> Function($$AnalysisRunsTableFilterComposer f) f) {
    final $$AnalysisRunsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.analysisRuns,
        getReferencedColumn: (t) => t.assessmentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnalysisRunsTableFilterComposer(
              $db: $db,
              $table: $db.analysisRuns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> reportRecordsRefs(
      Expression<bool> Function($$ReportRecordsTableFilterComposer f) f) {
    final $$ReportRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reportRecords,
        getReferencedColumn: (t) => t.assessmentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReportRecordsTableFilterComposer(
              $db: $db,
              $table: $db.reportRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AssessmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AssessmentsTable> {
  $$AssessmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get periodStart => $composableBuilder(
      column: $table.periodStart, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get periodEnd => $composableBuilder(
      column: $table.periodEnd, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdByUserId => $composableBuilder(
      column: $table.createdByUserId,
      builder: (column) => ColumnOrderings(column));

  $$CSEsTableOrderingComposer get cseId {
    final $$CSEsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableOrderingComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AssessmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssessmentsTable> {
  $$AssessmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get periodStart => $composableBuilder(
      column: $table.periodStart, builder: (column) => column);

  GeneratedColumn<DateTime> get periodEnd =>
      $composableBuilder(column: $table.periodEnd, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get createdByUserId => $composableBuilder(
      column: $table.createdByUserId, builder: (column) => column);

  $$CSEsTableAnnotationComposer get cseId {
    final $$CSEsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableAnnotationComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> datasetVersionsRefs<T extends Object>(
      Expression<T> Function($$DatasetVersionsTableAnnotationComposer a) f) {
    final $$DatasetVersionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.datasetVersions,
        getReferencedColumn: (t) => t.assessmentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DatasetVersionsTableAnnotationComposer(
              $db: $db,
              $table: $db.datasetVersions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> analysisRunsRefs<T extends Object>(
      Expression<T> Function($$AnalysisRunsTableAnnotationComposer a) f) {
    final $$AnalysisRunsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.analysisRuns,
        getReferencedColumn: (t) => t.assessmentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnalysisRunsTableAnnotationComposer(
              $db: $db,
              $table: $db.analysisRuns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> reportRecordsRefs<T extends Object>(
      Expression<T> Function($$ReportRecordsTableAnnotationComposer a) f) {
    final $$ReportRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reportRecords,
        getReferencedColumn: (t) => t.assessmentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReportRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.reportRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AssessmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AssessmentsTable,
    AssessmentRecord,
    $$AssessmentsTableFilterComposer,
    $$AssessmentsTableOrderingComposer,
    $$AssessmentsTableAnnotationComposer,
    $$AssessmentsTableCreateCompanionBuilder,
    $$AssessmentsTableUpdateCompanionBuilder,
    (AssessmentRecord, $$AssessmentsTableReferences),
    AssessmentRecord,
    PrefetchHooks Function(
        {bool cseId,
        bool datasetVersionsRefs,
        bool analysisRunsRefs,
        bool reportRecordsRefs})> {
  $$AssessmentsTableTableManager(_$AppDatabase db, $AssessmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssessmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssessmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssessmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> cseId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> periodStart = const Value.absent(),
            Value<DateTime> periodEnd = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String?> createdByUserId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AssessmentsCompanion(
            id: id,
            cseId: cseId,
            name: name,
            description: description,
            periodStart: periodStart,
            periodEnd: periodEnd,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            createdByUserId: createdByUserId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String cseId,
            required String name,
            Value<String?> description = const Value.absent(),
            required DateTime periodStart,
            required DateTime periodEnd,
            Value<String> status = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<String?> createdByUserId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AssessmentsCompanion.insert(
            id: id,
            cseId: cseId,
            name: name,
            description: description,
            periodStart: periodStart,
            periodEnd: periodEnd,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            createdByUserId: createdByUserId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AssessmentsTable, AssessmentRecord>(table),
                    $$AssessmentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {cseId = false,
              datasetVersionsRefs = false,
              analysisRunsRefs = false,
              reportRecordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (datasetVersionsRefs) db.datasetVersions,
                if (analysisRunsRefs) db.analysisRuns,
                if (reportRecordsRefs) db.reportRecords
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (cseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.cseId,
                    referencedTable:
                        $$AssessmentsTableReferences._cseIdTable(db),
                    referencedColumn:
                        $$AssessmentsTableReferences._cseIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (datasetVersionsRefs)
                    await $_getPrefetchedData<AssessmentRecord,
                            $AssessmentsTable, DatasetVersionRecord>(
                        currentTable: table,
                        referencedTable: $$AssessmentsTableReferences
                            ._datasetVersionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AssessmentsTableReferences(db, table, p0)
                                .datasetVersionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.assessmentId == item.id),
                        typedResults: items),
                  if (analysisRunsRefs)
                    await $_getPrefetchedData<AssessmentRecord,
                            $AssessmentsTable, AnalysisRunRecord>(
                        currentTable: table,
                        referencedTable: $$AssessmentsTableReferences
                            ._analysisRunsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AssessmentsTableReferences(db, table, p0)
                                .analysisRunsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.assessmentId == item.id),
                        typedResults: items),
                  if (reportRecordsRefs)
                    await $_getPrefetchedData<AssessmentRecord,
                            $AssessmentsTable, ReportRecordData>(
                        currentTable: table,
                        referencedTable: $$AssessmentsTableReferences
                            ._reportRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AssessmentsTableReferences(db, table, p0)
                                .reportRecordsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.assessmentId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AssessmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AssessmentsTable,
    AssessmentRecord,
    $$AssessmentsTableFilterComposer,
    $$AssessmentsTableOrderingComposer,
    $$AssessmentsTableAnnotationComposer,
    $$AssessmentsTableCreateCompanionBuilder,
    $$AssessmentsTableUpdateCompanionBuilder,
    (AssessmentRecord, $$AssessmentsTableReferences),
    AssessmentRecord,
    PrefetchHooks Function(
        {bool cseId,
        bool datasetVersionsRefs,
        bool analysisRunsRefs,
        bool reportRecordsRefs})>;
typedef $$DatasetVersionsTableCreateCompanionBuilder = DatasetVersionsCompanion
    Function({
  required String id,
  required String cseId,
  Value<String?> assessmentId,
  Value<String?> batchId,
  required String versionTag,
  required String datasetType,
  required String sourceFilename,
  required String contentHash,
  Value<int> recordCount,
  Value<bool> isImmutable,
  required DateTime createdAt,
  Value<String?> createdByUserId,
  Value<int> rowid,
});
typedef $$DatasetVersionsTableUpdateCompanionBuilder = DatasetVersionsCompanion
    Function({
  Value<String> id,
  Value<String> cseId,
  Value<String?> assessmentId,
  Value<String?> batchId,
  Value<String> versionTag,
  Value<String> datasetType,
  Value<String> sourceFilename,
  Value<String> contentHash,
  Value<int> recordCount,
  Value<bool> isImmutable,
  Value<DateTime> createdAt,
  Value<String?> createdByUserId,
  Value<int> rowid,
});

final class $$DatasetVersionsTableReferences extends BaseReferences<
    _$AppDatabase, $DatasetVersionsTable, DatasetVersionRecord> {
  $$DatasetVersionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $CSEsTable _cseIdTable(_$AppDatabase db) =>
      db.cSEs.createAlias('dataset_versions__cse_id__cses__id');

  $$CSEsTableProcessedTableManager get cseId {
    final $_column = $_itemColumn<String>('cse_id')!;

    final manager = $$CSEsTableTableManager($_db, $_db.cSEs)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AssessmentsTable _assessmentIdTable(_$AppDatabase db) =>
      db.assessments
          .createAlias('dataset_versions__assessment_id__assessments__id');

  $$AssessmentsTableProcessedTableManager? get assessmentId {
    final $_column = $_itemColumn<String>('assessment_id');
    if ($_column == null) return null;
    final manager = $$AssessmentsTableTableManager($_db, $_db.assessments)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_assessmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$AnalysisRunsTable, List<AnalysisRunRecord>>
      _analysisRunsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.analysisRuns,
          aliasName: 'dataset_versions__id__analysis_runs__dataset_version_id');

  $$AnalysisRunsTableProcessedTableManager get analysisRunsRefs {
    final manager = $$AnalysisRunsTableTableManager($_db, $_db.analysisRuns)
        .filter((f) =>
            f.datasetVersionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_analysisRunsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ReportRecordsTable, List<ReportRecordData>>
      _reportRecordsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.reportRecords,
              aliasName:
                  'dataset_versions__id__report_records__dataset_version_id');

  $$ReportRecordsTableProcessedTableManager get reportRecordsRefs {
    final manager = $$ReportRecordsTableTableManager($_db, $_db.reportRecords)
        .filter((f) =>
            f.datasetVersionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_reportRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DatasetVersionsTableFilterComposer
    extends Composer<_$AppDatabase, $DatasetVersionsTable> {
  $$DatasetVersionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get batchId => $composableBuilder(
      column: $table.batchId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get versionTag => $composableBuilder(
      column: $table.versionTag, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get datasetType => $composableBuilder(
      column: $table.datasetType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceFilename => $composableBuilder(
      column: $table.sourceFilename,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contentHash => $composableBuilder(
      column: $table.contentHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recordCount => $composableBuilder(
      column: $table.recordCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isImmutable => $composableBuilder(
      column: $table.isImmutable, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdByUserId => $composableBuilder(
      column: $table.createdByUserId,
      builder: (column) => ColumnFilters(column));

  $$CSEsTableFilterComposer get cseId {
    final $$CSEsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableFilterComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AssessmentsTableFilterComposer get assessmentId {
    final $$AssessmentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assessmentId,
        referencedTable: $db.assessments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssessmentsTableFilterComposer(
              $db: $db,
              $table: $db.assessments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> analysisRunsRefs(
      Expression<bool> Function($$AnalysisRunsTableFilterComposer f) f) {
    final $$AnalysisRunsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.analysisRuns,
        getReferencedColumn: (t) => t.datasetVersionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnalysisRunsTableFilterComposer(
              $db: $db,
              $table: $db.analysisRuns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> reportRecordsRefs(
      Expression<bool> Function($$ReportRecordsTableFilterComposer f) f) {
    final $$ReportRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reportRecords,
        getReferencedColumn: (t) => t.datasetVersionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReportRecordsTableFilterComposer(
              $db: $db,
              $table: $db.reportRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DatasetVersionsTableOrderingComposer
    extends Composer<_$AppDatabase, $DatasetVersionsTable> {
  $$DatasetVersionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get batchId => $composableBuilder(
      column: $table.batchId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get versionTag => $composableBuilder(
      column: $table.versionTag, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get datasetType => $composableBuilder(
      column: $table.datasetType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceFilename => $composableBuilder(
      column: $table.sourceFilename,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contentHash => $composableBuilder(
      column: $table.contentHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recordCount => $composableBuilder(
      column: $table.recordCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isImmutable => $composableBuilder(
      column: $table.isImmutable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdByUserId => $composableBuilder(
      column: $table.createdByUserId,
      builder: (column) => ColumnOrderings(column));

  $$CSEsTableOrderingComposer get cseId {
    final $$CSEsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableOrderingComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AssessmentsTableOrderingComposer get assessmentId {
    final $$AssessmentsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assessmentId,
        referencedTable: $db.assessments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssessmentsTableOrderingComposer(
              $db: $db,
              $table: $db.assessments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DatasetVersionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DatasetVersionsTable> {
  $$DatasetVersionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get batchId =>
      $composableBuilder(column: $table.batchId, builder: (column) => column);

  GeneratedColumn<String> get versionTag => $composableBuilder(
      column: $table.versionTag, builder: (column) => column);

  GeneratedColumn<String> get datasetType => $composableBuilder(
      column: $table.datasetType, builder: (column) => column);

  GeneratedColumn<String> get sourceFilename => $composableBuilder(
      column: $table.sourceFilename, builder: (column) => column);

  GeneratedColumn<String> get contentHash => $composableBuilder(
      column: $table.contentHash, builder: (column) => column);

  GeneratedColumn<int> get recordCount => $composableBuilder(
      column: $table.recordCount, builder: (column) => column);

  GeneratedColumn<bool> get isImmutable => $composableBuilder(
      column: $table.isImmutable, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdByUserId => $composableBuilder(
      column: $table.createdByUserId, builder: (column) => column);

  $$CSEsTableAnnotationComposer get cseId {
    final $$CSEsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableAnnotationComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AssessmentsTableAnnotationComposer get assessmentId {
    final $$AssessmentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assessmentId,
        referencedTable: $db.assessments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssessmentsTableAnnotationComposer(
              $db: $db,
              $table: $db.assessments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> analysisRunsRefs<T extends Object>(
      Expression<T> Function($$AnalysisRunsTableAnnotationComposer a) f) {
    final $$AnalysisRunsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.analysisRuns,
        getReferencedColumn: (t) => t.datasetVersionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnalysisRunsTableAnnotationComposer(
              $db: $db,
              $table: $db.analysisRuns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> reportRecordsRefs<T extends Object>(
      Expression<T> Function($$ReportRecordsTableAnnotationComposer a) f) {
    final $$ReportRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reportRecords,
        getReferencedColumn: (t) => t.datasetVersionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReportRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.reportRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DatasetVersionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DatasetVersionsTable,
    DatasetVersionRecord,
    $$DatasetVersionsTableFilterComposer,
    $$DatasetVersionsTableOrderingComposer,
    $$DatasetVersionsTableAnnotationComposer,
    $$DatasetVersionsTableCreateCompanionBuilder,
    $$DatasetVersionsTableUpdateCompanionBuilder,
    (DatasetVersionRecord, $$DatasetVersionsTableReferences),
    DatasetVersionRecord,
    PrefetchHooks Function(
        {bool cseId,
        bool assessmentId,
        bool analysisRunsRefs,
        bool reportRecordsRefs})> {
  $$DatasetVersionsTableTableManager(
      _$AppDatabase db, $DatasetVersionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DatasetVersionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DatasetVersionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DatasetVersionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> cseId = const Value.absent(),
            Value<String?> assessmentId = const Value.absent(),
            Value<String?> batchId = const Value.absent(),
            Value<String> versionTag = const Value.absent(),
            Value<String> datasetType = const Value.absent(),
            Value<String> sourceFilename = const Value.absent(),
            Value<String> contentHash = const Value.absent(),
            Value<int> recordCount = const Value.absent(),
            Value<bool> isImmutable = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String?> createdByUserId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DatasetVersionsCompanion(
            id: id,
            cseId: cseId,
            assessmentId: assessmentId,
            batchId: batchId,
            versionTag: versionTag,
            datasetType: datasetType,
            sourceFilename: sourceFilename,
            contentHash: contentHash,
            recordCount: recordCount,
            isImmutable: isImmutable,
            createdAt: createdAt,
            createdByUserId: createdByUserId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String cseId,
            Value<String?> assessmentId = const Value.absent(),
            Value<String?> batchId = const Value.absent(),
            required String versionTag,
            required String datasetType,
            required String sourceFilename,
            required String contentHash,
            Value<int> recordCount = const Value.absent(),
            Value<bool> isImmutable = const Value.absent(),
            required DateTime createdAt,
            Value<String?> createdByUserId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DatasetVersionsCompanion.insert(
            id: id,
            cseId: cseId,
            assessmentId: assessmentId,
            batchId: batchId,
            versionTag: versionTag,
            datasetType: datasetType,
            sourceFilename: sourceFilename,
            contentHash: contentHash,
            recordCount: recordCount,
            isImmutable: isImmutable,
            createdAt: createdAt,
            createdByUserId: createdByUserId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$DatasetVersionsTable, DatasetVersionRecord>(
                        table),
                    $$DatasetVersionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {cseId = false,
              assessmentId = false,
              analysisRunsRefs = false,
              reportRecordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (analysisRunsRefs) db.analysisRuns,
                if (reportRecordsRefs) db.reportRecords
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (cseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.cseId,
                    referencedTable:
                        $$DatasetVersionsTableReferences._cseIdTable(db),
                    referencedColumn:
                        $$DatasetVersionsTableReferences._cseIdTable(db).id,
                  ) as T;
                }
                if (assessmentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.assessmentId,
                    referencedTable:
                        $$DatasetVersionsTableReferences._assessmentIdTable(db),
                    referencedColumn: $$DatasetVersionsTableReferences
                        ._assessmentIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (analysisRunsRefs)
                    await $_getPrefetchedData<DatasetVersionRecord,
                            $DatasetVersionsTable, AnalysisRunRecord>(
                        currentTable: table,
                        referencedTable: $$DatasetVersionsTableReferences
                            ._analysisRunsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DatasetVersionsTableReferences(db, table, p0)
                                .analysisRunsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.datasetVersionId == item.id),
                        typedResults: items),
                  if (reportRecordsRefs)
                    await $_getPrefetchedData<DatasetVersionRecord,
                            $DatasetVersionsTable, ReportRecordData>(
                        currentTable: table,
                        referencedTable: $$DatasetVersionsTableReferences
                            ._reportRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DatasetVersionsTableReferences(db, table, p0)
                                .reportRecordsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.datasetVersionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DatasetVersionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DatasetVersionsTable,
    DatasetVersionRecord,
    $$DatasetVersionsTableFilterComposer,
    $$DatasetVersionsTableOrderingComposer,
    $$DatasetVersionsTableAnnotationComposer,
    $$DatasetVersionsTableCreateCompanionBuilder,
    $$DatasetVersionsTableUpdateCompanionBuilder,
    (DatasetVersionRecord, $$DatasetVersionsTableReferences),
    DatasetVersionRecord,
    PrefetchHooks Function(
        {bool cseId,
        bool assessmentId,
        bool analysisRunsRefs,
        bool reportRecordsRefs})>;
typedef $$AnalysisRunsTableCreateCompanionBuilder = AnalysisRunsCompanion
    Function({
  required String id,
  required String cseId,
  Value<String?> assessmentId,
  Value<String?> datasetVersionId,
  Value<DateTime?> obsStart,
  Value<DateTime?> obsEnd,
  Value<String> engineVersion,
  required String rulesEvaluated,
  Value<String> status,
  Value<int> findingsCreated,
  Value<int> baselinesPersisted,
  Value<String?> errorMessage,
  required DateTime startedAt,
  Value<DateTime?> completedAt,
  Value<String?> executedByUserId,
  Value<int> rowid,
});
typedef $$AnalysisRunsTableUpdateCompanionBuilder = AnalysisRunsCompanion
    Function({
  Value<String> id,
  Value<String> cseId,
  Value<String?> assessmentId,
  Value<String?> datasetVersionId,
  Value<DateTime?> obsStart,
  Value<DateTime?> obsEnd,
  Value<String> engineVersion,
  Value<String> rulesEvaluated,
  Value<String> status,
  Value<int> findingsCreated,
  Value<int> baselinesPersisted,
  Value<String?> errorMessage,
  Value<DateTime> startedAt,
  Value<DateTime?> completedAt,
  Value<String?> executedByUserId,
  Value<int> rowid,
});

final class $$AnalysisRunsTableReferences extends BaseReferences<_$AppDatabase,
    $AnalysisRunsTable, AnalysisRunRecord> {
  $$AnalysisRunsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CSEsTable _cseIdTable(_$AppDatabase db) =>
      db.cSEs.createAlias('analysis_runs__cse_id__cses__id');

  $$CSEsTableProcessedTableManager get cseId {
    final $_column = $_itemColumn<String>('cse_id')!;

    final manager = $$CSEsTableTableManager($_db, $_db.cSEs)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AssessmentsTable _assessmentIdTable(_$AppDatabase db) =>
      db.assessments
          .createAlias('analysis_runs__assessment_id__assessments__id');

  $$AssessmentsTableProcessedTableManager? get assessmentId {
    final $_column = $_itemColumn<String>('assessment_id');
    if ($_column == null) return null;
    final manager = $$AssessmentsTableTableManager($_db, $_db.assessments)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_assessmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $DatasetVersionsTable _datasetVersionIdTable(_$AppDatabase db) => db
      .datasetVersions
      .createAlias('analysis_runs__dataset_version_id__dataset_versions__id');

  $$DatasetVersionsTableProcessedTableManager? get datasetVersionId {
    final $_column = $_itemColumn<String>('dataset_version_id');
    if ($_column == null) return null;
    final manager =
        $$DatasetVersionsTableTableManager($_db, $_db.datasetVersions)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_datasetVersionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$FindingsTable, List<FindingRecord>>
      _findingsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.findings,
              aliasName: 'analysis_runs__id__findings__analysis_run_id');

  $$FindingsTableProcessedTableManager get findingsRefs {
    final manager = $$FindingsTableTableManager($_db, $_db.findings).filter(
        (f) => f.analysisRunId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_findingsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ReportRecordsTable, List<ReportRecordData>>
      _reportRecordsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.reportRecords,
              aliasName: 'analysis_runs__id__report_records__analysis_run_id');

  $$ReportRecordsTableProcessedTableManager get reportRecordsRefs {
    final manager = $$ReportRecordsTableTableManager($_db, $_db.reportRecords)
        .filter(
            (f) => f.analysisRunId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_reportRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AnalysisRunsTableFilterComposer
    extends Composer<_$AppDatabase, $AnalysisRunsTable> {
  $$AnalysisRunsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get obsStart => $composableBuilder(
      column: $table.obsStart, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get obsEnd => $composableBuilder(
      column: $table.obsEnd, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get engineVersion => $composableBuilder(
      column: $table.engineVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rulesEvaluated => $composableBuilder(
      column: $table.rulesEvaluated,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get findingsCreated => $composableBuilder(
      column: $table.findingsCreated,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get baselinesPersisted => $composableBuilder(
      column: $table.baselinesPersisted,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get executedByUserId => $composableBuilder(
      column: $table.executedByUserId,
      builder: (column) => ColumnFilters(column));

  $$CSEsTableFilterComposer get cseId {
    final $$CSEsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableFilterComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AssessmentsTableFilterComposer get assessmentId {
    final $$AssessmentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assessmentId,
        referencedTable: $db.assessments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssessmentsTableFilterComposer(
              $db: $db,
              $table: $db.assessments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DatasetVersionsTableFilterComposer get datasetVersionId {
    final $$DatasetVersionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.datasetVersionId,
        referencedTable: $db.datasetVersions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DatasetVersionsTableFilterComposer(
              $db: $db,
              $table: $db.datasetVersions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> findingsRefs(
      Expression<bool> Function($$FindingsTableFilterComposer f) f) {
    final $$FindingsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.findings,
        getReferencedColumn: (t) => t.analysisRunId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FindingsTableFilterComposer(
              $db: $db,
              $table: $db.findings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> reportRecordsRefs(
      Expression<bool> Function($$ReportRecordsTableFilterComposer f) f) {
    final $$ReportRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reportRecords,
        getReferencedColumn: (t) => t.analysisRunId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReportRecordsTableFilterComposer(
              $db: $db,
              $table: $db.reportRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AnalysisRunsTableOrderingComposer
    extends Composer<_$AppDatabase, $AnalysisRunsTable> {
  $$AnalysisRunsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get obsStart => $composableBuilder(
      column: $table.obsStart, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get obsEnd => $composableBuilder(
      column: $table.obsEnd, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get engineVersion => $composableBuilder(
      column: $table.engineVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rulesEvaluated => $composableBuilder(
      column: $table.rulesEvaluated,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get findingsCreated => $composableBuilder(
      column: $table.findingsCreated,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get baselinesPersisted => $composableBuilder(
      column: $table.baselinesPersisted,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get executedByUserId => $composableBuilder(
      column: $table.executedByUserId,
      builder: (column) => ColumnOrderings(column));

  $$CSEsTableOrderingComposer get cseId {
    final $$CSEsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableOrderingComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AssessmentsTableOrderingComposer get assessmentId {
    final $$AssessmentsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assessmentId,
        referencedTable: $db.assessments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssessmentsTableOrderingComposer(
              $db: $db,
              $table: $db.assessments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DatasetVersionsTableOrderingComposer get datasetVersionId {
    final $$DatasetVersionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.datasetVersionId,
        referencedTable: $db.datasetVersions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DatasetVersionsTableOrderingComposer(
              $db: $db,
              $table: $db.datasetVersions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AnalysisRunsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnalysisRunsTable> {
  $$AnalysisRunsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get obsStart =>
      $composableBuilder(column: $table.obsStart, builder: (column) => column);

  GeneratedColumn<DateTime> get obsEnd =>
      $composableBuilder(column: $table.obsEnd, builder: (column) => column);

  GeneratedColumn<String> get engineVersion => $composableBuilder(
      column: $table.engineVersion, builder: (column) => column);

  GeneratedColumn<String> get rulesEvaluated => $composableBuilder(
      column: $table.rulesEvaluated, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get findingsCreated => $composableBuilder(
      column: $table.findingsCreated, builder: (column) => column);

  GeneratedColumn<int> get baselinesPersisted => $composableBuilder(
      column: $table.baselinesPersisted, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<String> get executedByUserId => $composableBuilder(
      column: $table.executedByUserId, builder: (column) => column);

  $$CSEsTableAnnotationComposer get cseId {
    final $$CSEsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableAnnotationComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AssessmentsTableAnnotationComposer get assessmentId {
    final $$AssessmentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assessmentId,
        referencedTable: $db.assessments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssessmentsTableAnnotationComposer(
              $db: $db,
              $table: $db.assessments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DatasetVersionsTableAnnotationComposer get datasetVersionId {
    final $$DatasetVersionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.datasetVersionId,
        referencedTable: $db.datasetVersions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DatasetVersionsTableAnnotationComposer(
              $db: $db,
              $table: $db.datasetVersions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> findingsRefs<T extends Object>(
      Expression<T> Function($$FindingsTableAnnotationComposer a) f) {
    final $$FindingsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.findings,
        getReferencedColumn: (t) => t.analysisRunId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FindingsTableAnnotationComposer(
              $db: $db,
              $table: $db.findings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> reportRecordsRefs<T extends Object>(
      Expression<T> Function($$ReportRecordsTableAnnotationComposer a) f) {
    final $$ReportRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reportRecords,
        getReferencedColumn: (t) => t.analysisRunId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReportRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.reportRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AnalysisRunsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AnalysisRunsTable,
    AnalysisRunRecord,
    $$AnalysisRunsTableFilterComposer,
    $$AnalysisRunsTableOrderingComposer,
    $$AnalysisRunsTableAnnotationComposer,
    $$AnalysisRunsTableCreateCompanionBuilder,
    $$AnalysisRunsTableUpdateCompanionBuilder,
    (AnalysisRunRecord, $$AnalysisRunsTableReferences),
    AnalysisRunRecord,
    PrefetchHooks Function(
        {bool cseId,
        bool assessmentId,
        bool datasetVersionId,
        bool findingsRefs,
        bool reportRecordsRefs})> {
  $$AnalysisRunsTableTableManager(_$AppDatabase db, $AnalysisRunsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnalysisRunsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnalysisRunsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnalysisRunsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> cseId = const Value.absent(),
            Value<String?> assessmentId = const Value.absent(),
            Value<String?> datasetVersionId = const Value.absent(),
            Value<DateTime?> obsStart = const Value.absent(),
            Value<DateTime?> obsEnd = const Value.absent(),
            Value<String> engineVersion = const Value.absent(),
            Value<String> rulesEvaluated = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> findingsCreated = const Value.absent(),
            Value<int> baselinesPersisted = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String?> executedByUserId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AnalysisRunsCompanion(
            id: id,
            cseId: cseId,
            assessmentId: assessmentId,
            datasetVersionId: datasetVersionId,
            obsStart: obsStart,
            obsEnd: obsEnd,
            engineVersion: engineVersion,
            rulesEvaluated: rulesEvaluated,
            status: status,
            findingsCreated: findingsCreated,
            baselinesPersisted: baselinesPersisted,
            errorMessage: errorMessage,
            startedAt: startedAt,
            completedAt: completedAt,
            executedByUserId: executedByUserId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String cseId,
            Value<String?> assessmentId = const Value.absent(),
            Value<String?> datasetVersionId = const Value.absent(),
            Value<DateTime?> obsStart = const Value.absent(),
            Value<DateTime?> obsEnd = const Value.absent(),
            Value<String> engineVersion = const Value.absent(),
            required String rulesEvaluated,
            Value<String> status = const Value.absent(),
            Value<int> findingsCreated = const Value.absent(),
            Value<int> baselinesPersisted = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            required DateTime startedAt,
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String?> executedByUserId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AnalysisRunsCompanion.insert(
            id: id,
            cseId: cseId,
            assessmentId: assessmentId,
            datasetVersionId: datasetVersionId,
            obsStart: obsStart,
            obsEnd: obsEnd,
            engineVersion: engineVersion,
            rulesEvaluated: rulesEvaluated,
            status: status,
            findingsCreated: findingsCreated,
            baselinesPersisted: baselinesPersisted,
            errorMessage: errorMessage,
            startedAt: startedAt,
            completedAt: completedAt,
            executedByUserId: executedByUserId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AnalysisRunsTable, AnalysisRunRecord>(table),
                    $$AnalysisRunsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {cseId = false,
              assessmentId = false,
              datasetVersionId = false,
              findingsRefs = false,
              reportRecordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (findingsRefs) db.findings,
                if (reportRecordsRefs) db.reportRecords
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (cseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.cseId,
                    referencedTable:
                        $$AnalysisRunsTableReferences._cseIdTable(db),
                    referencedColumn:
                        $$AnalysisRunsTableReferences._cseIdTable(db).id,
                  ) as T;
                }
                if (assessmentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.assessmentId,
                    referencedTable:
                        $$AnalysisRunsTableReferences._assessmentIdTable(db),
                    referencedColumn:
                        $$AnalysisRunsTableReferences._assessmentIdTable(db).id,
                  ) as T;
                }
                if (datasetVersionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.datasetVersionId,
                    referencedTable: $$AnalysisRunsTableReferences
                        ._datasetVersionIdTable(db),
                    referencedColumn: $$AnalysisRunsTableReferences
                        ._datasetVersionIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (findingsRefs)
                    await $_getPrefetchedData<AnalysisRunRecord,
                            $AnalysisRunsTable, FindingRecord>(
                        currentTable: table,
                        referencedTable: $$AnalysisRunsTableReferences
                            ._findingsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AnalysisRunsTableReferences(db, table, p0)
                                .findingsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.analysisRunId == item.id),
                        typedResults: items),
                  if (reportRecordsRefs)
                    await $_getPrefetchedData<AnalysisRunRecord,
                            $AnalysisRunsTable, ReportRecordData>(
                        currentTable: table,
                        referencedTable: $$AnalysisRunsTableReferences
                            ._reportRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AnalysisRunsTableReferences(db, table, p0)
                                .reportRecordsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.analysisRunId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AnalysisRunsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AnalysisRunsTable,
    AnalysisRunRecord,
    $$AnalysisRunsTableFilterComposer,
    $$AnalysisRunsTableOrderingComposer,
    $$AnalysisRunsTableAnnotationComposer,
    $$AnalysisRunsTableCreateCompanionBuilder,
    $$AnalysisRunsTableUpdateCompanionBuilder,
    (AnalysisRunRecord, $$AnalysisRunsTableReferences),
    AnalysisRunRecord,
    PrefetchHooks Function(
        {bool cseId,
        bool assessmentId,
        bool datasetVersionId,
        bool findingsRefs,
        bool reportRecordsRefs})>;
typedef $$FindingsTableCreateCompanionBuilder = FindingsCompanion Function({
  required String id,
  required String findingCode,
  required String cseId,
  Value<String?> batchId,
  Value<String?> analysisRunId,
  required String category,
  required String severity,
  required String title,
  required String description,
  required String rationale,
  required String detectionMethod,
  Value<String?> metricsJson,
  Value<String> status,
  required DateTime detectedAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$FindingsTableUpdateCompanionBuilder = FindingsCompanion Function({
  Value<String> id,
  Value<String> findingCode,
  Value<String> cseId,
  Value<String?> batchId,
  Value<String?> analysisRunId,
  Value<String> category,
  Value<String> severity,
  Value<String> title,
  Value<String> description,
  Value<String> rationale,
  Value<String> detectionMethod,
  Value<String?> metricsJson,
  Value<String> status,
  Value<DateTime> detectedAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$FindingsTableReferences
    extends BaseReferences<_$AppDatabase, $FindingsTable, FindingRecord> {
  $$FindingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CSEsTable _cseIdTable(_$AppDatabase db) =>
      db.cSEs.createAlias('findings__cse_id__cses__id');

  $$CSEsTableProcessedTableManager get cseId {
    final $_column = $_itemColumn<String>('cse_id')!;

    final manager = $$CSEsTableTableManager($_db, $_db.cSEs)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AnalysisRunsTable _analysisRunIdTable(_$AppDatabase db) =>
      db.analysisRuns
          .createAlias('findings__analysis_run_id__analysis_runs__id');

  $$AnalysisRunsTableProcessedTableManager? get analysisRunId {
    final $_column = $_itemColumn<String>('analysis_run_id');
    if ($_column == null) return null;
    final manager = $$AnalysisRunsTableTableManager($_db, $_db.analysisRuns)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_analysisRunIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$FindingEvidencesTable,
      List<FindingEvidenceRecord>> _findingEvidencesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.findingEvidences,
          aliasName: 'findings__id__finding_evidences__finding_id');

  $$FindingEvidencesTableProcessedTableManager get findingEvidencesRefs {
    final manager = $$FindingEvidencesTableTableManager(
            $_db, $_db.findingEvidences)
        .filter((f) => f.findingId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_findingEvidencesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$FindingReviewHistoriesTable,
      List<FindingReviewHistoryRecord>> _findingReviewHistoriesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.findingReviewHistories,
          aliasName: 'findings__id__finding_review_histories__finding_id');

  $$FindingReviewHistoriesTableProcessedTableManager
      get findingReviewHistoriesRefs {
    final manager = $$FindingReviewHistoriesTableTableManager(
            $_db, $_db.findingReviewHistories)
        .filter((f) => f.findingId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_findingReviewHistoriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$FindingsTableFilterComposer
    extends Composer<_$AppDatabase, $FindingsTable> {
  $$FindingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get findingCode => $composableBuilder(
      column: $table.findingCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get batchId => $composableBuilder(
      column: $table.batchId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get severity => $composableBuilder(
      column: $table.severity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rationale => $composableBuilder(
      column: $table.rationale, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get detectionMethod => $composableBuilder(
      column: $table.detectionMethod,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metricsJson => $composableBuilder(
      column: $table.metricsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get detectedAt => $composableBuilder(
      column: $table.detectedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$CSEsTableFilterComposer get cseId {
    final $$CSEsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableFilterComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AnalysisRunsTableFilterComposer get analysisRunId {
    final $$AnalysisRunsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.analysisRunId,
        referencedTable: $db.analysisRuns,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnalysisRunsTableFilterComposer(
              $db: $db,
              $table: $db.analysisRuns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> findingEvidencesRefs(
      Expression<bool> Function($$FindingEvidencesTableFilterComposer f) f) {
    final $$FindingEvidencesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.findingEvidences,
        getReferencedColumn: (t) => t.findingId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FindingEvidencesTableFilterComposer(
              $db: $db,
              $table: $db.findingEvidences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> findingReviewHistoriesRefs(
      Expression<bool> Function($$FindingReviewHistoriesTableFilterComposer f)
          f) {
    final $$FindingReviewHistoriesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.findingReviewHistories,
            getReferencedColumn: (t) => t.findingId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$FindingReviewHistoriesTableFilterComposer(
                  $db: $db,
                  $table: $db.findingReviewHistories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$FindingsTableOrderingComposer
    extends Composer<_$AppDatabase, $FindingsTable> {
  $$FindingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get findingCode => $composableBuilder(
      column: $table.findingCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get batchId => $composableBuilder(
      column: $table.batchId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get severity => $composableBuilder(
      column: $table.severity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rationale => $composableBuilder(
      column: $table.rationale, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get detectionMethod => $composableBuilder(
      column: $table.detectionMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metricsJson => $composableBuilder(
      column: $table.metricsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get detectedAt => $composableBuilder(
      column: $table.detectedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$CSEsTableOrderingComposer get cseId {
    final $$CSEsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableOrderingComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AnalysisRunsTableOrderingComposer get analysisRunId {
    final $$AnalysisRunsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.analysisRunId,
        referencedTable: $db.analysisRuns,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnalysisRunsTableOrderingComposer(
              $db: $db,
              $table: $db.analysisRuns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FindingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FindingsTable> {
  $$FindingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get findingCode => $composableBuilder(
      column: $table.findingCode, builder: (column) => column);

  GeneratedColumn<String> get batchId =>
      $composableBuilder(column: $table.batchId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get rationale =>
      $composableBuilder(column: $table.rationale, builder: (column) => column);

  GeneratedColumn<String> get detectionMethod => $composableBuilder(
      column: $table.detectionMethod, builder: (column) => column);

  GeneratedColumn<String> get metricsJson => $composableBuilder(
      column: $table.metricsJson, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get detectedAt => $composableBuilder(
      column: $table.detectedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CSEsTableAnnotationComposer get cseId {
    final $$CSEsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableAnnotationComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AnalysisRunsTableAnnotationComposer get analysisRunId {
    final $$AnalysisRunsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.analysisRunId,
        referencedTable: $db.analysisRuns,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnalysisRunsTableAnnotationComposer(
              $db: $db,
              $table: $db.analysisRuns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> findingEvidencesRefs<T extends Object>(
      Expression<T> Function($$FindingEvidencesTableAnnotationComposer a) f) {
    final $$FindingEvidencesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.findingEvidences,
        getReferencedColumn: (t) => t.findingId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FindingEvidencesTableAnnotationComposer(
              $db: $db,
              $table: $db.findingEvidences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> findingReviewHistoriesRefs<T extends Object>(
      Expression<T> Function($$FindingReviewHistoriesTableAnnotationComposer a)
          f) {
    final $$FindingReviewHistoriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.findingReviewHistories,
            getReferencedColumn: (t) => t.findingId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$FindingReviewHistoriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.findingReviewHistories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$FindingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FindingsTable,
    FindingRecord,
    $$FindingsTableFilterComposer,
    $$FindingsTableOrderingComposer,
    $$FindingsTableAnnotationComposer,
    $$FindingsTableCreateCompanionBuilder,
    $$FindingsTableUpdateCompanionBuilder,
    (FindingRecord, $$FindingsTableReferences),
    FindingRecord,
    PrefetchHooks Function(
        {bool cseId,
        bool analysisRunId,
        bool findingEvidencesRefs,
        bool findingReviewHistoriesRefs})> {
  $$FindingsTableTableManager(_$AppDatabase db, $FindingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FindingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FindingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FindingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> findingCode = const Value.absent(),
            Value<String> cseId = const Value.absent(),
            Value<String?> batchId = const Value.absent(),
            Value<String?> analysisRunId = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> severity = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> rationale = const Value.absent(),
            Value<String> detectionMethod = const Value.absent(),
            Value<String?> metricsJson = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> detectedAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FindingsCompanion(
            id: id,
            findingCode: findingCode,
            cseId: cseId,
            batchId: batchId,
            analysisRunId: analysisRunId,
            category: category,
            severity: severity,
            title: title,
            description: description,
            rationale: rationale,
            detectionMethod: detectionMethod,
            metricsJson: metricsJson,
            status: status,
            detectedAt: detectedAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String findingCode,
            required String cseId,
            Value<String?> batchId = const Value.absent(),
            Value<String?> analysisRunId = const Value.absent(),
            required String category,
            required String severity,
            required String title,
            required String description,
            required String rationale,
            required String detectionMethod,
            Value<String?> metricsJson = const Value.absent(),
            Value<String> status = const Value.absent(),
            required DateTime detectedAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              FindingsCompanion.insert(
            id: id,
            findingCode: findingCode,
            cseId: cseId,
            batchId: batchId,
            analysisRunId: analysisRunId,
            category: category,
            severity: severity,
            title: title,
            description: description,
            rationale: rationale,
            detectionMethod: detectionMethod,
            metricsJson: metricsJson,
            status: status,
            detectedAt: detectedAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$FindingsTable, FindingRecord>(table),
                    $$FindingsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {cseId = false,
              analysisRunId = false,
              findingEvidencesRefs = false,
              findingReviewHistoriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (findingEvidencesRefs) db.findingEvidences,
                if (findingReviewHistoriesRefs) db.findingReviewHistories
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (cseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.cseId,
                    referencedTable: $$FindingsTableReferences._cseIdTable(db),
                    referencedColumn:
                        $$FindingsTableReferences._cseIdTable(db).id,
                  ) as T;
                }
                if (analysisRunId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.analysisRunId,
                    referencedTable:
                        $$FindingsTableReferences._analysisRunIdTable(db),
                    referencedColumn:
                        $$FindingsTableReferences._analysisRunIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (findingEvidencesRefs)
                    await $_getPrefetchedData<FindingRecord, $FindingsTable,
                            FindingEvidenceRecord>(
                        currentTable: table,
                        referencedTable: $$FindingsTableReferences
                            ._findingEvidencesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$FindingsTableReferences(db, table, p0)
                                .findingEvidencesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.findingId == item.id),
                        typedResults: items),
                  if (findingReviewHistoriesRefs)
                    await $_getPrefetchedData<FindingRecord, $FindingsTable,
                            FindingReviewHistoryRecord>(
                        currentTable: table,
                        referencedTable: $$FindingsTableReferences
                            ._findingReviewHistoriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$FindingsTableReferences(db, table, p0)
                                .findingReviewHistoriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.findingId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$FindingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FindingsTable,
    FindingRecord,
    $$FindingsTableFilterComposer,
    $$FindingsTableOrderingComposer,
    $$FindingsTableAnnotationComposer,
    $$FindingsTableCreateCompanionBuilder,
    $$FindingsTableUpdateCompanionBuilder,
    (FindingRecord, $$FindingsTableReferences),
    FindingRecord,
    PrefetchHooks Function(
        {bool cseId,
        bool analysisRunId,
        bool findingEvidencesRefs,
        bool findingReviewHistoriesRefs})>;
typedef $$AssetsTableCreateCompanionBuilder = AssetsCompanion Function({
  required String id,
  required String cseId,
  required String assetIdentifier,
  required String name,
  Value<String> assetType,
  Value<String?> ipAddress,
  Value<String?> hostname,
  Value<String> criticality,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$AssetsTableUpdateCompanionBuilder = AssetsCompanion Function({
  Value<String> id,
  Value<String> cseId,
  Value<String> assetIdentifier,
  Value<String> name,
  Value<String> assetType,
  Value<String?> ipAddress,
  Value<String?> hostname,
  Value<String> criticality,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$AssetsTableReferences
    extends BaseReferences<_$AppDatabase, $AssetsTable, AssetRecord> {
  $$AssetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CSEsTable _cseIdTable(_$AppDatabase db) =>
      db.cSEs.createAlias('assets__cse_id__cses__id');

  $$CSEsTableProcessedTableManager get cseId {
    final $_column = $_itemColumn<String>('cse_id')!;

    final manager = $$CSEsTableTableManager($_db, $_db.cSEs)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$AlertsTable, List<AlertRecord>> _alertsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.alerts,
          aliasName: 'assets__id__alerts__asset_id');

  $$AlertsTableProcessedTableManager get alertsRefs {
    final manager = $$AlertsTableTableManager($_db, $_db.alerts)
        .filter((f) => f.assetId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_alertsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AssetsTableFilterComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get assetIdentifier => $composableBuilder(
      column: $table.assetIdentifier,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get assetType => $composableBuilder(
      column: $table.assetType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ipAddress => $composableBuilder(
      column: $table.ipAddress, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hostname => $composableBuilder(
      column: $table.hostname, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get criticality => $composableBuilder(
      column: $table.criticality, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$CSEsTableFilterComposer get cseId {
    final $$CSEsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableFilterComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> alertsRefs(
      Expression<bool> Function($$AlertsTableFilterComposer f) f) {
    final $$AlertsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.alerts,
        getReferencedColumn: (t) => t.assetId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AlertsTableFilterComposer(
              $db: $db,
              $table: $db.alerts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AssetsTableOrderingComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assetIdentifier => $composableBuilder(
      column: $table.assetIdentifier,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assetType => $composableBuilder(
      column: $table.assetType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ipAddress => $composableBuilder(
      column: $table.ipAddress, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hostname => $composableBuilder(
      column: $table.hostname, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get criticality => $composableBuilder(
      column: $table.criticality, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CSEsTableOrderingComposer get cseId {
    final $$CSEsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableOrderingComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AssetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get assetIdentifier => $composableBuilder(
      column: $table.assetIdentifier, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get assetType =>
      $composableBuilder(column: $table.assetType, builder: (column) => column);

  GeneratedColumn<String> get ipAddress =>
      $composableBuilder(column: $table.ipAddress, builder: (column) => column);

  GeneratedColumn<String> get hostname =>
      $composableBuilder(column: $table.hostname, builder: (column) => column);

  GeneratedColumn<String> get criticality => $composableBuilder(
      column: $table.criticality, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CSEsTableAnnotationComposer get cseId {
    final $$CSEsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableAnnotationComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> alertsRefs<T extends Object>(
      Expression<T> Function($$AlertsTableAnnotationComposer a) f) {
    final $$AlertsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.alerts,
        getReferencedColumn: (t) => t.assetId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AlertsTableAnnotationComposer(
              $db: $db,
              $table: $db.alerts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AssetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AssetsTable,
    AssetRecord,
    $$AssetsTableFilterComposer,
    $$AssetsTableOrderingComposer,
    $$AssetsTableAnnotationComposer,
    $$AssetsTableCreateCompanionBuilder,
    $$AssetsTableUpdateCompanionBuilder,
    (AssetRecord, $$AssetsTableReferences),
    AssetRecord,
    PrefetchHooks Function({bool cseId, bool alertsRefs})> {
  $$AssetsTableTableManager(_$AppDatabase db, $AssetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> cseId = const Value.absent(),
            Value<String> assetIdentifier = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> assetType = const Value.absent(),
            Value<String?> ipAddress = const Value.absent(),
            Value<String?> hostname = const Value.absent(),
            Value<String> criticality = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AssetsCompanion(
            id: id,
            cseId: cseId,
            assetIdentifier: assetIdentifier,
            name: name,
            assetType: assetType,
            ipAddress: ipAddress,
            hostname: hostname,
            criticality: criticality,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String cseId,
            required String assetIdentifier,
            required String name,
            Value<String> assetType = const Value.absent(),
            Value<String?> ipAddress = const Value.absent(),
            Value<String?> hostname = const Value.absent(),
            Value<String> criticality = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AssetsCompanion.insert(
            id: id,
            cseId: cseId,
            assetIdentifier: assetIdentifier,
            name: name,
            assetType: assetType,
            ipAddress: ipAddress,
            hostname: hostname,
            criticality: criticality,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AssetsTable, AssetRecord>(table),
                    $$AssetsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({cseId = false, alertsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (alertsRefs) db.alerts],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (cseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.cseId,
                    referencedTable: $$AssetsTableReferences._cseIdTable(db),
                    referencedColumn:
                        $$AssetsTableReferences._cseIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (alertsRefs)
                    await $_getPrefetchedData<AssetRecord, $AssetsTable,
                            AlertRecord>(
                        currentTable: table,
                        referencedTable:
                            $$AssetsTableReferences._alertsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AssetsTableReferences(db, table, p0).alertsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.assetId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AssetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AssetsTable,
    AssetRecord,
    $$AssetsTableFilterComposer,
    $$AssetsTableOrderingComposer,
    $$AssetsTableAnnotationComposer,
    $$AssetsTableCreateCompanionBuilder,
    $$AssetsTableUpdateCompanionBuilder,
    (AssetRecord, $$AssetsTableReferences),
    AssetRecord,
    PrefetchHooks Function({bool cseId, bool alertsRefs})>;
typedef $$AlertsTableCreateCompanionBuilder = AlertsCompanion Function({
  required String id,
  required String cseId,
  Value<String?> batchId,
  Value<String?> assetId,
  required String externalAlertId,
  required String title,
  required String category,
  required String severity,
  Value<String> status,
  Value<String?> disposition,
  Value<String?> targetAssetName,
  required DateTime detectedAt,
  Value<DateTime?> closedAt,
  Value<String?> rawMetadata,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$AlertsTableUpdateCompanionBuilder = AlertsCompanion Function({
  Value<String> id,
  Value<String> cseId,
  Value<String?> batchId,
  Value<String?> assetId,
  Value<String> externalAlertId,
  Value<String> title,
  Value<String> category,
  Value<String> severity,
  Value<String> status,
  Value<String?> disposition,
  Value<String?> targetAssetName,
  Value<DateTime> detectedAt,
  Value<DateTime?> closedAt,
  Value<String?> rawMetadata,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$AlertsTableReferences
    extends BaseReferences<_$AppDatabase, $AlertsTable, AlertRecord> {
  $$AlertsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CSEsTable _cseIdTable(_$AppDatabase db) =>
      db.cSEs.createAlias('alerts__cse_id__cses__id');

  $$CSEsTableProcessedTableManager get cseId {
    final $_column = $_itemColumn<String>('cse_id')!;

    final manager = $$CSEsTableTableManager($_db, $_db.cSEs)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AssetsTable _assetIdTable(_$AppDatabase db) =>
      db.assets.createAlias('alerts__asset_id__assets__id');

  $$AssetsTableProcessedTableManager? get assetId {
    final $_column = $_itemColumn<String>('asset_id');
    if ($_column == null) return null;
    final manager = $$AssetsTableTableManager($_db, $_db.assets)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_assetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$CasesTable, List<CaseRecord>> _casesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.cases,
          aliasName: 'alerts__id__cases__alert_id');

  $$CasesTableProcessedTableManager get casesRefs {
    final manager = $$CasesTableTableManager($_db, $_db.cases)
        .filter((f) => f.alertId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_casesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$EscalationsTable, List<EscalationRecord>>
      _escalationsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.escalations,
              aliasName: 'alerts__id__escalations__alert_id');

  $$EscalationsTableProcessedTableManager get escalationsRefs {
    final manager = $$EscalationsTableTableManager($_db, $_db.escalations)
        .filter((f) => f.alertId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_escalationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$FindingEvidencesTable,
      List<FindingEvidenceRecord>> _findingEvidencesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.findingEvidences,
          aliasName: 'alerts__id__finding_evidences__alert_id');

  $$FindingEvidencesTableProcessedTableManager get findingEvidencesRefs {
    final manager =
        $$FindingEvidencesTableTableManager($_db, $_db.findingEvidences)
            .filter((f) => f.alertId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_findingEvidencesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AlertsTableFilterComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get batchId => $composableBuilder(
      column: $table.batchId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get externalAlertId => $composableBuilder(
      column: $table.externalAlertId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get severity => $composableBuilder(
      column: $table.severity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get disposition => $composableBuilder(
      column: $table.disposition, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetAssetName => $composableBuilder(
      column: $table.targetAssetName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get detectedAt => $composableBuilder(
      column: $table.detectedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get closedAt => $composableBuilder(
      column: $table.closedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rawMetadata => $composableBuilder(
      column: $table.rawMetadata, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$CSEsTableFilterComposer get cseId {
    final $$CSEsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableFilterComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AssetsTableFilterComposer get assetId {
    final $$AssetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableFilterComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> casesRefs(
      Expression<bool> Function($$CasesTableFilterComposer f) f) {
    final $$CasesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.cases,
        getReferencedColumn: (t) => t.alertId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CasesTableFilterComposer(
              $db: $db,
              $table: $db.cases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> escalationsRefs(
      Expression<bool> Function($$EscalationsTableFilterComposer f) f) {
    final $$EscalationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.escalations,
        getReferencedColumn: (t) => t.alertId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EscalationsTableFilterComposer(
              $db: $db,
              $table: $db.escalations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> findingEvidencesRefs(
      Expression<bool> Function($$FindingEvidencesTableFilterComposer f) f) {
    final $$FindingEvidencesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.findingEvidences,
        getReferencedColumn: (t) => t.alertId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FindingEvidencesTableFilterComposer(
              $db: $db,
              $table: $db.findingEvidences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AlertsTableOrderingComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get batchId => $composableBuilder(
      column: $table.batchId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get externalAlertId => $composableBuilder(
      column: $table.externalAlertId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get severity => $composableBuilder(
      column: $table.severity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get disposition => $composableBuilder(
      column: $table.disposition, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetAssetName => $composableBuilder(
      column: $table.targetAssetName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get detectedAt => $composableBuilder(
      column: $table.detectedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get closedAt => $composableBuilder(
      column: $table.closedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rawMetadata => $composableBuilder(
      column: $table.rawMetadata, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CSEsTableOrderingComposer get cseId {
    final $$CSEsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableOrderingComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AssetsTableOrderingComposer get assetId {
    final $$AssetsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableOrderingComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AlertsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get batchId =>
      $composableBuilder(column: $table.batchId, builder: (column) => column);

  GeneratedColumn<String> get externalAlertId => $composableBuilder(
      column: $table.externalAlertId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get disposition => $composableBuilder(
      column: $table.disposition, builder: (column) => column);

  GeneratedColumn<String> get targetAssetName => $composableBuilder(
      column: $table.targetAssetName, builder: (column) => column);

  GeneratedColumn<DateTime> get detectedAt => $composableBuilder(
      column: $table.detectedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);

  GeneratedColumn<String> get rawMetadata => $composableBuilder(
      column: $table.rawMetadata, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CSEsTableAnnotationComposer get cseId {
    final $$CSEsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableAnnotationComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AssetsTableAnnotationComposer get assetId {
    final $$AssetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableAnnotationComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> casesRefs<T extends Object>(
      Expression<T> Function($$CasesTableAnnotationComposer a) f) {
    final $$CasesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.cases,
        getReferencedColumn: (t) => t.alertId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CasesTableAnnotationComposer(
              $db: $db,
              $table: $db.cases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> escalationsRefs<T extends Object>(
      Expression<T> Function($$EscalationsTableAnnotationComposer a) f) {
    final $$EscalationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.escalations,
        getReferencedColumn: (t) => t.alertId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EscalationsTableAnnotationComposer(
              $db: $db,
              $table: $db.escalations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> findingEvidencesRefs<T extends Object>(
      Expression<T> Function($$FindingEvidencesTableAnnotationComposer a) f) {
    final $$FindingEvidencesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.findingEvidences,
        getReferencedColumn: (t) => t.alertId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FindingEvidencesTableAnnotationComposer(
              $db: $db,
              $table: $db.findingEvidences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AlertsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AlertsTable,
    AlertRecord,
    $$AlertsTableFilterComposer,
    $$AlertsTableOrderingComposer,
    $$AlertsTableAnnotationComposer,
    $$AlertsTableCreateCompanionBuilder,
    $$AlertsTableUpdateCompanionBuilder,
    (AlertRecord, $$AlertsTableReferences),
    AlertRecord,
    PrefetchHooks Function(
        {bool cseId,
        bool assetId,
        bool casesRefs,
        bool escalationsRefs,
        bool findingEvidencesRefs})> {
  $$AlertsTableTableManager(_$AppDatabase db, $AlertsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlertsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlertsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlertsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> cseId = const Value.absent(),
            Value<String?> batchId = const Value.absent(),
            Value<String?> assetId = const Value.absent(),
            Value<String> externalAlertId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> severity = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> disposition = const Value.absent(),
            Value<String?> targetAssetName = const Value.absent(),
            Value<DateTime> detectedAt = const Value.absent(),
            Value<DateTime?> closedAt = const Value.absent(),
            Value<String?> rawMetadata = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AlertsCompanion(
            id: id,
            cseId: cseId,
            batchId: batchId,
            assetId: assetId,
            externalAlertId: externalAlertId,
            title: title,
            category: category,
            severity: severity,
            status: status,
            disposition: disposition,
            targetAssetName: targetAssetName,
            detectedAt: detectedAt,
            closedAt: closedAt,
            rawMetadata: rawMetadata,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String cseId,
            Value<String?> batchId = const Value.absent(),
            Value<String?> assetId = const Value.absent(),
            required String externalAlertId,
            required String title,
            required String category,
            required String severity,
            Value<String> status = const Value.absent(),
            Value<String?> disposition = const Value.absent(),
            Value<String?> targetAssetName = const Value.absent(),
            required DateTime detectedAt,
            Value<DateTime?> closedAt = const Value.absent(),
            Value<String?> rawMetadata = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AlertsCompanion.insert(
            id: id,
            cseId: cseId,
            batchId: batchId,
            assetId: assetId,
            externalAlertId: externalAlertId,
            title: title,
            category: category,
            severity: severity,
            status: status,
            disposition: disposition,
            targetAssetName: targetAssetName,
            detectedAt: detectedAt,
            closedAt: closedAt,
            rawMetadata: rawMetadata,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AlertsTable, AlertRecord>(table),
                    $$AlertsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {cseId = false,
              assetId = false,
              casesRefs = false,
              escalationsRefs = false,
              findingEvidencesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (casesRefs) db.cases,
                if (escalationsRefs) db.escalations,
                if (findingEvidencesRefs) db.findingEvidences
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (cseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.cseId,
                    referencedTable: $$AlertsTableReferences._cseIdTable(db),
                    referencedColumn:
                        $$AlertsTableReferences._cseIdTable(db).id,
                  ) as T;
                }
                if (assetId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.assetId,
                    referencedTable: $$AlertsTableReferences._assetIdTable(db),
                    referencedColumn:
                        $$AlertsTableReferences._assetIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (casesRefs)
                    await $_getPrefetchedData<AlertRecord, $AlertsTable,
                            CaseRecord>(
                        currentTable: table,
                        referencedTable:
                            $$AlertsTableReferences._casesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AlertsTableReferences(db, table, p0).casesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.alertId == item.id),
                        typedResults: items),
                  if (escalationsRefs)
                    await $_getPrefetchedData<AlertRecord, $AlertsTable,
                            EscalationRecord>(
                        currentTable: table,
                        referencedTable:
                            $$AlertsTableReferences._escalationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AlertsTableReferences(db, table, p0)
                                .escalationsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.alertId == item.id),
                        typedResults: items),
                  if (findingEvidencesRefs)
                    await $_getPrefetchedData<AlertRecord, $AlertsTable, FindingEvidenceRecord>(
                        currentTable: table,
                        referencedTable: $$AlertsTableReferences
                            ._findingEvidencesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AlertsTableReferences(db, table, p0)
                                .findingEvidencesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.alertId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AlertsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AlertsTable,
    AlertRecord,
    $$AlertsTableFilterComposer,
    $$AlertsTableOrderingComposer,
    $$AlertsTableAnnotationComposer,
    $$AlertsTableCreateCompanionBuilder,
    $$AlertsTableUpdateCompanionBuilder,
    (AlertRecord, $$AlertsTableReferences),
    AlertRecord,
    PrefetchHooks Function(
        {bool cseId,
        bool assetId,
        bool casesRefs,
        bool escalationsRefs,
        bool findingEvidencesRefs})>;
typedef $$CasesTableCreateCompanionBuilder = CasesCompanion Function({
  required String id,
  required String cseId,
  Value<String?> batchId,
  Value<String?> alertId,
  required String externalCaseId,
  required String title,
  Value<String> status,
  Value<String> priority,
  Value<String?> summary,
  required DateTime openedAt,
  Value<DateTime?> closedAt,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$CasesTableUpdateCompanionBuilder = CasesCompanion Function({
  Value<String> id,
  Value<String> cseId,
  Value<String?> batchId,
  Value<String?> alertId,
  Value<String> externalCaseId,
  Value<String> title,
  Value<String> status,
  Value<String> priority,
  Value<String?> summary,
  Value<DateTime> openedAt,
  Value<DateTime?> closedAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$CasesTableReferences
    extends BaseReferences<_$AppDatabase, $CasesTable, CaseRecord> {
  $$CasesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CSEsTable _cseIdTable(_$AppDatabase db) =>
      db.cSEs.createAlias('cases__cse_id__cses__id');

  $$CSEsTableProcessedTableManager get cseId {
    final $_column = $_itemColumn<String>('cse_id')!;

    final manager = $$CSEsTableTableManager($_db, $_db.cSEs)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AlertsTable _alertIdTable(_$AppDatabase db) =>
      db.alerts.createAlias('cases__alert_id__alerts__id');

  $$AlertsTableProcessedTableManager? get alertId {
    final $_column = $_itemColumn<String>('alert_id');
    if ($_column == null) return null;
    final manager = $$AlertsTableTableManager($_db, $_db.alerts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_alertIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$InvestigationsTable, List<InvestigationRecord>>
      _investigationsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.investigations,
              aliasName: 'cases__id__investigations__case_id');

  $$InvestigationsTableProcessedTableManager get investigationsRefs {
    final manager = $$InvestigationsTableTableManager($_db, $_db.investigations)
        .filter((f) => f.caseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_investigationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$EscalationsTable, List<EscalationRecord>>
      _escalationsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.escalations,
              aliasName: 'cases__id__escalations__case_id');

  $$EscalationsTableProcessedTableManager get escalationsRefs {
    final manager = $$EscalationsTableTableManager($_db, $_db.escalations)
        .filter((f) => f.caseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_escalationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$FindingEvidencesTable,
      List<FindingEvidenceRecord>> _findingEvidencesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.findingEvidences,
          aliasName: 'cases__id__finding_evidences__case_id');

  $$FindingEvidencesTableProcessedTableManager get findingEvidencesRefs {
    final manager =
        $$FindingEvidencesTableTableManager($_db, $_db.findingEvidences)
            .filter((f) => f.caseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_findingEvidencesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CasesTableFilterComposer extends Composer<_$AppDatabase, $CasesTable> {
  $$CasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get batchId => $composableBuilder(
      column: $table.batchId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get externalCaseId => $composableBuilder(
      column: $table.externalCaseId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get openedAt => $composableBuilder(
      column: $table.openedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get closedAt => $composableBuilder(
      column: $table.closedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$CSEsTableFilterComposer get cseId {
    final $$CSEsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableFilterComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AlertsTableFilterComposer get alertId {
    final $$AlertsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.alertId,
        referencedTable: $db.alerts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AlertsTableFilterComposer(
              $db: $db,
              $table: $db.alerts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> investigationsRefs(
      Expression<bool> Function($$InvestigationsTableFilterComposer f) f) {
    final $$InvestigationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.investigations,
        getReferencedColumn: (t) => t.caseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvestigationsTableFilterComposer(
              $db: $db,
              $table: $db.investigations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> escalationsRefs(
      Expression<bool> Function($$EscalationsTableFilterComposer f) f) {
    final $$EscalationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.escalations,
        getReferencedColumn: (t) => t.caseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EscalationsTableFilterComposer(
              $db: $db,
              $table: $db.escalations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> findingEvidencesRefs(
      Expression<bool> Function($$FindingEvidencesTableFilterComposer f) f) {
    final $$FindingEvidencesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.findingEvidences,
        getReferencedColumn: (t) => t.caseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FindingEvidencesTableFilterComposer(
              $db: $db,
              $table: $db.findingEvidences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CasesTableOrderingComposer
    extends Composer<_$AppDatabase, $CasesTable> {
  $$CasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get batchId => $composableBuilder(
      column: $table.batchId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get externalCaseId => $composableBuilder(
      column: $table.externalCaseId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get openedAt => $composableBuilder(
      column: $table.openedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get closedAt => $composableBuilder(
      column: $table.closedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CSEsTableOrderingComposer get cseId {
    final $$CSEsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableOrderingComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AlertsTableOrderingComposer get alertId {
    final $$AlertsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.alertId,
        referencedTable: $db.alerts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AlertsTableOrderingComposer(
              $db: $db,
              $table: $db.alerts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CasesTable> {
  $$CasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get batchId =>
      $composableBuilder(column: $table.batchId, builder: (column) => column);

  GeneratedColumn<String> get externalCaseId => $composableBuilder(
      column: $table.externalCaseId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<DateTime> get openedAt =>
      $composableBuilder(column: $table.openedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CSEsTableAnnotationComposer get cseId {
    final $$CSEsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableAnnotationComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AlertsTableAnnotationComposer get alertId {
    final $$AlertsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.alertId,
        referencedTable: $db.alerts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AlertsTableAnnotationComposer(
              $db: $db,
              $table: $db.alerts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> investigationsRefs<T extends Object>(
      Expression<T> Function($$InvestigationsTableAnnotationComposer a) f) {
    final $$InvestigationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.investigations,
        getReferencedColumn: (t) => t.caseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvestigationsTableAnnotationComposer(
              $db: $db,
              $table: $db.investigations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> escalationsRefs<T extends Object>(
      Expression<T> Function($$EscalationsTableAnnotationComposer a) f) {
    final $$EscalationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.escalations,
        getReferencedColumn: (t) => t.caseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EscalationsTableAnnotationComposer(
              $db: $db,
              $table: $db.escalations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> findingEvidencesRefs<T extends Object>(
      Expression<T> Function($$FindingEvidencesTableAnnotationComposer a) f) {
    final $$FindingEvidencesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.findingEvidences,
        getReferencedColumn: (t) => t.caseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FindingEvidencesTableAnnotationComposer(
              $db: $db,
              $table: $db.findingEvidences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CasesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CasesTable,
    CaseRecord,
    $$CasesTableFilterComposer,
    $$CasesTableOrderingComposer,
    $$CasesTableAnnotationComposer,
    $$CasesTableCreateCompanionBuilder,
    $$CasesTableUpdateCompanionBuilder,
    (CaseRecord, $$CasesTableReferences),
    CaseRecord,
    PrefetchHooks Function(
        {bool cseId,
        bool alertId,
        bool investigationsRefs,
        bool escalationsRefs,
        bool findingEvidencesRefs})> {
  $$CasesTableTableManager(_$AppDatabase db, $CasesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> cseId = const Value.absent(),
            Value<String?> batchId = const Value.absent(),
            Value<String?> alertId = const Value.absent(),
            Value<String> externalCaseId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> priority = const Value.absent(),
            Value<String?> summary = const Value.absent(),
            Value<DateTime> openedAt = const Value.absent(),
            Value<DateTime?> closedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CasesCompanion(
            id: id,
            cseId: cseId,
            batchId: batchId,
            alertId: alertId,
            externalCaseId: externalCaseId,
            title: title,
            status: status,
            priority: priority,
            summary: summary,
            openedAt: openedAt,
            closedAt: closedAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String cseId,
            Value<String?> batchId = const Value.absent(),
            Value<String?> alertId = const Value.absent(),
            required String externalCaseId,
            required String title,
            Value<String> status = const Value.absent(),
            Value<String> priority = const Value.absent(),
            Value<String?> summary = const Value.absent(),
            required DateTime openedAt,
            Value<DateTime?> closedAt = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CasesCompanion.insert(
            id: id,
            cseId: cseId,
            batchId: batchId,
            alertId: alertId,
            externalCaseId: externalCaseId,
            title: title,
            status: status,
            priority: priority,
            summary: summary,
            openedAt: openedAt,
            closedAt: closedAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$CasesTable, CaseRecord>(table),
                    $$CasesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {cseId = false,
              alertId = false,
              investigationsRefs = false,
              escalationsRefs = false,
              findingEvidencesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (investigationsRefs) db.investigations,
                if (escalationsRefs) db.escalations,
                if (findingEvidencesRefs) db.findingEvidences
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (cseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.cseId,
                    referencedTable: $$CasesTableReferences._cseIdTable(db),
                    referencedColumn: $$CasesTableReferences._cseIdTable(db).id,
                  ) as T;
                }
                if (alertId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.alertId,
                    referencedTable: $$CasesTableReferences._alertIdTable(db),
                    referencedColumn:
                        $$CasesTableReferences._alertIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (investigationsRefs)
                    await $_getPrefetchedData<CaseRecord, $CasesTable,
                            InvestigationRecord>(
                        currentTable: table,
                        referencedTable:
                            $$CasesTableReferences._investigationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CasesTableReferences(db, table, p0)
                                .investigationsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.caseId == item.id),
                        typedResults: items),
                  if (escalationsRefs)
                    await $_getPrefetchedData<CaseRecord, $CasesTable,
                            EscalationRecord>(
                        currentTable: table,
                        referencedTable:
                            $$CasesTableReferences._escalationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CasesTableReferences(db, table, p0)
                                .escalationsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.caseId == item.id),
                        typedResults: items),
                  if (findingEvidencesRefs)
                    await $_getPrefetchedData<CaseRecord, $CasesTable,
                            FindingEvidenceRecord>(
                        currentTable: table,
                        referencedTable: $$CasesTableReferences
                            ._findingEvidencesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CasesTableReferences(db, table, p0)
                                .findingEvidencesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.caseId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CasesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CasesTable,
    CaseRecord,
    $$CasesTableFilterComposer,
    $$CasesTableOrderingComposer,
    $$CasesTableAnnotationComposer,
    $$CasesTableCreateCompanionBuilder,
    $$CasesTableUpdateCompanionBuilder,
    (CaseRecord, $$CasesTableReferences),
    CaseRecord,
    PrefetchHooks Function(
        {bool cseId,
        bool alertId,
        bool investigationsRefs,
        bool escalationsRefs,
        bool findingEvidencesRefs})>;
typedef $$InvestigationsTableCreateCompanionBuilder = InvestigationsCompanion
    Function({
  required String id,
  required String caseId,
  Value<String?> externalInvestigationId,
  Value<String?> investigatorRef,
  required String actionType,
  Value<String?> notes,
  required DateTime startedAt,
  Value<DateTime?> completedAt,
  Value<int> evidenceCount,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$InvestigationsTableUpdateCompanionBuilder = InvestigationsCompanion
    Function({
  Value<String> id,
  Value<String> caseId,
  Value<String?> externalInvestigationId,
  Value<String?> investigatorRef,
  Value<String> actionType,
  Value<String?> notes,
  Value<DateTime> startedAt,
  Value<DateTime?> completedAt,
  Value<int> evidenceCount,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$InvestigationsTableReferences extends BaseReferences<
    _$AppDatabase, $InvestigationsTable, InvestigationRecord> {
  $$InvestigationsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $CasesTable _caseIdTable(_$AppDatabase db) =>
      db.cases.createAlias('investigations__case_id__cases__id');

  $$CasesTableProcessedTableManager get caseId {
    final $_column = $_itemColumn<String>('case_id')!;

    final manager = $$CasesTableTableManager($_db, $_db.cases)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_caseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$FindingEvidencesTable,
      List<FindingEvidenceRecord>> _findingEvidencesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.findingEvidences,
          aliasName: 'investigations__id__finding_evidences__investigation_id');

  $$FindingEvidencesTableProcessedTableManager get findingEvidencesRefs {
    final manager =
        $$FindingEvidencesTableTableManager($_db, $_db.findingEvidences).filter(
            (f) => f.investigationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_findingEvidencesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$InvestigationsTableFilterComposer
    extends Composer<_$AppDatabase, $InvestigationsTable> {
  $$InvestigationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get externalInvestigationId => $composableBuilder(
      column: $table.externalInvestigationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get investigatorRef => $composableBuilder(
      column: $table.investigatorRef,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actionType => $composableBuilder(
      column: $table.actionType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get evidenceCount => $composableBuilder(
      column: $table.evidenceCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$CasesTableFilterComposer get caseId {
    final $$CasesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.caseId,
        referencedTable: $db.cases,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CasesTableFilterComposer(
              $db: $db,
              $table: $db.cases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> findingEvidencesRefs(
      Expression<bool> Function($$FindingEvidencesTableFilterComposer f) f) {
    final $$FindingEvidencesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.findingEvidences,
        getReferencedColumn: (t) => t.investigationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FindingEvidencesTableFilterComposer(
              $db: $db,
              $table: $db.findingEvidences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$InvestigationsTableOrderingComposer
    extends Composer<_$AppDatabase, $InvestigationsTable> {
  $$InvestigationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get externalInvestigationId => $composableBuilder(
      column: $table.externalInvestigationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get investigatorRef => $composableBuilder(
      column: $table.investigatorRef,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actionType => $composableBuilder(
      column: $table.actionType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get evidenceCount => $composableBuilder(
      column: $table.evidenceCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CasesTableOrderingComposer get caseId {
    final $$CasesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.caseId,
        referencedTable: $db.cases,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CasesTableOrderingComposer(
              $db: $db,
              $table: $db.cases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InvestigationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvestigationsTable> {
  $$InvestigationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get externalInvestigationId => $composableBuilder(
      column: $table.externalInvestigationId, builder: (column) => column);

  GeneratedColumn<String> get investigatorRef => $composableBuilder(
      column: $table.investigatorRef, builder: (column) => column);

  GeneratedColumn<String> get actionType => $composableBuilder(
      column: $table.actionType, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<int> get evidenceCount => $composableBuilder(
      column: $table.evidenceCount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CasesTableAnnotationComposer get caseId {
    final $$CasesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.caseId,
        referencedTable: $db.cases,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CasesTableAnnotationComposer(
              $db: $db,
              $table: $db.cases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> findingEvidencesRefs<T extends Object>(
      Expression<T> Function($$FindingEvidencesTableAnnotationComposer a) f) {
    final $$FindingEvidencesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.findingEvidences,
        getReferencedColumn: (t) => t.investigationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FindingEvidencesTableAnnotationComposer(
              $db: $db,
              $table: $db.findingEvidences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$InvestigationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InvestigationsTable,
    InvestigationRecord,
    $$InvestigationsTableFilterComposer,
    $$InvestigationsTableOrderingComposer,
    $$InvestigationsTableAnnotationComposer,
    $$InvestigationsTableCreateCompanionBuilder,
    $$InvestigationsTableUpdateCompanionBuilder,
    (InvestigationRecord, $$InvestigationsTableReferences),
    InvestigationRecord,
    PrefetchHooks Function({bool caseId, bool findingEvidencesRefs})> {
  $$InvestigationsTableTableManager(
      _$AppDatabase db, $InvestigationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvestigationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvestigationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvestigationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> caseId = const Value.absent(),
            Value<String?> externalInvestigationId = const Value.absent(),
            Value<String?> investigatorRef = const Value.absent(),
            Value<String> actionType = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int> evidenceCount = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InvestigationsCompanion(
            id: id,
            caseId: caseId,
            externalInvestigationId: externalInvestigationId,
            investigatorRef: investigatorRef,
            actionType: actionType,
            notes: notes,
            startedAt: startedAt,
            completedAt: completedAt,
            evidenceCount: evidenceCount,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String caseId,
            Value<String?> externalInvestigationId = const Value.absent(),
            Value<String?> investigatorRef = const Value.absent(),
            required String actionType,
            Value<String?> notes = const Value.absent(),
            required DateTime startedAt,
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int> evidenceCount = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              InvestigationsCompanion.insert(
            id: id,
            caseId: caseId,
            externalInvestigationId: externalInvestigationId,
            investigatorRef: investigatorRef,
            actionType: actionType,
            notes: notes,
            startedAt: startedAt,
            completedAt: completedAt,
            evidenceCount: evidenceCount,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$InvestigationsTable, InvestigationRecord>(
                        table),
                    $$InvestigationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {caseId = false, findingEvidencesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (findingEvidencesRefs) db.findingEvidences
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (caseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.caseId,
                    referencedTable:
                        $$InvestigationsTableReferences._caseIdTable(db),
                    referencedColumn:
                        $$InvestigationsTableReferences._caseIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (findingEvidencesRefs)
                    await $_getPrefetchedData<InvestigationRecord,
                            $InvestigationsTable, FindingEvidenceRecord>(
                        currentTable: table,
                        referencedTable: $$InvestigationsTableReferences
                            ._findingEvidencesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$InvestigationsTableReferences(db, table, p0)
                                .findingEvidencesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.investigationId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$InvestigationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $InvestigationsTable,
    InvestigationRecord,
    $$InvestigationsTableFilterComposer,
    $$InvestigationsTableOrderingComposer,
    $$InvestigationsTableAnnotationComposer,
    $$InvestigationsTableCreateCompanionBuilder,
    $$InvestigationsTableUpdateCompanionBuilder,
    (InvestigationRecord, $$InvestigationsTableReferences),
    InvestigationRecord,
    PrefetchHooks Function({bool caseId, bool findingEvidencesRefs})>;
typedef $$EscalationsTableCreateCompanionBuilder = EscalationsCompanion
    Function({
  required String id,
  required String caseId,
  Value<String?> alertId,
  required String escalationLevel,
  Value<String?> reason,
  Value<String> status,
  required DateTime escalatedAt,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$EscalationsTableUpdateCompanionBuilder = EscalationsCompanion
    Function({
  Value<String> id,
  Value<String> caseId,
  Value<String?> alertId,
  Value<String> escalationLevel,
  Value<String?> reason,
  Value<String> status,
  Value<DateTime> escalatedAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$EscalationsTableReferences
    extends BaseReferences<_$AppDatabase, $EscalationsTable, EscalationRecord> {
  $$EscalationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CasesTable _caseIdTable(_$AppDatabase db) =>
      db.cases.createAlias('escalations__case_id__cases__id');

  $$CasesTableProcessedTableManager get caseId {
    final $_column = $_itemColumn<String>('case_id')!;

    final manager = $$CasesTableTableManager($_db, $_db.cases)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_caseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AlertsTable _alertIdTable(_$AppDatabase db) =>
      db.alerts.createAlias('escalations__alert_id__alerts__id');

  $$AlertsTableProcessedTableManager? get alertId {
    final $_column = $_itemColumn<String>('alert_id');
    if ($_column == null) return null;
    final manager = $$AlertsTableTableManager($_db, $_db.alerts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_alertIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$FindingEvidencesTable,
      List<FindingEvidenceRecord>> _findingEvidencesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.findingEvidences,
          aliasName: 'escalations__id__finding_evidences__escalation_id');

  $$FindingEvidencesTableProcessedTableManager get findingEvidencesRefs {
    final manager =
        $$FindingEvidencesTableTableManager($_db, $_db.findingEvidences).filter(
            (f) => f.escalationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_findingEvidencesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$EscalationsTableFilterComposer
    extends Composer<_$AppDatabase, $EscalationsTable> {
  $$EscalationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get escalationLevel => $composableBuilder(
      column: $table.escalationLevel,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get escalatedAt => $composableBuilder(
      column: $table.escalatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$CasesTableFilterComposer get caseId {
    final $$CasesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.caseId,
        referencedTable: $db.cases,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CasesTableFilterComposer(
              $db: $db,
              $table: $db.cases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AlertsTableFilterComposer get alertId {
    final $$AlertsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.alertId,
        referencedTable: $db.alerts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AlertsTableFilterComposer(
              $db: $db,
              $table: $db.alerts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> findingEvidencesRefs(
      Expression<bool> Function($$FindingEvidencesTableFilterComposer f) f) {
    final $$FindingEvidencesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.findingEvidences,
        getReferencedColumn: (t) => t.escalationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FindingEvidencesTableFilterComposer(
              $db: $db,
              $table: $db.findingEvidences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EscalationsTableOrderingComposer
    extends Composer<_$AppDatabase, $EscalationsTable> {
  $$EscalationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get escalationLevel => $composableBuilder(
      column: $table.escalationLevel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get escalatedAt => $composableBuilder(
      column: $table.escalatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CasesTableOrderingComposer get caseId {
    final $$CasesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.caseId,
        referencedTable: $db.cases,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CasesTableOrderingComposer(
              $db: $db,
              $table: $db.cases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AlertsTableOrderingComposer get alertId {
    final $$AlertsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.alertId,
        referencedTable: $db.alerts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AlertsTableOrderingComposer(
              $db: $db,
              $table: $db.alerts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EscalationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EscalationsTable> {
  $$EscalationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get escalationLevel => $composableBuilder(
      column: $table.escalationLevel, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get escalatedAt => $composableBuilder(
      column: $table.escalatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CasesTableAnnotationComposer get caseId {
    final $$CasesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.caseId,
        referencedTable: $db.cases,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CasesTableAnnotationComposer(
              $db: $db,
              $table: $db.cases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AlertsTableAnnotationComposer get alertId {
    final $$AlertsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.alertId,
        referencedTable: $db.alerts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AlertsTableAnnotationComposer(
              $db: $db,
              $table: $db.alerts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> findingEvidencesRefs<T extends Object>(
      Expression<T> Function($$FindingEvidencesTableAnnotationComposer a) f) {
    final $$FindingEvidencesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.findingEvidences,
        getReferencedColumn: (t) => t.escalationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FindingEvidencesTableAnnotationComposer(
              $db: $db,
              $table: $db.findingEvidences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EscalationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EscalationsTable,
    EscalationRecord,
    $$EscalationsTableFilterComposer,
    $$EscalationsTableOrderingComposer,
    $$EscalationsTableAnnotationComposer,
    $$EscalationsTableCreateCompanionBuilder,
    $$EscalationsTableUpdateCompanionBuilder,
    (EscalationRecord, $$EscalationsTableReferences),
    EscalationRecord,
    PrefetchHooks Function(
        {bool caseId, bool alertId, bool findingEvidencesRefs})> {
  $$EscalationsTableTableManager(_$AppDatabase db, $EscalationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EscalationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EscalationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EscalationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> caseId = const Value.absent(),
            Value<String?> alertId = const Value.absent(),
            Value<String> escalationLevel = const Value.absent(),
            Value<String?> reason = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> escalatedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EscalationsCompanion(
            id: id,
            caseId: caseId,
            alertId: alertId,
            escalationLevel: escalationLevel,
            reason: reason,
            status: status,
            escalatedAt: escalatedAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String caseId,
            Value<String?> alertId = const Value.absent(),
            required String escalationLevel,
            Value<String?> reason = const Value.absent(),
            Value<String> status = const Value.absent(),
            required DateTime escalatedAt,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              EscalationsCompanion.insert(
            id: id,
            caseId: caseId,
            alertId: alertId,
            escalationLevel: escalationLevel,
            reason: reason,
            status: status,
            escalatedAt: escalatedAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$EscalationsTable, EscalationRecord>(table),
                    $$EscalationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {caseId = false, alertId = false, findingEvidencesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (findingEvidencesRefs) db.findingEvidences
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (caseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.caseId,
                    referencedTable:
                        $$EscalationsTableReferences._caseIdTable(db),
                    referencedColumn:
                        $$EscalationsTableReferences._caseIdTable(db).id,
                  ) as T;
                }
                if (alertId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.alertId,
                    referencedTable:
                        $$EscalationsTableReferences._alertIdTable(db),
                    referencedColumn:
                        $$EscalationsTableReferences._alertIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (findingEvidencesRefs)
                    await $_getPrefetchedData<EscalationRecord,
                            $EscalationsTable, FindingEvidenceRecord>(
                        currentTable: table,
                        referencedTable: $$EscalationsTableReferences
                            ._findingEvidencesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EscalationsTableReferences(db, table, p0)
                                .findingEvidencesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.escalationId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$EscalationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EscalationsTable,
    EscalationRecord,
    $$EscalationsTableFilterComposer,
    $$EscalationsTableOrderingComposer,
    $$EscalationsTableAnnotationComposer,
    $$EscalationsTableCreateCompanionBuilder,
    $$EscalationsTableUpdateCompanionBuilder,
    (EscalationRecord, $$EscalationsTableReferences),
    EscalationRecord,
    PrefetchHooks Function(
        {bool caseId, bool alertId, bool findingEvidencesRefs})>;
typedef $$MonitoringCoveragesTableCreateCompanionBuilder
    = MonitoringCoveragesCompanion Function({
  required String id,
  required String cseId,
  required String logSourceCategory,
  Value<bool> isExpected,
  Value<bool> isActive,
  Value<DateTime?> lastReceivedAt,
  Value<double?> coveragePercentage,
  Value<DateTime?> periodStart,
  Value<DateTime?> periodEnd,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$MonitoringCoveragesTableUpdateCompanionBuilder
    = MonitoringCoveragesCompanion Function({
  Value<String> id,
  Value<String> cseId,
  Value<String> logSourceCategory,
  Value<bool> isExpected,
  Value<bool> isActive,
  Value<DateTime?> lastReceivedAt,
  Value<double?> coveragePercentage,
  Value<DateTime?> periodStart,
  Value<DateTime?> periodEnd,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$MonitoringCoveragesTableReferences extends BaseReferences<
    _$AppDatabase, $MonitoringCoveragesTable, MonitoringCoverageRecord> {
  $$MonitoringCoveragesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $CSEsTable _cseIdTable(_$AppDatabase db) =>
      db.cSEs.createAlias('monitoring_coverages__cse_id__cses__id');

  $$CSEsTableProcessedTableManager get cseId {
    final $_column = $_itemColumn<String>('cse_id')!;

    final manager = $$CSEsTableTableManager($_db, $_db.cSEs)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$FindingEvidencesTable,
      List<FindingEvidenceRecord>> _findingEvidencesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.findingEvidences,
          aliasName:
              'monitoring_coverages__id__finding_evidences__coverage_id');

  $$FindingEvidencesTableProcessedTableManager get findingEvidencesRefs {
    final manager = $$FindingEvidencesTableTableManager(
            $_db, $_db.findingEvidences)
        .filter((f) => f.coverageId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_findingEvidencesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MonitoringCoveragesTableFilterComposer
    extends Composer<_$AppDatabase, $MonitoringCoveragesTable> {
  $$MonitoringCoveragesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logSourceCategory => $composableBuilder(
      column: $table.logSourceCategory,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isExpected => $composableBuilder(
      column: $table.isExpected, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastReceivedAt => $composableBuilder(
      column: $table.lastReceivedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get coveragePercentage => $composableBuilder(
      column: $table.coveragePercentage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get periodStart => $composableBuilder(
      column: $table.periodStart, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get periodEnd => $composableBuilder(
      column: $table.periodEnd, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$CSEsTableFilterComposer get cseId {
    final $$CSEsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableFilterComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> findingEvidencesRefs(
      Expression<bool> Function($$FindingEvidencesTableFilterComposer f) f) {
    final $$FindingEvidencesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.findingEvidences,
        getReferencedColumn: (t) => t.coverageId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FindingEvidencesTableFilterComposer(
              $db: $db,
              $table: $db.findingEvidences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MonitoringCoveragesTableOrderingComposer
    extends Composer<_$AppDatabase, $MonitoringCoveragesTable> {
  $$MonitoringCoveragesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logSourceCategory => $composableBuilder(
      column: $table.logSourceCategory,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isExpected => $composableBuilder(
      column: $table.isExpected, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastReceivedAt => $composableBuilder(
      column: $table.lastReceivedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get coveragePercentage => $composableBuilder(
      column: $table.coveragePercentage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get periodStart => $composableBuilder(
      column: $table.periodStart, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get periodEnd => $composableBuilder(
      column: $table.periodEnd, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CSEsTableOrderingComposer get cseId {
    final $$CSEsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableOrderingComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MonitoringCoveragesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MonitoringCoveragesTable> {
  $$MonitoringCoveragesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get logSourceCategory => $composableBuilder(
      column: $table.logSourceCategory, builder: (column) => column);

  GeneratedColumn<bool> get isExpected => $composableBuilder(
      column: $table.isExpected, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReceivedAt => $composableBuilder(
      column: $table.lastReceivedAt, builder: (column) => column);

  GeneratedColumn<double> get coveragePercentage => $composableBuilder(
      column: $table.coveragePercentage, builder: (column) => column);

  GeneratedColumn<DateTime> get periodStart => $composableBuilder(
      column: $table.periodStart, builder: (column) => column);

  GeneratedColumn<DateTime> get periodEnd =>
      $composableBuilder(column: $table.periodEnd, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CSEsTableAnnotationComposer get cseId {
    final $$CSEsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableAnnotationComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> findingEvidencesRefs<T extends Object>(
      Expression<T> Function($$FindingEvidencesTableAnnotationComposer a) f) {
    final $$FindingEvidencesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.findingEvidences,
        getReferencedColumn: (t) => t.coverageId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FindingEvidencesTableAnnotationComposer(
              $db: $db,
              $table: $db.findingEvidences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MonitoringCoveragesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MonitoringCoveragesTable,
    MonitoringCoverageRecord,
    $$MonitoringCoveragesTableFilterComposer,
    $$MonitoringCoveragesTableOrderingComposer,
    $$MonitoringCoveragesTableAnnotationComposer,
    $$MonitoringCoveragesTableCreateCompanionBuilder,
    $$MonitoringCoveragesTableUpdateCompanionBuilder,
    (MonitoringCoverageRecord, $$MonitoringCoveragesTableReferences),
    MonitoringCoverageRecord,
    PrefetchHooks Function({bool cseId, bool findingEvidencesRefs})> {
  $$MonitoringCoveragesTableTableManager(
      _$AppDatabase db, $MonitoringCoveragesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonitoringCoveragesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MonitoringCoveragesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MonitoringCoveragesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> cseId = const Value.absent(),
            Value<String> logSourceCategory = const Value.absent(),
            Value<bool> isExpected = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime?> lastReceivedAt = const Value.absent(),
            Value<double?> coveragePercentage = const Value.absent(),
            Value<DateTime?> periodStart = const Value.absent(),
            Value<DateTime?> periodEnd = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MonitoringCoveragesCompanion(
            id: id,
            cseId: cseId,
            logSourceCategory: logSourceCategory,
            isExpected: isExpected,
            isActive: isActive,
            lastReceivedAt: lastReceivedAt,
            coveragePercentage: coveragePercentage,
            periodStart: periodStart,
            periodEnd: periodEnd,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String cseId,
            required String logSourceCategory,
            Value<bool> isExpected = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime?> lastReceivedAt = const Value.absent(),
            Value<double?> coveragePercentage = const Value.absent(),
            Value<DateTime?> periodStart = const Value.absent(),
            Value<DateTime?> periodEnd = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              MonitoringCoveragesCompanion.insert(
            id: id,
            cseId: cseId,
            logSourceCategory: logSourceCategory,
            isExpected: isExpected,
            isActive: isActive,
            lastReceivedAt: lastReceivedAt,
            coveragePercentage: coveragePercentage,
            periodStart: periodStart,
            periodEnd: periodEnd,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$MonitoringCoveragesTable,
                        MonitoringCoverageRecord>(table),
                    $$MonitoringCoveragesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {cseId = false, findingEvidencesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (findingEvidencesRefs) db.findingEvidences
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (cseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.cseId,
                    referencedTable:
                        $$MonitoringCoveragesTableReferences._cseIdTable(db),
                    referencedColumn:
                        $$MonitoringCoveragesTableReferences._cseIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (findingEvidencesRefs)
                    await $_getPrefetchedData<MonitoringCoverageRecord,
                            $MonitoringCoveragesTable, FindingEvidenceRecord>(
                        currentTable: table,
                        referencedTable: $$MonitoringCoveragesTableReferences
                            ._findingEvidencesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MonitoringCoveragesTableReferences(db, table, p0)
                                .findingEvidencesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.coverageId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MonitoringCoveragesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MonitoringCoveragesTable,
    MonitoringCoverageRecord,
    $$MonitoringCoveragesTableFilterComposer,
    $$MonitoringCoveragesTableOrderingComposer,
    $$MonitoringCoveragesTableAnnotationComposer,
    $$MonitoringCoveragesTableCreateCompanionBuilder,
    $$MonitoringCoveragesTableUpdateCompanionBuilder,
    (MonitoringCoverageRecord, $$MonitoringCoveragesTableReferences),
    MonitoringCoverageRecord,
    PrefetchHooks Function({bool cseId, bool findingEvidencesRefs})>;
typedef $$FindingEvidencesTableCreateCompanionBuilder
    = FindingEvidencesCompanion Function({
  required String id,
  required String findingId,
  required String evidenceType,
  Value<String?> alertId,
  Value<String?> caseId,
  Value<String?> investigationId,
  Value<String?> escalationId,
  Value<String?> coverageId,
  Value<String?> notes,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$FindingEvidencesTableUpdateCompanionBuilder
    = FindingEvidencesCompanion Function({
  Value<String> id,
  Value<String> findingId,
  Value<String> evidenceType,
  Value<String?> alertId,
  Value<String?> caseId,
  Value<String?> investigationId,
  Value<String?> escalationId,
  Value<String?> coverageId,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$FindingEvidencesTableReferences extends BaseReferences<
    _$AppDatabase, $FindingEvidencesTable, FindingEvidenceRecord> {
  $$FindingEvidencesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $FindingsTable _findingIdTable(_$AppDatabase db) =>
      db.findings.createAlias('finding_evidences__finding_id__findings__id');

  $$FindingsTableProcessedTableManager get findingId {
    final $_column = $_itemColumn<String>('finding_id')!;

    final manager = $$FindingsTableTableManager($_db, $_db.findings)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_findingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AlertsTable _alertIdTable(_$AppDatabase db) =>
      db.alerts.createAlias('finding_evidences__alert_id__alerts__id');

  $$AlertsTableProcessedTableManager? get alertId {
    final $_column = $_itemColumn<String>('alert_id');
    if ($_column == null) return null;
    final manager = $$AlertsTableTableManager($_db, $_db.alerts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_alertIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CasesTable _caseIdTable(_$AppDatabase db) =>
      db.cases.createAlias('finding_evidences__case_id__cases__id');

  $$CasesTableProcessedTableManager? get caseId {
    final $_column = $_itemColumn<String>('case_id');
    if ($_column == null) return null;
    final manager = $$CasesTableTableManager($_db, $_db.cases)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_caseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $InvestigationsTable _investigationIdTable(_$AppDatabase db) => db
      .investigations
      .createAlias('finding_evidences__investigation_id__investigations__id');

  $$InvestigationsTableProcessedTableManager? get investigationId {
    final $_column = $_itemColumn<String>('investigation_id');
    if ($_column == null) return null;
    final manager = $$InvestigationsTableTableManager($_db, $_db.investigations)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_investigationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $EscalationsTable _escalationIdTable(_$AppDatabase db) =>
      db.escalations
          .createAlias('finding_evidences__escalation_id__escalations__id');

  $$EscalationsTableProcessedTableManager? get escalationId {
    final $_column = $_itemColumn<String>('escalation_id');
    if ($_column == null) return null;
    final manager = $$EscalationsTableTableManager($_db, $_db.escalations)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_escalationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $MonitoringCoveragesTable _coverageIdTable(_$AppDatabase db) => db
      .monitoringCoverages
      .createAlias('finding_evidences__coverage_id__monitoring_coverages__id');

  $$MonitoringCoveragesTableProcessedTableManager? get coverageId {
    final $_column = $_itemColumn<String>('coverage_id');
    if ($_column == null) return null;
    final manager =
        $$MonitoringCoveragesTableTableManager($_db, $_db.monitoringCoverages)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_coverageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$FindingEvidencesTableFilterComposer
    extends Composer<_$AppDatabase, $FindingEvidencesTable> {
  $$FindingEvidencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get evidenceType => $composableBuilder(
      column: $table.evidenceType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$FindingsTableFilterComposer get findingId {
    final $$FindingsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.findingId,
        referencedTable: $db.findings,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FindingsTableFilterComposer(
              $db: $db,
              $table: $db.findings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AlertsTableFilterComposer get alertId {
    final $$AlertsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.alertId,
        referencedTable: $db.alerts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AlertsTableFilterComposer(
              $db: $db,
              $table: $db.alerts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CasesTableFilterComposer get caseId {
    final $$CasesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.caseId,
        referencedTable: $db.cases,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CasesTableFilterComposer(
              $db: $db,
              $table: $db.cases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InvestigationsTableFilterComposer get investigationId {
    final $$InvestigationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.investigationId,
        referencedTable: $db.investigations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvestigationsTableFilterComposer(
              $db: $db,
              $table: $db.investigations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$EscalationsTableFilterComposer get escalationId {
    final $$EscalationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.escalationId,
        referencedTable: $db.escalations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EscalationsTableFilterComposer(
              $db: $db,
              $table: $db.escalations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MonitoringCoveragesTableFilterComposer get coverageId {
    final $$MonitoringCoveragesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.coverageId,
        referencedTable: $db.monitoringCoverages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MonitoringCoveragesTableFilterComposer(
              $db: $db,
              $table: $db.monitoringCoverages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FindingEvidencesTableOrderingComposer
    extends Composer<_$AppDatabase, $FindingEvidencesTable> {
  $$FindingEvidencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get evidenceType => $composableBuilder(
      column: $table.evidenceType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$FindingsTableOrderingComposer get findingId {
    final $$FindingsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.findingId,
        referencedTable: $db.findings,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FindingsTableOrderingComposer(
              $db: $db,
              $table: $db.findings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AlertsTableOrderingComposer get alertId {
    final $$AlertsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.alertId,
        referencedTable: $db.alerts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AlertsTableOrderingComposer(
              $db: $db,
              $table: $db.alerts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CasesTableOrderingComposer get caseId {
    final $$CasesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.caseId,
        referencedTable: $db.cases,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CasesTableOrderingComposer(
              $db: $db,
              $table: $db.cases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InvestigationsTableOrderingComposer get investigationId {
    final $$InvestigationsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.investigationId,
        referencedTable: $db.investigations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvestigationsTableOrderingComposer(
              $db: $db,
              $table: $db.investigations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$EscalationsTableOrderingComposer get escalationId {
    final $$EscalationsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.escalationId,
        referencedTable: $db.escalations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EscalationsTableOrderingComposer(
              $db: $db,
              $table: $db.escalations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MonitoringCoveragesTableOrderingComposer get coverageId {
    final $$MonitoringCoveragesTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.coverageId,
            referencedTable: $db.monitoringCoverages,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MonitoringCoveragesTableOrderingComposer(
                  $db: $db,
                  $table: $db.monitoringCoverages,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$FindingEvidencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FindingEvidencesTable> {
  $$FindingEvidencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get evidenceType => $composableBuilder(
      column: $table.evidenceType, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$FindingsTableAnnotationComposer get findingId {
    final $$FindingsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.findingId,
        referencedTable: $db.findings,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FindingsTableAnnotationComposer(
              $db: $db,
              $table: $db.findings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AlertsTableAnnotationComposer get alertId {
    final $$AlertsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.alertId,
        referencedTable: $db.alerts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AlertsTableAnnotationComposer(
              $db: $db,
              $table: $db.alerts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CasesTableAnnotationComposer get caseId {
    final $$CasesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.caseId,
        referencedTable: $db.cases,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CasesTableAnnotationComposer(
              $db: $db,
              $table: $db.cases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InvestigationsTableAnnotationComposer get investigationId {
    final $$InvestigationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.investigationId,
        referencedTable: $db.investigations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvestigationsTableAnnotationComposer(
              $db: $db,
              $table: $db.investigations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$EscalationsTableAnnotationComposer get escalationId {
    final $$EscalationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.escalationId,
        referencedTable: $db.escalations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EscalationsTableAnnotationComposer(
              $db: $db,
              $table: $db.escalations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MonitoringCoveragesTableAnnotationComposer get coverageId {
    final $$MonitoringCoveragesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.coverageId,
            referencedTable: $db.monitoringCoverages,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MonitoringCoveragesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.monitoringCoverages,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$FindingEvidencesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FindingEvidencesTable,
    FindingEvidenceRecord,
    $$FindingEvidencesTableFilterComposer,
    $$FindingEvidencesTableOrderingComposer,
    $$FindingEvidencesTableAnnotationComposer,
    $$FindingEvidencesTableCreateCompanionBuilder,
    $$FindingEvidencesTableUpdateCompanionBuilder,
    (FindingEvidenceRecord, $$FindingEvidencesTableReferences),
    FindingEvidenceRecord,
    PrefetchHooks Function(
        {bool findingId,
        bool alertId,
        bool caseId,
        bool investigationId,
        bool escalationId,
        bool coverageId})> {
  $$FindingEvidencesTableTableManager(
      _$AppDatabase db, $FindingEvidencesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FindingEvidencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FindingEvidencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FindingEvidencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> findingId = const Value.absent(),
            Value<String> evidenceType = const Value.absent(),
            Value<String?> alertId = const Value.absent(),
            Value<String?> caseId = const Value.absent(),
            Value<String?> investigationId = const Value.absent(),
            Value<String?> escalationId = const Value.absent(),
            Value<String?> coverageId = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FindingEvidencesCompanion(
            id: id,
            findingId: findingId,
            evidenceType: evidenceType,
            alertId: alertId,
            caseId: caseId,
            investigationId: investigationId,
            escalationId: escalationId,
            coverageId: coverageId,
            notes: notes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String findingId,
            required String evidenceType,
            Value<String?> alertId = const Value.absent(),
            Value<String?> caseId = const Value.absent(),
            Value<String?> investigationId = const Value.absent(),
            Value<String?> escalationId = const Value.absent(),
            Value<String?> coverageId = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              FindingEvidencesCompanion.insert(
            id: id,
            findingId: findingId,
            evidenceType: evidenceType,
            alertId: alertId,
            caseId: caseId,
            investigationId: investigationId,
            escalationId: escalationId,
            coverageId: coverageId,
            notes: notes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$FindingEvidencesTable, FindingEvidenceRecord>(
                        table),
                    $$FindingEvidencesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {findingId = false,
              alertId = false,
              caseId = false,
              investigationId = false,
              escalationId = false,
              coverageId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (findingId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.findingId,
                    referencedTable:
                        $$FindingEvidencesTableReferences._findingIdTable(db),
                    referencedColumn: $$FindingEvidencesTableReferences
                        ._findingIdTable(db)
                        .id,
                  ) as T;
                }
                if (alertId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.alertId,
                    referencedTable:
                        $$FindingEvidencesTableReferences._alertIdTable(db),
                    referencedColumn:
                        $$FindingEvidencesTableReferences._alertIdTable(db).id,
                  ) as T;
                }
                if (caseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.caseId,
                    referencedTable:
                        $$FindingEvidencesTableReferences._caseIdTable(db),
                    referencedColumn:
                        $$FindingEvidencesTableReferences._caseIdTable(db).id,
                  ) as T;
                }
                if (investigationId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.investigationId,
                    referencedTable: $$FindingEvidencesTableReferences
                        ._investigationIdTable(db),
                    referencedColumn: $$FindingEvidencesTableReferences
                        ._investigationIdTable(db)
                        .id,
                  ) as T;
                }
                if (escalationId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.escalationId,
                    referencedTable: $$FindingEvidencesTableReferences
                        ._escalationIdTable(db),
                    referencedColumn: $$FindingEvidencesTableReferences
                        ._escalationIdTable(db)
                        .id,
                  ) as T;
                }
                if (coverageId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.coverageId,
                    referencedTable:
                        $$FindingEvidencesTableReferences._coverageIdTable(db),
                    referencedColumn: $$FindingEvidencesTableReferences
                        ._coverageIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$FindingEvidencesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FindingEvidencesTable,
    FindingEvidenceRecord,
    $$FindingEvidencesTableFilterComposer,
    $$FindingEvidencesTableOrderingComposer,
    $$FindingEvidencesTableAnnotationComposer,
    $$FindingEvidencesTableCreateCompanionBuilder,
    $$FindingEvidencesTableUpdateCompanionBuilder,
    (FindingEvidenceRecord, $$FindingEvidencesTableReferences),
    FindingEvidenceRecord,
    PrefetchHooks Function(
        {bool findingId,
        bool alertId,
        bool caseId,
        bool investigationId,
        bool escalationId,
        bool coverageId})>;
typedef $$FindingReviewHistoriesTableCreateCompanionBuilder
    = FindingReviewHistoriesCompanion Function({
  required String id,
  required String findingId,
  Value<String?> userId,
  required String cseId,
  required String actionType,
  Value<String?> previousStatus,
  Value<String?> newStatus,
  Value<String?> noteText,
  Value<String?> evidenceRequestDetails,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$FindingReviewHistoriesTableUpdateCompanionBuilder
    = FindingReviewHistoriesCompanion Function({
  Value<String> id,
  Value<String> findingId,
  Value<String?> userId,
  Value<String> cseId,
  Value<String> actionType,
  Value<String?> previousStatus,
  Value<String?> newStatus,
  Value<String?> noteText,
  Value<String?> evidenceRequestDetails,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$FindingReviewHistoriesTableReferences extends BaseReferences<
    _$AppDatabase, $FindingReviewHistoriesTable, FindingReviewHistoryRecord> {
  $$FindingReviewHistoriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $FindingsTable _findingIdTable(_$AppDatabase db) => db.findings
      .createAlias('finding_review_histories__finding_id__findings__id');

  $$FindingsTableProcessedTableManager get findingId {
    final $_column = $_itemColumn<String>('finding_id')!;

    final manager = $$FindingsTableTableManager($_db, $_db.findings)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_findingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CSEsTable _cseIdTable(_$AppDatabase db) =>
      db.cSEs.createAlias('finding_review_histories__cse_id__cses__id');

  $$CSEsTableProcessedTableManager get cseId {
    final $_column = $_itemColumn<String>('cse_id')!;

    final manager = $$CSEsTableTableManager($_db, $_db.cSEs)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$FindingReviewHistoriesTableFilterComposer
    extends Composer<_$AppDatabase, $FindingReviewHistoriesTable> {
  $$FindingReviewHistoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actionType => $composableBuilder(
      column: $table.actionType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get previousStatus => $composableBuilder(
      column: $table.previousStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get newStatus => $composableBuilder(
      column: $table.newStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get noteText => $composableBuilder(
      column: $table.noteText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get evidenceRequestDetails => $composableBuilder(
      column: $table.evidenceRequestDetails,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$FindingsTableFilterComposer get findingId {
    final $$FindingsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.findingId,
        referencedTable: $db.findings,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FindingsTableFilterComposer(
              $db: $db,
              $table: $db.findings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CSEsTableFilterComposer get cseId {
    final $$CSEsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableFilterComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FindingReviewHistoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $FindingReviewHistoriesTable> {
  $$FindingReviewHistoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actionType => $composableBuilder(
      column: $table.actionType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get previousStatus => $composableBuilder(
      column: $table.previousStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get newStatus => $composableBuilder(
      column: $table.newStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get noteText => $composableBuilder(
      column: $table.noteText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get evidenceRequestDetails => $composableBuilder(
      column: $table.evidenceRequestDetails,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$FindingsTableOrderingComposer get findingId {
    final $$FindingsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.findingId,
        referencedTable: $db.findings,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FindingsTableOrderingComposer(
              $db: $db,
              $table: $db.findings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CSEsTableOrderingComposer get cseId {
    final $$CSEsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableOrderingComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FindingReviewHistoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FindingReviewHistoriesTable> {
  $$FindingReviewHistoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get actionType => $composableBuilder(
      column: $table.actionType, builder: (column) => column);

  GeneratedColumn<String> get previousStatus => $composableBuilder(
      column: $table.previousStatus, builder: (column) => column);

  GeneratedColumn<String> get newStatus =>
      $composableBuilder(column: $table.newStatus, builder: (column) => column);

  GeneratedColumn<String> get noteText =>
      $composableBuilder(column: $table.noteText, builder: (column) => column);

  GeneratedColumn<String> get evidenceRequestDetails => $composableBuilder(
      column: $table.evidenceRequestDetails, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$FindingsTableAnnotationComposer get findingId {
    final $$FindingsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.findingId,
        referencedTable: $db.findings,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FindingsTableAnnotationComposer(
              $db: $db,
              $table: $db.findings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CSEsTableAnnotationComposer get cseId {
    final $$CSEsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableAnnotationComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FindingReviewHistoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FindingReviewHistoriesTable,
    FindingReviewHistoryRecord,
    $$FindingReviewHistoriesTableFilterComposer,
    $$FindingReviewHistoriesTableOrderingComposer,
    $$FindingReviewHistoriesTableAnnotationComposer,
    $$FindingReviewHistoriesTableCreateCompanionBuilder,
    $$FindingReviewHistoriesTableUpdateCompanionBuilder,
    (FindingReviewHistoryRecord, $$FindingReviewHistoriesTableReferences),
    FindingReviewHistoryRecord,
    PrefetchHooks Function({bool findingId, bool cseId})> {
  $$FindingReviewHistoriesTableTableManager(
      _$AppDatabase db, $FindingReviewHistoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FindingReviewHistoriesTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$FindingReviewHistoriesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FindingReviewHistoriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> findingId = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<String> cseId = const Value.absent(),
            Value<String> actionType = const Value.absent(),
            Value<String?> previousStatus = const Value.absent(),
            Value<String?> newStatus = const Value.absent(),
            Value<String?> noteText = const Value.absent(),
            Value<String?> evidenceRequestDetails = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FindingReviewHistoriesCompanion(
            id: id,
            findingId: findingId,
            userId: userId,
            cseId: cseId,
            actionType: actionType,
            previousStatus: previousStatus,
            newStatus: newStatus,
            noteText: noteText,
            evidenceRequestDetails: evidenceRequestDetails,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String findingId,
            Value<String?> userId = const Value.absent(),
            required String cseId,
            required String actionType,
            Value<String?> previousStatus = const Value.absent(),
            Value<String?> newStatus = const Value.absent(),
            Value<String?> noteText = const Value.absent(),
            Value<String?> evidenceRequestDetails = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              FindingReviewHistoriesCompanion.insert(
            id: id,
            findingId: findingId,
            userId: userId,
            cseId: cseId,
            actionType: actionType,
            previousStatus: previousStatus,
            newStatus: newStatus,
            noteText: noteText,
            evidenceRequestDetails: evidenceRequestDetails,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$FindingReviewHistoriesTable,
                        FindingReviewHistoryRecord>(table),
                    $$FindingReviewHistoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({findingId = false, cseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (findingId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.findingId,
                    referencedTable: $$FindingReviewHistoriesTableReferences
                        ._findingIdTable(db),
                    referencedColumn: $$FindingReviewHistoriesTableReferences
                        ._findingIdTable(db)
                        .id,
                  ) as T;
                }
                if (cseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.cseId,
                    referencedTable:
                        $$FindingReviewHistoriesTableReferences._cseIdTable(db),
                    referencedColumn: $$FindingReviewHistoriesTableReferences
                        ._cseIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$FindingReviewHistoriesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $FindingReviewHistoriesTable,
        FindingReviewHistoryRecord,
        $$FindingReviewHistoriesTableFilterComposer,
        $$FindingReviewHistoriesTableOrderingComposer,
        $$FindingReviewHistoriesTableAnnotationComposer,
        $$FindingReviewHistoriesTableCreateCompanionBuilder,
        $$FindingReviewHistoriesTableUpdateCompanionBuilder,
        (FindingReviewHistoryRecord, $$FindingReviewHistoriesTableReferences),
        FindingReviewHistoryRecord,
        PrefetchHooks Function({bool findingId, bool cseId})>;
typedef $$ReportRecordsTableCreateCompanionBuilder = ReportRecordsCompanion
    Function({
  required String id,
  required String reportCode,
  required String cseId,
  Value<String?> assessmentId,
  Value<String?> datasetVersionId,
  Value<String?> analysisRunId,
  Value<DateTime?> obsStart,
  Value<DateTime?> obsEnd,
  required String generatedByUserId,
  required DateTime createdAt,
  required String summaryJson,
  Value<String?> metadataJson,
  Value<int> rowid,
});
typedef $$ReportRecordsTableUpdateCompanionBuilder = ReportRecordsCompanion
    Function({
  Value<String> id,
  Value<String> reportCode,
  Value<String> cseId,
  Value<String?> assessmentId,
  Value<String?> datasetVersionId,
  Value<String?> analysisRunId,
  Value<DateTime?> obsStart,
  Value<DateTime?> obsEnd,
  Value<String> generatedByUserId,
  Value<DateTime> createdAt,
  Value<String> summaryJson,
  Value<String?> metadataJson,
  Value<int> rowid,
});

final class $$ReportRecordsTableReferences extends BaseReferences<_$AppDatabase,
    $ReportRecordsTable, ReportRecordData> {
  $$ReportRecordsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $CSEsTable _cseIdTable(_$AppDatabase db) =>
      db.cSEs.createAlias('report_records__cse_id__cses__id');

  $$CSEsTableProcessedTableManager get cseId {
    final $_column = $_itemColumn<String>('cse_id')!;

    final manager = $$CSEsTableTableManager($_db, $_db.cSEs)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AssessmentsTable _assessmentIdTable(_$AppDatabase db) =>
      db.assessments
          .createAlias('report_records__assessment_id__assessments__id');

  $$AssessmentsTableProcessedTableManager? get assessmentId {
    final $_column = $_itemColumn<String>('assessment_id');
    if ($_column == null) return null;
    final manager = $$AssessmentsTableTableManager($_db, $_db.assessments)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_assessmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $DatasetVersionsTable _datasetVersionIdTable(_$AppDatabase db) => db
      .datasetVersions
      .createAlias('report_records__dataset_version_id__dataset_versions__id');

  $$DatasetVersionsTableProcessedTableManager? get datasetVersionId {
    final $_column = $_itemColumn<String>('dataset_version_id');
    if ($_column == null) return null;
    final manager =
        $$DatasetVersionsTableTableManager($_db, $_db.datasetVersions)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_datasetVersionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AnalysisRunsTable _analysisRunIdTable(_$AppDatabase db) =>
      db.analysisRuns
          .createAlias('report_records__analysis_run_id__analysis_runs__id');

  $$AnalysisRunsTableProcessedTableManager? get analysisRunId {
    final $_column = $_itemColumn<String>('analysis_run_id');
    if ($_column == null) return null;
    final manager = $$AnalysisRunsTableTableManager($_db, $_db.analysisRuns)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_analysisRunIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ReportRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ReportRecordsTable> {
  $$ReportRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reportCode => $composableBuilder(
      column: $table.reportCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get obsStart => $composableBuilder(
      column: $table.obsStart, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get obsEnd => $composableBuilder(
      column: $table.obsEnd, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get generatedByUserId => $composableBuilder(
      column: $table.generatedByUserId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get summaryJson => $composableBuilder(
      column: $table.summaryJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson, builder: (column) => ColumnFilters(column));

  $$CSEsTableFilterComposer get cseId {
    final $$CSEsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableFilterComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AssessmentsTableFilterComposer get assessmentId {
    final $$AssessmentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assessmentId,
        referencedTable: $db.assessments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssessmentsTableFilterComposer(
              $db: $db,
              $table: $db.assessments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DatasetVersionsTableFilterComposer get datasetVersionId {
    final $$DatasetVersionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.datasetVersionId,
        referencedTable: $db.datasetVersions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DatasetVersionsTableFilterComposer(
              $db: $db,
              $table: $db.datasetVersions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AnalysisRunsTableFilterComposer get analysisRunId {
    final $$AnalysisRunsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.analysisRunId,
        referencedTable: $db.analysisRuns,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnalysisRunsTableFilterComposer(
              $db: $db,
              $table: $db.analysisRuns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReportRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReportRecordsTable> {
  $$ReportRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reportCode => $composableBuilder(
      column: $table.reportCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get obsStart => $composableBuilder(
      column: $table.obsStart, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get obsEnd => $composableBuilder(
      column: $table.obsEnd, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get generatedByUserId => $composableBuilder(
      column: $table.generatedByUserId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get summaryJson => $composableBuilder(
      column: $table.summaryJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson,
      builder: (column) => ColumnOrderings(column));

  $$CSEsTableOrderingComposer get cseId {
    final $$CSEsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableOrderingComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AssessmentsTableOrderingComposer get assessmentId {
    final $$AssessmentsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assessmentId,
        referencedTable: $db.assessments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssessmentsTableOrderingComposer(
              $db: $db,
              $table: $db.assessments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DatasetVersionsTableOrderingComposer get datasetVersionId {
    final $$DatasetVersionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.datasetVersionId,
        referencedTable: $db.datasetVersions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DatasetVersionsTableOrderingComposer(
              $db: $db,
              $table: $db.datasetVersions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AnalysisRunsTableOrderingComposer get analysisRunId {
    final $$AnalysisRunsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.analysisRunId,
        referencedTable: $db.analysisRuns,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnalysisRunsTableOrderingComposer(
              $db: $db,
              $table: $db.analysisRuns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReportRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReportRecordsTable> {
  $$ReportRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reportCode => $composableBuilder(
      column: $table.reportCode, builder: (column) => column);

  GeneratedColumn<DateTime> get obsStart =>
      $composableBuilder(column: $table.obsStart, builder: (column) => column);

  GeneratedColumn<DateTime> get obsEnd =>
      $composableBuilder(column: $table.obsEnd, builder: (column) => column);

  GeneratedColumn<String> get generatedByUserId => $composableBuilder(
      column: $table.generatedByUserId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get summaryJson => $composableBuilder(
      column: $table.summaryJson, builder: (column) => column);

  GeneratedColumn<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson, builder: (column) => column);

  $$CSEsTableAnnotationComposer get cseId {
    final $$CSEsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cseId,
        referencedTable: $db.cSEs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CSEsTableAnnotationComposer(
              $db: $db,
              $table: $db.cSEs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AssessmentsTableAnnotationComposer get assessmentId {
    final $$AssessmentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assessmentId,
        referencedTable: $db.assessments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssessmentsTableAnnotationComposer(
              $db: $db,
              $table: $db.assessments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DatasetVersionsTableAnnotationComposer get datasetVersionId {
    final $$DatasetVersionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.datasetVersionId,
        referencedTable: $db.datasetVersions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DatasetVersionsTableAnnotationComposer(
              $db: $db,
              $table: $db.datasetVersions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AnalysisRunsTableAnnotationComposer get analysisRunId {
    final $$AnalysisRunsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.analysisRunId,
        referencedTable: $db.analysisRuns,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnalysisRunsTableAnnotationComposer(
              $db: $db,
              $table: $db.analysisRuns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReportRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReportRecordsTable,
    ReportRecordData,
    $$ReportRecordsTableFilterComposer,
    $$ReportRecordsTableOrderingComposer,
    $$ReportRecordsTableAnnotationComposer,
    $$ReportRecordsTableCreateCompanionBuilder,
    $$ReportRecordsTableUpdateCompanionBuilder,
    (ReportRecordData, $$ReportRecordsTableReferences),
    ReportRecordData,
    PrefetchHooks Function(
        {bool cseId,
        bool assessmentId,
        bool datasetVersionId,
        bool analysisRunId})> {
  $$ReportRecordsTableTableManager(_$AppDatabase db, $ReportRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReportRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReportRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReportRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> reportCode = const Value.absent(),
            Value<String> cseId = const Value.absent(),
            Value<String?> assessmentId = const Value.absent(),
            Value<String?> datasetVersionId = const Value.absent(),
            Value<String?> analysisRunId = const Value.absent(),
            Value<DateTime?> obsStart = const Value.absent(),
            Value<DateTime?> obsEnd = const Value.absent(),
            Value<String> generatedByUserId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String> summaryJson = const Value.absent(),
            Value<String?> metadataJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReportRecordsCompanion(
            id: id,
            reportCode: reportCode,
            cseId: cseId,
            assessmentId: assessmentId,
            datasetVersionId: datasetVersionId,
            analysisRunId: analysisRunId,
            obsStart: obsStart,
            obsEnd: obsEnd,
            generatedByUserId: generatedByUserId,
            createdAt: createdAt,
            summaryJson: summaryJson,
            metadataJson: metadataJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String reportCode,
            required String cseId,
            Value<String?> assessmentId = const Value.absent(),
            Value<String?> datasetVersionId = const Value.absent(),
            Value<String?> analysisRunId = const Value.absent(),
            Value<DateTime?> obsStart = const Value.absent(),
            Value<DateTime?> obsEnd = const Value.absent(),
            required String generatedByUserId,
            required DateTime createdAt,
            required String summaryJson,
            Value<String?> metadataJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReportRecordsCompanion.insert(
            id: id,
            reportCode: reportCode,
            cseId: cseId,
            assessmentId: assessmentId,
            datasetVersionId: datasetVersionId,
            analysisRunId: analysisRunId,
            obsStart: obsStart,
            obsEnd: obsEnd,
            generatedByUserId: generatedByUserId,
            createdAt: createdAt,
            summaryJson: summaryJson,
            metadataJson: metadataJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ReportRecordsTable, ReportRecordData>(table),
                    $$ReportRecordsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {cseId = false,
              assessmentId = false,
              datasetVersionId = false,
              analysisRunId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (cseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.cseId,
                    referencedTable:
                        $$ReportRecordsTableReferences._cseIdTable(db),
                    referencedColumn:
                        $$ReportRecordsTableReferences._cseIdTable(db).id,
                  ) as T;
                }
                if (assessmentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.assessmentId,
                    referencedTable:
                        $$ReportRecordsTableReferences._assessmentIdTable(db),
                    referencedColumn: $$ReportRecordsTableReferences
                        ._assessmentIdTable(db)
                        .id,
                  ) as T;
                }
                if (datasetVersionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.datasetVersionId,
                    referencedTable: $$ReportRecordsTableReferences
                        ._datasetVersionIdTable(db),
                    referencedColumn: $$ReportRecordsTableReferences
                        ._datasetVersionIdTable(db)
                        .id,
                  ) as T;
                }
                if (analysisRunId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.analysisRunId,
                    referencedTable:
                        $$ReportRecordsTableReferences._analysisRunIdTable(db),
                    referencedColumn: $$ReportRecordsTableReferences
                        ._analysisRunIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ReportRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReportRecordsTable,
    ReportRecordData,
    $$ReportRecordsTableFilterComposer,
    $$ReportRecordsTableOrderingComposer,
    $$ReportRecordsTableAnnotationComposer,
    $$ReportRecordsTableCreateCompanionBuilder,
    $$ReportRecordsTableUpdateCompanionBuilder,
    (ReportRecordData, $$ReportRecordsTableReferences),
    ReportRecordData,
    PrefetchHooks Function(
        {bool cseId,
        bool assessmentId,
        bool datasetVersionId,
        bool analysisRunId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CSEsTableTableManager get cSEs => $$CSEsTableTableManager(_db, _db.cSEs);
  $$AssessmentsTableTableManager get assessments =>
      $$AssessmentsTableTableManager(_db, _db.assessments);
  $$DatasetVersionsTableTableManager get datasetVersions =>
      $$DatasetVersionsTableTableManager(_db, _db.datasetVersions);
  $$AnalysisRunsTableTableManager get analysisRuns =>
      $$AnalysisRunsTableTableManager(_db, _db.analysisRuns);
  $$FindingsTableTableManager get findings =>
      $$FindingsTableTableManager(_db, _db.findings);
  $$AssetsTableTableManager get assets =>
      $$AssetsTableTableManager(_db, _db.assets);
  $$AlertsTableTableManager get alerts =>
      $$AlertsTableTableManager(_db, _db.alerts);
  $$CasesTableTableManager get cases =>
      $$CasesTableTableManager(_db, _db.cases);
  $$InvestigationsTableTableManager get investigations =>
      $$InvestigationsTableTableManager(_db, _db.investigations);
  $$EscalationsTableTableManager get escalations =>
      $$EscalationsTableTableManager(_db, _db.escalations);
  $$MonitoringCoveragesTableTableManager get monitoringCoverages =>
      $$MonitoringCoveragesTableTableManager(_db, _db.monitoringCoverages);
  $$FindingEvidencesTableTableManager get findingEvidences =>
      $$FindingEvidencesTableTableManager(_db, _db.findingEvidences);
  $$FindingReviewHistoriesTableTableManager get findingReviewHistories =>
      $$FindingReviewHistoriesTableTableManager(
          _db, _db.findingReviewHistories);
  $$ReportRecordsTableTableManager get reportRecords =>
      $$ReportRecordsTableTableManager(_db, _db.reportRecords);
}
