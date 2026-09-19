// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_counts.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SearchCounts extends SearchCounts {
  @override
  final int communication;
  @override
  final int modeling;
  @override
  final int unassigned;

  factory _$SearchCounts([void Function(SearchCountsBuilder)? updates]) =>
      (SearchCountsBuilder()..update(updates))._build();

  _$SearchCounts._(
      {required this.communication,
      required this.modeling,
      required this.unassigned})
      : super._();
  @override
  SearchCounts rebuild(void Function(SearchCountsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchCountsBuilder toBuilder() => SearchCountsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchCounts &&
        communication == other.communication &&
        modeling == other.modeling &&
        unassigned == other.unassigned;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, communication.hashCode);
    _$hash = $jc(_$hash, modeling.hashCode);
    _$hash = $jc(_$hash, unassigned.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SearchCounts')
          ..add('communication', communication)
          ..add('modeling', modeling)
          ..add('unassigned', unassigned))
        .toString();
  }
}

class SearchCountsBuilder
    implements Builder<SearchCounts, SearchCountsBuilder> {
  _$SearchCounts? _$v;

  int? _communication;
  int? get communication => _$this._communication;
  set communication(int? communication) =>
      _$this._communication = communication;

  int? _modeling;
  int? get modeling => _$this._modeling;
  set modeling(int? modeling) => _$this._modeling = modeling;

  int? _unassigned;
  int? get unassigned => _$this._unassigned;
  set unassigned(int? unassigned) => _$this._unassigned = unassigned;

  SearchCountsBuilder() {
    SearchCounts._defaults(this);
  }

  SearchCountsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _communication = $v.communication;
      _modeling = $v.modeling;
      _unassigned = $v.unassigned;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchCounts other) {
    _$v = other as _$SearchCounts;
  }

  @override
  void update(void Function(SearchCountsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchCounts build() => _build();

  _$SearchCounts _build() {
    final _$result = _$v ??
        _$SearchCounts._(
          communication: BuiltValueNullFieldError.checkNotNull(
              communication, r'SearchCounts', 'communication'),
          modeling: BuiltValueNullFieldError.checkNotNull(
              modeling, r'SearchCounts', 'modeling'),
          unassigned: BuiltValueNullFieldError.checkNotNull(
              unassigned, r'SearchCounts', 'unassigned'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
