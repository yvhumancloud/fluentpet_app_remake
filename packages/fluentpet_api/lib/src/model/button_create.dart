//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fluentpet_api/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'button_create.g.dart';

/// ButtonCreate
///
/// Properties:
/// * [text]
/// * [note]
/// * [introducedAt]
/// * [buttonConceptId]
@BuiltValue()
abstract class ButtonCreate
    implements Built<ButtonCreate, ButtonCreateBuilder> {
  @BuiltValueField(wireName: r'text')
  String get text;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'introduced_at')
  Date? get introducedAt;

  @BuiltValueField(wireName: r'button_concept_id')
  int? get buttonConceptId;

  ButtonCreate._();

  factory ButtonCreate([void updates(ButtonCreateBuilder b)]) = _$ButtonCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ButtonCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ButtonCreate> get serializer => _$ButtonCreateSerializer();
}

class _$ButtonCreateSerializer implements PrimitiveSerializer<ButtonCreate> {
  @override
  final Iterable<Type> types = const [ButtonCreate, _$ButtonCreate];

  @override
  final String wireName = r'ButtonCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ButtonCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'text';
    yield serializers.serialize(
      object.text,
      specifiedType: const FullType(String),
    );
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
  }

  @override
  Object serialize(
    Serializers serializers,
    ButtonCreate object, {
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
    required ButtonCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ButtonCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ButtonCreateBuilder();
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
