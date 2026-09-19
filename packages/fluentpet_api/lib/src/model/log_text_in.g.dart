// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_text_in.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LogTextIn extends LogTextIn {
  @override
  final String text;

  factory _$LogTextIn([void Function(LogTextInBuilder)? updates]) =>
      (LogTextInBuilder()..update(updates))._build();

  _$LogTextIn._({required this.text}) : super._();
  @override
  LogTextIn rebuild(void Function(LogTextInBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LogTextInBuilder toBuilder() => LogTextInBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LogTextIn && text == other.text;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LogTextIn')..add('text', text))
        .toString();
  }
}

class LogTextInBuilder implements Builder<LogTextIn, LogTextInBuilder> {
  _$LogTextIn? _$v;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  LogTextInBuilder() {
    LogTextIn._defaults(this);
  }

  LogTextInBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _text = $v.text;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LogTextIn other) {
    _$v = other as _$LogTextIn;
  }

  @override
  void update(void Function(LogTextInBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LogTextIn build() => _build();

  _$LogTextIn _build() {
    final _$result = _$v ??
        _$LogTextIn._(
          text:
              BuiltValueNullFieldError.checkNotNull(text, r'LogTextIn', 'text'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
