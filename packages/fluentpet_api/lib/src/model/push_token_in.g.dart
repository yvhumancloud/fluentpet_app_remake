// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_token_in.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PushTokenIn extends PushTokenIn {
  @override
  final String token;
  @override
  final String? platform;

  factory _$PushTokenIn([void Function(PushTokenInBuilder)? updates]) =>
      (PushTokenInBuilder()..update(updates))._build();

  _$PushTokenIn._({required this.token, this.platform}) : super._();
  @override
  PushTokenIn rebuild(void Function(PushTokenInBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PushTokenInBuilder toBuilder() => PushTokenInBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PushTokenIn &&
        token == other.token &&
        platform == other.platform;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jc(_$hash, platform.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PushTokenIn')
          ..add('token', token)
          ..add('platform', platform))
        .toString();
  }
}

class PushTokenInBuilder implements Builder<PushTokenIn, PushTokenInBuilder> {
  _$PushTokenIn? _$v;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  String? _platform;
  String? get platform => _$this._platform;
  set platform(String? platform) => _$this._platform = platform;

  PushTokenInBuilder() {
    PushTokenIn._defaults(this);
  }

  PushTokenInBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _token = $v.token;
      _platform = $v.platform;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PushTokenIn other) {
    _$v = other as _$PushTokenIn;
  }

  @override
  void update(void Function(PushTokenInBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PushTokenIn build() => _build();

  _$PushTokenIn _build() {
    final _$result = _$v ??
        _$PushTokenIn._(
          token: BuiltValueNullFieldError.checkNotNull(
              token, r'PushTokenIn', 'token'),
          platform: platform,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
