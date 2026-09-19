//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_filters.g.dart';

/// SearchFilters
///
/// Properties:
/// * [pusherIds]
/// * [contextIds]
/// * [buttonIds]
/// * [baseIds]
/// * [match]
/// * [text]
/// * [from]
/// * [to]
/// * [notes]
/// * [withNote]
/// * [favourites]
/// * [presses]
/// * [includeHidden]
@BuiltValue()
abstract class SearchFilters
    implements Built<SearchFilters, SearchFiltersBuilder> {
  @BuiltValueField(wireName: r'pusher_ids')
  BuiltList<int>? get pusherIds;

  @BuiltValueField(wireName: r'context_ids')
  BuiltList<int>? get contextIds;

  @BuiltValueField(wireName: r'button_ids')
  BuiltList<int>? get buttonIds;

  @BuiltValueField(wireName: r'base_ids')
  BuiltList<int>? get baseIds;

  @BuiltValueField(wireName: r'match')
  SearchFiltersMatchEnum? get match;
  // enum matchEnum {  any,  all,  };

  @BuiltValueField(wireName: r'text')
  String? get text;

  @BuiltValueField(wireName: r'from')
  DateTime? get from;

  @BuiltValueField(wireName: r'to')
  DateTime? get to;

  @BuiltValueField(wireName: r'notes')
  SearchFiltersNotesEnum? get notes;
  // enum notesEnum {  include,  only,  exclude,  };

  @BuiltValueField(wireName: r'with_note')
  SearchFiltersWithNoteEnum? get withNote;
  // enum withNoteEnum {  include,  only,  exclude,  };

  @BuiltValueField(wireName: r'favourites')
  SearchFiltersFavouritesEnum? get favourites;
  // enum favouritesEnum {  include,  only,  exclude,  };

  @BuiltValueField(wireName: r'presses')
  SearchFiltersPressesEnum? get presses;
  // enum pressesEnum {  all,  single,  multiple,  };

  @BuiltValueField(wireName: r'include_hidden')
  bool? get includeHidden;

  SearchFilters._();

  factory SearchFilters([void updates(SearchFiltersBuilder b)]) =
      _$SearchFilters;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SearchFiltersBuilder b) => b
    ..pusherIds = ListBuilder()
    ..contextIds = ListBuilder()
    ..buttonIds = ListBuilder()
    ..baseIds = ListBuilder()
    ..includeHidden = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<SearchFilters> get serializer =>
      _$SearchFiltersSerializer();
}

class _$SearchFiltersSerializer implements PrimitiveSerializer<SearchFilters> {
  @override
  final Iterable<Type> types = const [SearchFilters, _$SearchFilters];

  @override
  final String wireName = r'SearchFilters';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SearchFilters object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.pusherIds != null) {
      yield r'pusher_ids';
      yield serializers.serialize(
        object.pusherIds,
        specifiedType: const FullType(BuiltList, [FullType(int)]),
      );
    }
    if (object.contextIds != null) {
      yield r'context_ids';
      yield serializers.serialize(
        object.contextIds,
        specifiedType: const FullType(BuiltList, [FullType(int)]),
      );
    }
    if (object.buttonIds != null) {
      yield r'button_ids';
      yield serializers.serialize(
        object.buttonIds,
        specifiedType: const FullType(BuiltList, [FullType(int)]),
      );
    }
    if (object.baseIds != null) {
      yield r'base_ids';
      yield serializers.serialize(
        object.baseIds,
        specifiedType: const FullType(BuiltList, [FullType(int)]),
      );
    }
    if (object.match != null) {
      yield r'match';
      yield serializers.serialize(
        object.match,
        specifiedType: const FullType(SearchFiltersMatchEnum),
      );
    }
    if (object.text != null) {
      yield r'text';
      yield serializers.serialize(
        object.text,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.from != null) {
      yield r'from';
      yield serializers.serialize(
        object.from,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.to != null) {
      yield r'to';
      yield serializers.serialize(
        object.to,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.notes != null) {
      yield r'notes';
      yield serializers.serialize(
        object.notes,
        specifiedType: const FullType(SearchFiltersNotesEnum),
      );
    }
    if (object.withNote != null) {
      yield r'with_note';
      yield serializers.serialize(
        object.withNote,
        specifiedType: const FullType(SearchFiltersWithNoteEnum),
      );
    }
    if (object.favourites != null) {
      yield r'favourites';
      yield serializers.serialize(
        object.favourites,
        specifiedType: const FullType(SearchFiltersFavouritesEnum),
      );
    }
    if (object.presses != null) {
      yield r'presses';
      yield serializers.serialize(
        object.presses,
        specifiedType: const FullType(SearchFiltersPressesEnum),
      );
    }
    if (object.includeHidden != null) {
      yield r'include_hidden';
      yield serializers.serialize(
        object.includeHidden,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SearchFilters object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SearchFiltersBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pusher_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(int)]),
          ) as BuiltList<int>?;
          if (valueDes == null) continue;
          result.pusherIds.replace(valueDes);
          break;
        case r'context_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(int)]),
          ) as BuiltList<int>?;
          if (valueDes == null) continue;
          result.contextIds.replace(valueDes);
          break;
        case r'button_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(int)]),
          ) as BuiltList<int>?;
          if (valueDes == null) continue;
          result.buttonIds.replace(valueDes);
          break;
        case r'base_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(int)]),
          ) as BuiltList<int>?;
          if (valueDes == null) continue;
          result.baseIds.replace(valueDes);
          break;
        case r'match':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SearchFiltersMatchEnum),
          ) as SearchFiltersMatchEnum?;
          if (valueDes == null) continue;
          result.match = valueDes;
          break;
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.text = valueDes;
          break;
        case r'from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.from = valueDes;
          break;
        case r'to':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.to = valueDes;
          break;
        case r'notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SearchFiltersNotesEnum),
          ) as SearchFiltersNotesEnum?;
          if (valueDes == null) continue;
          result.notes = valueDes;
          break;
        case r'with_note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SearchFiltersWithNoteEnum),
          ) as SearchFiltersWithNoteEnum?;
          if (valueDes == null) continue;
          result.withNote = valueDes;
          break;
        case r'favourites':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SearchFiltersFavouritesEnum),
          ) as SearchFiltersFavouritesEnum?;
          if (valueDes == null) continue;
          result.favourites = valueDes;
          break;
        case r'presses':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SearchFiltersPressesEnum),
          ) as SearchFiltersPressesEnum?;
          if (valueDes == null) continue;
          result.presses = valueDes;
          break;
        case r'include_hidden':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.includeHidden = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SearchFilters deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SearchFiltersBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

class SearchFiltersMatchEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'any')
  static const SearchFiltersMatchEnum any = _$searchFiltersMatchEnum_any;
  @BuiltValueEnumConst(wireName: r'all')
  static const SearchFiltersMatchEnum all = _$searchFiltersMatchEnum_all;

  static Serializer<SearchFiltersMatchEnum> get serializer =>
      _$searchFiltersMatchEnumSerializer;

  const SearchFiltersMatchEnum._(String name) : super(name);

  static BuiltSet<SearchFiltersMatchEnum> get values =>
      _$searchFiltersMatchEnumValues;
  static SearchFiltersMatchEnum valueOf(String name) =>
      _$searchFiltersMatchEnumValueOf(name);
}

class SearchFiltersNotesEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'include')
  static const SearchFiltersNotesEnum include =
      _$searchFiltersNotesEnum_include;
  @BuiltValueEnumConst(wireName: r'only')
  static const SearchFiltersNotesEnum only = _$searchFiltersNotesEnum_only;
  @BuiltValueEnumConst(wireName: r'exclude')
  static const SearchFiltersNotesEnum exclude =
      _$searchFiltersNotesEnum_exclude;

  static Serializer<SearchFiltersNotesEnum> get serializer =>
      _$searchFiltersNotesEnumSerializer;

  const SearchFiltersNotesEnum._(String name) : super(name);

  static BuiltSet<SearchFiltersNotesEnum> get values =>
      _$searchFiltersNotesEnumValues;
  static SearchFiltersNotesEnum valueOf(String name) =>
      _$searchFiltersNotesEnumValueOf(name);
}

class SearchFiltersWithNoteEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'include')
  static const SearchFiltersWithNoteEnum include =
      _$searchFiltersWithNoteEnum_include;
  @BuiltValueEnumConst(wireName: r'only')
  static const SearchFiltersWithNoteEnum only =
      _$searchFiltersWithNoteEnum_only;
  @BuiltValueEnumConst(wireName: r'exclude')
  static const SearchFiltersWithNoteEnum exclude =
      _$searchFiltersWithNoteEnum_exclude;

  static Serializer<SearchFiltersWithNoteEnum> get serializer =>
      _$searchFiltersWithNoteEnumSerializer;

  const SearchFiltersWithNoteEnum._(String name) : super(name);

  static BuiltSet<SearchFiltersWithNoteEnum> get values =>
      _$searchFiltersWithNoteEnumValues;
  static SearchFiltersWithNoteEnum valueOf(String name) =>
      _$searchFiltersWithNoteEnumValueOf(name);
}

class SearchFiltersFavouritesEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'include')
  static const SearchFiltersFavouritesEnum include =
      _$searchFiltersFavouritesEnum_include;
  @BuiltValueEnumConst(wireName: r'only')
  static const SearchFiltersFavouritesEnum only =
      _$searchFiltersFavouritesEnum_only;
  @BuiltValueEnumConst(wireName: r'exclude')
  static const SearchFiltersFavouritesEnum exclude =
      _$searchFiltersFavouritesEnum_exclude;

  static Serializer<SearchFiltersFavouritesEnum> get serializer =>
      _$searchFiltersFavouritesEnumSerializer;

  const SearchFiltersFavouritesEnum._(String name) : super(name);

  static BuiltSet<SearchFiltersFavouritesEnum> get values =>
      _$searchFiltersFavouritesEnumValues;
  static SearchFiltersFavouritesEnum valueOf(String name) =>
      _$searchFiltersFavouritesEnumValueOf(name);
}

class SearchFiltersPressesEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'all')
  static const SearchFiltersPressesEnum all = _$searchFiltersPressesEnum_all;
  @BuiltValueEnumConst(wireName: r'single')
  static const SearchFiltersPressesEnum single =
      _$searchFiltersPressesEnum_single;
  @BuiltValueEnumConst(wireName: r'multiple')
  static const SearchFiltersPressesEnum multiple =
      _$searchFiltersPressesEnum_multiple;

  static Serializer<SearchFiltersPressesEnum> get serializer =>
      _$searchFiltersPressesEnumSerializer;

  const SearchFiltersPressesEnum._(String name) : super(name);

  static BuiltSet<SearchFiltersPressesEnum> get values =>
      _$searchFiltersPressesEnumValues;
  static SearchFiltersPressesEnum valueOf(String name) =>
      _$searchFiltersPressesEnumValueOf(name);
}
