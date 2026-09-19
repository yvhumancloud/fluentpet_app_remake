//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'press_out.g.dart';

/// PressOut
///
/// Properties:
/// * [id]
/// * [buttonId]
/// * [text]
/// * [pressOrder]
/// * [occurredAt]
@BuiltValue()
abstract class PressOut implements Built<PressOut, PressOutBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'button_id')
  int get buttonId;

  @BuiltValueField(wireName: r'text')
  String get text;

  @BuiltValueField(wireName: r'press_order')
  int get pressOrder;

  @BuiltValueField(wireName: r'occurred_at')
  DateTime? get occurredAt;

  PressOut._();

  factory PressOut([void updates(PressOutBuilder b)]) = _$PressOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PressOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PressOut> get serializer => _$PressOutSerializer();
}

class _$PressOutSerializer implements PrimitiveSerializer<PressOut> {
  @override
  final Iterable<Type> types = const [PressOut, _$PressOut];

  @override
  final String wireName = r'PressOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PressOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'button_id';
    yield serializers.serialize(
      object.buttonId,
      specifiedType: const FullType(int),
    );
    yield r'text';
    yield serializers.serialize(
      object.text,
      specifiedType: const FullType(String),
    );
    yield r'press_order';
    yield serializers.serialize(
      object.pressOrder,
      specifiedType: const FullType(int),
    );
    yield r'occurred_at';
    yield object.occurredAt == null
        ? null
        : serializers.serialize(
            object.occurredAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    PressOut object, {
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
    required PressOutBuilder result,
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
        case r'button_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.buttonId = valueDes;
          break;
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.text = valueDes;
          break;
        case r'press_order':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pressOrder = valueDes;
          break;
        case r'occurred_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.occurredAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PressOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PressOutBuilder();
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
