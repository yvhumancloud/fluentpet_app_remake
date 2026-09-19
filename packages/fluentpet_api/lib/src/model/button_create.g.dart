// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ButtonCreate extends ButtonCreate {
  @override
  final String text;
  @override
  final String? note;
  @override
  final Date? introducedAt;
  @override
  final int? buttonConceptId;

  factory _$ButtonCreate([void Function(ButtonCreateBuilder)? updates]) =>
      (ButtonCreateBuilder()..update(updates))._build();

  _$ButtonCreate._(
      {required this.text, this.note, this.introducedAt, this.buttonConceptId})
      : super._();
  @override
  ButtonCreate rebuild(void Function(ButtonCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ButtonCreateBuilder toBuilder() => ButtonCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ButtonCreate &&
        text == other.text &&
        note == other.note &&
        introducedAt == other.introducedAt &&
        buttonConceptId == other.buttonConceptId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, introducedAt.hashCode);
    _$hash = $jc(_$hash, buttonConceptId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ButtonCreate')
          ..add('text', text)
          ..add('note', note)
          ..add('introducedAt', introducedAt)
          ..add('buttonConceptId', buttonConceptId))
        .toString();
  }
}

class ButtonCreateBuilder
    implements Builder<ButtonCreate, ButtonCreateBuilder> {
  _$ButtonCreate? _$v;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  Date? _introducedAt;
  Date? get introducedAt => _$this._introducedAt;
  set introducedAt(Date? introducedAt) => _$this._introducedAt = introducedAt;

  int? _buttonConceptId;
  int? get buttonConceptId => _$this._buttonConceptId;
  set buttonConceptId(int? buttonConceptId) =>
      _$this._buttonConceptId = buttonConceptId;

  ButtonCreateBuilder() {
    ButtonCreate._defaults(this);
  }

  ButtonCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _text = $v.text;
      _note = $v.note;
      _introducedAt = $v.introducedAt;
      _buttonConceptId = $v.buttonConceptId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ButtonCreate other) {
    _$v = other as _$ButtonCreate;
  }

  @override
  void update(void Function(ButtonCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ButtonCreate build() => _build();

  _$ButtonCreate _build() {
    final _$result = _$v ??
        _$ButtonCreate._(
          text: BuiltValueNullFieldError.checkNotNull(
              text, r'ButtonCreate', 'text'),
          note: note,
          introducedAt: introducedAt,
          buttonConceptId: buttonConceptId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
