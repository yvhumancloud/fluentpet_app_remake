//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'button_merge.g.dart';

/// ButtonMerge
///
/// Properties:
/// * [sourceId]
/// * [targetId]
@BuiltValue()
abstract class ButtonMerge implements Built<ButtonMerge, ButtonMergeBuilder> {
  @BuiltValueField(wireName: r'source_id')
  int get sourceId;

  @BuiltValueField(wireName: r'target_id')
  int get targetId;

  ButtonMerge._();

  factory ButtonMerge([void updates(ButtonMergeBuilder b)]) = _$ButtonMerge;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ButtonMergeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ButtonMerge> get serializer => _$ButtonMergeSerializer();
}

class _$ButtonMergeSerializer implements PrimitiveSerializer<ButtonMerge> {
  @override
  final Iterable<Type> types = const [ButtonMerge, _$ButtonMerge];

  @override
  final String wireName = r'ButtonMerge';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ButtonMerge object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'source_id';
    yield serializers.serialize(
      object.sourceId,
      specifiedType: const FullType(int),
    );
    yield r'target_id';
    yield serializers.serialize(
      object.targetId,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ButtonMerge object, {
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
    required ButtonMergeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'source_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sourceId = valueDes;
          break;
        case r'target_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.targetId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ButtonMerge deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ButtonMergeBuilder();
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
