//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'bulk_in.g.dart';

/// BulkIn
///
/// Properties:
/// * [operation]
/// * [ids]
/// * [all]
/// * [pusherId]
@BuiltValue()
abstract class BulkIn implements Built<BulkIn, BulkInBuilder> {
  @BuiltValueField(wireName: r'operation')
  BulkInOperationEnum get operation;
  // enum operationEnum {  assign,  delete,  merge,  };

  @BuiltValueField(wireName: r'ids')
  BuiltList<int>? get ids;

  @BuiltValueField(wireName: r'all')
  bool? get all;

  @BuiltValueField(wireName: r'pusher_id')
  int? get pusherId;

  BulkIn._();

  factory BulkIn([void updates(BulkInBuilder b)]) = _$BulkIn;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BulkInBuilder b) => b..all = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<BulkIn> get serializer => _$BulkInSerializer();
}

class _$BulkInSerializer implements PrimitiveSerializer<BulkIn> {
  @override
  final Iterable<Type> types = const [BulkIn, _$BulkIn];

  @override
  final String wireName = r'BulkIn';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BulkIn object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'operation';
    yield serializers.serialize(
      object.operation,
      specifiedType: const FullType(BulkInOperationEnum),
    );
    if (object.ids != null) {
      yield r'ids';
      yield serializers.serialize(
        object.ids,
        specifiedType: const FullType.nullable(BuiltList, [FullType(int)]),
      );
    }
    if (object.all != null) {
      yield r'all';
      yield serializers.serialize(
        object.all,
        specifiedType: const FullType(bool),
      );
    }
    if (object.pusherId != null) {
      yield r'pusher_id';
      yield serializers.serialize(
        object.pusherId,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BulkIn object, {
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
    required BulkInBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'operation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BulkInOperationEnum),
          ) as BulkInOperationEnum;
          result.operation = valueDes;
          break;
        case r'ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(int)]),
          ) as BuiltList<int>?;
          if (valueDes == null) continue;
          result.ids.replace(valueDes);
          break;
        case r'all':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.all = valueDes;
          break;
        case r'pusher_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.pusherId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BulkIn deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BulkInBuilder();
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

class BulkInOperationEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'assign')
  static const BulkInOperationEnum assign = _$bulkInOperationEnum_assign;
  @BuiltValueEnumConst(wireName: r'delete')
  static const BulkInOperationEnum delete = _$bulkInOperationEnum_delete;
  @BuiltValueEnumConst(wireName: r'merge')
  static const BulkInOperationEnum merge = _$bulkInOperationEnum_merge;

  static Serializer<BulkInOperationEnum> get serializer =>
      _$bulkInOperationEnumSerializer;

  const BulkInOperationEnum._(String name) : super(name);

  static BuiltSet<BulkInOperationEnum> get values =>
      _$bulkInOperationEnumValues;
  static BulkInOperationEnum valueOf(String name) =>
      _$bulkInOperationEnumValueOf(name);
}
