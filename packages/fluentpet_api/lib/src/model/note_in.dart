//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'note_in.g.dart';

/// NoteIn
///
/// Properties:
/// * [text]
/// * [occurredAt]
/// * [deviceTimezone]
/// * [isFavourite]
@BuiltValue()
abstract class NoteIn implements Built<NoteIn, NoteInBuilder> {
  @BuiltValueField(wireName: r'text')
  String get text;

  @BuiltValueField(wireName: r'occurred_at')
  DateTime get occurredAt;

  @BuiltValueField(wireName: r'device_timezone')
  String? get deviceTimezone;

  @BuiltValueField(wireName: r'is_favourite')
  bool? get isFavourite;

  NoteIn._();

  factory NoteIn([void updates(NoteInBuilder b)]) = _$NoteIn;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NoteInBuilder b) => b..isFavourite = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<NoteIn> get serializer => _$NoteInSerializer();
}

class _$NoteInSerializer implements PrimitiveSerializer<NoteIn> {
  @override
  final Iterable<Type> types = const [NoteIn, _$NoteIn];

  @override
  final String wireName = r'NoteIn';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NoteIn object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'text';
    yield serializers.serialize(
      object.text,
      specifiedType: const FullType(String),
    );
    yield r'occurred_at';
    yield serializers.serialize(
      object.occurredAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.deviceTimezone != null) {
      yield r'device_timezone';
      yield serializers.serialize(
        object.deviceTimezone,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.isFavourite != null) {
      yield r'is_favourite';
      yield serializers.serialize(
        object.isFavourite,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    NoteIn object, {
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
    required NoteInBuilder result,
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
        case r'occurred_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.occurredAt = valueDes;
          break;
        case r'device_timezone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.deviceTimezone = valueDes;
          break;
        case r'is_favourite':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isFavourite = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NoteIn deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NoteInBuilder();
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
