//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'interaction_merge.g.dart';

/// InteractionMerge
///
/// Properties:
/// * [interactionIds]
@BuiltValue()
abstract class InteractionMerge
    implements Built<InteractionMerge, InteractionMergeBuilder> {
  @BuiltValueField(wireName: r'interaction_ids')
  BuiltList<int> get interactionIds;

  InteractionMerge._();

  factory InteractionMerge([void updates(InteractionMergeBuilder b)]) =
      _$InteractionMerge;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InteractionMergeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InteractionMerge> get serializer =>
      _$InteractionMergeSerializer();
}

class _$InteractionMergeSerializer
    implements PrimitiveSerializer<InteractionMerge> {
  @override
  final Iterable<Type> types = const [InteractionMerge, _$InteractionMerge];

  @override
  final String wireName = r'InteractionMerge';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InteractionMerge object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'interaction_ids';
    yield serializers.serialize(
      object.interactionIds,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InteractionMerge object, {
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
    required InteractionMergeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'interaction_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.interactionIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InteractionMerge deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InteractionMergeBuilder();
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
