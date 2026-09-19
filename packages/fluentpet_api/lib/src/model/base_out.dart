//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fluentpet_api/src/model/linked_button_out.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'base_out.g.dart';

/// BaseOut
///
/// Properties:
/// * [id]
/// * [serialNumber]
/// * [name]
/// * [defaultPusherId]
/// * [groupWindowSeconds]
/// * [fwVersion]
/// * [batteryLevel]
/// * [batteryUpdatedAt]
/// * [lastOnlineAt]
/// * [reportedState]
/// * [createdAt]
/// * [buttons]
@BuiltValue()
abstract class BaseOut implements Built<BaseOut, BaseOutBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'serial_number')
  String get serialNumber;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'default_pusher_id')
  int? get defaultPusherId;

  @BuiltValueField(wireName: r'group_window_seconds')
  int get groupWindowSeconds;

  @BuiltValueField(wireName: r'fw_version')
  String? get fwVersion;

  @BuiltValueField(wireName: r'battery_level')
  int? get batteryLevel;

  @BuiltValueField(wireName: r'battery_updated_at')
  DateTime? get batteryUpdatedAt;

  @BuiltValueField(wireName: r'last_online_at')
  DateTime? get lastOnlineAt;

  @BuiltValueField(wireName: r'reported_state')
  BuiltMap<String, JsonObject?>? get reportedState;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'buttons')
  BuiltList<LinkedButtonOut> get buttons;

  BaseOut._();

  factory BaseOut([void updates(BaseOutBuilder b)]) = _$BaseOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BaseOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BaseOut> get serializer => _$BaseOutSerializer();
}

class _$BaseOutSerializer implements PrimitiveSerializer<BaseOut> {
  @override
  final Iterable<Type> types = const [BaseOut, _$BaseOut];

  @override
  final String wireName = r'BaseOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BaseOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'serial_number';
    yield serializers.serialize(
      object.serialNumber,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield object.name == null
        ? null
        : serializers.serialize(
            object.name,
            specifiedType: const FullType.nullable(String),
          );
    yield r'default_pusher_id';
    yield object.defaultPusherId == null
        ? null
        : serializers.serialize(
            object.defaultPusherId,
            specifiedType: const FullType.nullable(int),
          );
    yield r'group_window_seconds';
    yield serializers.serialize(
      object.groupWindowSeconds,
      specifiedType: const FullType(int),
    );
    yield r'fw_version';
    yield object.fwVersion == null
        ? null
        : serializers.serialize(
            object.fwVersion,
            specifiedType: const FullType.nullable(String),
          );
    yield r'battery_level';
    yield object.batteryLevel == null
        ? null
        : serializers.serialize(
            object.batteryLevel,
            specifiedType: const FullType.nullable(int),
          );
    yield r'battery_updated_at';
    yield object.batteryUpdatedAt == null
        ? null
        : serializers.serialize(
            object.batteryUpdatedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'last_online_at';
    yield object.lastOnlineAt == null
        ? null
        : serializers.serialize(
            object.lastOnlineAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'reported_state';
    yield object.reportedState == null
        ? null
        : serializers.serialize(
            object.reportedState,
            specifiedType: const FullType.nullable(
                BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'buttons';
    yield serializers.serialize(
      object.buttons,
      specifiedType: const FullType(BuiltList, [FullType(LinkedButtonOut)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BaseOut object, {
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
    required BaseOutBuilder result,
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
        case r'serial_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.serialNumber = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'default_pusher_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.defaultPusherId = valueDes;
          break;
        case r'group_window_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.groupWindowSeconds = valueDes;
          break;
        case r'fw_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.fwVersion = valueDes;
          break;
        case r'battery_level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.batteryLevel = valueDes;
          break;
        case r'battery_updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.batteryUpdatedAt = valueDes;
          break;
        case r'last_online_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastOnlineAt = valueDes;
          break;
        case r'reported_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(
                BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.reportedState.replace(valueDes);
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'buttons':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(LinkedButtonOut)]),
          ) as BuiltList<LinkedButtonOut>;
          result.buttons.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BaseOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BaseOutBuilder();
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
