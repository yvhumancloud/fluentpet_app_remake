// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preference_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PreferenceOut extends PreferenceOut {
  @override
  final String key;
  @override
  final JsonObject? value;

  factory _$PreferenceOut([void Function(PreferenceOutBuilder)? updates]) =>
      (PreferenceOutBuilder()..update(updates))._build();

  _$PreferenceOut._({required this.key, this.value}) : super._();
  @override
  PreferenceOut rebuild(void Function(PreferenceOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PreferenceOutBuilder toBuilder() => PreferenceOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PreferenceOut && key == other.key && value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PreferenceOut')
          ..add('key', key)
          ..add('value', value))
        .toString();
  }
}

class PreferenceOutBuilder
    implements Builder<PreferenceOut, PreferenceOutBuilder> {
  _$PreferenceOut? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  JsonObject? _value;
  JsonObject? get value => _$this._value;
  set value(JsonObject? value) => _$this._value = value;

  PreferenceOutBuilder() {
    PreferenceOut._defaults(this);
  }

  PreferenceOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _value = $v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PreferenceOut other) {
    _$v = other as _$PreferenceOut;
  }

  @override
  void update(void Function(PreferenceOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PreferenceOut build() => _build();

  _$PreferenceOut _build() {
    final _$result = _$v ??
        _$PreferenceOut._(
          key: BuiltValueNullFieldError.checkNotNull(
              key, r'PreferenceOut', 'key'),
          value: value,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
