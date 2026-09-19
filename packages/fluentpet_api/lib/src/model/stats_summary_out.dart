//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fluentpet_api/src/model/stats_totals.dart';
import 'package:fluentpet_api/src/model/pusher_ref.dart';
import 'package:fluentpet_api/src/model/stats_range.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stats_summary_out.g.dart';

/// StatsSummaryOut
///
/// Properties:
/// * [pusher]
/// * [daysSinceTrainingStarted]
/// * [daysSinceFirstInteraction]
/// * [totals]
/// * [range]
@BuiltValue()
abstract class StatsSummaryOut
    implements Built<StatsSummaryOut, StatsSummaryOutBuilder> {
  @BuiltValueField(wireName: r'pusher')
  PusherRef get pusher;

  @BuiltValueField(wireName: r'days_since_training_started')
  int? get daysSinceTrainingStarted;

  @BuiltValueField(wireName: r'days_since_first_interaction')
  int? get daysSinceFirstInteraction;

  @BuiltValueField(wireName: r'totals')
  StatsTotals get totals;

  @BuiltValueField(wireName: r'range')
  StatsRange get range;

  StatsSummaryOut._();

  factory StatsSummaryOut([void updates(StatsSummaryOutBuilder b)]) =
      _$StatsSummaryOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StatsSummaryOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StatsSummaryOut> get serializer =>
      _$StatsSummaryOutSerializer();
}

class _$StatsSummaryOutSerializer
    implements PrimitiveSerializer<StatsSummaryOut> {
  @override
  final Iterable<Type> types = const [StatsSummaryOut, _$StatsSummaryOut];

  @override
  final String wireName = r'StatsSummaryOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StatsSummaryOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'pusher';
    yield serializers.serialize(
      object.pusher,
      specifiedType: const FullType(PusherRef),
    );
    yield r'days_since_training_started';
    yield object.daysSinceTrainingStarted == null
        ? null
        : serializers.serialize(
            object.daysSinceTrainingStarted,
            specifiedType: const FullType.nullable(int),
          );
    yield r'days_since_first_interaction';
    yield object.daysSinceFirstInteraction == null
        ? null
        : serializers.serialize(
            object.daysSinceFirstInteraction,
            specifiedType: const FullType.nullable(int),
          );
    yield r'totals';
    yield serializers.serialize(
      object.totals,
      specifiedType: const FullType(StatsTotals),
    );
    yield r'range';
    yield serializers.serialize(
      object.range,
      specifiedType: const FullType(StatsRange),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StatsSummaryOut object, {
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
    required StatsSummaryOutBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pusher':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PusherRef),
          ) as PusherRef;
          result.pusher.replace(valueDes);
          break;
        case r'days_since_training_started':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.daysSinceTrainingStarted = valueDes;
          break;
        case r'days_since_first_interaction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.daysSinceFirstInteraction = valueDes;
          break;
        case r'totals':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StatsTotals),
          ) as StatsTotals;
          result.totals.replace(valueDes);
          break;
        case r'range':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StatsRange),
          ) as StatsRange;
          result.range.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StatsSummaryOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StatsSummaryOutBuilder();
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
