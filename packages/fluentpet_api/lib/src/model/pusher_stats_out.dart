//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fluentpet_api/src/model/text_count.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fluentpet_api/src/model/combination.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pusher_stats_out.g.dart';

/// PusherStatsOut
///
/// Properties:
/// * [mostPressed]
/// * [leastPressed]
/// * [topContexts]
/// * [mostFrequentCombination]
/// * [daysSinceFirstEntry]
@BuiltValue()
abstract class PusherStatsOut
    implements Built<PusherStatsOut, PusherStatsOutBuilder> {
  @BuiltValueField(wireName: r'most_pressed')
  BuiltList<TextCount> get mostPressed;

  @BuiltValueField(wireName: r'least_pressed')
  BuiltList<TextCount> get leastPressed;

  @BuiltValueField(wireName: r'top_contexts')
  BuiltList<TextCount> get topContexts;

  @BuiltValueField(wireName: r'most_frequent_combination')
  Combination? get mostFrequentCombination;

  @BuiltValueField(wireName: r'days_since_first_entry')
  int? get daysSinceFirstEntry;

  PusherStatsOut._();

  factory PusherStatsOut([void updates(PusherStatsOutBuilder b)]) =
      _$PusherStatsOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PusherStatsOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PusherStatsOut> get serializer =>
      _$PusherStatsOutSerializer();
}

class _$PusherStatsOutSerializer
    implements PrimitiveSerializer<PusherStatsOut> {
  @override
  final Iterable<Type> types = const [PusherStatsOut, _$PusherStatsOut];

  @override
  final String wireName = r'PusherStatsOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PusherStatsOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'most_pressed';
    yield serializers.serialize(
      object.mostPressed,
      specifiedType: const FullType(BuiltList, [FullType(TextCount)]),
    );
    yield r'least_pressed';
    yield serializers.serialize(
      object.leastPressed,
      specifiedType: const FullType(BuiltList, [FullType(TextCount)]),
    );
    yield r'top_contexts';
    yield serializers.serialize(
      object.topContexts,
      specifiedType: const FullType(BuiltList, [FullType(TextCount)]),
    );
    yield r'most_frequent_combination';
    yield object.mostFrequentCombination == null
        ? null
        : serializers.serialize(
            object.mostFrequentCombination,
            specifiedType: const FullType.nullable(Combination),
          );
    yield r'days_since_first_entry';
    yield object.daysSinceFirstEntry == null
        ? null
        : serializers.serialize(
            object.daysSinceFirstEntry,
            specifiedType: const FullType.nullable(int),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    PusherStatsOut object, {
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
    required PusherStatsOutBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'most_pressed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TextCount)]),
          ) as BuiltList<TextCount>;
          result.mostPressed.replace(valueDes);
          break;
        case r'least_pressed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TextCount)]),
          ) as BuiltList<TextCount>;
          result.leastPressed.replace(valueDes);
          break;
        case r'top_contexts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TextCount)]),
          ) as BuiltList<TextCount>;
          result.topContexts.replace(valueDes);
          break;
        case r'most_frequent_combination':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Combination),
          ) as Combination?;
          if (valueDes == null) continue;
          result.mostFrequentCombination.replace(valueDes);
          break;
        case r'days_since_first_entry':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.daysSinceFirstEntry = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PusherStatsOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PusherStatsOutBuilder();
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
