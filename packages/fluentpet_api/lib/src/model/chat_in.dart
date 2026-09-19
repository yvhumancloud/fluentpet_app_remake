//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fluentpet_api/src/model/chat_message.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_in.g.dart';

/// ChatIn
///
/// Properties:
/// * [messages]
@BuiltValue()
abstract class ChatIn implements Built<ChatIn, ChatInBuilder> {
  @BuiltValueField(wireName: r'messages')
  BuiltList<ChatMessage> get messages;

  ChatIn._();

  factory ChatIn([void updates(ChatInBuilder b)]) = _$ChatIn;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatInBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatIn> get serializer => _$ChatInSerializer();
}

class _$ChatInSerializer implements PrimitiveSerializer<ChatIn> {
  @override
  final Iterable<Type> types = const [ChatIn, _$ChatIn];

  @override
  final String wireName = r'ChatIn';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatIn object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'messages';
    yield serializers.serialize(
      object.messages,
      specifiedType: const FullType(BuiltList, [FullType(ChatMessage)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatIn object, {
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
    required ChatInBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'messages':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ChatMessage)]),
          ) as BuiltList<ChatMessage>;
          result.messages.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatIn deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatInBuilder();
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
