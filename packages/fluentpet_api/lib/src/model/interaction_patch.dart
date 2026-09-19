//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'interaction_patch.g.dart';

/// InteractionPatch
///
/// Properties:
/// * [pusherId]
/// * [note]
/// * [occurredAt]
/// * [deviceTimezone]
/// * [isFavourite]
/// * [isHidden]
/// * [buttonIds]
/// * [contextIds]
/// * [modeledPusherIds]
@BuiltValue()
abstract class InteractionPatch
    implements Built<InteractionPatch, InteractionPatchBuilder> {
  @BuiltValueField(wireName: r'pusher_id')
  int? get pusherId;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'occurred_at')
  DateTime? get occurredAt;

  @BuiltValueField(wireName: r'device_timezone')
  String? get deviceTimezone;

  @BuiltValueField(wireName: r'is_favourite')
  bool? get isFavourite;

  @BuiltValueField(wireName: r'is_hidden')
  bool? get isHidden;

  @BuiltValueField(wireName: r'button_ids')
  BuiltList<int>? get buttonIds;

  @BuiltValueField(wireName: r'context_ids')
  BuiltList<int>? get contextIds;

  @BuiltValueField(wireName: r'modeled_pusher_ids')
  BuiltList<int>? get modeledPusherIds;

  InteractionPatch._();

  factory InteractionPatch([void updates(InteractionPatchBuilder b)]) =
      _$InteractionPatch;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InteractionPatchBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InteractionPatch> get serializer =>
      _$InteractionPatchSerializer();
}

class _$InteractionPatchSerializer
    implements PrimitiveSerializer<InteractionPatch> {
  @override
  final Iterable<Type> types = const [InteractionPatch, _$InteractionPatch];

  @override
  final String wireName = r'InteractionPatch';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InteractionPatch object, {
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
    if (object.buttonIds != null) {
      yield r'button_ids';
      yield serializers.serialize(
        object.buttonIds,
        specifiedType: const FullType.nullable(BuiltList, [FullType(int)]),
      );
    }
    if (object.contextIds != null) {
      yield r'context_ids';
      yield serializers.serialize(
        object.contextIds,
        specifiedType: const FullType.nullable(BuiltList, [FullType(int)]),
      );
    }
    if (object.modeledPusherIds != null) {
      yield r'modeled_pusher_ids';
      yield serializers.serialize(
        object.modeledPusherIds,
        specifiedType: const FullType.nullable(BuiltList, [FullType(int)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    InteractionPatch object, {
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
    required InteractionPatchBuilder result,
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
  InteractionPatch deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InteractionPatchBuilder();
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
