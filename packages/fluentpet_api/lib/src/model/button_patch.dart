//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fluentpet_api/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'button_patch.g.dart';

/// ButtonPatch
///
/// Properties:
/// * [text]
/// * [note]
/// * [introducedAt]
/// * [buttonConceptId]
/// * [isHidden]
/// * [audioId]
/// * [webhookUrl]
@BuiltValue()
abstract class ButtonPatch implements Built<ButtonPatch, ButtonPatchBuilder> {
  @BuiltValueField(wireName: r'text')
  String? get text;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'introduced_at')
  Date? get introducedAt;

  @BuiltValueField(wireName: r'button_concept_id')
  int? get buttonConceptId;

  @BuiltValueField(wireName: r'is_hidden')
  bool? get isHidden;

  @BuiltValueField(wireName: r'audio_id')
  int? get audioId;

  @BuiltValueField(wireName: r'webhook_url')
  String? get webhookUrl;

  ButtonPatch._();

  factory ButtonPatch([void updates(ButtonPatchBuilder b)]) = _$ButtonPatch;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ButtonPatchBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ButtonPatch> get serializer => _$ButtonPatchSerializer();
}

class _$ButtonPatchSerializer implements PrimitiveSerializer<ButtonPatch> {
  @override
  final Iterable<Type> types = const [ButtonPatch, _$ButtonPatch];

  @override
  final String wireName = r'ButtonPatch';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ButtonPatch object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.text != null) {
      yield r'text';
      yield serializers.serialize(
        object.text,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.introducedAt != null) {
      yield r'introduced_at';
      yield serializers.serialize(
        object.introducedAt,
        specifiedType: const FullType.nullable(Date),
      );
    }
    if (object.buttonConceptId != null) {
      yield r'button_concept_id';
      yield serializers.serialize(
        object.buttonConceptId,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.isHidden != null) {
      yield r'is_hidden';
      yield serializers.serialize(
        object.isHidden,
        specifiedType: const FullType.nullable(bool),
      );
    }
    if (object.audioId != null) {
      yield r'audio_id';
      yield serializers.serialize(
        object.audioId,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.webhookUrl != null) {
      yield r'webhook_url';
      yield serializers.serialize(
        object.webhookUrl,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ButtonPatch object, {
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
    required ButtonPatchBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.text = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
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
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isHidden = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ButtonPatch deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ButtonPatchBuilder();
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
