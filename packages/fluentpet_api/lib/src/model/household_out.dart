//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'household_out.g.dart';

/// HouseholdOut
///
/// Properties:
/// * [id]
/// * [name]
@BuiltValue()
abstract class HouseholdOut
    implements Built<HouseholdOut, HouseholdOutBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  HouseholdOut._();

  factory HouseholdOut([void updates(HouseholdOutBuilder b)]) = _$HouseholdOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(HouseholdOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<HouseholdOut> get serializer => _$HouseholdOutSerializer();
}

class _$HouseholdOutSerializer implements PrimitiveSerializer<HouseholdOut> {
  @override
  final Iterable<Type> types = const [HouseholdOut, _$HouseholdOut];

  @override
  final String wireName = r'HouseholdOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    HouseholdOut object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    HouseholdOut object, {
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
    required HouseholdOutBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  HouseholdOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = HouseholdOutBuilder();
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
