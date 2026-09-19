//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fluentpet_api/src/model/button_ref.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'combination.g.dart';

/// Combination
///
/// Properties:
/// * [buttons]
/// * [count]
@BuiltValue()
abstract class Combination implements Built<Combination, CombinationBuilder> {
  @BuiltValueField(wireName: r'buttons')
  BuiltList<ButtonRef> get buttons;

  @BuiltValueField(wireName: r'count')
  int get count;

  Combination._();

  factory Combination([void updates(CombinationBuilder b)]) = _$Combination;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CombinationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Combination> get serializer => _$CombinationSerializer();
}

class _$CombinationSerializer implements PrimitiveSerializer<Combination> {
  @override
  final Iterable<Type> types = const [Combination, _$Combination];

  @override
  final String wireName = r'Combination';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Combination object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'buttons';
    yield serializers.serialize(
      object.buttons,
      specifiedType: const FullType(BuiltList, [FullType(ButtonRef)]),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Combination object, {
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
    required CombinationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'buttons':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ButtonRef)]),
          ) as BuiltList<ButtonRef>;
          result.buttons.replace(valueDes);
          break;
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Combination deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CombinationBuilder();
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
