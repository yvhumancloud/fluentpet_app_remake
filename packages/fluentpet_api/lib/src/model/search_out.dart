//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fluentpet_api/src/model/search_counts.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fluentpet_api/src/model/items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_out.g.dart';

/// SearchOut
///
/// Properties:
/// * [items]
/// * [total]
/// * [page]
/// * [perPage]
/// * [counts]
@BuiltValue()
abstract class SearchOut implements Built<SearchOut, SearchOutBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<ItemsInner> get items;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'page')
  int get page;

  @BuiltValueField(wireName: r'per_page')
  int get perPage;

  @BuiltValueField(wireName: r'counts')
  SearchCounts get counts;

  SearchOut._();

  factory SearchOut([void updates(SearchOutBuilder b)]) = _$SearchOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SearchOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SearchOut> get serializer => _$SearchOutSerializer();
}

class _$SearchOutSerializer implements PrimitiveSerializer<SearchOut> {
  @override
  final Iterable<Type> types = const [SearchOut, _$SearchOut];

  @override
  final String wireName = r'SearchOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SearchOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(ItemsInner)]),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'page';
    yield serializers.serialize(
      object.page,
      specifiedType: const FullType(int),
    );
    yield r'per_page';
    yield serializers.serialize(
      object.perPage,
      specifiedType: const FullType(int),
    );
    yield r'counts';
    yield serializers.serialize(
      object.counts,
      specifiedType: const FullType(SearchCounts),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SearchOut object, {
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
    required SearchOutBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ItemsInner)]),
          ) as BuiltList<ItemsInner>;
          result.items.replace(valueDes);
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.page = valueDes;
          break;
        case r'per_page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.perPage = valueDes;
          break;
        case r'counts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SearchCounts),
          ) as SearchCounts;
          result.counts.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SearchOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SearchOutBuilder();
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
