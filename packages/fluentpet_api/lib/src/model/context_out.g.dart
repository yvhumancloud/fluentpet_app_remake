// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'context_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ContextOut extends ContextOut {
  @override
  final int id;
  @override
  final int? householdId;
  @override
  final String text;
  @override
  final String appliesTo;

  factory _$ContextOut([void Function(ContextOutBuilder)? updates]) =>
      (ContextOutBuilder()..update(updates))._build();

  _$ContextOut._(
      {required this.id,
      this.householdId,
      required this.text,
      required this.appliesTo})
      : super._();
  @override
  ContextOut rebuild(void Function(ContextOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ContextOutBuilder toBuilder() => ContextOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContextOut &&
        id == other.id &&
        householdId == other.householdId &&
        text == other.text &&
        appliesTo == other.appliesTo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, householdId.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, appliesTo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ContextOut')
          ..add('id', id)
          ..add('householdId', householdId)
          ..add('text', text)
          ..add('appliesTo', appliesTo))
        .toString();
  }
}

class ContextOutBuilder implements Builder<ContextOut, ContextOutBuilder> {
  _$ContextOut? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _householdId;
  int? get householdId => _$this._householdId;
  set householdId(int? householdId) => _$this._householdId = householdId;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  String? _appliesTo;
  String? get appliesTo => _$this._appliesTo;
  set appliesTo(String? appliesTo) => _$this._appliesTo = appliesTo;

  ContextOutBuilder() {
    ContextOut._defaults(this);
  }

  ContextOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _householdId = $v.householdId;
      _text = $v.text;
      _appliesTo = $v.appliesTo;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContextOut other) {
    _$v = other as _$ContextOut;
  }

  @override
  void update(void Function(ContextOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContextOut build() => _build();

  _$ContextOut _build() {
    final _$result = _$v ??
        _$ContextOut._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ContextOut', 'id'),
          householdId: householdId,
          text: BuiltValueNullFieldError.checkNotNull(
              text, r'ContextOut', 'text'),
          appliesTo: BuiltValueNullFieldError.checkNotNull(
              appliesTo, r'ContextOut', 'appliesTo'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
