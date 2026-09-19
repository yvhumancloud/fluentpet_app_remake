// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_patch.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BasePatch extends BasePatch {
  @override
  final String? name;
  @override
  final int? defaultPusherId;
  @override
  final int? groupWindowSeconds;

  factory _$BasePatch([void Function(BasePatchBuilder)? updates]) =>
      (BasePatchBuilder()..update(updates))._build();

  _$BasePatch._({this.name, this.defaultPusherId, this.groupWindowSeconds})
      : super._();
  @override
  BasePatch rebuild(void Function(BasePatchBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BasePatchBuilder toBuilder() => BasePatchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BasePatch &&
        name == other.name &&
        defaultPusherId == other.defaultPusherId &&
        groupWindowSeconds == other.groupWindowSeconds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, defaultPusherId.hashCode);
    _$hash = $jc(_$hash, groupWindowSeconds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BasePatch')
          ..add('name', name)
          ..add('defaultPusherId', defaultPusherId)
          ..add('groupWindowSeconds', groupWindowSeconds))
        .toString();
  }
}

class BasePatchBuilder implements Builder<BasePatch, BasePatchBuilder> {
  _$BasePatch? _$v;

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

  BasePatchBuilder() {
    BasePatch._defaults(this);
  }

  BasePatchBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _defaultPusherId = $v.defaultPusherId;
      _groupWindowSeconds = $v.groupWindowSeconds;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BasePatch other) {
    _$v = other as _$BasePatch;
  }

  @override
  void update(void Function(BasePatchBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BasePatch build() => _build();

  _$BasePatch _build() {
    final _$result = _$v ??
        _$BasePatch._(
          name: name,
          defaultPusherId: defaultPusherId,
          groupWindowSeconds: groupWindowSeconds,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
