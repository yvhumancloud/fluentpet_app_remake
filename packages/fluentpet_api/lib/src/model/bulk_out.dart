//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'bulk_out.g.dart';

/// BulkOut
///
/// Properties:
/// * [affected]
/// * [id]
@BuiltValue()
abstract class BulkOut implements Built<BulkOut, BulkOutBuilder> {
  @BuiltValueField(wireName: r'affected')
  int get affected;

  @BuiltValueField(wireName: r'id')
  int? get id;

  BulkOut._();

  factory BulkOut([void updates(BulkOutBuilder b)]) = _$BulkOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BulkOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BulkOut> get serializer => _$BulkOutSerializer();
}

class _$BulkOutSerializer implements PrimitiveSerializer<BulkOut> {
  @override
  final Iterable<Type> types = const [BulkOut, _$BulkOut];

  @override
  final String wireName = r'BulkOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BulkOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'affected';
    yield serializers.serialize(
      object.affected,
      specifiedType: const FullType(int),
    );
    yield r'id';
    yield object.id == null
        ? null
        : serializers.serialize(
            object.id,
            specifiedType: const FullType.nullable(int),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    BulkOut object, {
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
    required BulkOutBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'affected':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.affected = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BulkOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BulkOutBuilder();
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
