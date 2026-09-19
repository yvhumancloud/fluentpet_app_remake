// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interaction_merge.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InteractionMerge extends InteractionMerge {
  @override
  final BuiltList<int> interactionIds;

  factory _$InteractionMerge(
          [void Function(InteractionMergeBuilder)? updates]) =>
      (InteractionMergeBuilder()..update(updates))._build();

  _$InteractionMerge._({required this.interactionIds}) : super._();
  @override
  InteractionMerge rebuild(void Function(InteractionMergeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InteractionMergeBuilder toBuilder() =>
      InteractionMergeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InteractionMerge && interactionIds == other.interactionIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, interactionIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InteractionMerge')
          ..add('interactionIds', interactionIds))
        .toString();
  }
}

class InteractionMergeBuilder
    implements Builder<InteractionMerge, InteractionMergeBuilder> {
  _$InteractionMerge? _$v;

  ListBuilder<int>? _interactionIds;
  ListBuilder<int> get interactionIds =>
      _$this._interactionIds ??= ListBuilder<int>();
  set interactionIds(ListBuilder<int>? interactionIds) =>
      _$this._interactionIds = interactionIds;

  InteractionMergeBuilder() {
    InteractionMerge._defaults(this);
  }

  InteractionMergeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _interactionIds = $v.interactionIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InteractionMerge other) {
    _$v = other as _$InteractionMerge;
  }

  @override
  void update(void Function(InteractionMergeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InteractionMerge build() => _build();

  _$InteractionMerge _build() {
    _$InteractionMerge _$result;
    try {
      _$result = _$v ??
          _$InteractionMerge._(
            interactionIds: interactionIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'interactionIds';
        interactionIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'InteractionMerge', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
