// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BulkOut extends BulkOut {
  @override
  final int affected;
  @override
  final int? id;

  factory _$BulkOut([void Function(BulkOutBuilder)? updates]) =>
      (BulkOutBuilder()..update(updates))._build();

  _$BulkOut._({required this.affected, this.id}) : super._();
  @override
  BulkOut rebuild(void Function(BulkOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BulkOutBuilder toBuilder() => BulkOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BulkOut && affected == other.affected && id == other.id;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, affected.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BulkOut')
          ..add('affected', affected)
          ..add('id', id))
        .toString();
  }
}

class BulkOutBuilder implements Builder<BulkOut, BulkOutBuilder> {
  _$BulkOut? _$v;

  int? _affected;
  int? get affected => _$this._affected;
  set affected(int? affected) => _$this._affected = affected;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  BulkOutBuilder() {
    BulkOut._defaults(this);
  }

  BulkOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _affected = $v.affected;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BulkOut other) {
    _$v = other as _$BulkOut;
  }

  @override
  void update(void Function(BulkOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BulkOut build() => _build();

  _$BulkOut _build() {
    final _$result = _$v ??
        _$BulkOut._(
          affected: BuiltValueNullFieldError.checkNotNull(
              affected, r'BulkOut', 'affected'),
          id: id,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
