// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_text_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LogTextOut extends LogTextOut {
  @override
  final InteractionIn draft;
  @override
  final BuiltList<String> unmatchedWords;

  factory _$LogTextOut([void Function(LogTextOutBuilder)? updates]) =>
      (LogTextOutBuilder()..update(updates))._build();

  _$LogTextOut._({required this.draft, required this.unmatchedWords})
      : super._();
  @override
  LogTextOut rebuild(void Function(LogTextOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LogTextOutBuilder toBuilder() => LogTextOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LogTextOut &&
        draft == other.draft &&
        unmatchedWords == other.unmatchedWords;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, draft.hashCode);
    _$hash = $jc(_$hash, unmatchedWords.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LogTextOut')
          ..add('draft', draft)
          ..add('unmatchedWords', unmatchedWords))
        .toString();
  }
}

class LogTextOutBuilder implements Builder<LogTextOut, LogTextOutBuilder> {
  _$LogTextOut? _$v;

  InteractionInBuilder? _draft;
  InteractionInBuilder get draft => _$this._draft ??= InteractionInBuilder();
  set draft(InteractionInBuilder? draft) => _$this._draft = draft;

  ListBuilder<String>? _unmatchedWords;
  ListBuilder<String> get unmatchedWords =>
      _$this._unmatchedWords ??= ListBuilder<String>();
  set unmatchedWords(ListBuilder<String>? unmatchedWords) =>
      _$this._unmatchedWords = unmatchedWords;

  LogTextOutBuilder() {
    LogTextOut._defaults(this);
  }

  LogTextOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _draft = $v.draft.toBuilder();
      _unmatchedWords = $v.unmatchedWords.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LogTextOut other) {
    _$v = other as _$LogTextOut;
  }

  @override
  void update(void Function(LogTextOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LogTextOut build() => _build();

  _$LogTextOut _build() {
    _$LogTextOut _$result;
    try {
      _$result = _$v ??
          _$LogTextOut._(
            draft: draft.build(),
            unmatchedWords: unmatchedWords.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'draft';
        draft.build();
        _$failedField = 'unmatchedWords';
        unmatchedWords.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'LogTextOut', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
