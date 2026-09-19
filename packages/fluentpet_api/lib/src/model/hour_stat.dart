//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'hour_stat.g.dart';

/// HourStat
///
/// Properties:
/// * [hour]
/// * [interactions]
@BuiltValue()
abstract class HourStat implements Built<HourStat, HourStatBuilder> {
  @BuiltValueField(wireName: r'hour')
  int get hour;

  @BuiltValueField(wireName: r'interactions')
  int get interactions;

  HourStat._();

  factory HourStat([void updates(HourStatBuilder b)]) = _$HourStat;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(HourStatBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<HourStat> get serializer => _$HourStatSerializer();
}

class _$HourStatSerializer implements PrimitiveSerializer<HourStat> {
  @override
  final Iterable<Type> types = const [HourStat, _$HourStat];

  @override
  final String wireName = r'HourStat';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    HourStat object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'hour';
    yield serializers.serialize(
      object.hour,
      specifiedType: const FullType(int),
    );
    yield r'interactions';
    yield serializers.serialize(
      object.interactions,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    HourStat object, {
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
    required HourStatBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'hour':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.hour = valueDes;
          break;
        case r'interactions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.interactions = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  HourStat deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = HourStatBuilder();
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
