// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AudioOut extends AudioOut {
  @override
  final int id;
  @override
  final int householdId;
  @override
  final String name;
  @override
  final int crc32;
  @override
  final int byteSize;
  @override
  final DateTime createdAt;

  factory _$AudioOut([void Function(AudioOutBuilder)? updates]) =>
      (AudioOutBuilder()..update(updates))._build();

  _$AudioOut._(
      {required this.id,
      required this.householdId,
      required this.name,
      required this.crc32,
      required this.byteSize,
      required this.createdAt})
      : super._();
  @override
  AudioOut rebuild(void Function(AudioOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AudioOutBuilder toBuilder() => AudioOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AudioOut &&
        id == other.id &&
        householdId == other.householdId &&
        name == other.name &&
        crc32 == other.crc32 &&
        byteSize == other.byteSize &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, householdId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, crc32.hashCode);
    _$hash = $jc(_$hash, byteSize.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AudioOut')
          ..add('id', id)
          ..add('householdId', householdId)
          ..add('name', name)
          ..add('crc32', crc32)
          ..add('byteSize', byteSize)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class AudioOutBuilder implements Builder<AudioOut, AudioOutBuilder> {
  _$AudioOut? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _householdId;
  int? get householdId => _$this._householdId;
  set householdId(int? householdId) => _$this._householdId = householdId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _crc32;
  int? get crc32 => _$this._crc32;
  set crc32(int? crc32) => _$this._crc32 = crc32;

  int? _byteSize;
  int? get byteSize => _$this._byteSize;
  set byteSize(int? byteSize) => _$this._byteSize = byteSize;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  AudioOutBuilder() {
    AudioOut._defaults(this);
  }

  AudioOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _householdId = $v.householdId;
      _name = $v.name;
      _crc32 = $v.crc32;
      _byteSize = $v.byteSize;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AudioOut other) {
    _$v = other as _$AudioOut;
  }

  @override
  void update(void Function(AudioOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AudioOut build() => _build();

  _$AudioOut _build() {
    final _$result = _$v ??
        _$AudioOut._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'AudioOut', 'id'),
          householdId: BuiltValueNullFieldError.checkNotNull(
              householdId, r'AudioOut', 'householdId'),
          name:
              BuiltValueNullFieldError.checkNotNull(name, r'AudioOut', 'name'),
          crc32: BuiltValueNullFieldError.checkNotNull(
              crc32, r'AudioOut', 'crc32'),
          byteSize: BuiltValueNullFieldError.checkNotNull(
              byteSize, r'AudioOut', 'byteSize'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'AudioOut', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
