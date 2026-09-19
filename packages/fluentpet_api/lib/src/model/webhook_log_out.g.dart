// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webhook_log_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WebhookLogOut extends WebhookLogOut {
  @override
  final int id;
  @override
  final String url;
  @override
  final int? statusCode;
  @override
  final DateTime requestedAt;
  @override
  final DateTime? respondedAt;

  factory _$WebhookLogOut([void Function(WebhookLogOutBuilder)? updates]) =>
      (WebhookLogOutBuilder()..update(updates))._build();

  _$WebhookLogOut._(
      {required this.id,
      required this.url,
      this.statusCode,
      required this.requestedAt,
      this.respondedAt})
      : super._();
  @override
  WebhookLogOut rebuild(void Function(WebhookLogOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WebhookLogOutBuilder toBuilder() => WebhookLogOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WebhookLogOut &&
        id == other.id &&
        url == other.url &&
        statusCode == other.statusCode &&
        requestedAt == other.requestedAt &&
        respondedAt == other.respondedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, statusCode.hashCode);
    _$hash = $jc(_$hash, requestedAt.hashCode);
    _$hash = $jc(_$hash, respondedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WebhookLogOut')
          ..add('id', id)
          ..add('url', url)
          ..add('statusCode', statusCode)
          ..add('requestedAt', requestedAt)
          ..add('respondedAt', respondedAt))
        .toString();
  }
}

class WebhookLogOutBuilder
    implements Builder<WebhookLogOut, WebhookLogOutBuilder> {
  _$WebhookLogOut? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  int? _statusCode;
  int? get statusCode => _$this._statusCode;
  set statusCode(int? statusCode) => _$this._statusCode = statusCode;

  DateTime? _requestedAt;
  DateTime? get requestedAt => _$this._requestedAt;
  set requestedAt(DateTime? requestedAt) => _$this._requestedAt = requestedAt;

  DateTime? _respondedAt;
  DateTime? get respondedAt => _$this._respondedAt;
  set respondedAt(DateTime? respondedAt) => _$this._respondedAt = respondedAt;

  WebhookLogOutBuilder() {
    WebhookLogOut._defaults(this);
  }

  WebhookLogOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _url = $v.url;
      _statusCode = $v.statusCode;
      _requestedAt = $v.requestedAt;
      _respondedAt = $v.respondedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WebhookLogOut other) {
    _$v = other as _$WebhookLogOut;
  }

  @override
  void update(void Function(WebhookLogOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WebhookLogOut build() => _build();

  _$WebhookLogOut _build() {
    final _$result = _$v ??
        _$WebhookLogOut._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'WebhookLogOut', 'id'),
          url: BuiltValueNullFieldError.checkNotNull(
              url, r'WebhookLogOut', 'url'),
          statusCode: statusCode,
          requestedAt: BuiltValueNullFieldError.checkNotNull(
              requestedAt, r'WebhookLogOut', 'requestedAt'),
          respondedAt: respondedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
