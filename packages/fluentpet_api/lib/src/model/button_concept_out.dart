//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'button_concept_out.g.dart';

/// ButtonConceptOut
///
/// Properties:
/// * [id]
/// * [concept]
@BuiltValue()
abstract class ButtonConceptOut
    implements Built<ButtonConceptOut, ButtonConceptOutBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'concept')
  String get concept;

  ButtonConceptOut._();

  factory ButtonConceptOut([void updates(ButtonConceptOutBuilder b)]) =
      _$ButtonConceptOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ButtonConceptOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ButtonConceptOut> get serializer =>
      _$ButtonConceptOutSerializer();
}

class _$ButtonConceptOutSerializer
    implements PrimitiveSerializer<ButtonConceptOut> {
  @override
  final Iterable<Type> types = const [ButtonConceptOut, _$ButtonConceptOut];

  @override
  final String wireName = r'ButtonConceptOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ButtonConceptOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'concept';
    yield serializers.serialize(
      object.concept,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ButtonConceptOut object, {
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
    required ButtonConceptOutBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'concept':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.concept = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ButtonConceptOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ButtonConceptOutBuilder();
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
