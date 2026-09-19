//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_counts.g.dart';

/// SearchCounts
///
/// Properties:
/// * [communication]
/// * [modeling]
/// * [unassigned]
@BuiltValue()
abstract class SearchCounts
    implements Built<SearchCounts, SearchCountsBuilder> {
  @BuiltValueField(wireName: r'communication')
  int get communication;

  @BuiltValueField(wireName: r'modeling')
  int get modeling;

  @BuiltValueField(wireName: r'unassigned')
  int get unassigned;

  SearchCounts._();

  factory SearchCounts([void updates(SearchCountsBuilder b)]) = _$SearchCounts;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SearchCountsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SearchCounts> get serializer => _$SearchCountsSerializer();
}

class _$SearchCountsSerializer implements PrimitiveSerializer<SearchCounts> {
  @override
  final Iterable<Type> types = const [SearchCounts, _$SearchCounts];

  @override
  final String wireName = r'SearchCounts';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SearchCounts object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'communication';
    yield serializers.serialize(
      object.communication,
      specifiedType: const FullType(int),
    );
    yield r'modeling';
    yield serializers.serialize(
      object.modeling,
      specifiedType: const FullType(int),
    );
    yield r'unassigned';
    yield serializers.serialize(
      object.unassigned,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SearchCounts object, {
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
    required SearchCountsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'communication':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.communication = valueDes;
          break;
        case r'modeling':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.modeling = valueDes;
          break;
        case r'unassigned':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unassigned = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SearchCounts deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SearchCountsBuilder();
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
