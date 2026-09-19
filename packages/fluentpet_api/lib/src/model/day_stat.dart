//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fluentpet_api/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'day_stat.g.dart';

/// DayStat
///
/// Properties:
/// * [date]
/// * [presses]
/// * [interactions]
@BuiltValue()
abstract class DayStat implements Built<DayStat, DayStatBuilder> {
  @BuiltValueField(wireName: r'date')
  Date get date;

  @BuiltValueField(wireName: r'presses')
  int get presses;

  @BuiltValueField(wireName: r'interactions')
  int get interactions;

  DayStat._();

  factory DayStat([void updates(DayStatBuilder b)]) = _$DayStat;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DayStatBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DayStat> get serializer => _$DayStatSerializer();
}

class _$DayStatSerializer implements PrimitiveSerializer<DayStat> {
  @override
  final Iterable<Type> types = const [DayStat, _$DayStat];

  @override
  final String wireName = r'DayStat';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DayStat object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(Date),
    );
    yield r'presses';
    yield serializers.serialize(
      object.presses,
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
    DayStat object, {
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
    required DayStatBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.date = valueDes;
          break;
        case r'presses':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.presses = valueDes;
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
  DayStat deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DayStatBuilder();
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
