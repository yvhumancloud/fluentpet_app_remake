// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'household_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$HouseholdOut extends HouseholdOut {
  @override
  final int id;
  @override
  final String name;

  factory _$HouseholdOut([void Function(HouseholdOutBuilder)? updates]) =>
      (HouseholdOutBuilder()..update(updates))._build();

  _$HouseholdOut._({required this.id, required this.name}) : super._();
  @override
  HouseholdOut rebuild(void Function(HouseholdOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HouseholdOutBuilder toBuilder() => HouseholdOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HouseholdOut && id == other.id && name == other.name;
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
    return (newBuiltValueToStringHelper(r'HouseholdOut')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class HouseholdOutBuilder
    implements Builder<HouseholdOut, HouseholdOutBuilder> {
  _$HouseholdOut? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  HouseholdOutBuilder() {
    HouseholdOut._defaults(this);
  }

  HouseholdOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HouseholdOut other) {
    _$v = other as _$HouseholdOut;
  }

  @override
  void update(void Function(HouseholdOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HouseholdOut build() => _build();

  _$HouseholdOut _build() {
    final _$result = _$v ??
        _$HouseholdOut._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'HouseholdOut', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'HouseholdOut', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
