//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'preference_in.g.dart';

/// PreferenceIn
///
/// Properties:
/// * [value]
@BuiltValue()
abstract class PreferenceIn
    implements Built<PreferenceIn, PreferenceInBuilder> {
  @BuiltValueField(wireName: r'value')
  JsonObject? get value;

  PreferenceIn._();

  factory PreferenceIn([void updates(PreferenceInBuilder b)]) = _$PreferenceIn;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PreferenceInBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PreferenceIn> get serializer => _$PreferenceInSerializer();
}

class _$PreferenceInSerializer implements PrimitiveSerializer<PreferenceIn> {
  @override
  final Iterable<Type> types = const [PreferenceIn, _$PreferenceIn];

  @override
  final String wireName = r'PreferenceIn';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PreferenceIn object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    PreferenceIn object, {
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
    required PreferenceInBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  PreferenceIn deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PreferenceInBuilder();
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
