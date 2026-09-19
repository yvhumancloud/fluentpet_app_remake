//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pusher_out.g.dart';

/// PusherOut
///
/// Properties:
/// * [id]
/// * [name]
/// * [isHuman]
/// * [isHidden]
/// * [avatarUrl]
@BuiltValue()
abstract class PusherOut implements Built<PusherOut, PusherOutBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'is_human')
  bool get isHuman;

  @BuiltValueField(wireName: r'is_hidden')
  bool get isHidden;

  @BuiltValueField(wireName: r'avatar_url')
  String? get avatarUrl;

  PusherOut._();

  factory PusherOut([void updates(PusherOutBuilder b)]) = _$PusherOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PusherOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PusherOut> get serializer => _$PusherOutSerializer();
}

class _$PusherOutSerializer implements PrimitiveSerializer<PusherOut> {
  @override
  final Iterable<Type> types = const [PusherOut, _$PusherOut];

  @override
  final String wireName = r'PusherOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PusherOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'is_human';
    yield serializers.serialize(
      object.isHuman,
      specifiedType: const FullType(bool),
    );
    yield r'is_hidden';
    yield serializers.serialize(
      object.isHidden,
      specifiedType: const FullType(bool),
    );
    yield r'avatar_url';
    yield object.avatarUrl == null
        ? null
        : serializers.serialize(
            object.avatarUrl,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    PusherOut object, {
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
    required PusherOutBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'is_human':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isHuman = valueDes;
          break;
        case r'is_hidden':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isHidden = valueDes;
          break;
        case r'avatar_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.avatarUrl = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PusherOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PusherOutBuilder();
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
