//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'note_patch.g.dart';

/// NotePatch
///
/// Properties:
/// * [text]
/// * [occurredAt]
/// * [deviceTimezone]
/// * [isFavourite]
/// * [isHidden]
@BuiltValue()
abstract class NotePatch implements Built<NotePatch, NotePatchBuilder> {
  @BuiltValueField(wireName: r'text')
  String? get text;

  @BuiltValueField(wireName: r'occurred_at')
  DateTime? get occurredAt;

  @BuiltValueField(wireName: r'device_timezone')
  String? get deviceTimezone;

  @BuiltValueField(wireName: r'is_favourite')
  bool? get isFavourite;

  @BuiltValueField(wireName: r'is_hidden')
  bool? get isHidden;

  NotePatch._();

  factory NotePatch([void updates(NotePatchBuilder b)]) = _$NotePatch;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotePatchBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotePatch> get serializer => _$NotePatchSerializer();
}

class _$NotePatchSerializer implements PrimitiveSerializer<NotePatch> {
  @override
  final Iterable<Type> types = const [NotePatch, _$NotePatch];

  @override
  final String wireName = r'NotePatch';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotePatch object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.text != null) {
      yield r'text';
      yield serializers.serialize(
        object.text,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.occurredAt != null) {
      yield r'occurred_at';
      yield serializers.serialize(
        object.occurredAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
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
        specifiedType: const FullType.nullable(bool),
      );
    }
    if (object.isHidden != null) {
      yield r'is_hidden';
      yield serializers.serialize(
        object.isHidden,
        specifiedType: const FullType.nullable(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    NotePatch object, {
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
    required NotePatchBuilder result,
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
        case r'occurred_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
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
        case r'is_hidden':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isHidden = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NotePatch deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotePatchBuilder();
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
