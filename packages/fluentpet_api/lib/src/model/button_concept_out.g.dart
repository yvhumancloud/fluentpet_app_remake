// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button_concept_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ButtonConceptOut extends ButtonConceptOut {
  @override
  final int id;
  @override
  final String concept;

  factory _$ButtonConceptOut(
          [void Function(ButtonConceptOutBuilder)? updates]) =>
      (ButtonConceptOutBuilder()..update(updates))._build();

  _$ButtonConceptOut._({required this.id, required this.concept}) : super._();
  @override
  ButtonConceptOut rebuild(void Function(ButtonConceptOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ButtonConceptOutBuilder toBuilder() =>
      ButtonConceptOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ButtonConceptOut &&
        id == other.id &&
        concept == other.concept;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, concept.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ButtonConceptOut')
          ..add('id', id)
          ..add('concept', concept))
        .toString();
  }
}

class ButtonConceptOutBuilder
    implements Builder<ButtonConceptOut, ButtonConceptOutBuilder> {
  _$ButtonConceptOut? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _concept;
  String? get concept => _$this._concept;
  set concept(String? concept) => _$this._concept = concept;

  ButtonConceptOutBuilder() {
    ButtonConceptOut._defaults(this);
  }

  ButtonConceptOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _concept = $v.concept;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ButtonConceptOut other) {
    _$v = other as _$ButtonConceptOut;
  }

  @override
  void update(void Function(ButtonConceptOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ButtonConceptOut build() => _build();

  _$ButtonConceptOut _build() {
    final _$result = _$v ??
        _$ButtonConceptOut._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ButtonConceptOut', 'id'),
          concept: BuiltValueNullFieldError.checkNotNull(
              concept, r'ButtonConceptOut', 'concept'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
