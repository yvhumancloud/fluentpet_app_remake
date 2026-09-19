// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preference_in.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PreferenceIn extends PreferenceIn {
  @override
  final JsonObject? value;

  factory _$PreferenceIn([void Function(PreferenceInBuilder)? updates]) =>
      (PreferenceInBuilder()..update(updates))._build();

  _$PreferenceIn._({this.value}) : super._();
  @override
  PreferenceIn rebuild(void Function(PreferenceInBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PreferenceInBuilder toBuilder() => PreferenceInBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PreferenceIn && value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PreferenceIn')..add('value', value))
        .toString();
  }
}

class PreferenceInBuilder
    implements Builder<PreferenceIn, PreferenceInBuilder> {
  _$PreferenceIn? _$v;

  JsonObject? _value;
  JsonObject? get value => _$this._value;
  set value(JsonObject? value) => _$this._value = value;

  PreferenceInBuilder() {
    PreferenceIn._defaults(this);
  }

  PreferenceInBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _value = $v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PreferenceIn other) {
    _$v = other as _$PreferenceIn;
  }

  @override
  void update(void Function(PreferenceInBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PreferenceIn build() => _build();

  _$PreferenceIn _build() {
    final _$result = _$v ??
        _$PreferenceIn._(
          value: value,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
