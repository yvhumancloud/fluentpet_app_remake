// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button_ref.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ButtonRef extends ButtonRef {
  @override
  final int id;
  @override
  final String text;

  factory _$ButtonRef([void Function(ButtonRefBuilder)? updates]) =>
      (ButtonRefBuilder()..update(updates))._build();

  _$ButtonRef._({required this.id, required this.text}) : super._();
  @override
  ButtonRef rebuild(void Function(ButtonRefBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ButtonRefBuilder toBuilder() => ButtonRefBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ButtonRef && id == other.id && text == other.text;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ButtonRef')
          ..add('id', id)
          ..add('text', text))
        .toString();
  }
}

class ButtonRefBuilder implements Builder<ButtonRef, ButtonRefBuilder> {
  _$ButtonRef? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  ButtonRefBuilder() {
    ButtonRef._defaults(this);
  }

  ButtonRefBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _text = $v.text;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ButtonRef other) {
    _$v = other as _$ButtonRef;
  }

  @override
  void update(void Function(ButtonRefBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ButtonRef build() => _build();

  _$ButtonRef _build() {
    final _$result = _$v ??
        _$ButtonRef._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ButtonRef', 'id'),
          text:
              BuiltValueNullFieldError.checkNotNull(text, r'ButtonRef', 'text'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
