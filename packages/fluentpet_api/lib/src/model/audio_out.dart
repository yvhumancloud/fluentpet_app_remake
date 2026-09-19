//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'audio_out.g.dart';

/// AudioOut
///
/// Properties:
/// * [id]
/// * [householdId]
/// * [name]
/// * [crc32]
/// * [byteSize]
/// * [createdAt]
@BuiltValue()
abstract class AudioOut implements Built<AudioOut, AudioOutBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'household_id')
  int get householdId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'crc32')
  int get crc32;

  @BuiltValueField(wireName: r'byte_size')
  int get byteSize;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  AudioOut._();

  factory AudioOut([void updates(AudioOutBuilder b)]) = _$AudioOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AudioOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AudioOut> get serializer => _$AudioOutSerializer();
}

class _$AudioOutSerializer implements PrimitiveSerializer<AudioOut> {
  @override
  final Iterable<Type> types = const [AudioOut, _$AudioOut];

  @override
  final String wireName = r'AudioOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AudioOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'household_id';
    yield serializers.serialize(
      object.householdId,
      specifiedType: const FullType(int),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'crc32';
    yield serializers.serialize(
      object.crc32,
      specifiedType: const FullType(int),
    );
    yield r'byte_size';
    yield serializers.serialize(
      object.byteSize,
      specifiedType: const FullType(int),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AudioOut object, {
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
    required AudioOutBuilder result,
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
        case r'household_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.householdId = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'crc32':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.crc32 = valueDes;
          break;
        case r'byte_size':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.byteSize = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AudioOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AudioOutBuilder();
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
