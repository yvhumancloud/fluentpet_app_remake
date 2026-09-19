// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'url_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UrlOut extends UrlOut {
  @override
  final String url;

  factory _$UrlOut([void Function(UrlOutBuilder)? updates]) =>
      (UrlOutBuilder()..update(updates))._build();

  _$UrlOut._({required this.url}) : super._();
  @override
  UrlOut rebuild(void Function(UrlOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UrlOutBuilder toBuilder() => UrlOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UrlOut && url == other.url;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UrlOut')..add('url', url)).toString();
  }
}

class UrlOutBuilder implements Builder<UrlOut, UrlOutBuilder> {
  _$UrlOut? _$v;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  UrlOutBuilder() {
    UrlOut._defaults(this);
  }

  UrlOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _url = $v.url;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UrlOut other) {
    _$v = other as _$UrlOut;
  }

  @override
  void update(void Function(UrlOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UrlOut build() => _build();

  _$UrlOut _build() {
    final _$result = _$v ??
        _$UrlOut._(
          url: BuiltValueNullFieldError.checkNotNull(url, r'UrlOut', 'url'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
