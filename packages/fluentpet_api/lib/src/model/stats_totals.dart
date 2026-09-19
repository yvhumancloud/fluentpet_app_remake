//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stats_totals.g.dart';

/// StatsTotals
///
/// Properties:
/// * [interactions]
/// * [presses]
/// * [distinctButtons]
@BuiltValue()
abstract class StatsTotals implements Built<StatsTotals, StatsTotalsBuilder> {
  @BuiltValueField(wireName: r'interactions')
  int get interactions;

  @BuiltValueField(wireName: r'presses')
  int get presses;

  @BuiltValueField(wireName: r'distinct_buttons')
  int get distinctButtons;

  StatsTotals._();

  factory StatsTotals([void updates(StatsTotalsBuilder b)]) = _$StatsTotals;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StatsTotalsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StatsTotals> get serializer => _$StatsTotalsSerializer();
}

class _$StatsTotalsSerializer implements PrimitiveSerializer<StatsTotals> {
  @override
  final Iterable<Type> types = const [StatsTotals, _$StatsTotals];

  @override
  final String wireName = r'StatsTotals';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StatsTotals object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'interactions';
    yield serializers.serialize(
      object.interactions,
      specifiedType: const FullType(int),
    );
    yield r'presses';
    yield serializers.serialize(
      object.presses,
      specifiedType: const FullType(int),
    );
    yield r'distinct_buttons';
    yield serializers.serialize(
      object.distinctButtons,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StatsTotals object, {
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
    required StatsTotalsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'interactions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.interactions = valueDes;
          break;
        case r'presses':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.presses = valueDes;
          break;
        case r'distinct_buttons':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.distinctButtons = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StatsTotals deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StatsTotalsBuilder();
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
