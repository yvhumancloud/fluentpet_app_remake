// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_patch.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NotePatch extends NotePatch {
  @override
  final String? text;
  @override
  final DateTime? occurredAt;
  @override
  final String? deviceTimezone;
  @override
  final bool? isFavourite;
  @override
  final bool? isHidden;

  factory _$NotePatch([void Function(NotePatchBuilder)? updates]) =>
      (NotePatchBuilder()..update(updates))._build();

  _$NotePatch._(
      {this.text,
      this.occurredAt,
      this.deviceTimezone,
      this.isFavourite,
      this.isHidden})
      : super._();
  @override
  NotePatch rebuild(void Function(NotePatchBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotePatchBuilder toBuilder() => NotePatchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotePatch &&
        text == other.text &&
        occurredAt == other.occurredAt &&
        deviceTimezone == other.deviceTimezone &&
        isFavourite == other.isFavourite &&
        isHidden == other.isHidden;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, occurredAt.hashCode);
    _$hash = $jc(_$hash, deviceTimezone.hashCode);
    _$hash = $jc(_$hash, isFavourite.hashCode);
    _$hash = $jc(_$hash, isHidden.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotePatch')
          ..add('text', text)
          ..add('occurredAt', occurredAt)
          ..add('deviceTimezone', deviceTimezone)
          ..add('isFavourite', isFavourite)
          ..add('isHidden', isHidden))
        .toString();
  }
}

class NotePatchBuilder implements Builder<NotePatch, NotePatchBuilder> {
  _$NotePatch? _$v;

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

  bool? _isHidden;
  bool? get isHidden => _$this._isHidden;
  set isHidden(bool? isHidden) => _$this._isHidden = isHidden;

  NotePatchBuilder() {
    NotePatch._defaults(this);
  }

  NotePatchBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _text = $v.text;
      _occurredAt = $v.occurredAt;
      _deviceTimezone = $v.deviceTimezone;
      _isFavourite = $v.isFavourite;
      _isHidden = $v.isHidden;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotePatch other) {
    _$v = other as _$NotePatch;
  }

  @override
  void update(void Function(NotePatchBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotePatch build() => _build();

  _$NotePatch _build() {
    final _$result = _$v ??
        _$NotePatch._(
          text: text,
          occurredAt: occurredAt,
          deviceTimezone: deviceTimezone,
          isFavourite: isFavourite,
          isHidden: isHidden,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
