//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'push_token_in.g.dart';

/// PushTokenIn
///
/// Properties:
/// * [token]
/// * [platform]
@BuiltValue()
abstract class PushTokenIn implements Built<PushTokenIn, PushTokenInBuilder> {
  @BuiltValueField(wireName: r'token')
  String get token;

  @BuiltValueField(wireName: r'platform')
  String? get platform;

  PushTokenIn._();

  factory PushTokenIn([void updates(PushTokenInBuilder b)]) = _$PushTokenIn;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PushTokenInBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PushTokenIn> get serializer => _$PushTokenInSerializer();
}

class _$PushTokenInSerializer implements PrimitiveSerializer<PushTokenIn> {
  @override
  final Iterable<Type> types = const [PushTokenIn, _$PushTokenIn];

  @override
  final String wireName = r'PushTokenIn';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PushTokenIn object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'token';
    yield serializers.serialize(
      object.token,
      specifiedType: const FullType(String),
    );
    if (object.platform != null) {
      yield r'platform';
      yield serializers.serialize(
        object.platform,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PushTokenIn object, {
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
    required PushTokenInBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.token = valueDes;
          break;
        case r'platform':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.platform = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PushTokenIn deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PushTokenInBuilder();
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
