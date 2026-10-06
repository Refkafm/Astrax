// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class Settings extends Table with TableInfo<Settings, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Settings(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY CHECK (id = 1)',
  );
  static const VerificationMeta _zoneMeta = const VerificationMeta('zone');
  late final GeneratedColumn<String> zone = GeneratedColumn<String>(
    'zone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'Asia/Jakarta\'',
    defaultValue: const CustomExpression('\'Asia/Jakarta\''),
  );
  static const VerificationMeta _anchorMeta = const VerificationMeta('anchor');
  late final GeneratedColumn<int> anchor = GeneratedColumn<int>(
    'anchor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1 CHECK (anchor BETWEEN 1 AND 31)',
    defaultValue: const CustomExpression('1'),
  );
  static const VerificationMeta _startedMeta = const VerificationMeta(
    'started',
  );
  late final GeneratedColumn<String> started = GeneratedColumn<String>(
    'started',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _onboardedMeta = const VerificationMeta(
    'onboarded',
  );
  late final GeneratedColumn<int> onboarded = GeneratedColumn<int>(
    'onboarded',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, zone, anchor, started, onboarded];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('zone')) {
      context.handle(
        _zoneMeta,
        zone.isAcceptableOrUnknown(data['zone']!, _zoneMeta),
      );
    }
    if (data.containsKey('anchor')) {
      context.handle(
        _anchorMeta,
        anchor.isAcceptableOrUnknown(data['anchor']!, _anchorMeta),
      );
    }
    if (data.containsKey('started')) {
      context.handle(
        _startedMeta,
        started.isAcceptableOrUnknown(data['started']!, _startedMeta),
      );
    } else if (isInserting) {
      context.missing(_startedMeta);
    }
    if (data.containsKey('onboarded')) {
      context.handle(
        _onboardedMeta,
        onboarded.isAcceptableOrUnknown(data['onboarded']!, _onboardedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      zone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zone'],
      )!,
      anchor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}anchor'],
      )!,
      started: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}started'],
      )!,
      onboarded: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}onboarded'],
      )!,
    );
  }

  @override
  Settings createAlias(String alias) {
    return Settings(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Setting extends DataClass implements Insertable<Setting> {
  final int id;
  final String zone;
  final int anchor;
  final String started;
  final int onboarded;
  const Setting({
    required this.id,
    required this.zone,
    required this.anchor,
    required this.started,
    required this.onboarded,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['zone'] = Variable<String>(zone);
    map['anchor'] = Variable<int>(anchor);
    map['started'] = Variable<String>(started);
    map['onboarded'] = Variable<int>(onboarded);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      zone: Value(zone),
      anchor: Value(anchor),
      started: Value(started),
      onboarded: Value(onboarded),
    );
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      id: serializer.fromJson<int>(json['id']),
      zone: serializer.fromJson<String>(json['zone']),
      anchor: serializer.fromJson<int>(json['anchor']),
      started: serializer.fromJson<String>(json['started']),
      onboarded: serializer.fromJson<int>(json['onboarded']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'zone': serializer.toJson<String>(zone),
      'anchor': serializer.toJson<int>(anchor),
      'started': serializer.toJson<String>(started),
      'onboarded': serializer.toJson<int>(onboarded),
    };
  }

  Setting copyWith({
    int? id,
    String? zone,
    int? anchor,
    String? started,
    int? onboarded,
  }) => Setting(
    id: id ?? this.id,
    zone: zone ?? this.zone,
    anchor: anchor ?? this.anchor,
    started: started ?? this.started,
    onboarded: onboarded ?? this.onboarded,
  );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      id: data.id.present ? data.id.value : this.id,
      zone: data.zone.present ? data.zone.value : this.zone,
      anchor: data.anchor.present ? data.anchor.value : this.anchor,
      started: data.started.present ? data.started.value : this.started,
      onboarded: data.onboarded.present ? data.onboarded.value : this.onboarded,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('id: $id, ')
          ..write('zone: $zone, ')
          ..write('anchor: $anchor, ')
          ..write('started: $started, ')
          ..write('onboarded: $onboarded')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, zone, anchor, started, onboarded);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.id == this.id &&
          other.zone == this.zone &&
          other.anchor == this.anchor &&
          other.started == this.started &&
          other.onboarded == this.onboarded);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<int> id;
  final Value<String> zone;
  final Value<int> anchor;
  final Value<String> started;
  final Value<int> onboarded;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.zone = const Value.absent(),
    this.anchor = const Value.absent(),
    this.started = const Value.absent(),
    this.onboarded = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    this.zone = const Value.absent(),
    this.anchor = const Value.absent(),
    required String started,
    this.onboarded = const Value.absent(),
  }) : started = Value(started);
  static Insertable<Setting> custom({
    Expression<int>? id,
    Expression<String>? zone,
    Expression<int>? anchor,
    Expression<String>? started,
    Expression<int>? onboarded,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (zone != null) 'zone': zone,
      if (anchor != null) 'anchor': anchor,
      if (started != null) 'started': started,
      if (onboarded != null) 'onboarded': onboarded,
    });
  }

  SettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? zone,
    Value<int>? anchor,
    Value<String>? started,
    Value<int>? onboarded,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      zone: zone ?? this.zone,
      anchor: anchor ?? this.anchor,
      started: started ?? this.started,
      onboarded: onboarded ?? this.onboarded,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (zone.present) {
      map['zone'] = Variable<String>(zone.value);
    }
    if (anchor.present) {
      map['anchor'] = Variable<int>(anchor.value);
    }
    if (started.present) {
      map['started'] = Variable<String>(started.value);
    }
    if (onboarded.present) {
      map['onboarded'] = Variable<int>(onboarded.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('zone: $zone, ')
          ..write('anchor: $anchor, ')
          ..write('started: $started, ')
          ..write('onboarded: $onboarded')
          ..write(')'))
        .toString();
  }
}

