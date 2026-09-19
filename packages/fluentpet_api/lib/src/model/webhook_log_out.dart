//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'webhook_log_out.g.dart';

/// WebhookLogOut
///
/// Properties:
/// * [id]
/// * [url]
/// * [statusCode]
/// * [requestedAt]
/// * [respondedAt]
@BuiltValue()
abstract class WebhookLogOut
    implements Built<WebhookLogOut, WebhookLogOutBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'url')
  String get url;

  @BuiltValueField(wireName: r'status_code')
  int? get statusCode;

  @BuiltValueField(wireName: r'requested_at')
  DateTime get requestedAt;

  @BuiltValueField(wireName: r'responded_at')
  DateTime? get respondedAt;

  WebhookLogOut._();

  factory WebhookLogOut([void updates(WebhookLogOutBuilder b)]) =
      _$WebhookLogOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WebhookLogOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WebhookLogOut> get serializer =>
      _$WebhookLogOutSerializer();
}

class _$WebhookLogOutSerializer implements PrimitiveSerializer<WebhookLogOut> {
  @override
  final Iterable<Type> types = const [WebhookLogOut, _$WebhookLogOut];

  @override
  final String wireName = r'WebhookLogOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WebhookLogOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
    yield r'status_code';
    yield object.statusCode == null
        ? null
        : serializers.serialize(
            object.statusCode,
            specifiedType: const FullType.nullable(int),
          );
    yield r'requested_at';
    yield serializers.serialize(
      object.requestedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'responded_at';
    yield object.respondedAt == null
        ? null
        : serializers.serialize(
            object.respondedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    WebhookLogOut object, {
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
    required WebhookLogOutBuilder result,
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
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        case r'status_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.statusCode = valueDes;
          break;
        case r'requested_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.requestedAt = valueDes;
          break;
        case r'responded_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.respondedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WebhookLogOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WebhookLogOutBuilder();
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
