// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_in.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NoteIn extends NoteIn {
  @override
  final String text;
  @override
  final DateTime occurredAt;
  @override
  final String? deviceTimezone;
  @override
  final bool? isFavourite;

  factory _$NoteIn([void Function(NoteInBuilder)? updates]) =>
      (NoteInBuilder()..update(updates))._build();

  _$NoteIn._(
      {required this.text,
      required this.occurredAt,
      this.deviceTimezone,
      this.isFavourite})
      : super._();
  @override
  NoteIn rebuild(void Function(NoteInBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NoteInBuilder toBuilder() => NoteInBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NoteIn &&
        text == other.text &&
        occurredAt == other.occurredAt &&
        deviceTimezone == other.deviceTimezone &&
        isFavourite == other.isFavourite;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, occurredAt.hashCode);
    _$hash = $jc(_$hash, deviceTimezone.hashCode);
    _$hash = $jc(_$hash, isFavourite.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NoteIn')
          ..add('text', text)
          ..add('occurredAt', occurredAt)
          ..add('deviceTimezone', deviceTimezone)
          ..add('isFavourite', isFavourite))
        .toString();
  }
}

class NoteInBuilder implements Builder<NoteIn, NoteInBuilder> {
  _$NoteIn? _$v;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  DateTime? _occurredAt;
  DateTime? get occurredAt => _$this._occurredAt;
  set occurredAt(DateTime? occurredAt) => _$this._occurredAt = occurredAt;

  String? _deviceTimezone;
  String? get deviceTimezone => _$this._deviceTimezone;
  set deviceTimezone(String? deviceTimezone) =>
      _$this._deviceTimezone = deviceTimezone;

  bool? _isFavourite;
  bool? get isFavourite => _$this._isFavourite;
  set isFavourite(bool? isFavourite) => _$this._isFavourite = isFavourite;

  NoteInBuilder() {
    NoteIn._defaults(this);
  }

  NoteInBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _text = $v.text;
      _occurredAt = $v.occurredAt;
      _deviceTimezone = $v.deviceTimezone;
      _isFavourite = $v.isFavourite;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NoteIn other) {
    _$v = other as _$NoteIn;
  }

  @override
  void update(void Function(NoteInBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NoteIn build() => _build();

  _$NoteIn _build() {
    final _$result = _$v ??
        _$NoteIn._(
          text: BuiltValueNullFieldError.checkNotNull(text, r'NoteIn', 'text'),
          occurredAt: BuiltValueNullFieldError.checkNotNull(
              occurredAt, r'NoteIn', 'occurredAt'),
          deviceTimezone: deviceTimezone,
          isFavourite: isFavourite,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
