//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'context_create.g.dart';

/// ContextCreate
///
/// Properties:
/// * [text]
/// * [appliesTo]
@BuiltValue()
abstract class ContextCreate
    implements Built<ContextCreate, ContextCreateBuilder> {
  @BuiltValueField(wireName: r'text')
  String get text;

  @BuiltValueField(wireName: r'applies_to')
  ContextCreateAppliesToEnum? get appliesTo;
  // enum appliesToEnum {  human,  learner,  both,  };

  ContextCreate._();

  factory ContextCreate([void updates(ContextCreateBuilder b)]) =
      _$ContextCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContextCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContextCreate> get serializer =>
      _$ContextCreateSerializer();
}

class _$ContextCreateSerializer implements PrimitiveSerializer<ContextCreate> {
  @override
  final Iterable<Type> types = const [ContextCreate, _$ContextCreate];

  @override
  final String wireName = r'ContextCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContextCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'text';
    yield serializers.serialize(
      object.text,
      specifiedType: const FullType(String),
    );
    if (object.appliesTo != null) {
      yield r'applies_to';
      yield serializers.serialize(
        object.appliesTo,
        specifiedType: const FullType(ContextCreateAppliesToEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ContextCreate object, {
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
    required ContextCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.text = valueDes;
          break;
        case r'applies_to':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ContextCreateAppliesToEnum),
          ) as ContextCreateAppliesToEnum?;
          if (valueDes == null) continue;
          result.appliesTo = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ContextCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContextCreateBuilder();
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

class ContextCreateAppliesToEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'human')
  static const ContextCreateAppliesToEnum human =
      _$contextCreateAppliesToEnum_human;
  @BuiltValueEnumConst(wireName: r'learner')
  static const ContextCreateAppliesToEnum learner =
      _$contextCreateAppliesToEnum_learner;
  @BuiltValueEnumConst(wireName: r'both')
  static const ContextCreateAppliesToEnum both =
      _$contextCreateAppliesToEnum_both;

  static Serializer<ContextCreateAppliesToEnum> get serializer =>
      _$contextCreateAppliesToEnumSerializer;

  const ContextCreateAppliesToEnum._(String name) : super(name);

  static BuiltSet<ContextCreateAppliesToEnum> get values =>
      _$contextCreateAppliesToEnumValues;
  static ContextCreateAppliesToEnum valueOf(String name) =>
      _$contextCreateAppliesToEnumValueOf(name);
}
