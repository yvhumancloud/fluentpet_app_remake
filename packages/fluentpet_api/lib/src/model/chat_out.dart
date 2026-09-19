//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_out.g.dart';

/// ChatOut
///
/// Properties:
/// * [reply]
/// * [remainingToday]
@BuiltValue()
abstract class ChatOut implements Built<ChatOut, ChatOutBuilder> {
  @BuiltValueField(wireName: r'reply')
  String get reply;

  @BuiltValueField(wireName: r'remaining_today')
  int get remainingToday;

  ChatOut._();

  factory ChatOut([void updates(ChatOutBuilder b)]) = _$ChatOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatOut> get serializer => _$ChatOutSerializer();
}

class _$ChatOutSerializer implements PrimitiveSerializer<ChatOut> {
  @override
  final Iterable<Type> types = const [ChatOut, _$ChatOut];

  @override
  final String wireName = r'ChatOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reply';
    yield serializers.serialize(
      object.reply,
      specifiedType: const FullType(String),
    );
    yield r'remaining_today';
    yield serializers.serialize(
      object.remainingToday,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatOut object, {
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
    required ChatOutBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reply':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reply = valueDes;
          break;
        case r'remaining_today':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.remainingToday = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatOutBuilder();
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
