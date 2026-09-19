//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fluentpet_api/src/model/base_button_out.dart';
import 'package:fluentpet_api/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'button_out.g.dart';

/// ButtonOut
///
/// Properties:
/// * [id]
/// * [text]
/// * [word]
/// * [normalizedWord]
/// * [introducedAt]
/// * [buttonConceptId]
/// * [isHidden]
/// * [note]
/// * [origin]
/// * [audioId]
/// * [webhookUrl]
/// * [createdAt]
/// * [baseButton]
/// * [pressCount]
@BuiltValue()
abstract class ButtonOut implements Built<ButtonOut, ButtonOutBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'text')
  String get text;

  @BuiltValueField(wireName: r'word')
  String get word;

  @BuiltValueField(wireName: r'normalized_word')
  String get normalizedWord;

  @BuiltValueField(wireName: r'introduced_at')
  Date? get introducedAt;

  @BuiltValueField(wireName: r'button_concept_id')
  int? get buttonConceptId;

  @BuiltValueField(wireName: r'is_hidden')
  bool get isHidden;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'origin')
  String get origin;

  @BuiltValueField(wireName: r'audio_id')
  int? get audioId;

  @BuiltValueField(wireName: r'webhook_url')
  String? get webhookUrl;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'base_button')
  BaseButtonOut? get baseButton;

  @BuiltValueField(wireName: r'press_count')
  int get pressCount;

  ButtonOut._();

  factory ButtonOut([void updates(ButtonOutBuilder b)]) = _$ButtonOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ButtonOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ButtonOut> get serializer => _$ButtonOutSerializer();
}

class _$ButtonOutSerializer implements PrimitiveSerializer<ButtonOut> {
  @override
  final Iterable<Type> types = const [ButtonOut, _$ButtonOut];

  @override
  final String wireName = r'ButtonOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ButtonOut object, {
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
    yield r'word';
    yield serializers.serialize(
      object.word,
      specifiedType: const FullType(String),
    );
    yield r'normalized_word';
    yield serializers.serialize(
      object.normalizedWord,
      specifiedType: const FullType(String),
    );
    yield r'introduced_at';
    yield object.introducedAt == null
        ? null
        : serializers.serialize(
            object.introducedAt,
            specifiedType: const FullType.nullable(Date),
          );
    yield r'button_concept_id';
    yield object.buttonConceptId == null
        ? null
        : serializers.serialize(
            object.buttonConceptId,
            specifiedType: const FullType.nullable(int),
          );
    yield r'is_hidden';
    yield serializers.serialize(
      object.isHidden,
      specifiedType: const FullType(bool),
    );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
    yield r'origin';
    yield serializers.serialize(
      object.origin,
      specifiedType: const FullType(String),
    );
    yield r'audio_id';
    yield object.audioId == null
        ? null
        : serializers.serialize(
            object.audioId,
            specifiedType: const FullType.nullable(int),
          );
    yield r'webhook_url';
    yield object.webhookUrl == null
        ? null
        : serializers.serialize(
            object.webhookUrl,
            specifiedType: const FullType.nullable(String),
          );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'base_button';
    yield object.baseButton == null
        ? null
        : serializers.serialize(
            object.baseButton,
            specifiedType: const FullType.nullable(BaseButtonOut),
          );
    yield r'press_count';
    yield serializers.serialize(
      object.pressCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ButtonOut object, {
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
    required ButtonOutBuilder result,
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
        case r'word':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.word = valueDes;
          break;
        case r'normalized_word':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.normalizedWord = valueDes;
          break;
        case r'introduced_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.introducedAt = valueDes;
          break;
        case r'button_concept_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.buttonConceptId = valueDes;
          break;
        case r'is_hidden':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isHidden = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'origin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.origin = valueDes;
          break;
        case r'audio_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.audioId = valueDes;
          break;
        case r'webhook_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.webhookUrl = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'base_button':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BaseButtonOut),
          ) as BaseButtonOut?;
          if (valueDes == null) continue;
          result.baseButton.replace(valueDes);
          break;
        case r'press_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pressCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ButtonOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ButtonOutBuilder();
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
