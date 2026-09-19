//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fluentpet_api/src/model/text_count.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fluentpet_api/src/model/day_stat.dart';
import 'package:fluentpet_api/src/model/hour_stat.dart';
import 'package:fluentpet_api/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stats_range.g.dart';

/// StatsRange
///
/// Properties:
/// * [from]
/// * [to]
/// * [buttonsLogged]
/// * [buttonsCreated]
/// * [combinations]
/// * [contexts]
/// * [perDay]
/// * [perHour]
@BuiltValue()
abstract class StatsRange implements Built<StatsRange, StatsRangeBuilder> {
  @BuiltValueField(wireName: r'from')
  Date get from;

  @BuiltValueField(wireName: r'to')
  Date get to;

  @BuiltValueField(wireName: r'buttons_logged')
  BuiltList<TextCount> get buttonsLogged;

  @BuiltValueField(wireName: r'buttons_created')
  BuiltList<TextCount> get buttonsCreated;

  @BuiltValueField(wireName: r'combinations')
  BuiltList<TextCount> get combinations;

  @BuiltValueField(wireName: r'contexts')
  BuiltList<TextCount> get contexts;

  @BuiltValueField(wireName: r'per_day')
  BuiltList<DayStat> get perDay;

  @BuiltValueField(wireName: r'per_hour')
  BuiltList<HourStat> get perHour;

  StatsRange._();

  factory StatsRange([void updates(StatsRangeBuilder b)]) = _$StatsRange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StatsRangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StatsRange> get serializer => _$StatsRangeSerializer();
}

class _$StatsRangeSerializer implements PrimitiveSerializer<StatsRange> {
  @override
  final Iterable<Type> types = const [StatsRange, _$StatsRange];

  @override
  final String wireName = r'StatsRange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StatsRange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(Date),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(Date),
    );
    yield r'buttons_logged';
    yield serializers.serialize(
      object.buttonsLogged,
      specifiedType: const FullType(BuiltList, [FullType(TextCount)]),
    );
    yield r'buttons_created';
    yield serializers.serialize(
      object.buttonsCreated,
      specifiedType: const FullType(BuiltList, [FullType(TextCount)]),
    );
    yield r'combinations';
    yield serializers.serialize(
      object.combinations,
      specifiedType: const FullType(BuiltList, [FullType(TextCount)]),
    );
    yield r'contexts';
    yield serializers.serialize(
      object.contexts,
      specifiedType: const FullType(BuiltList, [FullType(TextCount)]),
    );
    yield r'per_day';
    yield serializers.serialize(
      object.perDay,
      specifiedType: const FullType(BuiltList, [FullType(DayStat)]),
    );
    yield r'per_hour';
    yield serializers.serialize(
      object.perHour,
      specifiedType: const FullType(BuiltList, [FullType(HourStat)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StatsRange object, {
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
    required StatsRangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.from = valueDes;
          break;
        case r'to':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.to = valueDes;
          break;
        case r'buttons_logged':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TextCount)]),
          ) as BuiltList<TextCount>;
          result.buttonsLogged.replace(valueDes);
          break;
        case r'buttons_created':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TextCount)]),
          ) as BuiltList<TextCount>;
          result.buttonsCreated.replace(valueDes);
          break;
        case r'combinations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TextCount)]),
          ) as BuiltList<TextCount>;
          result.combinations.replace(valueDes);
          break;
        case r'contexts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TextCount)]),
          ) as BuiltList<TextCount>;
          result.contexts.replace(valueDes);
          break;
        case r'per_day':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DayStat)]),
          ) as BuiltList<DayStat>;
          result.perDay.replace(valueDes);
          break;
        case r'per_hour':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(HourStat)]),
          ) as BuiltList<HourStat>;
          result.perHour.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StatsRange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StatsRangeBuilder();
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
