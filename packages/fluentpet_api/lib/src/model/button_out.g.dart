// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ButtonOut extends ButtonOut {
  @override
  final int id;
  @override
  final String text;
  @override
  final String word;
  @override
  final String normalizedWord;
  @override
  final Date? introducedAt;
  @override
  final int? buttonConceptId;
  @override
  final bool isHidden;
  @override
  final String? note;
  @override
  final String origin;
  @override
  final int? audioId;
  @override
  final String? webhookUrl;
  @override
  final DateTime createdAt;
  @override
  final BaseButtonOut? baseButton;
  @override
  final int pressCount;

  factory _$ButtonOut([void Function(ButtonOutBuilder)? updates]) =>
      (ButtonOutBuilder()..update(updates))._build();

  _$ButtonOut._(
      {required this.id,
      required this.text,
      required this.word,
      required this.normalizedWord,
      this.introducedAt,
      this.buttonConceptId,
      required this.isHidden,
      this.note,
      required this.origin,
      this.audioId,
      this.webhookUrl,
      required this.createdAt,
      this.baseButton,
      required this.pressCount})
      : super._();
  @override
  ButtonOut rebuild(void Function(ButtonOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ButtonOutBuilder toBuilder() => ButtonOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ButtonOut &&
        id == other.id &&
        text == other.text &&
        word == other.word &&
        normalizedWord == other.normalizedWord &&
        introducedAt == other.introducedAt &&
        buttonConceptId == other.buttonConceptId &&
        isHidden == other.isHidden &&
        note == other.note &&
        origin == other.origin &&
        audioId == other.audioId &&
        webhookUrl == other.webhookUrl &&
        createdAt == other.createdAt &&
        baseButton == other.baseButton &&
        pressCount == other.pressCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, word.hashCode);
    _$hash = $jc(_$hash, normalizedWord.hashCode);
    _$hash = $jc(_$hash, introducedAt.hashCode);
    _$hash = $jc(_$hash, buttonConceptId.hashCode);
    _$hash = $jc(_$hash, isHidden.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, origin.hashCode);
    _$hash = $jc(_$hash, audioId.hashCode);
    _$hash = $jc(_$hash, webhookUrl.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, baseButton.hashCode);
    _$hash = $jc(_$hash, pressCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ButtonOut')
          ..add('id', id)
          ..add('text', text)
          ..add('word', word)
          ..add('normalizedWord', normalizedWord)
          ..add('introducedAt', introducedAt)
          ..add('buttonConceptId', buttonConceptId)
          ..add('isHidden', isHidden)
          ..add('note', note)
          ..add('origin', origin)
          ..add('audioId', audioId)
          ..add('webhookUrl', webhookUrl)
          ..add('createdAt', createdAt)
          ..add('baseButton', baseButton)
          ..add('pressCount', pressCount))
        .toString();
  }
}

class ButtonOutBuilder implements Builder<ButtonOut, ButtonOutBuilder> {
  _$ButtonOut? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  String? _word;
  String? get word => _$this._word;
  set word(String? word) => _$this._word = word;

  String? _normalizedWord;
  String? get normalizedWord => _$this._normalizedWord;
  set normalizedWord(String? normalizedWord) =>
      _$this._normalizedWord = normalizedWord;

  Date? _introducedAt;
  Date? get introducedAt => _$this._introducedAt;
  set introducedAt(Date? introducedAt) => _$this._introducedAt = introducedAt;

  int? _buttonConceptId;
  int? get buttonConceptId => _$this._buttonConceptId;
  set buttonConceptId(int? buttonConceptId) =>
      _$this._buttonConceptId = buttonConceptId;

  bool? _isHidden;
  bool? get isHidden => _$this._isHidden;
  set isHidden(bool? isHidden) => _$this._isHidden = isHidden;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  String? _origin;
  String? get origin => _$this._origin;
  set origin(String? origin) => _$this._origin = origin;

  int? _audioId;
  int? get audioId => _$this._audioId;
  set audioId(int? audioId) => _$this._audioId = audioId;

  String? _webhookUrl;
  String? get webhookUrl => _$this._webhookUrl;
  set webhookUrl(String? webhookUrl) => _$this._webhookUrl = webhookUrl;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  BaseButtonOutBuilder? _baseButton;
  BaseButtonOutBuilder get baseButton =>
      _$this._baseButton ??= BaseButtonOutBuilder();
  set baseButton(BaseButtonOutBuilder? baseButton) =>
      _$this._baseButton = baseButton;

  int? _pressCount;
  int? get pressCount => _$this._pressCount;
  set pressCount(int? pressCount) => _$this._pressCount = pressCount;

  ButtonOutBuilder() {
    ButtonOut._defaults(this);
  }

  ButtonOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _text = $v.text;
      _word = $v.word;
      _normalizedWord = $v.normalizedWord;
      _introducedAt = $v.introducedAt;
      _buttonConceptId = $v.buttonConceptId;
      _isHidden = $v.isHidden;
      _note = $v.note;
      _origin = $v.origin;
      _audioId = $v.audioId;
      _webhookUrl = $v.webhookUrl;
      _createdAt = $v.createdAt;
      _baseButton = $v.baseButton?.toBuilder();
      _pressCount = $v.pressCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ButtonOut other) {
    _$v = other as _$ButtonOut;
  }

  @override
  void update(void Function(ButtonOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ButtonOut build() => _build();

  _$ButtonOut _build() {
    _$ButtonOut _$result;
    try {
      _$result = _$v ??
          _$ButtonOut._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'ButtonOut', 'id'),
            text: BuiltValueNullFieldError.checkNotNull(
                text, r'ButtonOut', 'text'),
            word: BuiltValueNullFieldError.checkNotNull(
                word, r'ButtonOut', 'word'),
            normalizedWord: BuiltValueNullFieldError.checkNotNull(
                normalizedWord, r'ButtonOut', 'normalizedWord'),
            introducedAt: introducedAt,
            buttonConceptId: buttonConceptId,
            isHidden: BuiltValueNullFieldError.checkNotNull(
                isHidden, r'ButtonOut', 'isHidden'),
            note: note,
            origin: BuiltValueNullFieldError.checkNotNull(
                origin, r'ButtonOut', 'origin'),
            audioId: audioId,
            webhookUrl: webhookUrl,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'ButtonOut', 'createdAt'),
            baseButton: _baseButton?.build(),
            pressCount: BuiltValueNullFieldError.checkNotNull(
                pressCount, r'ButtonOut', 'pressCount'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'baseButton';
        _baseButton?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ButtonOut', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