class Accounts extends Table with TableInfo<Accounts, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Accounts(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (type IN (\'bank\', \'e_wallet\', \'cash\'))',
  );
  static const VerificationMeta _openingMeta = const VerificationMeta(
    'opening',
  );
  late final GeneratedColumn<int> opening = GeneratedColumn<int>(
    'opening',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (opening >= 0)',
  );
  static const VerificationMeta _openedMeta = const VerificationMeta('opened');
  late final GeneratedColumn<int> opened = GeneratedColumn<int>(
    'opened',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  late final GeneratedColumn<int> archived = GeneratedColumn<int>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0 CHECK (archived IN (0, 1))',
    defaultValue: const CustomExpression('0'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    opening,
    opened,
    archived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Account> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('opening')) {
      context.handle(
        _openingMeta,
        opening.isAcceptableOrUnknown(data['opening']!, _openingMeta),
      );
    } else if (isInserting) {
      context.missing(_openingMeta);
    }
    if (data.containsKey('opened')) {
      context.handle(
        _openedMeta,
        opened.isAcceptableOrUnknown(data['opened']!, _openedMeta),
      );
    } else if (isInserting) {
      context.missing(_openedMeta);
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      opening: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opening'],
      )!,
      opened: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opened'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}archived'],
      )!,
    );
  }

  @override
  Accounts createAlias(String alias) {
    return Accounts(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Account extends DataClass implements Insertable<Account> {
  final String id;
  final String name;
  final String type;
  final int opening;
  final int opened;
  final int archived;
  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.opening,
    required this.opened,
    required this.archived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['opening'] = Variable<int>(opening);
    map['opened'] = Variable<int>(opened);
    map['archived'] = Variable<int>(archived);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      opening: Value(opening),
      opened: Value(opened),
      archived: Value(archived),
    );
  }

  factory Account.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      opening: serializer.fromJson<int>(json['opening']),
      opened: serializer.fromJson<int>(json['opened']),
      archived: serializer.fromJson<int>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'opening': serializer.toJson<int>(opening),
      'opened': serializer.toJson<int>(opened),
      'archived': serializer.toJson<int>(archived),
    };
  }

  Account copyWith({
    String? id,
    String? name,
    String? type,
    int? opening,
    int? opened,
    int? archived,
  }) => Account(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    opening: opening ?? this.opening,
    opened: opened ?? this.opened,
    archived: archived ?? this.archived,
  );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      opening: data.opening.present ? data.opening.value : this.opening,
      opened: data.opened.present ? data.opened.value : this.opened,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('opening: $opening, ')
          ..write('opened: $opened, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, opening, opened, archived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.opening == this.opening &&
          other.opened == this.opened &&
          other.archived == this.archived);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<int> opening;
  final Value<int> opened;
  final Value<int> archived;
  final Value<int> rowid;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.opening = const Value.absent(),
    this.opened = const Value.absent(),
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    required String id,
    required String name,
    required String type,
    required int opening,
    required int opened,
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       opening = Value(opening),
       opened = Value(opened);
  static Insertable<Account> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? opening,
    Expression<int>? opened,
    Expression<int>? archived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (opening != null) 'opening': opening,
      if (opened != null) 'opened': opened,
      if (archived != null) 'archived': archived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? type,
    Value<int>? opening,
    Value<int>? opened,
    Value<int>? archived,
    Value<int>? rowid,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      opening: opening ?? this.opening,
      opened: opened ?? this.opened,
      archived: archived ?? this.archived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (opening.present) {
      map['opening'] = Variable<int>(opening.value);
    }
    if (opened.present) {
      map['opened'] = Variable<int>(opened.value);
    }
    if (archived.present) {
      map['archived'] = Variable<int>(archived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('opening: $opening, ')
          ..write('opened: $opened, ')
          ..write('archived: $archived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Entries extends Table with TableInfo<Entries, Entry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Entries(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _commandMeta = const VerificationMeta(
    'command',
  );
  late final GeneratedColumn<String> command = GeneratedColumn<String>(
    'command',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (type IN (\'expense\', \'income\', \'transfer\', \'refund\', \'adjustment\'))',
  );
  static const VerificationMeta _accountMeta = const VerificationMeta(
    'account',
  );
  late final GeneratedColumn<String> account = GeneratedColumn<String>(
    'account',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES accounts(id)',
  );
  static const VerificationMeta _destinationMeta = const VerificationMeta(
    'destination',
  );
  late final GeneratedColumn<String> destination = GeneratedColumn<String>(
    'destination',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES accounts(id)',
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (amount BETWEEN -999999999999 AND 999999999999 AND amount != 0)',
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _merchantMeta = const VerificationMeta(
    'merchant',
  );
  late final GeneratedColumn<String> merchant = GeneratedColumn<String>(
    'merchant',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _occurredMeta = const VerificationMeta(
    'occurred',
  );
  late final GeneratedColumn<int> occurred = GeneratedColumn<int>(
    'occurred',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _businessDateMeta = const VerificationMeta(
    'businessDate',
  );
  late final GeneratedColumn<String> businessDate = GeneratedColumn<String>(
    'business_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _zoneMeta = const VerificationMeta('zone');
  late final GeneratedColumn<String> zone = GeneratedColumn<String>(
    'zone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _refundOfMeta = const VerificationMeta(
    'refundOf',
  );
  late final GeneratedColumn<String> refundOf = GeneratedColumn<String>(
    'refund_of',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES entries(id)',
  );
  static const VerificationMeta _parentMeta = const VerificationMeta('parent');
  late final GeneratedColumn<String> parent = GeneratedColumn<String>(
    'parent',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES entries(id)',
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  late final GeneratedColumn<int> deleted = GeneratedColumn<int>(
    'deleted',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    command,
    type,
    account,
    destination,
    amount,
    category,
    merchant,
    note,
    occurred,
    businessDate,
    zone,
    refundOf,
    parent,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<Entry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('command')) {
      context.handle(
        _commandMeta,
        command.isAcceptableOrUnknown(data['command']!, _commandMeta),
      );
    } else if (isInserting) {
      context.missing(_commandMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('account')) {
      context.handle(
        _accountMeta,
        account.isAcceptableOrUnknown(data['account']!, _accountMeta),
      );
    } else if (isInserting) {
      context.missing(_accountMeta);
    }
    if (data.containsKey('destination')) {
      context.handle(
        _destinationMeta,
        destination.isAcceptableOrUnknown(
          data['destination']!,
          _destinationMeta,
        ),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('merchant')) {
      context.handle(
        _merchantMeta,
        merchant.isAcceptableOrUnknown(data['merchant']!, _merchantMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('occurred')) {
      context.handle(
        _occurredMeta,
        occurred.isAcceptableOrUnknown(data['occurred']!, _occurredMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredMeta);
    }
    if (data.containsKey('business_date')) {
      context.handle(
        _businessDateMeta,
        businessDate.isAcceptableOrUnknown(
          data['business_date']!,
          _businessDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_businessDateMeta);
    }
    if (data.containsKey('zone')) {
      context.handle(
        _zoneMeta,
        zone.isAcceptableOrUnknown(data['zone']!, _zoneMeta),
      );
    } else if (isInserting) {
      context.missing(_zoneMeta);
    }
    if (data.containsKey('refund_of')) {
      context.handle(
        _refundOfMeta,
        refundOf.isAcceptableOrUnknown(data['refund_of']!, _refundOfMeta),
      );
    }
    if (data.containsKey('parent')) {
      context.handle(
        _parentMeta,
        parent.isAcceptableOrUnknown(data['parent']!, _parentMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Entry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Entry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      command: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}command'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      account: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account'],
      )!,
      destination: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      merchant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      occurred: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}occurred'],
      )!,
      businessDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_date'],
      )!,
      zone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zone'],
      )!,
      refundOf: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}refund_of'],
      ),
      parent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent'],
      ),
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted'],
      ),
    );
  }

  @override
  Entries createAlias(String alias) {
    return Entries(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'CHECK((type = \'adjustment\')OR amount > 0)',
    'CHECK((type = \'transfer\' AND destination IS NOT NULL AND destination != account)OR(type != \'transfer\' AND destination IS NULL))',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class Entry extends DataClass implements Insertable<Entry> {
  final String id;
  final String command;
  final String type;
  final String account;
  final String? destination;
  final int amount;
  final String category;
  final String merchant;
  final String note;
  final int occurred;
  final String businessDate;
  final String zone;
  final String? refundOf;
  final String? parent;
  final int? deleted;
  const Entry({
    required this.id,
    required this.command,
    required this.type,
    required this.account,
    this.destination,
    required this.amount,
    required this.category,
    required this.merchant,
    required this.note,
    required this.occurred,
    required this.businessDate,
    required this.zone,
    this.refundOf,
    this.parent,
    this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['command'] = Variable<String>(command);
    map['type'] = Variable<String>(type);
    map['account'] = Variable<String>(account);
    if (!nullToAbsent || destination != null) {
      map['destination'] = Variable<String>(destination);
    }
    map['amount'] = Variable<int>(amount);
    map['category'] = Variable<String>(category);
    map['merchant'] = Variable<String>(merchant);
    map['note'] = Variable<String>(note);
    map['occurred'] = Variable<int>(occurred);
    map['business_date'] = Variable<String>(businessDate);
    map['zone'] = Variable<String>(zone);
    if (!nullToAbsent || refundOf != null) {
      map['refund_of'] = Variable<String>(refundOf);
    }
    if (!nullToAbsent || parent != null) {
      map['parent'] = Variable<String>(parent);
    }
    if (!nullToAbsent || deleted != null) {
      map['deleted'] = Variable<int>(deleted);
    }
    return map;
  }

  EntriesCompanion toCompanion(bool nullToAbsent) {
    return EntriesCompanion(
      id: Value(id),
      command: Value(command),
      type: Value(type),
      account: Value(account),
      destination: destination == null && nullToAbsent
          ? const Value.absent()
          : Value(destination),
      amount: Value(amount),
      category: Value(category),
      merchant: Value(merchant),
      note: Value(note),
      occurred: Value(occurred),
      businessDate: Value(businessDate),
      zone: Value(zone),
      refundOf: refundOf == null && nullToAbsent
          ? const Value.absent()
          : Value(refundOf),
      parent: parent == null && nullToAbsent
          ? const Value.absent()
          : Value(parent),
      deleted: deleted == null && nullToAbsent
          ? const Value.absent()
          : Value(deleted),
    );
  }

  factory Entry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Entry(
      id: serializer.fromJson<String>(json['id']),
      command: serializer.fromJson<String>(json['command']),
      type: serializer.fromJson<String>(json['type']),
      account: serializer.fromJson<String>(json['account']),
      destination: serializer.fromJson<String?>(json['destination']),
      amount: serializer.fromJson<int>(json['amount']),
      category: serializer.fromJson<String>(json['category']),
      merchant: serializer.fromJson<String>(json['merchant']),
      note: serializer.fromJson<String>(json['note']),
      occurred: serializer.fromJson<int>(json['occurred']),
      businessDate: serializer.fromJson<String>(json['business_date']),
      zone: serializer.fromJson<String>(json['zone']),
      refundOf: serializer.fromJson<String?>(json['refund_of']),
      parent: serializer.fromJson<String?>(json['parent']),
      deleted: serializer.fromJson<int?>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'command': serializer.toJson<String>(command),
      'type': serializer.toJson<String>(type),
      'account': serializer.toJson<String>(account),
      'destination': serializer.toJson<String?>(destination),
      'amount': serializer.toJson<int>(amount),
      'category': serializer.toJson<String>(category),
      'merchant': serializer.toJson<String>(merchant),
      'note': serializer.toJson<String>(note),
      'occurred': serializer.toJson<int>(occurred),
      'business_date': serializer.toJson<String>(businessDate),
      'zone': serializer.toJson<String>(zone),
      'refund_of': serializer.toJson<String?>(refundOf),
      'parent': serializer.toJson<String?>(parent),
      'deleted': serializer.toJson<int?>(deleted),
    };
  }

  Entry copyWith({
    String? id,
    String? command,
    String? type,
    String? account,
    Value<String?> destination = const Value.absent(),
    int? amount,
    String? category,
    String? merchant,
    String? note,
    int? occurred,
    String? businessDate,
    String? zone,
    Value<String?> refundOf = const Value.absent(),
    Value<String?> parent = const Value.absent(),
    Value<int?> deleted = const Value.absent(),
  }) => Entry(
    id: id ?? this.id,
    command: command ?? this.command,
    type: type ?? this.type,
    account: account ?? this.account,
    destination: destination.present ? destination.value : this.destination,
    amount: amount ?? this.amount,
    category: category ?? this.category,
    merchant: merchant ?? this.merchant,
    note: note ?? this.note,
    occurred: occurred ?? this.occurred,
    businessDate: businessDate ?? this.businessDate,
    zone: zone ?? this.zone,
    refundOf: refundOf.present ? refundOf.value : this.refundOf,
    parent: parent.present ? parent.value : this.parent,
    deleted: deleted.present ? deleted.value : this.deleted,
  );
  Entry copyWithCompanion(EntriesCompanion data) {
    return Entry(
      id: data.id.present ? data.id.value : this.id,
      command: data.command.present ? data.command.value : this.command,
      type: data.type.present ? data.type.value : this.type,
      account: data.account.present ? data.account.value : this.account,
      destination: data.destination.present
          ? data.destination.value
          : this.destination,
      amount: data.amount.present ? data.amount.value : this.amount,
      category: data.category.present ? data.category.value : this.category,
      merchant: data.merchant.present ? data.merchant.value : this.merchant,
      note: data.note.present ? data.note.value : this.note,
      occurred: data.occurred.present ? data.occurred.value : this.occurred,
      businessDate: data.businessDate.present
          ? data.businessDate.value
          : this.businessDate,
      zone: data.zone.present ? data.zone.value : this.zone,
      refundOf: data.refundOf.present ? data.refundOf.value : this.refundOf,
      parent: data.parent.present ? data.parent.value : this.parent,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Entry(')
          ..write('id: $id, ')
          ..write('command: $command, ')
          ..write('type: $type, ')
          ..write('account: $account, ')
          ..write('destination: $destination, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('merchant: $merchant, ')
          ..write('note: $note, ')
          ..write('occurred: $occurred, ')
          ..write('businessDate: $businessDate, ')
          ..write('zone: $zone, ')
          ..write('refundOf: $refundOf, ')
          ..write('parent: $parent, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    command,
    type,
    account,
    destination,
    amount,
    category,
    merchant,
    note,
    occurred,
    businessDate,
    zone,
    refundOf,
    parent,
    deleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Entry &&
          other.id == this.id &&
          other.command == this.command &&
          other.type == this.type &&
          other.account == this.account &&
          other.destination == this.destination &&
          other.amount == this.amount &&
          other.category == this.category &&
          other.merchant == this.merchant &&
          other.note == this.note &&
          other.occurred == this.occurred &&
          other.businessDate == this.businessDate &&
          other.zone == this.zone &&
          other.refundOf == this.refundOf &&
          other.parent == this.parent &&
          other.deleted == this.deleted);
}

class EntriesCompanion extends UpdateCompanion<Entry> {
  final Value<String> id;
  final Value<String> command;
  final Value<String> type;
  final Value<String> account;
  final Value<String?> destination;
  final Value<int> amount;
  final Value<String> category;
  final Value<String> merchant;
  final Value<String> note;
  final Value<int> occurred;
  final Value<String> businessDate;
  final Value<String> zone;
  final Value<String?> refundOf;
  final Value<String?> parent;
  final Value<int?> deleted;
  final Value<int> rowid;
  const EntriesCompanion({
    this.id = const Value.absent(),
    this.command = const Value.absent(),
    this.type = const Value.absent(),
    this.account = const Value.absent(),
    this.destination = const Value.absent(),
    this.amount = const Value.absent(),
    this.category = const Value.absent(),
    this.merchant = const Value.absent(),
    this.note = const Value.absent(),
    this.occurred = const Value.absent(),
    this.businessDate = const Value.absent(),
    this.zone = const Value.absent(),
    this.refundOf = const Value.absent(),
    this.parent = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntriesCompanion.insert({
    required String id,
    required String command,
    required String type,
    required String account,
    this.destination = const Value.absent(),
    required int amount,
    this.category = const Value.absent(),
    this.merchant = const Value.absent(),
    this.note = const Value.absent(),
    required int occurred,
    required String businessDate,
    required String zone,
    this.refundOf = const Value.absent(),
    this.parent = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       command = Value(command),
       type = Value(type),
       account = Value(account),
       amount = Value(amount),
       occurred = Value(occurred),
       businessDate = Value(businessDate),
       zone = Value(zone);
  static Insertable<Entry> custom({
    Expression<String>? id,
    Expression<String>? command,
    Expression<String>? type,
    Expression<String>? account,
    Expression<String>? destination,
    Expression<int>? amount,
    Expression<String>? category,
    Expression<String>? merchant,
    Expression<String>? note,
    Expression<int>? occurred,
    Expression<String>? businessDate,
    Expression<String>? zone,
    Expression<String>? refundOf,
    Expression<String>? parent,
    Expression<int>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (command != null) 'command': command,
      if (type != null) 'type': type,
      if (account != null) 'account': account,
      if (destination != null) 'destination': destination,
      if (amount != null) 'amount': amount,
      if (category != null) 'category': category,
      if (merchant != null) 'merchant': merchant,
      if (note != null) 'note': note,
      if (occurred != null) 'occurred': occurred,
      if (businessDate != null) 'business_date': businessDate,
      if (zone != null) 'zone': zone,
      if (refundOf != null) 'refund_of': refundOf,
      if (parent != null) 'parent': parent,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? command,
    Value<String>? type,
    Value<String>? account,
    Value<String?>? destination,
    Value<int>? amount,
    Value<String>? category,
    Value<String>? merchant,
    Value<String>? note,
    Value<int>? occurred,
    Value<String>? businessDate,
    Value<String>? zone,
    Value<String?>? refundOf,
    Value<String?>? parent,
    Value<int?>? deleted,
    Value<int>? rowid,
  }) {
    return EntriesCompanion(
      id: id ?? this.id,
      command: command ?? this.command,
      type: type ?? this.type,
      account: account ?? this.account,
      destination: destination ?? this.destination,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      merchant: merchant ?? this.merchant,
      note: note ?? this.note,
      occurred: occurred ?? this.occurred,
      businessDate: businessDate ?? this.businessDate,
      zone: zone ?? this.zone,
      refundOf: refundOf ?? this.refundOf,
      parent: parent ?? this.parent,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (command.present) {
      map['command'] = Variable<String>(command.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (account.present) {
      map['account'] = Variable<String>(account.value);
    }
    if (destination.present) {
      map['destination'] = Variable<String>(destination.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (merchant.present) {
      map['merchant'] = Variable<String>(merchant.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (occurred.present) {
      map['occurred'] = Variable<int>(occurred.value);
    }
    if (businessDate.present) {
      map['business_date'] = Variable<String>(businessDate.value);
    }
    if (zone.present) {
      map['zone'] = Variable<String>(zone.value);
    }
    if (refundOf.present) {
      map['refund_of'] = Variable<String>(refundOf.value);
    }
    if (parent.present) {
      map['parent'] = Variable<String>(parent.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<int>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntriesCompanion(')
          ..write('id: $id, ')
          ..write('command: $command, ')
          ..write('type: $type, ')
          ..write('account: $account, ')
          ..write('destination: $destination, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('merchant: $merchant, ')
          ..write('note: $note, ')
          ..write('occurred: $occurred, ')
          ..write('businessDate: $businessDate, ')
          ..write('zone: $zone, ')
          ..write('refundOf: $refundOf, ')
          ..write('parent: $parent, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Budgets extends Table with TableInfo<Budgets, Budget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Budgets(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _startMeta = const VerificationMeta('start');
  late final GeneratedColumn<String> start = GeneratedColumn<String>(
    'start',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (total >= 0)',
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1',
    defaultValue: const CustomExpression('1'),
  );
  static const VerificationMeta _updatedMeta = const VerificationMeta(
    'updated',
  );
  late final GeneratedColumn<int> updated = GeneratedColumn<int>(
    'updated',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    start,
    endDate,
    total,
    revision,
    updated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Budget> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('start')) {
      context.handle(
        _startMeta,
        start.isAcceptableOrUnknown(data['start']!, _startMeta),
      );
    } else if (isInserting) {
      context.missing(_startMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('updated')) {
      context.handle(
        _updatedMeta,
        updated.isAcceptableOrUnknown(data['updated']!, _updatedMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {start};
  @override
  Budget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Budget(
      start: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_date'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      updated: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated'],
      )!,
    );
  }

  @override
  Budgets createAlias(String alias) {
    return Budgets(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Budget extends DataClass implements Insertable<Budget> {
  final String start;
  final String endDate;
  final int total;
  final int revision;
  final int updated;
  const Budget({
    required this.start,
    required this.endDate,
    required this.total,
    required this.revision,
    required this.updated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['start'] = Variable<String>(start);
    map['end_date'] = Variable<String>(endDate);
    map['total'] = Variable<int>(total);
    map['revision'] = Variable<int>(revision);
    map['updated'] = Variable<int>(updated);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      start: Value(start),
      endDate: Value(endDate),
      total: Value(total),
      revision: Value(revision),
      updated: Value(updated),
    );
  }

  factory Budget.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Budget(
      start: serializer.fromJson<String>(json['start']),
      endDate: serializer.fromJson<String>(json['end_date']),
      total: serializer.fromJson<int>(json['total']),
      revision: serializer.fromJson<int>(json['revision']),
      updated: serializer.fromJson<int>(json['updated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'start': serializer.toJson<String>(start),
      'end_date': serializer.toJson<String>(endDate),
      'total': serializer.toJson<int>(total),
      'revision': serializer.toJson<int>(revision),
      'updated': serializer.toJson<int>(updated),
    };
  }

  Budget copyWith({
    String? start,
    String? endDate,
    int? total,
    int? revision,
    int? updated,
  }) => Budget(
    start: start ?? this.start,
    endDate: endDate ?? this.endDate,
    total: total ?? this.total,
    revision: revision ?? this.revision,
    updated: updated ?? this.updated,
  );
  Budget copyWithCompanion(BudgetsCompanion data) {
    return Budget(
      start: data.start.present ? data.start.value : this.start,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      total: data.total.present ? data.total.value : this.total,
      revision: data.revision.present ? data.revision.value : this.revision,
      updated: data.updated.present ? data.updated.value : this.updated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Budget(')
          ..write('start: $start, ')
          ..write('endDate: $endDate, ')
          ..write('total: $total, ')
          ..write('revision: $revision, ')
          ..write('updated: $updated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(start, endDate, total, revision, updated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Budget &&
          other.start == this.start &&
          other.endDate == this.endDate &&
          other.total == this.total &&
          other.revision == this.revision &&
          other.updated == this.updated);
}

class BudgetsCompanion extends UpdateCompanion<Budget> {
  final Value<String> start;
  final Value<String> endDate;
  final Value<int> total;
  final Value<int> revision;
  final Value<int> updated;
  final Value<int> rowid;
  const BudgetsCompanion({
    this.start = const Value.absent(),
    this.endDate = const Value.absent(),
    this.total = const Value.absent(),
    this.revision = const Value.absent(),
    this.updated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetsCompanion.insert({
    required String start,
    required String endDate,
    required int total,
    this.revision = const Value.absent(),
    required int updated,
    this.rowid = const Value.absent(),
  }) : start = Value(start),
       endDate = Value(endDate),
       total = Value(total),
       updated = Value(updated);
  static Insertable<Budget> custom({
    Expression<String>? start,
    Expression<String>? endDate,
    Expression<int>? total,
    Expression<int>? revision,
    Expression<int>? updated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (start != null) 'start': start,
      if (endDate != null) 'end_date': endDate,
      if (total != null) 'total': total,
      if (revision != null) 'revision': revision,
      if (updated != null) 'updated': updated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetsCompanion copyWith({
    Value<String>? start,
    Value<String>? endDate,
    Value<int>? total,
    Value<int>? revision,
    Value<int>? updated,
    Value<int>? rowid,
  }) {
    return BudgetsCompanion(
      start: start ?? this.start,
      endDate: endDate ?? this.endDate,
      total: total ?? this.total,
      revision: revision ?? this.revision,
      updated: updated ?? this.updated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (start.present) {
      map['start'] = Variable<String>(start.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (updated.present) {
      map['updated'] = Variable<int>(updated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('start: $start, ')
          ..write('endDate: $endDate, ')
          ..write('total: $total, ')
          ..write('revision: $revision, ')
          ..write('updated: $updated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Allocations extends Table with TableInfo<Allocations, Allocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Allocations(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
    'period',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES budgets(start)',
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (amount >= 0)',
  );
  @override
  List<GeneratedColumn> get $columns => [period, category, amount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'allocations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Allocation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    } else if (isInserting) {
      context.missing(_periodMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {period, category};
  @override
  Allocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Allocation(
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
    );
  }

  @override
  Allocations createAlias(String alias) {
    return Allocations(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const ['PRIMARY KEY(period, category)'];
  @override
  bool get dontWriteConstraints => true;
}

class Allocation extends DataClass implements Insertable<Allocation> {
  final String period;
  final String category;
  final int amount;
  const Allocation({
    required this.period,
    required this.category,
    required this.amount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['period'] = Variable<String>(period);
    map['category'] = Variable<String>(category);
    map['amount'] = Variable<int>(amount);
    return map;
  }

  AllocationsCompanion toCompanion(bool nullToAbsent) {
    return AllocationsCompanion(
      period: Value(period),
      category: Value(category),
      amount: Value(amount),
    );
  }

  factory Allocation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Allocation(
      period: serializer.fromJson<String>(json['period']),
      category: serializer.fromJson<String>(json['category']),
      amount: serializer.fromJson<int>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'period': serializer.toJson<String>(period),
      'category': serializer.toJson<String>(category),
      'amount': serializer.toJson<int>(amount),
    };
  }

  Allocation copyWith({String? period, String? category, int? amount}) =>
      Allocation(
        period: period ?? this.period,
        category: category ?? this.category,
        amount: amount ?? this.amount,
      );
  Allocation copyWithCompanion(AllocationsCompanion data) {
    return Allocation(
      period: data.period.present ? data.period.value : this.period,
      category: data.category.present ? data.category.value : this.category,
      amount: data.amount.present ? data.amount.value : this.amount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Allocation(')
          ..write('period: $period, ')
          ..write('category: $category, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(period, category, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Allocation &&
          other.period == this.period &&
          other.category == this.category &&
          other.amount == this.amount);
}

class AllocationsCompanion extends UpdateCompanion<Allocation> {
  final Value<String> period;
  final Value<String> category;
  final Value<int> amount;
  final Value<int> rowid;
  const AllocationsCompanion({
    this.period = const Value.absent(),
    this.category = const Value.absent(),
    this.amount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AllocationsCompanion.insert({
    required String period,
    required String category,
    required int amount,
    this.rowid = const Value.absent(),
  }) : period = Value(period),
       category = Value(category),
       amount = Value(amount);
  static Insertable<Allocation> custom({
    Expression<String>? period,
    Expression<String>? category,
    Expression<int>? amount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (period != null) 'period': period,
      if (category != null) 'category': category,
      if (amount != null) 'amount': amount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AllocationsCompanion copyWith({
    Value<String>? period,
    Value<String>? category,
    Value<int>? amount,
    Value<int>? rowid,
  }) {
    return AllocationsCompanion(
      period: period ?? this.period,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AllocationsCompanion(')
          ..write('period: $period, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Templates extends Table with TableInfo<Templates, Template> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Templates(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _accountMeta = const VerificationMeta(
    'account',
  );
  late final GeneratedColumn<String> account = GeneratedColumn<String>(
    'account',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES accounts(id)',
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _directionMeta = const VerificationMeta(
    'direction',
  );
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
    'direction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (direction IN (\'expense\', \'income\'))',
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (amount > 0)',
  );
  static const VerificationMeta _cadenceMeta = const VerificationMeta(
    'cadence',
  );
  late final GeneratedColumn<String> cadence = GeneratedColumn<String>(
    'cadence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (cadence IN (\'monthly\', \'weekly\'))',
  );
  static const VerificationMeta _firstDateMeta = const VerificationMeta(
    'firstDate',
  );
  late final GeneratedColumn<String> firstDate = GeneratedColumn<String>(
    'first_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  late final GeneratedColumn<int> active = GeneratedColumn<int>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1 CHECK (active IN (0, 1))',
    defaultValue: const CustomExpression('1'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    account,
    category,
    direction,
    amount,
    cadence,
    firstDate,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<Template> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('account')) {
      context.handle(
        _accountMeta,
        account.isAcceptableOrUnknown(data['account']!, _accountMeta),
      );
    } else if (isInserting) {
      context.missing(_accountMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('direction')) {
      context.handle(
        _directionMeta,
        direction.isAcceptableOrUnknown(data['direction']!, _directionMeta),
      );
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('cadence')) {
      context.handle(
        _cadenceMeta,
        cadence.isAcceptableOrUnknown(data['cadence']!, _cadenceMeta),
      );
    } else if (isInserting) {
      context.missing(_cadenceMeta);
    }
    if (data.containsKey('first_date')) {
      context.handle(
        _firstDateMeta,
        firstDate.isAcceptableOrUnknown(data['first_date']!, _firstDateMeta),
      );
    } else if (isInserting) {
      context.missing(_firstDateMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Template map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Template(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      account: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      direction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direction'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      cadence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cadence'],
      )!,
      firstDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_date'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  Templates createAlias(String alias) {
    return Templates(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Template extends DataClass implements Insertable<Template> {
  final String id;
  final String name;
  final String account;
  final String category;
  final String direction;
  final int amount;
  final String cadence;
  final String firstDate;
  final int active;
  const Template({
    required this.id,
    required this.name,
    required this.account,
    required this.category,
    required this.direction,
    required this.amount,
    required this.cadence,
    required this.firstDate,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['account'] = Variable<String>(account);
    map['category'] = Variable<String>(category);
    map['direction'] = Variable<String>(direction);
    map['amount'] = Variable<int>(amount);
    map['cadence'] = Variable<String>(cadence);
    map['first_date'] = Variable<String>(firstDate);
    map['active'] = Variable<int>(active);
    return map;
  }

  TemplatesCompanion toCompanion(bool nullToAbsent) {
    return TemplatesCompanion(
      id: Value(id),
      name: Value(name),
      account: Value(account),
      category: Value(category),
      direction: Value(direction),
      amount: Value(amount),
      cadence: Value(cadence),
      firstDate: Value(firstDate),
      active: Value(active),
    );
  }

  factory Template.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Template(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      account: serializer.fromJson<String>(json['account']),
      category: serializer.fromJson<String>(json['category']),
      direction: serializer.fromJson<String>(json['direction']),
      amount: serializer.fromJson<int>(json['amount']),
      cadence: serializer.fromJson<String>(json['cadence']),
      firstDate: serializer.fromJson<String>(json['first_date']),
      active: serializer.fromJson<int>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'account': serializer.toJson<String>(account),
      'category': serializer.toJson<String>(category),
      'direction': serializer.toJson<String>(direction),
      'amount': serializer.toJson<int>(amount),
      'cadence': serializer.toJson<String>(cadence),
      'first_date': serializer.toJson<String>(firstDate),
      'active': serializer.toJson<int>(active),
    };
  }

  Template copyWith({
    String? id,
    String? name,
    String? account,
    String? category,
    String? direction,
    int? amount,
    String? cadence,
    String? firstDate,
    int? active,
  }) => Template(
    id: id ?? this.id,
    name: name ?? this.name,
    account: account ?? this.account,
    category: category ?? this.category,
    direction: direction ?? this.direction,
    amount: amount ?? this.amount,
    cadence: cadence ?? this.cadence,
    firstDate: firstDate ?? this.firstDate,
    active: active ?? this.active,
  );
  Template copyWithCompanion(TemplatesCompanion data) {
    return Template(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      account: data.account.present ? data.account.value : this.account,
      category: data.category.present ? data.category.value : this.category,
      direction: data.direction.present ? data.direction.value : this.direction,
      amount: data.amount.present ? data.amount.value : this.amount,
      cadence: data.cadence.present ? data.cadence.value : this.cadence,
      firstDate: data.firstDate.present ? data.firstDate.value : this.firstDate,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Template(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('account: $account, ')
          ..write('category: $category, ')
          ..write('direction: $direction, ')
          ..write('amount: $amount, ')
          ..write('cadence: $cadence, ')
          ..write('firstDate: $firstDate, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    account,
    category,
    direction,
    amount,
    cadence,
    firstDate,
    active,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Template &&
          other.id == this.id &&
          other.name == this.name &&
          other.account == this.account &&
          other.category == this.category &&
          other.direction == this.direction &&
          other.amount == this.amount &&
          other.cadence == this.cadence &&
          other.firstDate == this.firstDate &&
          other.active == this.active);
}

class TemplatesCompanion extends UpdateCompanion<Template> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> account;
  final Value<String> category;
  final Value<String> direction;
  final Value<int> amount;
  final Value<String> cadence;
  final Value<String> firstDate;
  final Value<int> active;
  final Value<int> rowid;
  const TemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.account = const Value.absent(),
    this.category = const Value.absent(),
    this.direction = const Value.absent(),
    this.amount = const Value.absent(),
    this.cadence = const Value.absent(),
    this.firstDate = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TemplatesCompanion.insert({
    required String id,
    required String name,
    required String account,
    required String category,
    required String direction,
    required int amount,
    required String cadence,
    required String firstDate,
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       account = Value(account),
       category = Value(category),
       direction = Value(direction),
       amount = Value(amount),
       cadence = Value(cadence),
       firstDate = Value(firstDate);
  static Insertable<Template> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? account,
    Expression<String>? category,
    Expression<String>? direction,
    Expression<int>? amount,
    Expression<String>? cadence,
    Expression<String>? firstDate,
    Expression<int>? active,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (account != null) 'account': account,
      if (category != null) 'category': category,
      if (direction != null) 'direction': direction,
      if (amount != null) 'amount': amount,
      if (cadence != null) 'cadence': cadence,
      if (firstDate != null) 'first_date': firstDate,
      if (active != null) 'active': active,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TemplatesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? account,
    Value<String>? category,
    Value<String>? direction,
    Value<int>? amount,
    Value<String>? cadence,
    Value<String>? firstDate,
    Value<int>? active,
    Value<int>? rowid,
  }) {
    return TemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      account: account ?? this.account,
      category: category ?? this.category,
      direction: direction ?? this.direction,
      amount: amount ?? this.amount,
      cadence: cadence ?? this.cadence,
      firstDate: firstDate ?? this.firstDate,
      active: active ?? this.active,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (account.present) {
      map['account'] = Variable<String>(account.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (cadence.present) {
      map['cadence'] = Variable<String>(cadence.value);
    }
    if (firstDate.present) {
      map['first_date'] = Variable<String>(firstDate.value);
    }
    if (active.present) {
      map['active'] = Variable<int>(active.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('account: $account, ')
          ..write('category: $category, ')
          ..write('direction: $direction, ')
          ..write('amount: $amount, ')
          ..write('cadence: $cadence, ')
          ..write('firstDate: $firstDate, ')
          ..write('active: $active, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Bills extends Table with TableInfo<Bills, Bill> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Bills(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _templateMeta = const VerificationMeta(
    'template',
  );
  late final GeneratedColumn<String> template = GeneratedColumn<String>(
    'template',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES templates(id)',
  );
  static const VerificationMeta _dueMeta = const VerificationMeta('due');
  late final GeneratedColumn<String> due = GeneratedColumn<String>(
    'due',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'unpaid\' CHECK (state IN (\'unpaid\', \'paid\', \'skipped\'))',
    defaultValue: const CustomExpression('\'unpaid\''),
  );
  static const VerificationMeta _entryMeta = const VerificationMeta('entry');
  late final GeneratedColumn<String> entry = GeneratedColumn<String>(
    'entry',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'UNIQUE REFERENCES entries(id)',
  );
  static const VerificationMeta _amountOverrideMeta = const VerificationMeta(
    'amountOverride',
  );
  late final GeneratedColumn<int> amountOverride = GeneratedColumn<int>(
    'amount_override',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (amount_override BETWEEN 1 AND 999999999999)',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    template,
    due,
    state,
    entry,
    amountOverride,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bills';
  @override
  VerificationContext validateIntegrity(
    Insertable<Bill> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('template')) {
      context.handle(
        _templateMeta,
        template.isAcceptableOrUnknown(data['template']!, _templateMeta),
      );
    } else if (isInserting) {
      context.missing(_templateMeta);
    }
    if (data.containsKey('due')) {
      context.handle(
        _dueMeta,
        due.isAcceptableOrUnknown(data['due']!, _dueMeta),
      );
    } else if (isInserting) {
      context.missing(_dueMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('entry')) {
      context.handle(
        _entryMeta,
        entry.isAcceptableOrUnknown(data['entry']!, _entryMeta),
      );
    }
    if (data.containsKey('amount_override')) {
      context.handle(
        _amountOverrideMeta,
        amountOverride.isAcceptableOrUnknown(
          data['amount_override']!,
          _amountOverrideMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {template, due},
  ];
  @override
  Bill map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bill(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      template: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template'],
      )!,
      due: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      entry: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entry'],
      ),
      amountOverride: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_override'],
      ),
    );
  }

  @override
  Bills createAlias(String alias) {
    return Bills(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const ['UNIQUE(template, due)'];
  @override
  bool get dontWriteConstraints => true;
}

class Bill extends DataClass implements Insertable<Bill> {
  final String id;
  final String template;
  final String due;
  final String state;
  final String? entry;
  final int? amountOverride;
  const Bill({
    required this.id,
    required this.template,
    required this.due,
    required this.state,
    this.entry,
    this.amountOverride,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['template'] = Variable<String>(template);
    map['due'] = Variable<String>(due);
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || entry != null) {
      map['entry'] = Variable<String>(entry);
    }
    if (!nullToAbsent || amountOverride != null) {
      map['amount_override'] = Variable<int>(amountOverride);
    }
    return map;
  }

  BillsCompanion toCompanion(bool nullToAbsent) {
    return BillsCompanion(
      id: Value(id),
      template: Value(template),
      due: Value(due),
      state: Value(state),
      entry: entry == null && nullToAbsent
          ? const Value.absent()
          : Value(entry),
      amountOverride: amountOverride == null && nullToAbsent
          ? const Value.absent()
          : Value(amountOverride),
    );
  }

  factory Bill.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bill(
      id: serializer.fromJson<String>(json['id']),
      template: serializer.fromJson<String>(json['template']),
      due: serializer.fromJson<String>(json['due']),
      state: serializer.fromJson<String>(json['state']),
      entry: serializer.fromJson<String?>(json['entry']),
      amountOverride: serializer.fromJson<int?>(json['amount_override']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'template': serializer.toJson<String>(template),
      'due': serializer.toJson<String>(due),
      'state': serializer.toJson<String>(state),
      'entry': serializer.toJson<String?>(entry),
      'amount_override': serializer.toJson<int?>(amountOverride),
    };
  }

  Bill copyWith({
    String? id,
    String? template,
    String? due,
    String? state,
    Value<String?> entry = const Value.absent(),
    Value<int?> amountOverride = const Value.absent(),
  }) => Bill(
    id: id ?? this.id,
    template: template ?? this.template,
    due: due ?? this.due,
    state: state ?? this.state,
    entry: entry.present ? entry.value : this.entry,
    amountOverride: amountOverride.present
        ? amountOverride.value
        : this.amountOverride,
  );
  Bill copyWithCompanion(BillsCompanion data) {
    return Bill(
      id: data.id.present ? data.id.value : this.id,
      template: data.template.present ? data.template.value : this.template,
      due: data.due.present ? data.due.value : this.due,
      state: data.state.present ? data.state.value : this.state,
      entry: data.entry.present ? data.entry.value : this.entry,
      amountOverride: data.amountOverride.present
          ? data.amountOverride.value
          : this.amountOverride,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bill(')
          ..write('id: $id, ')
          ..write('template: $template, ')
          ..write('due: $due, ')
          ..write('state: $state, ')
          ..write('entry: $entry, ')
          ..write('amountOverride: $amountOverride')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, template, due, state, entry, amountOverride);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bill &&
          other.id == this.id &&
          other.template == this.template &&
          other.due == this.due &&
          other.state == this.state &&
          other.entry == this.entry &&
          other.amountOverride == this.amountOverride);
}

class BillsCompanion extends UpdateCompanion<Bill> {
  final Value<String> id;
  final Value<String> template;
  final Value<String> due;
  final Value<String> state;
  final Value<String?> entry;
  final Value<int?> amountOverride;
  final Value<int> rowid;
  const BillsCompanion({
    this.id = const Value.absent(),
    this.template = const Value.absent(),
    this.due = const Value.absent(),
    this.state = const Value.absent(),
    this.entry = const Value.absent(),
    this.amountOverride = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BillsCompanion.insert({
    required String id,
    required String template,
    required String due,
    this.state = const Value.absent(),
    this.entry = const Value.absent(),
    this.amountOverride = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       template = Value(template),
       due = Value(due);
  static Insertable<Bill> custom({
    Expression<String>? id,
    Expression<String>? template,
    Expression<String>? due,
    Expression<String>? state,
    Expression<String>? entry,
    Expression<int>? amountOverride,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (template != null) 'template': template,
      if (due != null) 'due': due,
      if (state != null) 'state': state,
      if (entry != null) 'entry': entry,
      if (amountOverride != null) 'amount_override': amountOverride,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BillsCompanion copyWith({
    Value<String>? id,
    Value<String>? template,
    Value<String>? due,
    Value<String>? state,
    Value<String?>? entry,
    Value<int?>? amountOverride,
    Value<int>? rowid,
  }) {
    return BillsCompanion(
      id: id ?? this.id,
      template: template ?? this.template,
      due: due ?? this.due,
      state: state ?? this.state,
      entry: entry ?? this.entry,
      amountOverride: amountOverride ?? this.amountOverride,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (template.present) {
      map['template'] = Variable<String>(template.value);
    }
    if (due.present) {
      map['due'] = Variable<String>(due.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (entry.present) {
      map['entry'] = Variable<String>(entry.value);
    }
    if (amountOverride.present) {
      map['amount_override'] = Variable<int>(amountOverride.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillsCompanion(')
          ..write('id: $id, ')
          ..write('template: $template, ')
          ..write('due: $due, ')
          ..write('state: $state, ')
          ..write('entry: $entry, ')
          ..write('amountOverride: $amountOverride, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Receipts extends Table with TableInfo<Receipts, Receipt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Receipts(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _commandMeta = const VerificationMeta(
    'command',
  );
  late final GeneratedColumn<String> command = GeneratedColumn<String>(
    'command',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [command, entity, operation];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'receipts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Receipt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('command')) {
      context.handle(
        _commandMeta,
        command.isAcceptableOrUnknown(data['command']!, _commandMeta),
      );
    } else if (isInserting) {
      context.missing(_commandMeta);
    }
    if (data.containsKey('entity')) {
      context.handle(
        _entityMeta,
        entity.isAcceptableOrUnknown(data['entity']!, _entityMeta),
      );
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {command};
  @override
  Receipt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Receipt(
      command: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}command'],
      )!,
      entity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
    );
  }

  @override
  Receipts createAlias(String alias) {
    return Receipts(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Receipt extends DataClass implements Insertable<Receipt> {
  final String command;
  final String entity;
  final String operation;
  const Receipt({
    required this.command,
    required this.entity,
    required this.operation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['command'] = Variable<String>(command);
    map['entity'] = Variable<String>(entity);
    map['operation'] = Variable<String>(operation);
    return map;
  }

  ReceiptsCompanion toCompanion(bool nullToAbsent) {
    return ReceiptsCompanion(
      command: Value(command),
      entity: Value(entity),
      operation: Value(operation),
    );
  }

  factory Receipt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Receipt(
      command: serializer.fromJson<String>(json['command']),
      entity: serializer.fromJson<String>(json['entity']),
      operation: serializer.fromJson<String>(json['operation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'command': serializer.toJson<String>(command),
      'entity': serializer.toJson<String>(entity),
      'operation': serializer.toJson<String>(operation),
    };
  }

  Receipt copyWith({String? command, String? entity, String? operation}) =>
      Receipt(
        command: command ?? this.command,
        entity: entity ?? this.entity,
        operation: operation ?? this.operation,
      );
  Receipt copyWithCompanion(ReceiptsCompanion data) {
    return Receipt(
      command: data.command.present ? data.command.value : this.command,
      entity: data.entity.present ? data.entity.value : this.entity,
      operation: data.operation.present ? data.operation.value : this.operation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Receipt(')
          ..write('command: $command, ')
          ..write('entity: $entity, ')
          ..write('operation: $operation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(command, entity, operation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Receipt &&
          other.command == this.command &&
          other.entity == this.entity &&
          other.operation == this.operation);
}

class ReceiptsCompanion extends UpdateCompanion<Receipt> {
  final Value<String> command;
  final Value<String> entity;
  final Value<String> operation;
  final Value<int> rowid;
  const ReceiptsCompanion({
    this.command = const Value.absent(),
    this.entity = const Value.absent(),
    this.operation = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReceiptsCompanion.insert({
    required String command,
    required String entity,
    required String operation,
    this.rowid = const Value.absent(),
  }) : command = Value(command),
       entity = Value(entity),
       operation = Value(operation);
  static Insertable<Receipt> custom({
    Expression<String>? command,
    Expression<String>? entity,
    Expression<String>? operation,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (command != null) 'command': command,
      if (entity != null) 'entity': entity,
      if (operation != null) 'operation': operation,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReceiptsCompanion copyWith({
    Value<String>? command,
    Value<String>? entity,
    Value<String>? operation,
    Value<int>? rowid,
  }) {
    return ReceiptsCompanion(
      command: command ?? this.command,
      entity: entity ?? this.entity,
      operation: operation ?? this.operation,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (command.present) {
      map['command'] = Variable<String>(command.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReceiptsCompanion(')
          ..write('command: $command, ')
          ..write('entity: $entity, ')
          ..write('operation: $operation, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Categories extends Table with TableInfo<Categories, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Categories(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (type IN (\'expense\', \'income\'))',
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  late final GeneratedColumn<int> archived = GeneratedColumn<int>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0 CHECK (archived IN (0, 1))',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta(
    'isSystem',
  );
  late final GeneratedColumn<int> isSystem = GeneratedColumn<int>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  @override
  List<GeneratedColumn> get $columns => [name, type, archived, isSystem];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('is_system')) {
      context.handle(
        _isSystemMeta,
        isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {name, type};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}archived'],
      )!,
      isSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_system'],
      )!,
    );
  }

  @override
  Categories createAlias(String alias) {
    return Categories(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const ['PRIMARY KEY(name, type)'];
  @override
  bool get dontWriteConstraints => true;
}

class Category extends DataClass implements Insertable<Category> {
  final String name;
  final String type;
  final int archived;
  final int isSystem;
  const Category({
    required this.name,
    required this.type,
    required this.archived,
    required this.isSystem,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['archived'] = Variable<int>(archived);
    map['is_system'] = Variable<int>(isSystem);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      name: Value(name),
      type: Value(type),
      archived: Value(archived),
      isSystem: Value(isSystem),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      archived: serializer.fromJson<int>(json['archived']),
      isSystem: serializer.fromJson<int>(json['is_system']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'archived': serializer.toJson<int>(archived),
      'is_system': serializer.toJson<int>(isSystem),
    };
  }

  Category copyWith({
    String? name,
    String? type,
    int? archived,
    int? isSystem,
  }) => Category(
    name: name ?? this.name,
    type: type ?? this.type,
    archived: archived ?? this.archived,
    isSystem: isSystem ?? this.isSystem,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      archived: data.archived.present ? data.archived.value : this.archived,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('archived: $archived, ')
          ..write('isSystem: $isSystem')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(name, type, archived, isSystem);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.name == this.name &&
          other.type == this.type &&
          other.archived == this.archived &&
          other.isSystem == this.isSystem);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> name;
  final Value<String> type;
  final Value<int> archived;
  final Value<int> isSystem;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.archived = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String name,
    required String type,
    this.archived = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       type = Value(type);
  static Insertable<Category> custom({
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? archived,
    Expression<int>? isSystem,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (archived != null) 'archived': archived,
      if (isSystem != null) 'is_system': isSystem,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? name,
    Value<String>? type,
    Value<int>? archived,
    Value<int>? isSystem,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      name: name ?? this.name,
      type: type ?? this.type,
      archived: archived ?? this.archived,
      isSystem: isSystem ?? this.isSystem,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (archived.present) {
      map['archived'] = Variable<int>(archived.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<int>(isSystem.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('archived: $archived, ')
          ..write('isSystem: $isSystem, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final Settings settings = Settings(this);
  late final Accounts accounts = Accounts(this);
  late final Entries entries = Entries(this);
  late final Index entryDate = Index(
    'entry_date',
    'CREATE INDEX entry_date ON entries (business_date, type, deleted)',
  );
  late final Index entryAccount = Index(
    'entry_account',
    'CREATE INDEX entry_account ON entries (account, business_date)',
  );
  late final Index entryDestination = Index(
    'entry_destination',
    'CREATE INDEX entry_destination ON entries (destination, business_date)',
  );
  late final Index entryRefund = Index(
    'entry_refund',
    'CREATE INDEX entry_refund ON entries (refund_of)',
  );
  late final Budgets budgets = Budgets(this);
  late final Allocations allocations = Allocations(this);
  late final Templates templates = Templates(this);
  late final Bills bills = Bills(this);
  late final Receipts receipts = Receipts(this);
  late final Categories categories = Categories(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    settings,
    accounts,
    entries,
    entryDate,
    entryAccount,
    entryDestination,
    entryRefund,
    budgets,
    allocations,
    templates,
    bills,
    receipts,
    categories,
  ];
}

typedef $SettingsCreateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<String> zone,
  Value<int> anchor,
  required String started,
  Value<int> onboarded,
});
typedef $SettingsUpdateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<String> zone,
  Value<int> anchor,
  Value<String> started,
  Value<int> onboarded,
});

class $SettingsFilterComposer extends Composer<_$AppDatabase, Settings> {
  $SettingsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get zone => $composableBuilder(
    column: $table.zone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get anchor => $composableBuilder(
    column: $table.anchor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get started => $composableBuilder(
    column: $table.started,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get onboarded => $composableBuilder(
    column: $table.onboarded,
    builder: (column) => ColumnFilters(column),
  );
}

class $SettingsOrderingComposer extends Composer<_$AppDatabase, Settings> {
  $SettingsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get zone => $composableBuilder(
    column: $table.zone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get anchor => $composableBuilder(
    column: $table.anchor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get started => $composableBuilder(
    column: $table.started,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get onboarded => $composableBuilder(
    column: $table.onboarded,
    builder: (column) => ColumnOrderings(column),
  );
}

class $SettingsAnnotationComposer extends Composer<_$AppDatabase, Settings> {
  $SettingsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get zone =>
      $composableBuilder(column: $table.zone, builder: (column) => column);

  GeneratedColumn<int> get anchor =>
      $composableBuilder(column: $table.anchor, builder: (column) => column);

  GeneratedColumn<String> get started =>
      $composableBuilder(column: $table.started, builder: (column) => column);

  GeneratedColumn<int> get onboarded =>
      $composableBuilder(column: $table.onboarded, builder: (column) => column);
}

class $SettingsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Settings,
          Setting,
          $SettingsFilterComposer,
          $SettingsOrderingComposer,
          $SettingsAnnotationComposer,
          $SettingsCreateCompanionBuilder,
          $SettingsUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, Settings, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $SettingsTableManager(_$AppDatabase db, Settings table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $SettingsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $SettingsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $SettingsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> zone = const Value.absent(),
                Value<int> anchor = const Value.absent(),
                Value<String> started = const Value.absent(),
                Value<int> onboarded = const Value.absent(),
              }) => SettingsCompanion(
                id: id,
                zone: zone,
                anchor: anchor,
                started: started,
                onboarded: onboarded,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> zone = const Value.absent(),
                Value<int> anchor = const Value.absent(),
                required String started,
                Value<int> onboarded = const Value.absent(),
              }) => SettingsCompanion.insert(
                id: id,
                zone: zone,
                anchor: anchor,
                started: started,
                onboarded: onboarded,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Settings, Setting>(table),
                  BaseReferences<_$AppDatabase, Settings, Setting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $SettingsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Settings,
      Setting,
      $SettingsFilterComposer,
      $SettingsOrderingComposer,
      $SettingsAnnotationComposer,
      $SettingsCreateCompanionBuilder,
      $SettingsUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, Settings, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $AccountsCreateCompanionBuilder = AccountsCompanion Function({
  required String id,
  required String name,
  required String type,
  required int opening,
  required int opened,
  Value<int> archived,
  Value<int> rowid,
});
typedef $AccountsUpdateCompanionBuilder = AccountsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> type,
  Value<int> opening,
  Value<int> opened,
  Value<int> archived,
  Value<int> rowid,
});

final class $AccountsReferences
    extends BaseReferences<_$AppDatabase, Accounts, Account> {
  $AccountsReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<Templates, List<Template>> _templatesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.templates,
    aliasName: 'accounts__id__templates__account',
  );

  $TemplatesProcessedTableManager get templatesRefs {
    final manager = $TemplatesTableManager(
      $_db,
      $_db.templates,
    ).filter((f) => f.account.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_templatesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $AccountsFilterComposer extends Composer<_$AppDatabase, Accounts> {
  $AccountsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get opening => $composableBuilder(
    column: $table.opening,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get opened => $composableBuilder(
    column: $table.opened,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> templatesRefs(
    Expression<bool> Function($TemplatesFilterComposer f) f,
  ) {
    final $TemplatesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.account,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TemplatesFilterComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $AccountsOrderingComposer extends Composer<_$AppDatabase, Accounts> {
  $AccountsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get opening => $composableBuilder(
    column: $table.opening,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get opened => $composableBuilder(
    column: $table.opened,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );
}

class $AccountsAnnotationComposer extends Composer<_$AppDatabase, Accounts> {
  $AccountsAnnotationComposer({
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

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get opening =>
      $composableBuilder(column: $table.opening, builder: (column) => column);

  GeneratedColumn<int> get opened =>
      $composableBuilder(column: $table.opened, builder: (column) => column);

  GeneratedColumn<int> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  Expression<T> templatesRefs<T extends Object>(
    Expression<T> Function($TemplatesAnnotationComposer a) f,
  ) {
    final $TemplatesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.account,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TemplatesAnnotationComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $AccountsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Accounts,
          Account,
          $AccountsFilterComposer,
          $AccountsOrderingComposer,
          $AccountsAnnotationComposer,
          $AccountsCreateCompanionBuilder,
          $AccountsUpdateCompanionBuilder,
          (Account, $AccountsReferences),
          Account,
          PrefetchHooks Function({bool templatesRefs})
        > {
  $AccountsTableManager(_$AppDatabase db, Accounts table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $AccountsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $AccountsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $AccountsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> opening = const Value.absent(),
                Value<int> opened = const Value.absent(),
                Value<int> archived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                name: name,
                type: type,
                opening: opening,
                opened: opened,
                archived: archived,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String type,
                required int opening,
                required int opened,
                Value<int> archived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                name: name,
                type: type,
                opening: opening,
                opened: opened,
                archived: archived,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Accounts, Account>(table),
                  $AccountsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({templatesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (templatesRefs) db.templates],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (templatesRefs)
                    await $_getPrefetchedData<Account, Accounts, Template>(
                      currentTable: table,
                      referencedTable: $AccountsReferences._templatesRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $AccountsReferences(db, table, p0).templatesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.account == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $AccountsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Accounts,
      Account,
      $AccountsFilterComposer,
      $AccountsOrderingComposer,
      $AccountsAnnotationComposer,
      $AccountsCreateCompanionBuilder,
      $AccountsUpdateCompanionBuilder,
      (Account, $AccountsReferences),
      Account,
      PrefetchHooks Function({bool templatesRefs})
    >;
typedef $EntriesCreateCompanionBuilder = EntriesCompanion Function({
  required String id,
  required String command,
  required String type,
  required String account,
  Value<String?> destination,
  required int amount,
  Value<String> category,
  Value<String> merchant,
  Value<String> note,
  required int occurred,
  required String businessDate,
  required String zone,
  Value<String?> refundOf,
  Value<String?> parent,
  Value<int?> deleted,
  Value<int> rowid,
});
typedef $EntriesUpdateCompanionBuilder = EntriesCompanion Function({
  Value<String> id,
  Value<String> command,
  Value<String> type,
  Value<String> account,
  Value<String?> destination,
  Value<int> amount,
  Value<String> category,
  Value<String> merchant,
  Value<String> note,
  Value<int> occurred,
  Value<String> businessDate,
  Value<String> zone,
  Value<String?> refundOf,
  Value<String?> parent,
  Value<int?> deleted,
  Value<int> rowid,
});

final class $EntriesReferences
    extends BaseReferences<_$AppDatabase, Entries, Entry> {
  $EntriesReferences(super.$_db, super.$_table, super.$_typedResult);

  static Accounts _accountTable(_$AppDatabase db) =>
      db.accounts.createAlias('entries__account__accounts__id');

  $AccountsProcessedTableManager get account {
    final $_column = $_itemColumn<String>('account')!;

    final manager = $AccountsTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Accounts _destinationTable(_$AppDatabase db) =>
      db.accounts.createAlias('entries__destination__accounts__id');

  $AccountsProcessedTableManager? get destination {
    final $_column = $_itemColumn<String>('destination');
    if ($_column == null) return null;
    final manager = $AccountsTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_destinationTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Entries _refundOfTable(_$AppDatabase db) =>
      db.entries.createAlias('entries__refund_of__entries__id');

  $EntriesProcessedTableManager? get refundOf {
    final $_column = $_itemColumn<String>('refund_of');
    if ($_column == null) return null;
    final manager = $EntriesTableManager(
      $_db,
      $_db.entries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_refundOfTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Entries _parentTable(_$AppDatabase db) =>
      db.entries.createAlias('entries__parent__entries__id');

  $EntriesProcessedTableManager? get parent {
    final $_column = $_itemColumn<String>('parent');
    if ($_column == null) return null;
    final manager = $EntriesTableManager(
      $_db,
      $_db.entries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<Bills, List<Bill>> _billsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.bills,
    aliasName: 'entries__id__bills__entry',
  );

  $BillsProcessedTableManager get billsRefs {
    final manager = $BillsTableManager(
      $_db,
      $_db.bills,
    ).filter((f) => f.entry.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_billsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $EntriesFilterComposer extends Composer<_$AppDatabase, Entries> {
  $EntriesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get command => $composableBuilder(
    column: $table.command,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get occurred => $composableBuilder(
    column: $table.occurred,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get businessDate => $composableBuilder(
    column: $table.businessDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get zone => $composableBuilder(
    column: $table.zone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  $AccountsFilterComposer get account {
    final $AccountsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.account,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $AccountsFilterComposer get destination {
    final $AccountsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.destination,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $EntriesFilterComposer get refundOf {
    final $EntriesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.refundOf,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EntriesFilterComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $EntriesFilterComposer get parent {
    final $EntriesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parent,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EntriesFilterComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> billsRefs(
    Expression<bool> Function($BillsFilterComposer f) f,
  ) {
    final $BillsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bills,
      getReferencedColumn: (t) => t.entry,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BillsFilterComposer(
            $db: $db,
            $table: $db.bills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $EntriesOrderingComposer extends Composer<_$AppDatabase, Entries> {
  $EntriesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get command => $composableBuilder(
    column: $table.command,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get occurred => $composableBuilder(
    column: $table.occurred,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get businessDate => $composableBuilder(
    column: $table.businessDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get zone => $composableBuilder(
    column: $table.zone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  $AccountsOrderingComposer get account {
    final $AccountsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.account,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $AccountsOrderingComposer get destination {
    final $AccountsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.destination,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $EntriesOrderingComposer get refundOf {
    final $EntriesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.refundOf,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EntriesOrderingComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $EntriesOrderingComposer get parent {
    final $EntriesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parent,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EntriesOrderingComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $EntriesAnnotationComposer extends Composer<_$AppDatabase, Entries> {
  $EntriesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get command =>
      $composableBuilder(column: $table.command, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get merchant =>
      $composableBuilder(column: $table.merchant, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get occurred =>
      $composableBuilder(column: $table.occurred, builder: (column) => column);

  GeneratedColumn<String> get businessDate => $composableBuilder(
    column: $table.businessDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get zone =>
      $composableBuilder(column: $table.zone, builder: (column) => column);

  GeneratedColumn<int> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  $AccountsAnnotationComposer get account {
    final $AccountsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.account,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $AccountsAnnotationComposer get destination {
    final $AccountsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.destination,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $EntriesAnnotationComposer get refundOf {
    final $EntriesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.refundOf,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EntriesAnnotationComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $EntriesAnnotationComposer get parent {
    final $EntriesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parent,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EntriesAnnotationComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> billsRefs<T extends Object>(
    Expression<T> Function($BillsAnnotationComposer a) f,
  ) {
    final $BillsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bills,
      getReferencedColumn: (t) => t.entry,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BillsAnnotationComposer(
            $db: $db,
            $table: $db.bills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $EntriesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Entries,
          Entry,
          $EntriesFilterComposer,
          $EntriesOrderingComposer,
          $EntriesAnnotationComposer,
          $EntriesCreateCompanionBuilder,
          $EntriesUpdateCompanionBuilder,
          (Entry, $EntriesReferences),
          Entry,
          PrefetchHooks Function({
            bool account,
            bool destination,
            bool refundOf,
            bool parent,
            bool billsRefs,
          })
        > {
  $EntriesTableManager(_$AppDatabase db, Entries table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $EntriesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $EntriesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $EntriesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> command = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> account = const Value.absent(),
                Value<String?> destination = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> merchant = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<int> occurred = const Value.absent(),
                Value<String> businessDate = const Value.absent(),
                Value<String> zone = const Value.absent(),
                Value<String?> refundOf = const Value.absent(),
                Value<String?> parent = const Value.absent(),
                Value<int?> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntriesCompanion(
                id: id,
                command: command,
                type: type,
                account: account,
                destination: destination,
                amount: amount,
                category: category,
                merchant: merchant,
                note: note,
                occurred: occurred,
                businessDate: businessDate,
                zone: zone,
                refundOf: refundOf,
                parent: parent,
                deleted: deleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String command,
                required String type,
                required String account,
                Value<String?> destination = const Value.absent(),
                required int amount,
                Value<String> category = const Value.absent(),
                Value<String> merchant = const Value.absent(),
                Value<String> note = const Value.absent(),
                required int occurred,
                required String businessDate,
                required String zone,
                Value<String?> refundOf = const Value.absent(),
                Value<String?> parent = const Value.absent(),
                Value<int?> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntriesCompanion.insert(
                id: id,
                command: command,
                type: type,
                account: account,
                destination: destination,
                amount: amount,
                category: category,
                merchant: merchant,
                note: note,
                occurred: occurred,
                businessDate: businessDate,
                zone: zone,
                refundOf: refundOf,
                parent: parent,
                deleted: deleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Entries, Entry>(table),
                  $EntriesReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                account = false,
                destination = false,
                refundOf = false,
                parent = false,
                billsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (billsRefs) db.bills],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (account) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.account,
                            referencedTable: $EntriesReferences._accountTable(
                              db,
                            ),
                            referencedColumn: $EntriesReferences
                                ._accountTable(db)
                                .id,
                          ) as T;
                        }
                        if (destination) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.destination,
                            referencedTable: $EntriesReferences
                                ._destinationTable(db),
                            referencedColumn: $EntriesReferences
                                ._destinationTable(db)
                                .id,
                          ) as T;
                        }
                        if (refundOf) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.refundOf,
                            referencedTable: $EntriesReferences._refundOfTable(
                              db,
                            ),
                            referencedColumn: $EntriesReferences
                                ._refundOfTable(db)
                                .id,
                          ) as T;
                        }
                        if (parent) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.parent,
                            referencedTable: $EntriesReferences._parentTable(
                              db,
                            ),
                            referencedColumn: $EntriesReferences
                                ._parentTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (billsRefs)
                        await $_getPrefetchedData<Entry, Entries, Bill>(
                          currentTable: table,
                          referencedTable: $EntriesReferences._billsRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $EntriesReferences(db, table, p0).billsRefs,
                          referencedItemsForCurrentItem: (
                            item,
                            referencedItems,
                          ) => referencedItems.where((e) => e.entry == item.id),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $EntriesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Entries,
      Entry,
      $EntriesFilterComposer,
      $EntriesOrderingComposer,
      $EntriesAnnotationComposer,
      $EntriesCreateCompanionBuilder,
      $EntriesUpdateCompanionBuilder,
      (Entry, $EntriesReferences),
      Entry,
      PrefetchHooks Function({
        bool account,
        bool destination,
        bool refundOf,
        bool parent,
        bool billsRefs,
      })
    >;
typedef $BudgetsCreateCompanionBuilder = BudgetsCompanion Function({
  required String start,
  required String endDate,
  required int total,
  Value<int> revision,
  required int updated,
  Value<int> rowid,
});
typedef $BudgetsUpdateCompanionBuilder = BudgetsCompanion Function({
  Value<String> start,
  Value<String> endDate,
  Value<int> total,
  Value<int> revision,
  Value<int> updated,
  Value<int> rowid,
});

final class $BudgetsReferences
    extends BaseReferences<_$AppDatabase, Budgets, Budget> {
  $BudgetsReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<Allocations, List<Allocation>>
  _allocationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.allocations,
    aliasName: 'budgets__start__allocations__period',
  );

  $AllocationsProcessedTableManager get allocationsRefs {
    final manager = $AllocationsTableManager(
      $_db,
      $_db.allocations,
    ).filter((f) => f.period.start.sqlEquals($_itemColumn<String>('start')!));

    final cache = $_typedResult.readTableOrNull(_allocationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $BudgetsFilterComposer extends Composer<_$AppDatabase, Budgets> {
  $BudgetsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updated => $composableBuilder(
    column: $table.updated,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> allocationsRefs(
    Expression<bool> Function($AllocationsFilterComposer f) f,
  ) {
    final $AllocationsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.start,
      referencedTable: $db.allocations,
      getReferencedColumn: (t) => t.period,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AllocationsFilterComposer(
            $db: $db,
            $table: $db.allocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $BudgetsOrderingComposer extends Composer<_$AppDatabase, Budgets> {
  $BudgetsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updated => $composableBuilder(
    column: $table.updated,
    builder: (column) => ColumnOrderings(column),
  );
}

class $BudgetsAnnotationComposer extends Composer<_$AppDatabase, Budgets> {
  $BudgetsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get start =>
      $composableBuilder(column: $table.start, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<int> get updated =>
      $composableBuilder(column: $table.updated, builder: (column) => column);

  Expression<T> allocationsRefs<T extends Object>(
    Expression<T> Function($AllocationsAnnotationComposer a) f,
  ) {
    final $AllocationsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.start,
      referencedTable: $db.allocations,
      getReferencedColumn: (t) => t.period,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AllocationsAnnotationComposer(
            $db: $db,
            $table: $db.allocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $BudgetsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Budgets,
          Budget,
          $BudgetsFilterComposer,
          $BudgetsOrderingComposer,
          $BudgetsAnnotationComposer,
          $BudgetsCreateCompanionBuilder,
          $BudgetsUpdateCompanionBuilder,
          (Budget, $BudgetsReferences),
          Budget,
          PrefetchHooks Function({bool allocationsRefs})
        > {
  $BudgetsTableManager(_$AppDatabase db, Budgets table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $BudgetsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $BudgetsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $BudgetsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> start = const Value.absent(),
                Value<String> endDate = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> updated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion(
                start: start,
                endDate: endDate,
                total: total,
                revision: revision,
                updated: updated,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String start,
                required String endDate,
                required int total,
                Value<int> revision = const Value.absent(),
                required int updated,
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion.insert(
                start: start,
                endDate: endDate,
                total: total,
                revision: revision,
                updated: updated,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Budgets, Budget>(table),
                  $BudgetsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({allocationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (allocationsRefs) db.allocations],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (allocationsRefs)
                    await $_getPrefetchedData<Budget, Budgets, Allocation>(
                      currentTable: table,
                      referencedTable: $BudgetsReferences._allocationsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $BudgetsReferences(db, table, p0).allocationsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.period == item.start),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $BudgetsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Budgets,
      Budget,
      $BudgetsFilterComposer,
      $BudgetsOrderingComposer,
      $BudgetsAnnotationComposer,
      $BudgetsCreateCompanionBuilder,
      $BudgetsUpdateCompanionBuilder,
      (Budget, $BudgetsReferences),
      Budget,
      PrefetchHooks Function({bool allocationsRefs})
    >;
typedef $AllocationsCreateCompanionBuilder = AllocationsCompanion Function({
  required String period,
  required String category,
  required int amount,
  Value<int> rowid,
});
typedef $AllocationsUpdateCompanionBuilder = AllocationsCompanion Function({
  Value<String> period,
  Value<String> category,
  Value<int> amount,
  Value<int> rowid,
});

final class $AllocationsReferences
    extends BaseReferences<_$AppDatabase, Allocations, Allocation> {
  $AllocationsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Budgets _periodTable(_$AppDatabase db) =>
      db.budgets.createAlias('allocations__period__budgets__start');

  $BudgetsProcessedTableManager get period {
    final $_column = $_itemColumn<String>('period')!;

    final manager = $BudgetsTableManager(
      $_db,
      $_db.budgets,
    ).filter((f) => f.start.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_periodTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $AllocationsFilterComposer extends Composer<_$AppDatabase, Allocations> {
  $AllocationsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  $BudgetsFilterComposer get period {
    final $BudgetsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.period,
      referencedTable: $db.budgets,
      getReferencedColumn: (t) => t.start,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BudgetsFilterComposer(
            $db: $db,
            $table: $db.budgets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AllocationsOrderingComposer
    extends Composer<_$AppDatabase, Allocations> {
  $AllocationsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  $BudgetsOrderingComposer get period {
    final $BudgetsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.period,
      referencedTable: $db.budgets,
      getReferencedColumn: (t) => t.start,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BudgetsOrderingComposer(
            $db: $db,
            $table: $db.budgets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AllocationsAnnotationComposer
    extends Composer<_$AppDatabase, Allocations> {
  $AllocationsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  $BudgetsAnnotationComposer get period {
    final $BudgetsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.period,
      referencedTable: $db.budgets,
      getReferencedColumn: (t) => t.start,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BudgetsAnnotationComposer(
            $db: $db,
            $table: $db.budgets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AllocationsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Allocations,
          Allocation,
          $AllocationsFilterComposer,
          $AllocationsOrderingComposer,
          $AllocationsAnnotationComposer,
          $AllocationsCreateCompanionBuilder,
          $AllocationsUpdateCompanionBuilder,
          (Allocation, $AllocationsReferences),
          Allocation,
          PrefetchHooks Function({bool period})
        > {
  $AllocationsTableManager(_$AppDatabase db, Allocations table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $AllocationsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $AllocationsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $AllocationsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> period = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AllocationsCompanion(
                period: period,
                category: category,
                amount: amount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String period,
                required String category,
                required int amount,
                Value<int> rowid = const Value.absent(),
              }) => AllocationsCompanion.insert(
                period: period,
                category: category,
                amount: amount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Allocations, Allocation>(table),
                  $AllocationsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({period = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (period) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.period,
                        referencedTable: $AllocationsReferences._periodTable(
                          db,
                        ),
                        referencedColumn: $AllocationsReferences
                            ._periodTable(db)
                            .start,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $AllocationsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Allocations,
      Allocation,
      $AllocationsFilterComposer,
      $AllocationsOrderingComposer,
      $AllocationsAnnotationComposer,
      $AllocationsCreateCompanionBuilder,
      $AllocationsUpdateCompanionBuilder,
      (Allocation, $AllocationsReferences),
      Allocation,
      PrefetchHooks Function({bool period})
    >;
typedef $TemplatesCreateCompanionBuilder = TemplatesCompanion Function({
  required String id,
  required String name,
  required String account,
  required String category,
  required String direction,
  required int amount,
  required String cadence,
  required String firstDate,
  Value<int> active,
  Value<int> rowid,
});
typedef $TemplatesUpdateCompanionBuilder = TemplatesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> account,
  Value<String> category,
  Value<String> direction,
  Value<int> amount,
  Value<String> cadence,
  Value<String> firstDate,
  Value<int> active,
  Value<int> rowid,
});

final class $TemplatesReferences
    extends BaseReferences<_$AppDatabase, Templates, Template> {
  $TemplatesReferences(super.$_db, super.$_table, super.$_typedResult);

  static Accounts _accountTable(_$AppDatabase db) =>
      db.accounts.createAlias('templates__account__accounts__id');

  $AccountsProcessedTableManager get account {
    final $_column = $_itemColumn<String>('account')!;

    final manager = $AccountsTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<Bills, List<Bill>> _billsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.bills,
    aliasName: 'templates__id__bills__template',
  );

  $BillsProcessedTableManager get billsRefs {
    final manager = $BillsTableManager(
      $_db,
      $_db.bills,
    ).filter((f) => f.template.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_billsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $TemplatesFilterComposer extends Composer<_$AppDatabase, Templates> {
  $TemplatesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cadence => $composableBuilder(
    column: $table.cadence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstDate => $composableBuilder(
    column: $table.firstDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  $AccountsFilterComposer get account {
    final $AccountsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.account,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> billsRefs(
    Expression<bool> Function($BillsFilterComposer f) f,
  ) {
    final $BillsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bills,
      getReferencedColumn: (t) => t.template,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BillsFilterComposer(
            $db: $db,
            $table: $db.bills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $TemplatesOrderingComposer extends Composer<_$AppDatabase, Templates> {
  $TemplatesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cadence => $composableBuilder(
    column: $table.cadence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstDate => $composableBuilder(
    column: $table.firstDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  $AccountsOrderingComposer get account {
    final $AccountsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.account,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $TemplatesAnnotationComposer extends Composer<_$AppDatabase, Templates> {
  $TemplatesAnnotationComposer({
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

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get cadence =>
      $composableBuilder(column: $table.cadence, builder: (column) => column);

  GeneratedColumn<String> get firstDate =>
      $composableBuilder(column: $table.firstDate, builder: (column) => column);

  GeneratedColumn<int> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  $AccountsAnnotationComposer get account {
    final $AccountsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.account,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> billsRefs<T extends Object>(
    Expression<T> Function($BillsAnnotationComposer a) f,
  ) {
    final $BillsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bills,
      getReferencedColumn: (t) => t.template,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BillsAnnotationComposer(
            $db: $db,
            $table: $db.bills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $TemplatesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Templates,
          Template,
          $TemplatesFilterComposer,
          $TemplatesOrderingComposer,
          $TemplatesAnnotationComposer,
          $TemplatesCreateCompanionBuilder,
          $TemplatesUpdateCompanionBuilder,
          (Template, $TemplatesReferences),
          Template,
          PrefetchHooks Function({bool account, bool billsRefs})
        > {
  $TemplatesTableManager(_$AppDatabase db, Templates table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $TemplatesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $TemplatesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $TemplatesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> account = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> direction = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> cadence = const Value.absent(),
                Value<String> firstDate = const Value.absent(),
                Value<int> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TemplatesCompanion(
                id: id,
                name: name,
                account: account,
                category: category,
                direction: direction,
                amount: amount,
                cadence: cadence,
                firstDate: firstDate,
                active: active,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String account,
                required String category,
                required String direction,
                required int amount,
                required String cadence,
                required String firstDate,
                Value<int> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TemplatesCompanion.insert(
                id: id,
                name: name,
                account: account,
                category: category,
                direction: direction,
                amount: amount,
                cadence: cadence,
                firstDate: firstDate,
                active: active,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Templates, Template>(table),
                  $TemplatesReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({account = false, billsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (billsRefs) db.bills],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (account) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.account,
                        referencedTable: $TemplatesReferences._accountTable(db),
                        referencedColumn: $TemplatesReferences
                            ._accountTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (billsRefs)
                    await $_getPrefetchedData<Template, Templates, Bill>(
                      currentTable: table,
                      referencedTable: $TemplatesReferences._billsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $TemplatesReferences(db, table, p0).billsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.template == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $TemplatesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Templates,
      Template,
      $TemplatesFilterComposer,
      $TemplatesOrderingComposer,
      $TemplatesAnnotationComposer,
      $TemplatesCreateCompanionBuilder,
      $TemplatesUpdateCompanionBuilder,
      (Template, $TemplatesReferences),
      Template,
      PrefetchHooks Function({bool account, bool billsRefs})
    >;
typedef $BillsCreateCompanionBuilder = BillsCompanion Function({
  required String id,
  required String template,
  required String due,
  Value<String> state,
  Value<String?> entry,
  Value<int?> amountOverride,
  Value<int> rowid,
});
typedef $BillsUpdateCompanionBuilder = BillsCompanion Function({
  Value<String> id,
  Value<String> template,
  Value<String> due,
  Value<String> state,
  Value<String?> entry,
  Value<int?> amountOverride,
  Value<int> rowid,
});

final class $BillsReferences
    extends BaseReferences<_$AppDatabase, Bills, Bill> {
  $BillsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Templates _templateTable(_$AppDatabase db) =>
      db.templates.createAlias('bills__template__templates__id');

  $TemplatesProcessedTableManager get template {
    final $_column = $_itemColumn<String>('template')!;

    final manager = $TemplatesTableManager(
      $_db,
      $_db.templates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Entries _entryTable(_$AppDatabase db) =>
      db.entries.createAlias('bills__entry__entries__id');

  $EntriesProcessedTableManager? get entry {
    final $_column = $_itemColumn<String>('entry');
    if ($_column == null) return null;
    final manager = $EntriesTableManager(
      $_db,
      $_db.entries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $BillsFilterComposer extends Composer<_$AppDatabase, Bills> {
  $BillsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountOverride => $composableBuilder(
    column: $table.amountOverride,
    builder: (column) => ColumnFilters(column),
  );

  $TemplatesFilterComposer get template {
    final $TemplatesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.template,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TemplatesFilterComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $EntriesFilterComposer get entry {
    final $EntriesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entry,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EntriesFilterComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $BillsOrderingComposer extends Composer<_$AppDatabase, Bills> {
  $BillsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountOverride => $composableBuilder(
    column: $table.amountOverride,
    builder: (column) => ColumnOrderings(column),
  );

  $TemplatesOrderingComposer get template {
    final $TemplatesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.template,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TemplatesOrderingComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $EntriesOrderingComposer get entry {
    final $EntriesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entry,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EntriesOrderingComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $BillsAnnotationComposer extends Composer<_$AppDatabase, Bills> {
  $BillsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get due =>
      $composableBuilder(column: $table.due, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<int> get amountOverride => $composableBuilder(
    column: $table.amountOverride,
    builder: (column) => column,
  );

  $TemplatesAnnotationComposer get template {
    final $TemplatesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.template,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TemplatesAnnotationComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $EntriesAnnotationComposer get entry {
    final $EntriesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entry,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EntriesAnnotationComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $BillsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Bills,
          Bill,
          $BillsFilterComposer,
          $BillsOrderingComposer,
          $BillsAnnotationComposer,
          $BillsCreateCompanionBuilder,
          $BillsUpdateCompanionBuilder,
          (Bill, $BillsReferences),
          Bill,
          PrefetchHooks Function({bool template, bool entry})
        > {
  $BillsTableManager(_$AppDatabase db, Bills table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $BillsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $BillsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $BillsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> template = const Value.absent(),
                Value<String> due = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String?> entry = const Value.absent(),
                Value<int?> amountOverride = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BillsCompanion(
                id: id,
                template: template,
                due: due,
                state: state,
                entry: entry,
                amountOverride: amountOverride,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String template,
                required String due,
                Value<String> state = const Value.absent(),
                Value<String?> entry = const Value.absent(),
                Value<int?> amountOverride = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BillsCompanion.insert(
                id: id,
                template: template,
                due: due,
                state: state,
                entry: entry,
                amountOverride: amountOverride,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Bills, Bill>(table),
                  $BillsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({template = false, entry = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (template) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.template,
                        referencedTable: $BillsReferences._templateTable(db),
                        referencedColumn: $BillsReferences
                            ._templateTable(db)
                            .id,
                      ) as T;
                    }
                    if (entry) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.entry,
                        referencedTable: $BillsReferences._entryTable(db),
                        referencedColumn: $BillsReferences._entryTable(db).id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $BillsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Bills,
      Bill,
      $BillsFilterComposer,
      $BillsOrderingComposer,
      $BillsAnnotationComposer,
      $BillsCreateCompanionBuilder,
      $BillsUpdateCompanionBuilder,
      (Bill, $BillsReferences),
      Bill,
      PrefetchHooks Function({bool template, bool entry})
    >;
typedef $ReceiptsCreateCompanionBuilder = ReceiptsCompanion Function({
  required String command,
  required String entity,
  required String operation,
  Value<int> rowid,
});
typedef $ReceiptsUpdateCompanionBuilder = ReceiptsCompanion Function({
  Value<String> command,
  Value<String> entity,
  Value<String> operation,
  Value<int> rowid,
});

class $ReceiptsFilterComposer extends Composer<_$AppDatabase, Receipts> {
  $ReceiptsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get command => $composableBuilder(
    column: $table.command,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );
}

class $ReceiptsOrderingComposer extends Composer<_$AppDatabase, Receipts> {
  $ReceiptsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get command => $composableBuilder(
    column: $table.command,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );
}

class $ReceiptsAnnotationComposer extends Composer<_$AppDatabase, Receipts> {
  $ReceiptsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get command =>
      $composableBuilder(column: $table.command, builder: (column) => column);

  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);
}

class $ReceiptsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Receipts,
          Receipt,
          $ReceiptsFilterComposer,
          $ReceiptsOrderingComposer,
          $ReceiptsAnnotationComposer,
          $ReceiptsCreateCompanionBuilder,
          $ReceiptsUpdateCompanionBuilder,
          (Receipt, BaseReferences<_$AppDatabase, Receipts, Receipt>),
          Receipt,
          PrefetchHooks Function()
        > {
  $ReceiptsTableManager(_$AppDatabase db, Receipts table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ReceiptsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ReceiptsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ReceiptsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> command = const Value.absent(),
                Value<String> entity = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReceiptsCompanion(
                command: command,
                entity: entity,
                operation: operation,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String command,
                required String entity,
                required String operation,
                Value<int> rowid = const Value.absent(),
              }) => ReceiptsCompanion.insert(
                command: command,
                entity: entity,
                operation: operation,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Receipts, Receipt>(table),
                  BaseReferences<_$AppDatabase, Receipts, Receipt>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $ReceiptsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Receipts,
      Receipt,
      $ReceiptsFilterComposer,
      $ReceiptsOrderingComposer,
      $ReceiptsAnnotationComposer,
      $ReceiptsCreateCompanionBuilder,
      $ReceiptsUpdateCompanionBuilder,
      (Receipt, BaseReferences<_$AppDatabase, Receipts, Receipt>),
      Receipt,
      PrefetchHooks Function()
    >;
typedef $CategoriesCreateCompanionBuilder = CategoriesCompanion Function({
  required String name,
  required String type,
  Value<int> archived,
  Value<int> isSystem,
  Value<int> rowid,
});
typedef $CategoriesUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> name,
  Value<String> type,
  Value<int> archived,
  Value<int> isSystem,
  Value<int> rowid,
});

class $CategoriesFilterComposer extends Composer<_$AppDatabase, Categories> {
  $CategoriesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnFilters(column),
  );
}

class $CategoriesOrderingComposer extends Composer<_$AppDatabase, Categories> {
  $CategoriesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnOrderings(column),
  );
}

class $CategoriesAnnotationComposer
    extends Composer<_$AppDatabase, Categories> {
  $CategoriesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<int> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);
}

class $CategoriesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Categories,
          Category,
          $CategoriesFilterComposer,
          $CategoriesOrderingComposer,
          $CategoriesAnnotationComposer,
          $CategoriesCreateCompanionBuilder,
          $CategoriesUpdateCompanionBuilder,
          (Category, BaseReferences<_$AppDatabase, Categories, Category>),
          Category,
          PrefetchHooks Function()
        > {
  $CategoriesTableManager(_$AppDatabase db, Categories table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $CategoriesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $CategoriesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $CategoriesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> archived = const Value.absent(),
                Value<int> isSystem = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                name: name,
                type: type,
                archived: archived,
                isSystem: isSystem,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String name,
                required String type,
                Value<int> archived = const Value.absent(),
                Value<int> isSystem = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                name: name,
                type: type,
                archived: archived,
                isSystem: isSystem,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Categories, Category>(table),
                  BaseReferences<_$AppDatabase, Categories, Category>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $CategoriesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Categories,
      Category,
      $CategoriesFilterComposer,
      $CategoriesOrderingComposer,
      $CategoriesAnnotationComposer,
      $CategoriesCreateCompanionBuilder,
      $CategoriesUpdateCompanionBuilder,
      (Category, BaseReferences<_$AppDatabase, Categories, Category>),
      Category,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $SettingsTableManager get settings =>
      $SettingsTableManager(_db, _db.settings);
  $AccountsTableManager get accounts =>
      $AccountsTableManager(_db, _db.accounts);
  $EntriesTableManager get entries => $EntriesTableManager(_db, _db.entries);
  $BudgetsTableManager get budgets => $BudgetsTableManager(_db, _db.budgets);
  $AllocationsTableManager get allocations =>
      $AllocationsTableManager(_db, _db.allocations);
  $TemplatesTableManager get templates =>
      $TemplatesTableManager(_db, _db.templates);
  $BillsTableManager get bills => $BillsTableManager(_db, _db.bills);
  $ReceiptsTableManager get receipts =>
      $ReceiptsTableManager(_db, _db.receipts);
  $CategoriesTableManager get categories =>
      $CategoriesTableManager(_db, _db.categories);
}
