//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'button_ref.g.dart';

/// ButtonRef
///
/// Properties:
/// * [id]
/// * [text]
@BuiltValue()
abstract class ButtonRef implements Built<ButtonRef, ButtonRefBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'text')
  String get text;

  ButtonRef._();

  factory ButtonRef([void updates(ButtonRefBuilder b)]) = _$ButtonRef;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ButtonRefBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ButtonRef> get serializer => _$ButtonRefSerializer();
}

class _$ButtonRefSerializer implements PrimitiveSerializer<ButtonRef> {
  @override
  final Iterable<Type> types = const [ButtonRef, _$ButtonRef];

  @override
  final String wireName = r'ButtonRef';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ButtonRef object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'text';
    yield serializers.serialize(
      object.text,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ButtonRef object, {
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
    required ButtonRefBuilder result,
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
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.text = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ButtonRef deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ButtonRefBuilder();
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
