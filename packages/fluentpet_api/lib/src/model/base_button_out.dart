//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'base_button_out.g.dart';

/// BaseButtonOut
///
/// Properties:
/// * [id]
/// * [baseId]
/// * [buttonSerialNumber]
/// * [batteryLevel]
/// * [batteryUpdatedAt]
/// * [lastOnlineAt]
/// * [desiredAudioId]
/// * [desiredDeleted]
/// * [desiredVersion]
/// * [appliedVersion]
@BuiltValue()
abstract class BaseButtonOut
    implements Built<BaseButtonOut, BaseButtonOutBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'base_id')
  int get baseId;

  @BuiltValueField(wireName: r'button_serial_number')
  String get buttonSerialNumber;

  @BuiltValueField(wireName: r'battery_level')
  int? get batteryLevel;

  @BuiltValueField(wireName: r'battery_updated_at')
  DateTime? get batteryUpdatedAt;

  @BuiltValueField(wireName: r'last_online_at')
  DateTime? get lastOnlineAt;

  @BuiltValueField(wireName: r'desired_audio_id')
  int? get desiredAudioId;

  @BuiltValueField(wireName: r'desired_deleted')
  bool get desiredDeleted;

  @BuiltValueField(wireName: r'desired_version')
  int get desiredVersion;

  @BuiltValueField(wireName: r'applied_version')
  int get appliedVersion;

  BaseButtonOut._();

  factory BaseButtonOut([void updates(BaseButtonOutBuilder b)]) =
      _$BaseButtonOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BaseButtonOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BaseButtonOut> get serializer =>
      _$BaseButtonOutSerializer();
}

class _$BaseButtonOutSerializer implements PrimitiveSerializer<BaseButtonOut> {
  @override
  final Iterable<Type> types = const [BaseButtonOut, _$BaseButtonOut];

  @override
  final String wireName = r'BaseButtonOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BaseButtonOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'base_id';
    yield serializers.serialize(
      object.baseId,
      specifiedType: const FullType(int),
    );
    yield r'button_serial_number';
    yield serializers.serialize(
      object.buttonSerialNumber,
      specifiedType: const FullType(String),
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
    yield r'desired_audio_id';
    yield object.desiredAudioId == null
        ? null
        : serializers.serialize(
            object.desiredAudioId,
            specifiedType: const FullType.nullable(int),
          );
    yield r'desired_deleted';
    yield serializers.serialize(
      object.desiredDeleted,
      specifiedType: const FullType(bool),
    );
    yield r'desired_version';
    yield serializers.serialize(
      object.desiredVersion,
      specifiedType: const FullType(int),
    );
    yield r'applied_version';
    yield serializers.serialize(
      object.appliedVersion,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BaseButtonOut object, {
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
    required BaseButtonOutBuilder result,
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
        case r'base_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.baseId = valueDes;
          break;
        case r'button_serial_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.buttonSerialNumber = valueDes;
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
        case r'desired_audio_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.desiredAudioId = valueDes;
          break;
        case r'desired_deleted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.desiredDeleted = valueDes;
          break;
        case r'desired_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.desiredVersion = valueDes;
          break;
        case r'applied_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.appliedVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BaseButtonOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BaseButtonOutBuilder();
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
