//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fluentpet_api/src/model/search_filters.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_in.g.dart';

/// SearchIn
///
/// Properties:
/// * [page]
/// * [perPage]
/// * [sort]
/// * [tab]
/// * [filters]
@BuiltValue()
abstract class SearchIn implements Built<SearchIn, SearchInBuilder> {
  @BuiltValueField(wireName: r'page')
  int? get page;

  @BuiltValueField(wireName: r'per_page')
  int? get perPage;

  @BuiltValueField(wireName: r'sort')
  SearchInSortEnum? get sort;
  // enum sortEnum {  occurred_at_desc,  occurred_at_asc,  created_at_desc,  };

  @BuiltValueField(wireName: r'tab')
  SearchInTabEnum? get tab;
  // enum tabEnum {  all,  assigned,  unassigned,  };

  @BuiltValueField(wireName: r'filters')
  SearchFilters? get filters;

  SearchIn._();

  factory SearchIn([void updates(SearchInBuilder b)]) = _$SearchIn;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SearchInBuilder b) => b
    ..page = 1
    ..perPage = 45;

  @BuiltValueSerializer(custom: true)
  static Serializer<SearchIn> get serializer => _$SearchInSerializer();
}

class _$SearchInSerializer implements PrimitiveSerializer<SearchIn> {
  @override
  final Iterable<Type> types = const [SearchIn, _$SearchIn];

  @override
  final String wireName = r'SearchIn';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SearchIn object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.page != null) {
      yield r'page';
      yield serializers.serialize(
        object.page,
        specifiedType: const FullType(int),
      );
    }
    if (object.perPage != null) {
      yield r'per_page';
      yield serializers.serialize(
        object.perPage,
        specifiedType: const FullType(int),
      );
    }
    if (object.sort != null) {
      yield r'sort';
      yield serializers.serialize(
        object.sort,
        specifiedType: const FullType(SearchInSortEnum),
      );
    }
    if (object.tab != null) {
      yield r'tab';
      yield serializers.serialize(
        object.tab,
        specifiedType: const FullType(SearchInTabEnum),
      );
    }
    if (object.filters != null) {
      yield r'filters';
      yield serializers.serialize(
        object.filters,
        specifiedType: const FullType(SearchFilters),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SearchIn object, {
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
    required SearchInBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.page = valueDes;
          break;
        case r'per_page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.perPage = valueDes;
          break;
        case r'sort':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SearchInSortEnum),
          ) as SearchInSortEnum?;
          if (valueDes == null) continue;
          result.sort = valueDes;
          break;
        case r'tab':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SearchInTabEnum),
          ) as SearchInTabEnum?;
          if (valueDes == null) continue;
          result.tab = valueDes;
          break;
        case r'filters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SearchFilters),
          ) as SearchFilters?;
          if (valueDes == null) continue;
          result.filters.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SearchIn deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SearchInBuilder();
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

class SearchInSortEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'occurred_at_desc')
  static const SearchInSortEnum occurredAtDesc =
      _$searchInSortEnum_occurredAtDesc;
  @BuiltValueEnumConst(wireName: r'occurred_at_asc')
  static const SearchInSortEnum occurredAtAsc =
      _$searchInSortEnum_occurredAtAsc;
  @BuiltValueEnumConst(wireName: r'created_at_desc')
  static const SearchInSortEnum createdAtDesc =
      _$searchInSortEnum_createdAtDesc;

  static Serializer<SearchInSortEnum> get serializer =>
      _$searchInSortEnumSerializer;

  const SearchInSortEnum._(String name) : super(name);

  static BuiltSet<SearchInSortEnum> get values => _$searchInSortEnumValues;
  static SearchInSortEnum valueOf(String name) =>
      _$searchInSortEnumValueOf(name);
}

class SearchInTabEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'all')
  static const SearchInTabEnum all = _$searchInTabEnum_all;
  @BuiltValueEnumConst(wireName: r'assigned')
  static const SearchInTabEnum assigned = _$searchInTabEnum_assigned;
  @BuiltValueEnumConst(wireName: r'unassigned')
  static const SearchInTabEnum unassigned = _$searchInTabEnum_unassigned;

  static Serializer<SearchInTabEnum> get serializer =>
      _$searchInTabEnumSerializer;

  const SearchInTabEnum._(String name) : super(name);

  static BuiltSet<SearchInTabEnum> get values => _$searchInTabEnumValues;
  static SearchInTabEnum valueOf(String name) => _$searchInTabEnumValueOf(name);
}
