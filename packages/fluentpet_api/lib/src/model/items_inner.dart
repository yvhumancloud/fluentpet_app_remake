//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fluentpet_api/src/model/context_out.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fluentpet_api/src/model/note_out.dart';
import 'package:fluentpet_api/src/model/press_out.dart';
import 'package:fluentpet_api/src/model/interaction_out.dart';
import 'package:fluentpet_api/src/model/pusher_out.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/any_of.dart';

part 'items_inner.g.dart';

/// ItemsInner
///
/// Properties:
/// * [type]
/// * [id]
/// * [pusherId]
/// * [pusher]
/// * [note]
/// * [occurredAt]
/// * [deviceTimezone]
/// * [origin]
/// * [isFavourite]
/// * [isHidden]
/// * [numPresses]
/// * [durationSeconds]
/// * [presses]
/// * [contexts]
/// * [modeledPushers]
/// * [createdByBaseId]
/// * [createdAt]
/// * [updatedAt]
/// * [text]
@BuiltValue()
abstract class ItemsInner implements Built<ItemsInner, ItemsInnerBuilder> {
  /// Any Of [InteractionOut], [NoteOut]
  AnyOf get anyOf;

  ItemsInner._();

  factory ItemsInner([void updates(ItemsInnerBuilder b)]) = _$ItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ItemsInner> get serializer => _$ItemsInnerSerializer();
}

class _$ItemsInnerSerializer implements PrimitiveSerializer<ItemsInner> {
  @override
  final Iterable<Type> types = const [ItemsInner, _$ItemsInner];

  @override
  final String wireName = r'ItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {}

  @override
  Object serialize(
    Serializers serializers,
    ItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final anyOf = object.anyOf;
    return serializers.serialize(anyOf,
        specifiedType: FullType(
            AnyOf, anyOf.types.map((type) => FullType(type)).toList()))!;
  }

  @override
  ItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ItemsInnerBuilder();
    Object? anyOfDataSrc;
    final targetType = const FullType(AnyOf, [
      FullType(InteractionOut),
      FullType(NoteOut),
    ]);
    anyOfDataSrc = serialized;
    result.anyOf = serializers.deserialize(anyOfDataSrc,
        specifiedType: targetType) as AnyOf;
    return result.build();
  }
}

class ItemsInnerTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'interaction')
  static const ItemsInnerTypeEnum interaction =
      _$itemsInnerTypeEnum_interaction;
  @BuiltValueEnumConst(wireName: r'note')
  static const ItemsInnerTypeEnum note = _$itemsInnerTypeEnum_note;

  static Serializer<ItemsInnerTypeEnum> get serializer =>
      _$itemsInnerTypeEnumSerializer;

  const ItemsInnerTypeEnum._(String name) : super(name);

  static BuiltSet<ItemsInnerTypeEnum> get values => _$itemsInnerTypeEnumValues;
  static ItemsInnerTypeEnum valueOf(String name) =>
      _$itemsInnerTypeEnumValueOf(name);
}
