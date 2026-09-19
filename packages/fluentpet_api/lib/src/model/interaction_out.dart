//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fluentpet_api/src/model/context_out.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fluentpet_api/src/model/press_out.dart';
import 'package:fluentpet_api/src/model/pusher_out.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'interaction_out.g.dart';

/// InteractionOut
///
/// Properties:
/// * [type]
/// * [id]
/// * [pusherId]
/// * [pusher]
/// * [note]
/// * [occurredAt]
/// * [deviceTimezone]
/// * [origin]
/// * [isFavourite]
/// * [isHidden]
/// * [numPresses]
/// * [durationSeconds]
/// * [presses]
/// * [contexts]
/// * [modeledPushers]
/// * [createdByBaseId]
/// * [createdAt]
/// * [updatedAt]
@BuiltValue()
abstract class InteractionOut
    implements Built<InteractionOut, InteractionOutBuilder> {
  @BuiltValueField(wireName: r'type')
  InteractionOutTypeEnum? get type;
  // enum typeEnum {  interaction,  };

  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'pusher_id')
  int? get pusherId;

  @BuiltValueField(wireName: r'pusher')
  PusherOut? get pusher;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'occurred_at')
  DateTime get occurredAt;

  @BuiltValueField(wireName: r'device_timezone')
  String? get deviceTimezone;

  @BuiltValueField(wireName: r'origin')
  String get origin;

  @BuiltValueField(wireName: r'is_favourite')
  bool get isFavourite;

  @BuiltValueField(wireName: r'is_hidden')
  bool get isHidden;

  @BuiltValueField(wireName: r'num_presses')
  int get numPresses;

  @BuiltValueField(wireName: r'duration_seconds')
  num get durationSeconds;

  @BuiltValueField(wireName: r'presses')
  BuiltList<PressOut> get presses;

  @BuiltValueField(wireName: r'contexts')
  BuiltList<ContextOut> get contexts;

  @BuiltValueField(wireName: r'modeled_pushers')
  BuiltList<PusherOut> get modeledPushers;

  @BuiltValueField(wireName: r'created_by_base_id')
  int? get createdByBaseId;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  InteractionOut._();

  factory InteractionOut([void updates(InteractionOutBuilder b)]) =
      _$InteractionOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InteractionOutBuilder b) =>
      b..type = InteractionOutTypeEnum.valueOf('interaction');

  @BuiltValueSerializer(custom: true)
  static Serializer<InteractionOut> get serializer =>
      _$InteractionOutSerializer();
}

class _$InteractionOutSerializer
    implements PrimitiveSerializer<InteractionOut> {
  @override
  final Iterable<Type> types = const [InteractionOut, _$InteractionOut];

  @override
  final String wireName = r'InteractionOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InteractionOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.type != null) {
      yield r'type';
      yield serializers.serialize(
        object.type,
        specifiedType: const FullType(InteractionOutTypeEnum),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'pusher_id';
    yield object.pusherId == null
        ? null
        : serializers.serialize(
            object.pusherId,
            specifiedType: const FullType.nullable(int),
          );
    yield r'pusher';
    yield object.pusher == null
        ? null
        : serializers.serialize(
            object.pusher,
            specifiedType: const FullType.nullable(PusherOut),
          );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
    yield r'occurred_at';
    yield serializers.serialize(
      object.occurredAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'device_timezone';
    yield object.deviceTimezone == null
        ? null
        : serializers.serialize(
            object.deviceTimezone,
            specifiedType: const FullType.nullable(String),
          );
    yield r'origin';
    yield serializers.serialize(
      object.origin,
      specifiedType: const FullType(String),
    );
    yield r'is_favourite';
    yield serializers.serialize(
      object.isFavourite,
      specifiedType: const FullType(bool),
    );
    yield r'is_hidden';
    yield serializers.serialize(
      object.isHidden,
      specifiedType: const FullType(bool),
    );
    yield r'num_presses';
    yield serializers.serialize(
      object.numPresses,
      specifiedType: const FullType(int),
    );
    yield r'duration_seconds';
    yield serializers.serialize(
      object.durationSeconds,
      specifiedType: const FullType(num),
    );
    yield r'presses';
    yield serializers.serialize(
      object.presses,
      specifiedType: const FullType(BuiltList, [FullType(PressOut)]),
    );
    yield r'contexts';
    yield serializers.serialize(
      object.contexts,
      specifiedType: const FullType(BuiltList, [FullType(ContextOut)]),
    );
    yield r'modeled_pushers';
    yield serializers.serialize(
      object.modeledPushers,
      specifiedType: const FullType(BuiltList, [FullType(PusherOut)]),
    );
    yield r'created_by_base_id';
    yield object.createdByBaseId == null
        ? null
        : serializers.serialize(
            object.createdByBaseId,
            specifiedType: const FullType.nullable(int),
          );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updated_at';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InteractionOut object, {
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
    required InteractionOutBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(InteractionOutTypeEnum),
          ) as InteractionOutTypeEnum?;
          if (valueDes == null) continue;
          result.type = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'pusher_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.pusherId = valueDes;
          break;
        case r'pusher':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PusherOut),
          ) as PusherOut?;
          if (valueDes == null) continue;
          result.pusher.replace(valueDes);
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
        case r'origin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.origin = valueDes;
          break;
        case r'is_favourite':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isFavourite = valueDes;
          break;
        case r'is_hidden':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isHidden = valueDes;
          break;
        case r'num_presses':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.numPresses = valueDes;
          break;
        case r'duration_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.durationSeconds = valueDes;
          break;
        case r'presses':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PressOut)]),
          ) as BuiltList<PressOut>;
          result.presses.replace(valueDes);
          break;
        case r'contexts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ContextOut)]),
          ) as BuiltList<ContextOut>;
          result.contexts.replace(valueDes);
          break;
        case r'modeled_pushers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PusherOut)]),
          ) as BuiltList<PusherOut>;
          result.modeledPushers.replace(valueDes);
          break;
        case r'created_by_base_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.createdByBaseId = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InteractionOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InteractionOutBuilder();
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

class InteractionOutTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'interaction')
  static const InteractionOutTypeEnum interaction =
      _$interactionOutTypeEnum_interaction;

  static Serializer<InteractionOutTypeEnum> get serializer =>
      _$interactionOutTypeEnumSerializer;

  const InteractionOutTypeEnum._(String name) : super(name);

  static BuiltSet<InteractionOutTypeEnum> get values =>
      _$interactionOutTypeEnumValues;
  static InteractionOutTypeEnum valueOf(String name) =>
      _$interactionOutTypeEnumValueOf(name);
}
