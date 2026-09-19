// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_filters.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SearchFiltersMatchEnum _$searchFiltersMatchEnum_any =
    const SearchFiltersMatchEnum._('any');
const SearchFiltersMatchEnum _$searchFiltersMatchEnum_all =
    const SearchFiltersMatchEnum._('all');

SearchFiltersMatchEnum _$searchFiltersMatchEnumValueOf(String name) {
  switch (name) {
    case 'any':
      return _$searchFiltersMatchEnum_any;
    case 'all':
      return _$searchFiltersMatchEnum_all;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SearchFiltersMatchEnum> _$searchFiltersMatchEnumValues =
    BuiltSet<SearchFiltersMatchEnum>(const <SearchFiltersMatchEnum>[
  _$searchFiltersMatchEnum_any,
  _$searchFiltersMatchEnum_all,
]);

const SearchFiltersNotesEnum _$searchFiltersNotesEnum_include =
    const SearchFiltersNotesEnum._('include');
const SearchFiltersNotesEnum _$searchFiltersNotesEnum_only =
    const SearchFiltersNotesEnum._('only');
const SearchFiltersNotesEnum _$searchFiltersNotesEnum_exclude =
    const SearchFiltersNotesEnum._('exclude');

SearchFiltersNotesEnum _$searchFiltersNotesEnumValueOf(String name) {
  switch (name) {
    case 'include':
      return _$searchFiltersNotesEnum_include;
    case 'only':
      return _$searchFiltersNotesEnum_only;
    case 'exclude':
      return _$searchFiltersNotesEnum_exclude;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SearchFiltersNotesEnum> _$searchFiltersNotesEnumValues =
    BuiltSet<SearchFiltersNotesEnum>(const <SearchFiltersNotesEnum>[
  _$searchFiltersNotesEnum_include,
  _$searchFiltersNotesEnum_only,
  _$searchFiltersNotesEnum_exclude,
]);

const SearchFiltersWithNoteEnum _$searchFiltersWithNoteEnum_include =
    const SearchFiltersWithNoteEnum._('include');
const SearchFiltersWithNoteEnum _$searchFiltersWithNoteEnum_only =
    const SearchFiltersWithNoteEnum._('only');
const SearchFiltersWithNoteEnum _$searchFiltersWithNoteEnum_exclude =
    const SearchFiltersWithNoteEnum._('exclude');

SearchFiltersWithNoteEnum _$searchFiltersWithNoteEnumValueOf(String name) {
  switch (name) {
    case 'include':
      return _$searchFiltersWithNoteEnum_include;
    case 'only':
      return _$searchFiltersWithNoteEnum_only;
    case 'exclude':
      return _$searchFiltersWithNoteEnum_exclude;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SearchFiltersWithNoteEnum> _$searchFiltersWithNoteEnumValues =
    BuiltSet<SearchFiltersWithNoteEnum>(const <SearchFiltersWithNoteEnum>[
  _$searchFiltersWithNoteEnum_include,
  _$searchFiltersWithNoteEnum_only,
  _$searchFiltersWithNoteEnum_exclude,
]);

const SearchFiltersFavouritesEnum _$searchFiltersFavouritesEnum_include =
    const SearchFiltersFavouritesEnum._('include');
const SearchFiltersFavouritesEnum _$searchFiltersFavouritesEnum_only =
    const SearchFiltersFavouritesEnum._('only');
const SearchFiltersFavouritesEnum _$searchFiltersFavouritesEnum_exclude =
    const SearchFiltersFavouritesEnum._('exclude');

SearchFiltersFavouritesEnum _$searchFiltersFavouritesEnumValueOf(String name) {
  switch (name) {
    case 'include':
      return _$searchFiltersFavouritesEnum_include;
    case 'only':
      return _$searchFiltersFavouritesEnum_only;
    case 'exclude':
      return _$searchFiltersFavouritesEnum_exclude;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SearchFiltersFavouritesEnum>
    _$searchFiltersFavouritesEnumValues =
    BuiltSet<SearchFiltersFavouritesEnum>(const <SearchFiltersFavouritesEnum>[
  _$searchFiltersFavouritesEnum_include,
  _$searchFiltersFavouritesEnum_only,
  _$searchFiltersFavouritesEnum_exclude,
]);

const SearchFiltersPressesEnum _$searchFiltersPressesEnum_all =
    const SearchFiltersPressesEnum._('all');
const SearchFiltersPressesEnum _$searchFiltersPressesEnum_single =
    const SearchFiltersPressesEnum._('single');
const SearchFiltersPressesEnum _$searchFiltersPressesEnum_multiple =
    const SearchFiltersPressesEnum._('multiple');

SearchFiltersPressesEnum _$searchFiltersPressesEnumValueOf(String name) {
  switch (name) {
    case 'all':
      return _$searchFiltersPressesEnum_all;
    case 'single':
      return _$searchFiltersPressesEnum_single;
    case 'multiple':
      return _$searchFiltersPressesEnum_multiple;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SearchFiltersPressesEnum> _$searchFiltersPressesEnumValues =
    BuiltSet<SearchFiltersPressesEnum>(const <SearchFiltersPressesEnum>[
  _$searchFiltersPressesEnum_all,
  _$searchFiltersPressesEnum_single,
  _$searchFiltersPressesEnum_multiple,
]);

Serializer<SearchFiltersMatchEnum> _$searchFiltersMatchEnumSerializer =
    _$SearchFiltersMatchEnumSerializer();
Serializer<SearchFiltersNotesEnum> _$searchFiltersNotesEnumSerializer =
    _$SearchFiltersNotesEnumSerializer();
Serializer<SearchFiltersWithNoteEnum> _$searchFiltersWithNoteEnumSerializer =
    _$SearchFiltersWithNoteEnumSerializer();
Serializer<SearchFiltersFavouritesEnum>
    _$searchFiltersFavouritesEnumSerializer =
    _$SearchFiltersFavouritesEnumSerializer();
Serializer<SearchFiltersPressesEnum> _$searchFiltersPressesEnumSerializer =
    _$SearchFiltersPressesEnumSerializer();

class _$SearchFiltersMatchEnumSerializer
    implements PrimitiveSerializer<SearchFiltersMatchEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'any': 'any',
    'all': 'all',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'any': 'any',
    'all': 'all',
  };

  @override
  final Iterable<Type> types = const <Type>[SearchFiltersMatchEnum];
  @override
  final String wireName = 'SearchFiltersMatchEnum';

  @override
  Object serialize(Serializers serializers, SearchFiltersMatchEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SearchFiltersMatchEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SearchFiltersMatchEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SearchFiltersNotesEnumSerializer
    implements PrimitiveSerializer<SearchFiltersNotesEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'include': 'include',
    'only': 'only',
    'exclude': 'exclude',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'include': 'include',
    'only': 'only',
    'exclude': 'exclude',
  };

  @override
  final Iterable<Type> types = const <Type>[SearchFiltersNotesEnum];
  @override
  final String wireName = 'SearchFiltersNotesEnum';

  @override
  Object serialize(Serializers serializers, SearchFiltersNotesEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SearchFiltersNotesEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SearchFiltersNotesEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SearchFiltersWithNoteEnumSerializer
    implements PrimitiveSerializer<SearchFiltersWithNoteEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'include': 'include',
    'only': 'only',
    'exclude': 'exclude',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'include': 'include',
    'only': 'only',
    'exclude': 'exclude',
  };

  @override
  final Iterable<Type> types = const <Type>[SearchFiltersWithNoteEnum];
  @override
  final String wireName = 'SearchFiltersWithNoteEnum';

  @override
  Object serialize(Serializers serializers, SearchFiltersWithNoteEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SearchFiltersWithNoteEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SearchFiltersWithNoteEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SearchFiltersFavouritesEnumSerializer
    implements PrimitiveSerializer<SearchFiltersFavouritesEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'include': 'include',
    'only': 'only',
    'exclude': 'exclude',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'include': 'include',
    'only': 'only',
    'exclude': 'exclude',
  };

  @override
  final Iterable<Type> types = const <Type>[SearchFiltersFavouritesEnum];
  @override
  final String wireName = 'SearchFiltersFavouritesEnum';

  @override
  Object serialize(Serializers serializers, SearchFiltersFavouritesEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SearchFiltersFavouritesEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SearchFiltersFavouritesEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SearchFiltersPressesEnumSerializer
    implements PrimitiveSerializer<SearchFiltersPressesEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'all': 'all',
    'single': 'single',
    'multiple': 'multiple',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'all': 'all',
    'single': 'single',
    'multiple': 'multiple',
  };

  @override
  final Iterable<Type> types = const <Type>[SearchFiltersPressesEnum];
  @override
  final String wireName = 'SearchFiltersPressesEnum';

  @override
  Object serialize(Serializers serializers, SearchFiltersPressesEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SearchFiltersPressesEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SearchFiltersPressesEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SearchFilters extends SearchFilters {
  @override
  final BuiltList<int>? pusherIds;
  @override
  final BuiltList<int>? contextIds;
  @override
  final BuiltList<int>? buttonIds;
  @override
  final BuiltList<int>? baseIds;
  @override
  final SearchFiltersMatchEnum? match;
  @override
  final String? text;
  @override
  final DateTime? from;
  @override
  final DateTime? to;
  @override
  final SearchFiltersNotesEnum? notes;
  @override
  final SearchFiltersWithNoteEnum? withNote;
  @override
  final SearchFiltersFavouritesEnum? favourites;
  @override
  final SearchFiltersPressesEnum? presses;
  @override
  final bool? includeHidden;

  factory _$SearchFilters([void Function(SearchFiltersBuilder)? updates]) =>
      (SearchFiltersBuilder()..update(updates))._build();

  _$SearchFilters._(
      {this.pusherIds,
      this.contextIds,
      this.buttonIds,
      this.baseIds,
      this.match,
      this.text,
      this.from,
      this.to,
      this.notes,
      this.withNote,
      this.favourites,
      this.presses,
      this.includeHidden})
      : super._();
  @override
  SearchFilters rebuild(void Function(SearchFiltersBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchFiltersBuilder toBuilder() => SearchFiltersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchFilters &&
        pusherIds == other.pusherIds &&
        contextIds == other.contextIds &&
        buttonIds == other.buttonIds &&
        baseIds == other.baseIds &&
        match == other.match &&
        text == other.text &&
        from == other.from &&
        to == other.to &&
        notes == other.notes &&
        withNote == other.withNote &&
        favourites == other.favourites &&
        presses == other.presses &&
        includeHidden == other.includeHidden;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pusherIds.hashCode);
    _$hash = $jc(_$hash, contextIds.hashCode);
    _$hash = $jc(_$hash, buttonIds.hashCode);
    _$hash = $jc(_$hash, baseIds.hashCode);
    _$hash = $jc(_$hash, match.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jc(_$hash, withNote.hashCode);
    _$hash = $jc(_$hash, favourites.hashCode);
    _$hash = $jc(_$hash, presses.hashCode);
    _$hash = $jc(_$hash, includeHidden.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SearchFilters')
          ..add('pusherIds', pusherIds)
          ..add('contextIds', contextIds)
          ..add('buttonIds', buttonIds)
          ..add('baseIds', baseIds)
          ..add('match', match)
          ..add('text', text)
          ..add('from', from)
          ..add('to', to)
          ..add('notes', notes)
          ..add('withNote', withNote)
          ..add('favourites', favourites)
          ..add('presses', presses)
          ..add('includeHidden', includeHidden))
        .toString();
  }
}

class SearchFiltersBuilder
    implements Builder<SearchFilters, SearchFiltersBuilder> {
  _$SearchFilters? _$v;

  ListBuilder<int>? _pusherIds;
  ListBuilder<int> get pusherIds => _$this._pusherIds ??= ListBuilder<int>();
  set pusherIds(ListBuilder<int>? pusherIds) => _$this._pusherIds = pusherIds;

  ListBuilder<int>? _contextIds;
  ListBuilder<int> get contextIds => _$this._contextIds ??= ListBuilder<int>();
  set contextIds(ListBuilder<int>? contextIds) =>
      _$this._contextIds = contextIds;

  ListBuilder<int>? _buttonIds;
  ListBuilder<int> get buttonIds => _$this._buttonIds ??= ListBuilder<int>();
  set buttonIds(ListBuilder<int>? buttonIds) => _$this._buttonIds = buttonIds;

  ListBuilder<int>? _baseIds;
  ListBuilder<int> get baseIds => _$this._baseIds ??= ListBuilder<int>();
  set baseIds(ListBuilder<int>? baseIds) => _$this._baseIds = baseIds;

  SearchFiltersMatchEnum? _match;
  SearchFiltersMatchEnum? get match => _$this._match;
  set match(SearchFiltersMatchEnum? match) => _$this._match = match;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  DateTime? _from;
  DateTime? get from => _$this._from;
  set from(DateTime? from) => _$this._from = from;

  DateTime? _to;
  DateTime? get to => _$this._to;
  set to(DateTime? to) => _$this._to = to;

  SearchFiltersNotesEnum? _notes;
  SearchFiltersNotesEnum? get notes => _$this._notes;
  set notes(SearchFiltersNotesEnum? notes) => _$this._notes = notes;

  SearchFiltersWithNoteEnum? _withNote;
  SearchFiltersWithNoteEnum? get withNote => _$this._withNote;
  set withNote(SearchFiltersWithNoteEnum? withNote) =>
      _$this._withNote = withNote;

  SearchFiltersFavouritesEnum? _favourites;
  SearchFiltersFavouritesEnum? get favourites => _$this._favourites;
  set favourites(SearchFiltersFavouritesEnum? favourites) =>
      _$this._favourites = favourites;

  SearchFiltersPressesEnum? _presses;
  SearchFiltersPressesEnum? get presses => _$this._presses;
  set presses(SearchFiltersPressesEnum? presses) => _$this._presses = presses;

  bool? _includeHidden;
  bool? get includeHidden => _$this._includeHidden;
  set includeHidden(bool? includeHidden) =>
      _$this._includeHidden = includeHidden;

  SearchFiltersBuilder() {
    SearchFilters._defaults(this);
  }

  SearchFiltersBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pusherIds = $v.pusherIds?.toBuilder();
      _contextIds = $v.contextIds?.toBuilder();
      _buttonIds = $v.buttonIds?.toBuilder();
      _baseIds = $v.baseIds?.toBuilder();
      _match = $v.match;
      _text = $v.text;
      _from = $v.from;
      _to = $v.to;
      _notes = $v.notes;
      _withNote = $v.withNote;
      _favourites = $v.favourites;
      _presses = $v.presses;
      _includeHidden = $v.includeHidden;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchFilters other) {
    _$v = other as _$SearchFilters;
  }

  @override
  void update(void Function(SearchFiltersBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchFilters build() => _build();

  _$SearchFilters _build() {
    _$SearchFilters _$result;
    try {
      _$result = _$v ??
          _$SearchFilters._(
            pusherIds: _pusherIds?.build(),
            contextIds: _contextIds?.build(),
            buttonIds: _buttonIds?.build(),
            baseIds: _baseIds?.build(),
            match: match,
            text: text,
            from: from,
            to: to,
            notes: notes,
            withNote: withNote,
            favourites: favourites,
            presses: presses,
            includeHidden: includeHidden,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'pusherIds';
        _pusherIds?.build();
        _$failedField = 'contextIds';
        _contextIds?.build();
        _$failedField = 'buttonIds';
        _buttonIds?.build();
        _$failedField = 'baseIds';
        _baseIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SearchFilters', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
