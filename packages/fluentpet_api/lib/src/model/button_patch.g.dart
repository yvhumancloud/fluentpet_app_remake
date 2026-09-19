// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button_patch.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ButtonPatch extends ButtonPatch {
  @override
  final String? text;
  @override
  final String? note;
  @override
  final Date? introducedAt;
  @override
  final int? buttonConceptId;
  @override
  final bool? isHidden;
  @override
  final int? audioId;
  @override
  final String? webhookUrl;

  factory _$ButtonPatch([void Function(ButtonPatchBuilder)? updates]) =>
      (ButtonPatchBuilder()..update(updates))._build();

  _$ButtonPatch._(
      {this.text,
      this.note,
      this.introducedAt,
      this.buttonConceptId,
      this.isHidden,
      this.audioId,
      this.webhookUrl})
      : super._();
  @override
  ButtonPatch rebuild(void Function(ButtonPatchBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ButtonPatchBuilder toBuilder() => ButtonPatchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ButtonPatch &&
        text == other.text &&
        note == other.note &&
        introducedAt == other.introducedAt &&
        buttonConceptId == other.buttonConceptId &&
        isHidden == other.isHidden &&
        audioId == other.audioId &&
        webhookUrl == other.webhookUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, introducedAt.hashCode);
    _$hash = $jc(_$hash, buttonConceptId.hashCode);
    _$hash = $jc(_$hash, isHidden.hashCode);
    _$hash = $jc(_$hash, audioId.hashCode);
    _$hash = $jc(_$hash, webhookUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ButtonPatch')
          ..add('text', text)
          ..add('note', note)
          ..add('introducedAt', introducedAt)
          ..add('buttonConceptId', buttonConceptId)
          ..add('isHidden', isHidden)
          ..add('audioId', audioId)
          ..add('webhookUrl', webhookUrl))
        .toString();
  }
}

class ButtonPatchBuilder implements Builder<ButtonPatch, ButtonPatchBuilder> {
  _$ButtonPatch? _$v;

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

  bool? _isHidden;
  bool? get isHidden => _$this._isHidden;
  set isHidden(bool? isHidden) => _$this._isHidden = isHidden;

  int? _audioId;
  int? get audioId => _$this._audioId;
  set audioId(int? audioId) => _$this._audioId = audioId;

  String? _webhookUrl;
  String? get webhookUrl => _$this._webhookUrl;
  set webhookUrl(String? webhookUrl) => _$this._webhookUrl = webhookUrl;

  ButtonPatchBuilder() {
    ButtonPatch._defaults(this);
  }

  ButtonPatchBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _text = $v.text;
      _note = $v.note;
      _introducedAt = $v.introducedAt;
      _buttonConceptId = $v.buttonConceptId;
      _isHidden = $v.isHidden;
      _audioId = $v.audioId;
      _webhookUrl = $v.webhookUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ButtonPatch other) {
    _$v = other as _$ButtonPatch;
  }

  @override
  void update(void Function(ButtonPatchBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ButtonPatch build() => _build();

  _$ButtonPatch _build() {
    final _$result = _$v ??
        _$ButtonPatch._(
          text: text,
          note: note,
          introducedAt: introducedAt,
          buttonConceptId: buttonConceptId,
          isHidden: isHidden,
          audioId: audioId,
          webhookUrl: webhookUrl,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
