// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SearchOut extends SearchOut {
  @override
  final BuiltList<ItemsInner> items;
  @override
  final int total;
  @override
  final int page;
  @override
  final int perPage;
  @override
  final SearchCounts counts;

  factory _$SearchOut([void Function(SearchOutBuilder)? updates]) =>
      (SearchOutBuilder()..update(updates))._build();

  _$SearchOut._(
      {required this.items,
      required this.total,
      required this.page,
      required this.perPage,
      required this.counts})
      : super._();
  @override
  SearchOut rebuild(void Function(SearchOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchOutBuilder toBuilder() => SearchOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchOut &&
        items == other.items &&
        total == other.total &&
        page == other.page &&
        perPage == other.perPage &&
        counts == other.counts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, perPage.hashCode);
    _$hash = $jc(_$hash, counts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SearchOut')
          ..add('items', items)
          ..add('total', total)
          ..add('page', page)
          ..add('perPage', perPage)
          ..add('counts', counts))
        .toString();
  }
}

class SearchOutBuilder implements Builder<SearchOut, SearchOutBuilder> {
  _$SearchOut? _$v;

  ListBuilder<ItemsInner>? _items;
  ListBuilder<ItemsInner> get items =>
      _$this._items ??= ListBuilder<ItemsInner>();
  set items(ListBuilder<ItemsInner>? items) => _$this._items = items;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  int? _perPage;
  int? get perPage => _$this._perPage;
  set perPage(int? perPage) => _$this._perPage = perPage;

  SearchCountsBuilder? _counts;
  SearchCountsBuilder get counts => _$this._counts ??= SearchCountsBuilder();
  set counts(SearchCountsBuilder? counts) => _$this._counts = counts;

  SearchOutBuilder() {
    SearchOut._defaults(this);
  }

  SearchOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _total = $v.total;
      _page = $v.page;
      _perPage = $v.perPage;
      _counts = $v.counts.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchOut other) {
    _$v = other as _$SearchOut;
  }

  @override
  void update(void Function(SearchOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchOut build() => _build();

  _$SearchOut _build() {
    _$SearchOut _$result;
    try {
      _$result = _$v ??
          _$SearchOut._(
            items: items.build(),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'SearchOut', 'total'),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'SearchOut', 'page'),
            perPage: BuiltValueNullFieldError.checkNotNull(
                perPage, r'SearchOut', 'perPage'),
            counts: counts.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();

        _$failedField = 'counts';
        counts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SearchOut', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
