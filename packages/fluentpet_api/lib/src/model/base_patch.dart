//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'base_patch.g.dart';

/// BasePatch
///
/// Properties:
/// * [name]
/// * [defaultPusherId]
/// * [groupWindowSeconds]
@BuiltValue()
abstract class BasePatch implements Built<BasePatch, BasePatchBuilder> {
  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'default_pusher_id')
  int? get defaultPusherId;

  @BuiltValueField(wireName: r'group_window_seconds')
  int? get groupWindowSeconds;

  BasePatch._();

  factory BasePatch([void updates(BasePatchBuilder b)]) = _$BasePatch;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BasePatchBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BasePatch> get serializer => _$BasePatchSerializer();
}

class _$BasePatchSerializer implements PrimitiveSerializer<BasePatch> {
  @override
  final Iterable<Type> types = const [BasePatch, _$BasePatch];

  @override
  final String wireName = r'BasePatch';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BasePatch object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.defaultPusherId != null) {
      yield r'default_pusher_id';
      yield serializers.serialize(
        object.defaultPusherId,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.groupWindowSeconds != null) {
      yield r'group_window_seconds';
      yield serializers.serialize(
        object.groupWindowSeconds,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BasePatch object, {
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
    required BasePatchBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.groupWindowSeconds = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BasePatch deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BasePatchBuilder();
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
