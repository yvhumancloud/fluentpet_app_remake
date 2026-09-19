// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_count.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TextCount extends TextCount {
  @override
  final String text;
  @override
  final int count;

  factory _$TextCount([void Function(TextCountBuilder)? updates]) =>
      (TextCountBuilder()..update(updates))._build();

  _$TextCount._({required this.text, required this.count}) : super._();
  @override
  TextCount rebuild(void Function(TextCountBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TextCountBuilder toBuilder() => TextCountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TextCount && text == other.text && count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TextCount')
          ..add('text', text)
          ..add('count', count))
        .toString();
  }
}

class TextCountBuilder implements Builder<TextCount, TextCountBuilder> {
  _$TextCount? _$v;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  TextCountBuilder() {
    TextCount._defaults(this);
  }

  TextCountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _text = $v.text;
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TextCount other) {
    _$v = other as _$TextCount;
  }

  @override
  void update(void Function(TextCountBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TextCount build() => _build();

  _$TextCount _build() {
    final _$result = _$v ??
        _$TextCount._(
          text:
              BuiltValueNullFieldError.checkNotNull(text, r'TextCount', 'text'),
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'TextCount', 'count'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
