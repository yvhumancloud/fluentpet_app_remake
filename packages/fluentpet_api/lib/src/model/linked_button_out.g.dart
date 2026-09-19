// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'linked_button_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LinkedButtonOut extends LinkedButtonOut {
  @override
  final int id;
  @override
  final int baseId;
  @override
  final String buttonSerialNumber;
  @override
  final int? batteryLevel;
  @override
  final DateTime? batteryUpdatedAt;
  @override
  final DateTime? lastOnlineAt;
  @override
  final int? desiredAudioId;
  @override
  final bool desiredDeleted;
  @override
  final int desiredVersion;
  @override
  final int appliedVersion;
  @override
  final int buttonId;
  @override
  final String text;

  factory _$LinkedButtonOut([void Function(LinkedButtonOutBuilder)? updates]) =>
      (LinkedButtonOutBuilder()..update(updates))._build();

  _$LinkedButtonOut._(
      {required this.id,
      required this.baseId,
      required this.buttonSerialNumber,
      this.batteryLevel,
      this.batteryUpdatedAt,
      this.lastOnlineAt,
      this.desiredAudioId,
      required this.desiredDeleted,
      required this.desiredVersion,
      required this.appliedVersion,
      required this.buttonId,
      required this.text})
      : super._();
  @override
  LinkedButtonOut rebuild(void Function(LinkedButtonOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LinkedButtonOutBuilder toBuilder() => LinkedButtonOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LinkedButtonOut &&
        id == other.id &&
        baseId == other.baseId &&
        buttonSerialNumber == other.buttonSerialNumber &&
        batteryLevel == other.batteryLevel &&
        batteryUpdatedAt == other.batteryUpdatedAt &&
        lastOnlineAt == other.lastOnlineAt &&
        desiredAudioId == other.desiredAudioId &&
        desiredDeleted == other.desiredDeleted &&
        desiredVersion == other.desiredVersion &&
        appliedVersion == other.appliedVersion &&
        buttonId == other.buttonId &&
        text == other.text;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, baseId.hashCode);
    _$hash = $jc(_$hash, buttonSerialNumber.hashCode);
    _$hash = $jc(_$hash, batteryLevel.hashCode);
    _$hash = $jc(_$hash, batteryUpdatedAt.hashCode);
    _$hash = $jc(_$hash, lastOnlineAt.hashCode);
    _$hash = $jc(_$hash, desiredAudioId.hashCode);
    _$hash = $jc(_$hash, desiredDeleted.hashCode);
    _$hash = $jc(_$hash, desiredVersion.hashCode);
    _$hash = $jc(_$hash, appliedVersion.hashCode);
    _$hash = $jc(_$hash, buttonId.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LinkedButtonOut')
          ..add('id', id)
          ..add('baseId', baseId)
          ..add('buttonSerialNumber', buttonSerialNumber)
          ..add('batteryLevel', batteryLevel)
          ..add('batteryUpdatedAt', batteryUpdatedAt)
          ..add('lastOnlineAt', lastOnlineAt)
          ..add('desiredAudioId', desiredAudioId)
          ..add('desiredDeleted', desiredDeleted)
          ..add('desiredVersion', desiredVersion)
          ..add('appliedVersion', appliedVersion)
          ..add('buttonId', buttonId)
          ..add('text', text))
        .toString();
  }
}

class LinkedButtonOutBuilder
    implements Builder<LinkedButtonOut, LinkedButtonOutBuilder> {
  _$LinkedButtonOut? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _baseId;
  int? get baseId => _$this._baseId;
  set baseId(int? baseId) => _$this._baseId = baseId;

  String? _buttonSerialNumber;
  String? get buttonSerialNumber => _$this._buttonSerialNumber;
  set buttonSerialNumber(String? buttonSerialNumber) =>
      _$this._buttonSerialNumber = buttonSerialNumber;

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

  int? _desiredAudioId;
  int? get desiredAudioId => _$this._desiredAudioId;
  set desiredAudioId(int? desiredAudioId) =>
      _$this._desiredAudioId = desiredAudioId;

  bool? _desiredDeleted;
  bool? get desiredDeleted => _$this._desiredDeleted;
  set desiredDeleted(bool? desiredDeleted) =>
      _$this._desiredDeleted = desiredDeleted;

  int? _desiredVersion;
  int? get desiredVersion => _$this._desiredVersion;
  set desiredVersion(int? desiredVersion) =>
      _$this._desiredVersion = desiredVersion;

  int? _appliedVersion;
  int? get appliedVersion => _$this._appliedVersion;
  set appliedVersion(int? appliedVersion) =>
      _$this._appliedVersion = appliedVersion;

  int? _buttonId;
  int? get buttonId => _$this._buttonId;
  set buttonId(int? buttonId) => _$this._buttonId = buttonId;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  LinkedButtonOutBuilder() {
    LinkedButtonOut._defaults(this);
  }

  LinkedButtonOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _baseId = $v.baseId;
      _buttonSerialNumber = $v.buttonSerialNumber;
      _batteryLevel = $v.batteryLevel;
      _batteryUpdatedAt = $v.batteryUpdatedAt;
      _lastOnlineAt = $v.lastOnlineAt;
      _desiredAudioId = $v.desiredAudioId;
      _desiredDeleted = $v.desiredDeleted;
      _desiredVersion = $v.desiredVersion;
      _appliedVersion = $v.appliedVersion;
      _buttonId = $v.buttonId;
      _text = $v.text;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LinkedButtonOut other) {
    _$v = other as _$LinkedButtonOut;
  }

  @override
  void update(void Function(LinkedButtonOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LinkedButtonOut build() => _build();

  _$LinkedButtonOut _build() {
    final _$result = _$v ??
        _$LinkedButtonOut._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'LinkedButtonOut', 'id'),
          baseId: BuiltValueNullFieldError.checkNotNull(
              baseId, r'LinkedButtonOut', 'baseId'),
          buttonSerialNumber: BuiltValueNullFieldError.checkNotNull(
              buttonSerialNumber, r'LinkedButtonOut', 'buttonSerialNumber'),
          batteryLevel: batteryLevel,
          batteryUpdatedAt: batteryUpdatedAt,
          lastOnlineAt: lastOnlineAt,
          desiredAudioId: desiredAudioId,
          desiredDeleted: BuiltValueNullFieldError.checkNotNull(
              desiredDeleted, r'LinkedButtonOut', 'desiredDeleted'),
          desiredVersion: BuiltValueNullFieldError.checkNotNull(
              desiredVersion, r'LinkedButtonOut', 'desiredVersion'),
          appliedVersion: BuiltValueNullFieldError.checkNotNull(
              appliedVersion, r'LinkedButtonOut', 'appliedVersion'),
          buttonId: BuiltValueNullFieldError.checkNotNull(
              buttonId, r'LinkedButtonOut', 'buttonId'),
          text: BuiltValueNullFieldError.checkNotNull(
              text, r'LinkedButtonOut', 'text'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
