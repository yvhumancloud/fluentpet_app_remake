// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button_merge.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ButtonMerge extends ButtonMerge {
  @override
  final int sourceId;
  @override
  final int targetId;

  factory _$ButtonMerge([void Function(ButtonMergeBuilder)? updates]) =>
      (ButtonMergeBuilder()..update(updates))._build();

  _$ButtonMerge._({required this.sourceId, required this.targetId}) : super._();
  @override
  ButtonMerge rebuild(void Function(ButtonMergeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ButtonMergeBuilder toBuilder() => ButtonMergeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ButtonMerge &&
        sourceId == other.sourceId &&
        targetId == other.targetId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sourceId.hashCode);
    _$hash = $jc(_$hash, targetId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ButtonMerge')
          ..add('sourceId', sourceId)
          ..add('targetId', targetId))
        .toString();
  }
}

class ButtonMergeBuilder implements Builder<ButtonMerge, ButtonMergeBuilder> {
  _$ButtonMerge? _$v;

  int? _sourceId;
  int? get sourceId => _$this._sourceId;
  set sourceId(int? sourceId) => _$this._sourceId = sourceId;

  int? _targetId;
  int? get targetId => _$this._targetId;
  set targetId(int? targetId) => _$this._targetId = targetId;

  ButtonMergeBuilder() {
    ButtonMerge._defaults(this);
  }

  ButtonMergeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sourceId = $v.sourceId;
      _targetId = $v.targetId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ButtonMerge other) {
    _$v = other as _$ButtonMerge;
  }

  @override
  void update(void Function(ButtonMergeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ButtonMerge build() => _build();

  _$ButtonMerge _build() {
    final _$result = _$v ??
        _$ButtonMerge._(
          sourceId: BuiltValueNullFieldError.checkNotNull(
              sourceId, r'ButtonMerge', 'sourceId'),
          targetId: BuiltValueNullFieldError.checkNotNull(
              targetId, r'ButtonMerge', 'targetId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
