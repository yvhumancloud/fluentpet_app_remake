// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_in.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SearchInSortEnum _$searchInSortEnum_occurredAtDesc =
    const SearchInSortEnum._('occurredAtDesc');
const SearchInSortEnum _$searchInSortEnum_occurredAtAsc =
    const SearchInSortEnum._('occurredAtAsc');
const SearchInSortEnum _$searchInSortEnum_createdAtDesc =
    const SearchInSortEnum._('createdAtDesc');

SearchInSortEnum _$searchInSortEnumValueOf(String name) {
  switch (name) {
    case 'occurredAtDesc':
      return _$searchInSortEnum_occurredAtDesc;
    case 'occurredAtAsc':
      return _$searchInSortEnum_occurredAtAsc;
    case 'createdAtDesc':
      return _$searchInSortEnum_createdAtDesc;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SearchInSortEnum> _$searchInSortEnumValues =
    BuiltSet<SearchInSortEnum>(const <SearchInSortEnum>[
  _$searchInSortEnum_occurredAtDesc,
  _$searchInSortEnum_occurredAtAsc,
  _$searchInSortEnum_createdAtDesc,
]);

const SearchInTabEnum _$searchInTabEnum_all = const SearchInTabEnum._('all');
const SearchInTabEnum _$searchInTabEnum_assigned =
    const SearchInTabEnum._('assigned');
const SearchInTabEnum _$searchInTabEnum_unassigned =
    const SearchInTabEnum._('unassigned');

SearchInTabEnum _$searchInTabEnumValueOf(String name) {
  switch (name) {
    case 'all':
      return _$searchInTabEnum_all;
    case 'assigned':
      return _$searchInTabEnum_assigned;
    case 'unassigned':
      return _$searchInTabEnum_unassigned;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SearchInTabEnum> _$searchInTabEnumValues =
    BuiltSet<SearchInTabEnum>(const <SearchInTabEnum>[
  _$searchInTabEnum_all,
  _$searchInTabEnum_assigned,
  _$searchInTabEnum_unassigned,
]);

Serializer<SearchInSortEnum> _$searchInSortEnumSerializer =
    _$SearchInSortEnumSerializer();
Serializer<SearchInTabEnum> _$searchInTabEnumSerializer =
    _$SearchInTabEnumSerializer();

class _$SearchInSortEnumSerializer
    implements PrimitiveSerializer<SearchInSortEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'occurredAtDesc': 'occurred_at_desc',
    'occurredAtAsc': 'occurred_at_asc',
    'createdAtDesc': 'created_at_desc',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'occurred_at_desc': 'occurredAtDesc',
    'occurred_at_asc': 'occurredAtAsc',
    'created_at_desc': 'createdAtDesc',
  };

  @override
  final Iterable<Type> types = const <Type>[SearchInSortEnum];
  @override
  final String wireName = 'SearchInSortEnum';

  @override
  Object serialize(Serializers serializers, SearchInSortEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SearchInSortEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SearchInSortEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SearchInTabEnumSerializer
    implements PrimitiveSerializer<SearchInTabEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'all': 'all',
    'assigned': 'assigned',
    'unassigned': 'unassigned',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'all': 'all',
    'assigned': 'assigned',
    'unassigned': 'unassigned',
  };

  @override
  final Iterable<Type> types = const <Type>[SearchInTabEnum];
  @override
  final String wireName = 'SearchInTabEnum';

  @override
  Object serialize(Serializers serializers, SearchInTabEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SearchInTabEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SearchInTabEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SearchIn extends SearchIn {
  @override
  final int? page;
  @override
  final int? perPage;
  @override
  final SearchInSortEnum? sort;
  @override
  final SearchInTabEnum? tab;
  @override
  final SearchFilters? filters;

  factory _$SearchIn([void Function(SearchInBuilder)? updates]) =>
      (SearchInBuilder()..update(updates))._build();

  _$SearchIn._({this.page, this.perPage, this.sort, this.tab, this.filters})
      : super._();
  @override
  SearchIn rebuild(void Function(SearchInBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchInBuilder toBuilder() => SearchInBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchIn &&
        page == other.page &&
        perPage == other.perPage &&
        sort == other.sort &&
        tab == other.tab &&
        filters == other.filters;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, perPage.hashCode);
    _$hash = $jc(_$hash, sort.hashCode);
    _$hash = $jc(_$hash, tab.hashCode);
    _$hash = $jc(_$hash, filters.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SearchIn')
          ..add('page', page)
          ..add('perPage', perPage)
          ..add('sort', sort)
          ..add('tab', tab)
          ..add('filters', filters))
        .toString();
  }
}

class SearchInBuilder implements Builder<SearchIn, SearchInBuilder> {
  _$SearchIn? _$v;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  int? _perPage;
  int? get perPage => _$this._perPage;
  set perPage(int? perPage) => _$this._perPage = perPage;

  SearchInSortEnum? _sort;
  SearchInSortEnum? get sort => _$this._sort;
  set sort(SearchInSortEnum? sort) => _$this._sort = sort;

  SearchInTabEnum? _tab;
  SearchInTabEnum? get tab => _$this._tab;
  set tab(SearchInTabEnum? tab) => _$this._tab = tab;

  SearchFiltersBuilder? _filters;
  SearchFiltersBuilder get filters =>
      _$this._filters ??= SearchFiltersBuilder();
  set filters(SearchFiltersBuilder? filters) => _$this._filters = filters;

  SearchInBuilder() {
    SearchIn._defaults(this);
  }

  SearchInBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _page = $v.page;
      _perPage = $v.perPage;
      _sort = $v.sort;
      _tab = $v.tab;
      _filters = $v.filters?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchIn other) {
    _$v = other as _$SearchIn;
  }

  @override
  void update(void Function(SearchInBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchIn build() => _build();

  _$SearchIn _build() {
    _$SearchIn _$result;
    try {
      _$result = _$v ??
          _$SearchIn._(
            page: page,
            perPage: perPage,
            sort: sort,
            tab: tab,
            filters: _filters?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'filters';
        _filters?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SearchIn', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
