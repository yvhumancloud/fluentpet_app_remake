// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BaseCreate extends BaseCreate {
  @override
  final String serialNumber;
  @override
  final String name;

  factory _$BaseCreate([void Function(BaseCreateBuilder)? updates]) =>
      (BaseCreateBuilder()..update(updates))._build();

  _$BaseCreate._({required this.serialNumber, required this.name}) : super._();
  @override
  BaseCreate rebuild(void Function(BaseCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BaseCreateBuilder toBuilder() => BaseCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BaseCreate &&
        serialNumber == other.serialNumber &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, serialNumber.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BaseCreate')
          ..add('serialNumber', serialNumber)
          ..add('name', name))
        .toString();
  }
}

class BaseCreateBuilder implements Builder<BaseCreate, BaseCreateBuilder> {
  _$BaseCreate? _$v;

  String? _serialNumber;
  String? get serialNumber => _$this._serialNumber;
  set serialNumber(String? serialNumber) => _$this._serialNumber = serialNumber;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  BaseCreateBuilder() {
    BaseCreate._defaults(this);
  }

  BaseCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _serialNumber = $v.serialNumber;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BaseCreate other) {
    _$v = other as _$BaseCreate;
  }

  @override
  void update(void Function(BaseCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BaseCreate build() => _build();

  _$BaseCreate _build() {
    final _$result = _$v ??
        _$BaseCreate._(
          serialNumber: BuiltValueNullFieldError.checkNotNull(
              serialNumber, r'BaseCreate', 'serialNumber'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'BaseCreate', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
