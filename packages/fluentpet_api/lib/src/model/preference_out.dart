//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'preference_out.g.dart';

/// PreferenceOut
///
/// Properties:
/// * [key]
/// * [value]
@BuiltValue()
abstract class PreferenceOut
    implements Built<PreferenceOut, PreferenceOutBuilder> {
  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'value')
  JsonObject? get value;

  PreferenceOut._();

  factory PreferenceOut([void updates(PreferenceOutBuilder b)]) =
      _$PreferenceOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PreferenceOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PreferenceOut> get serializer =>
      _$PreferenceOutSerializer();
}

class _$PreferenceOutSerializer implements PrimitiveSerializer<PreferenceOut> {
  @override
  final Iterable<Type> types = const [PreferenceOut, _$PreferenceOut];

  @override
  final String wireName = r'PreferenceOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PreferenceOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'value';
    yield object.value == null
        ? null
        : serializers.serialize(
            object.value,
            specifiedType: const FullType.nullable(JsonObject),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    PreferenceOut object, {
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
    required PreferenceOutBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.key = valueDes;
          break;
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.value = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PreferenceOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PreferenceOutBuilder();
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
