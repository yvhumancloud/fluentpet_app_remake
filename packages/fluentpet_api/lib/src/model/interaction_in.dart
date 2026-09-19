//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'interaction_in.g.dart';

/// InteractionIn
///
/// Properties:
/// * [pusherId]
/// * [note]
/// * [occurredAt]
/// * [deviceTimezone]
/// * [isFavourite]
/// * [buttonIds]
/// * [contextIds]
/// * [modeledPusherIds]
@BuiltValue()
abstract class InteractionIn
    implements Built<InteractionIn, InteractionInBuilder> {
  @BuiltValueField(wireName: r'pusher_id')
  int? get pusherId;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'occurred_at')
  DateTime get occurredAt;

  @BuiltValueField(wireName: r'device_timezone')
  String? get deviceTimezone;

  @BuiltValueField(wireName: r'is_favourite')
  bool? get isFavourite;

  @BuiltValueField(wireName: r'button_ids')
  BuiltList<int>? get buttonIds;

  @BuiltValueField(wireName: r'context_ids')
  BuiltList<int>? get contextIds;

  @BuiltValueField(wireName: r'modeled_pusher_ids')
  BuiltList<int>? get modeledPusherIds;

  InteractionIn._();

  factory InteractionIn([void updates(InteractionInBuilder b)]) =
      _$InteractionIn;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InteractionInBuilder b) => b
    ..isFavourite = false
    ..buttonIds = ListBuilder()
    ..contextIds = ListBuilder()
    ..modeledPusherIds = ListBuilder();

  @BuiltValueSerializer(custom: true)
  static Serializer<InteractionIn> get serializer =>
      _$InteractionInSerializer();
}

class _$InteractionInSerializer implements PrimitiveSerializer<InteractionIn> {
  @override
  final Iterable<Type> types = const [InteractionIn, _$InteractionIn];

  @override
  final String wireName = r'InteractionIn';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InteractionIn object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.pusherId != null) {
      yield r'pusher_id';
      yield serializers.serialize(
        object.pusherId,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType.nullable(String),
      );
    }
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
    if (object.buttonIds != null) {
      yield r'button_ids';
      yield serializers.serialize(
        object.buttonIds,
        specifiedType: const FullType(BuiltList, [FullType(int)]),
      );
    }
    if (object.contextIds != null) {
      yield r'context_ids';
      yield serializers.serialize(
        object.contextIds,
        specifiedType: const FullType(BuiltList, [FullType(int)]),
      );
    }
    if (object.modeledPusherIds != null) {
      yield r'modeled_pusher_ids';
      yield serializers.serialize(
        object.modeledPusherIds,
        specifiedType: const FullType(BuiltList, [FullType(int)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    InteractionIn object, {
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
    required InteractionInBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pusher_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.pusherId = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
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
        case r'button_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(int)]),
          ) as BuiltList<int>?;
          if (valueDes == null) continue;
          result.buttonIds.replace(valueDes);
          break;
        case r'context_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(int)]),
          ) as BuiltList<int>?;
          if (valueDes == null) continue;
          result.contextIds.replace(valueDes);
          break;
        case r'modeled_pusher_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(int)]),
          ) as BuiltList<int>?;
          if (valueDes == null) continue;
          result.modeledPusherIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InteractionIn deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InteractionInBuilder();
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
