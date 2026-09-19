//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'learner_type_out.g.dart';

/// LearnerTypeOut
///
/// Properties:
/// * [id]
/// * [name]
@BuiltValue()
abstract class LearnerTypeOut
    implements Built<LearnerTypeOut, LearnerTypeOutBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  LearnerTypeOut._();

  factory LearnerTypeOut([void updates(LearnerTypeOutBuilder b)]) =
      _$LearnerTypeOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LearnerTypeOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LearnerTypeOut> get serializer =>
      _$LearnerTypeOutSerializer();
}

class _$LearnerTypeOutSerializer
    implements PrimitiveSerializer<LearnerTypeOut> {
  @override
  final Iterable<Type> types = const [LearnerTypeOut, _$LearnerTypeOut];

  @override
  final String wireName = r'LearnerTypeOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LearnerTypeOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LearnerTypeOut object, {
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
    required LearnerTypeOutBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LearnerTypeOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LearnerTypeOutBuilder();
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
