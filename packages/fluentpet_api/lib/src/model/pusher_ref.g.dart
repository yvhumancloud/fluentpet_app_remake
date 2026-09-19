// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pusher_ref.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PusherRef extends PusherRef {
  @override
  final int id;
  @override
  final String name;

  factory _$PusherRef([void Function(PusherRefBuilder)? updates]) =>
      (PusherRefBuilder()..update(updates))._build();

  _$PusherRef._({required this.id, required this.name}) : super._();
  @override
  PusherRef rebuild(void Function(PusherRefBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PusherRefBuilder toBuilder() => PusherRefBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PusherRef && id == other.id && name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PusherRef')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class PusherRefBuilder implements Builder<PusherRef, PusherRefBuilder> {
  _$PusherRef? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  PusherRefBuilder() {
    PusherRef._defaults(this);
  }

  PusherRefBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PusherRef other) {
    _$v = other as _$PusherRef;
  }

  @override
  void update(void Function(PusherRefBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PusherRef build() => _build();

  _$PusherRef _build() {
    final _$result = _$v ??
        _$PusherRef._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'PusherRef', 'id'),
          name:
              BuiltValueNullFieldError.checkNotNull(name, r'PusherRef', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
