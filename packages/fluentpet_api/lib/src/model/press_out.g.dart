// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'press_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PressOut extends PressOut {
  @override
  final int id;
  @override
  final int buttonId;
  @override
  final String text;
  @override
  final int pressOrder;
  @override
  final DateTime? occurredAt;

  factory _$PressOut([void Function(PressOutBuilder)? updates]) =>
      (PressOutBuilder()..update(updates))._build();

  _$PressOut._(
      {required this.id,
      required this.buttonId,
      required this.text,
      required this.pressOrder,
      this.occurredAt})
      : super._();
  @override
  PressOut rebuild(void Function(PressOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PressOutBuilder toBuilder() => PressOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PressOut &&
        id == other.id &&
        buttonId == other.buttonId &&
        text == other.text &&
        pressOrder == other.pressOrder &&
        occurredAt == other.occurredAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, buttonId.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, pressOrder.hashCode);
    _$hash = $jc(_$hash, occurredAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PressOut')
          ..add('id', id)
          ..add('buttonId', buttonId)
          ..add('text', text)
          ..add('pressOrder', pressOrder)
          ..add('occurredAt', occurredAt))
        .toString();
  }
}

class PressOutBuilder implements Builder<PressOut, PressOutBuilder> {
  _$PressOut? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _buttonId;
  int? get buttonId => _$this._buttonId;
  set buttonId(int? buttonId) => _$this._buttonId = buttonId;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  int? _pressOrder;
  int? get pressOrder => _$this._pressOrder;
  set pressOrder(int? pressOrder) => _$this._pressOrder = pressOrder;

  DateTime? _occurredAt;
  DateTime? get occurredAt => _$this._occurredAt;
  set occurredAt(DateTime? occurredAt) => _$this._occurredAt = occurredAt;

  PressOutBuilder() {
    PressOut._defaults(this);
  }

  PressOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _buttonId = $v.buttonId;
      _text = $v.text;
      _pressOrder = $v.pressOrder;
      _occurredAt = $v.occurredAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PressOut other) {
    _$v = other as _$PressOut;
  }

  @override
  void update(void Function(PressOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PressOut build() => _build();

  _$PressOut _build() {
    final _$result = _$v ??
        _$PressOut._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'PressOut', 'id'),
          buttonId: BuiltValueNullFieldError.checkNotNull(
              buttonId, r'PressOut', 'buttonId'),
          text:
              BuiltValueNullFieldError.checkNotNull(text, r'PressOut', 'text'),
          pressOrder: BuiltValueNullFieldError.checkNotNull(
              pressOrder, r'PressOut', 'pressOrder'),
          occurredAt: occurredAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
