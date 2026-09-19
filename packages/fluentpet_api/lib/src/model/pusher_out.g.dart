// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pusher_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PusherOut extends PusherOut {
  @override
  final int id;
  @override
  final String name;
  @override
  final bool isHuman;
  @override
  final bool isHidden;
  @override
  final String? avatarUrl;

  factory _$PusherOut([void Function(PusherOutBuilder)? updates]) =>
      (PusherOutBuilder()..update(updates))._build();

  _$PusherOut._(
      {required this.id,
      required this.name,
      required this.isHuman,
      required this.isHidden,
      this.avatarUrl})
      : super._();
  @override
  PusherOut rebuild(void Function(PusherOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PusherOutBuilder toBuilder() => PusherOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PusherOut &&
        id == other.id &&
        name == other.name &&
        isHuman == other.isHuman &&
        isHidden == other.isHidden &&
        avatarUrl == other.avatarUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, isHuman.hashCode);
    _$hash = $jc(_$hash, isHidden.hashCode);
    _$hash = $jc(_$hash, avatarUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PusherOut')
          ..add('id', id)
          ..add('name', name)
          ..add('isHuman', isHuman)
          ..add('isHidden', isHidden)
          ..add('avatarUrl', avatarUrl))
        .toString();
  }
}

class PusherOutBuilder implements Builder<PusherOut, PusherOutBuilder> {
  _$PusherOut? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  bool? _isHuman;
  bool? get isHuman => _$this._isHuman;
  set isHuman(bool? isHuman) => _$this._isHuman = isHuman;

  bool? _isHidden;
  bool? get isHidden => _$this._isHidden;
  set isHidden(bool? isHidden) => _$this._isHidden = isHidden;

  String? _avatarUrl;
  String? get avatarUrl => _$this._avatarUrl;
  set avatarUrl(String? avatarUrl) => _$this._avatarUrl = avatarUrl;

  PusherOutBuilder() {
    PusherOut._defaults(this);
  }

  PusherOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _isHuman = $v.isHuman;
      _isHidden = $v.isHidden;
      _avatarUrl = $v.avatarUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PusherOut other) {
    _$v = other as _$PusherOut;
  }

  @override
  void update(void Function(PusherOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PusherOut build() => _build();

  _$PusherOut _build() {
    final _$result = _$v ??
        _$PusherOut._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'PusherOut', 'id'),
          name:
              BuiltValueNullFieldError.checkNotNull(name, r'PusherOut', 'name'),
          isHuman: BuiltValueNullFieldError.checkNotNull(
              isHuman, r'PusherOut', 'isHuman'),
          isHidden: BuiltValueNullFieldError.checkNotNull(
              isHidden, r'PusherOut', 'isHidden'),
          avatarUrl: avatarUrl,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
