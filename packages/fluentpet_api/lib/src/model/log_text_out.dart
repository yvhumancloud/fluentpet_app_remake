//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fluentpet_api/src/model/interaction_in.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'log_text_out.g.dart';

/// LogTextOut
///
/// Properties:
/// * [draft]
/// * [unmatchedWords]
@BuiltValue()
abstract class LogTextOut implements Built<LogTextOut, LogTextOutBuilder> {
  @BuiltValueField(wireName: r'draft')
  InteractionIn get draft;

  @BuiltValueField(wireName: r'unmatched_words')
  BuiltList<String> get unmatchedWords;

  LogTextOut._();

  factory LogTextOut([void updates(LogTextOutBuilder b)]) = _$LogTextOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LogTextOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LogTextOut> get serializer => _$LogTextOutSerializer();
}

class _$LogTextOutSerializer implements PrimitiveSerializer<LogTextOut> {
  @override
  final Iterable<Type> types = const [LogTextOut, _$LogTextOut];

  @override
  final String wireName = r'LogTextOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LogTextOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'draft';
    yield serializers.serialize(
      object.draft,
      specifiedType: const FullType(InteractionIn),
    );
    yield r'unmatched_words';
    yield serializers.serialize(
      object.unmatchedWords,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LogTextOut object, {
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
    required LogTextOutBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'draft':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InteractionIn),
          ) as InteractionIn;
          result.draft.replace(valueDes);
          break;
        case r'unmatched_words':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.unmatchedWords.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LogTextOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LogTextOutBuilder();
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
