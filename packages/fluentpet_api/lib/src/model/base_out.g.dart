// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BaseOut extends BaseOut {
  @override
  final int id;
  @override
  final String serialNumber;
  @override
  final String? name;
  @override
  final int? defaultPusherId;
  @override
  final int groupWindowSeconds;
  @override
  final String? fwVersion;
  @override
  final int? batteryLevel;
  @override
  final DateTime? batteryUpdatedAt;
  @override
  final DateTime? lastOnlineAt;
  @override
  final BuiltMap<String, JsonObject?>? reportedState;
  @override
  final DateTime createdAt;
  @override
  final BuiltList<LinkedButtonOut> buttons;

  factory _$BaseOut([void Function(BaseOutBuilder)? updates]) =>
      (BaseOutBuilder()..update(updates))._build();

  _$BaseOut._(
      {required this.id,
      required this.serialNumber,
      this.name,
      this.defaultPusherId,
      required this.groupWindowSeconds,
      this.fwVersion,
      this.batteryLevel,
      this.batteryUpdatedAt,
      this.lastOnlineAt,
      this.reportedState,
      required this.createdAt,
      required this.buttons})
      : super._();
  @override
  BaseOut rebuild(void Function(BaseOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BaseOutBuilder toBuilder() => BaseOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BaseOut &&
        id == other.id &&
        serialNumber == other.serialNumber &&
        name == other.name &&
        defaultPusherId == other.defaultPusherId &&
        groupWindowSeconds == other.groupWindowSeconds &&
        fwVersion == other.fwVersion &&
        batteryLevel == other.batteryLevel &&
        batteryUpdatedAt == other.batteryUpdatedAt &&
        lastOnlineAt == other.lastOnlineAt &&
        reportedState == other.reportedState &&
        createdAt == other.createdAt &&
        buttons == other.buttons;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, serialNumber.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, defaultPusherId.hashCode);
    _$hash = $jc(_$hash, groupWindowSeconds.hashCode);
    _$hash = $jc(_$hash, fwVersion.hashCode);
    _$hash = $jc(_$hash, batteryLevel.hashCode);
    _$hash = $jc(_$hash, batteryUpdatedAt.hashCode);
    _$hash = $jc(_$hash, lastOnlineAt.hashCode);
    _$hash = $jc(_$hash, reportedState.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, buttons.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BaseOut')
          ..add('id', id)
          ..add('serialNumber', serialNumber)
          ..add('name', name)
          ..add('defaultPusherId', defaultPusherId)
          ..add('groupWindowSeconds', groupWindowSeconds)
          ..add('fwVersion', fwVersion)
          ..add('batteryLevel', batteryLevel)
          ..add('batteryUpdatedAt', batteryUpdatedAt)
          ..add('lastOnlineAt', lastOnlineAt)
          ..add('reportedState', reportedState)
          ..add('createdAt', createdAt)
          ..add('buttons', buttons))
        .toString();
  }
}

class BaseOutBuilder implements Builder<BaseOut, BaseOutBuilder> {
  _$BaseOut? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _serialNumber;
  String? get serialNumber => _$this._serialNumber;
  set serialNumber(String? serialNumber) => _$this._serialNumber = serialNumber;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _defaultPusherId;
  int? get defaultPusherId => _$this._defaultPusherId;
  set defaultPusherId(int? defaultPusherId) =>
      _$this._defaultPusherId = defaultPusherId;

  int? _groupWindowSeconds;
  int? get groupWindowSeconds => _$this._groupWindowSeconds;
  set groupWindowSeconds(int? groupWindowSeconds) =>
      _$this._groupWindowSeconds = groupWindowSeconds;

  String? _fwVersion;
  String? get fwVersion => _$this._fwVersion;
  set fwVersion(String? fwVersion) => _$this._fwVersion = fwVersion;

  int? _batteryLevel;
  int? get batteryLevel => _$this._batteryLevel;
  set batteryLevel(int? batteryLevel) => _$this._batteryLevel = batteryLevel;

  DateTime? _batteryUpdatedAt;
  DateTime? get batteryUpdatedAt => _$this._batteryUpdatedAt;
  set batteryUpdatedAt(DateTime? batteryUpdatedAt) =>
      _$this._batteryUpdatedAt = batteryUpdatedAt;

  DateTime? _lastOnlineAt;
  DateTime? get lastOnlineAt => _$this._lastOnlineAt;
  set lastOnlineAt(DateTime? lastOnlineAt) =>
      _$this._lastOnlineAt = lastOnlineAt;

  MapBuilder<String, JsonObject?>? _reportedState;
  MapBuilder<String, JsonObject?> get reportedState =>
      _$this._reportedState ??= MapBuilder<String, JsonObject?>();
  set reportedState(MapBuilder<String, JsonObject?>? reportedState) =>
      _$this._reportedState = reportedState;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ListBuilder<LinkedButtonOut>? _buttons;
  ListBuilder<LinkedButtonOut> get buttons =>
      _$this._buttons ??= ListBuilder<LinkedButtonOut>();
  set buttons(ListBuilder<LinkedButtonOut>? buttons) =>
      _$this._buttons = buttons;

  BaseOutBuilder() {
    BaseOut._defaults(this);
  }

  BaseOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _serialNumber = $v.serialNumber;
      _name = $v.name;
      _defaultPusherId = $v.defaultPusherId;
      _groupWindowSeconds = $v.groupWindowSeconds;
      _fwVersion = $v.fwVersion;
      _batteryLevel = $v.batteryLevel;
      _batteryUpdatedAt = $v.batteryUpdatedAt;
      _lastOnlineAt = $v.lastOnlineAt;
      _reportedState = $v.reportedState?.toBuilder();
      _createdAt = $v.createdAt;
      _buttons = $v.buttons.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BaseOut other) {
    _$v = other as _$BaseOut;
  }

  @override
  void update(void Function(BaseOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BaseOut build() => _build();

  _$BaseOut _build() {
    _$BaseOut _$result;
    try {
      _$result = _$v ??
          _$BaseOut._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'BaseOut', 'id'),
            serialNumber: BuiltValueNullFieldError.checkNotNull(
                serialNumber, r'BaseOut', 'serialNumber'),
            name: name,
            defaultPusherId: defaultPusherId,
            groupWindowSeconds: BuiltValueNullFieldError.checkNotNull(
                groupWindowSeconds, r'BaseOut', 'groupWindowSeconds'),
            fwVersion: fwVersion,
            batteryLevel: batteryLevel,
            batteryUpdatedAt: batteryUpdatedAt,
            lastOnlineAt: lastOnlineAt,
            reportedState: _reportedState?.build(),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'BaseOut', 'createdAt'),
            buttons: buttons.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reportedState';
        _reportedState?.build();

        _$failedField = 'buttons';
        buttons.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BaseOut', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
