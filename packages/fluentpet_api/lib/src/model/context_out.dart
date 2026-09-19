//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'context_out.g.dart';

/// ContextOut
///
/// Properties:
/// * [id]
/// * [householdId]
/// * [text]
/// * [appliesTo]
@BuiltValue()
abstract class ContextOut implements Built<ContextOut, ContextOutBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'household_id')
  int? get householdId;

  @BuiltValueField(wireName: r'text')
  String get text;

  @BuiltValueField(wireName: r'applies_to')
  String get appliesTo;

  ContextOut._();

  factory ContextOut([void updates(ContextOutBuilder b)]) = _$ContextOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContextOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContextOut> get serializer => _$ContextOutSerializer();
}

class _$ContextOutSerializer implements PrimitiveSerializer<ContextOut> {
  @override
  final Iterable<Type> types = const [ContextOut, _$ContextOut];

  @override
  final String wireName = r'ContextOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContextOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'household_id';
    yield object.householdId == null
        ? null
        : serializers.serialize(
            object.householdId,
            specifiedType: const FullType.nullable(int),
          );
    yield r'text';
    yield serializers.serialize(
      object.text,
      specifiedType: const FullType(String),
    );
    yield r'applies_to';
    yield serializers.serialize(
      object.appliesTo,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ContextOut object, {
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
    required ContextOutBuilder result,
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
        case r'household_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.householdId = valueDes;
          break;
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
            specifiedType: const FullType(String),
          ) as String;
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
  ContextOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContextOutBuilder();
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
