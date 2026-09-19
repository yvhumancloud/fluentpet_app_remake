// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learner_type_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LearnerTypeOut extends LearnerTypeOut {
  @override
  final int id;
  @override
  final String name;

  factory _$LearnerTypeOut([void Function(LearnerTypeOutBuilder)? updates]) =>
      (LearnerTypeOutBuilder()..update(updates))._build();

  _$LearnerTypeOut._({required this.id, required this.name}) : super._();
  @override
  LearnerTypeOut rebuild(void Function(LearnerTypeOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LearnerTypeOutBuilder toBuilder() => LearnerTypeOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LearnerTypeOut && id == other.id && name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LearnerTypeOut')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class LearnerTypeOutBuilder
    implements Builder<LearnerTypeOut, LearnerTypeOutBuilder> {
  _$LearnerTypeOut? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  LearnerTypeOutBuilder() {
    LearnerTypeOut._defaults(this);
  }

  LearnerTypeOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LearnerTypeOut other) {
    _$v = other as _$LearnerTypeOut;
  }

  @override
  void update(void Function(LearnerTypeOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LearnerTypeOut build() => _build();

  _$LearnerTypeOut _build() {
    final _$result = _$v ??
        _$LearnerTypeOut._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'LearnerTypeOut', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'LearnerTypeOut', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
