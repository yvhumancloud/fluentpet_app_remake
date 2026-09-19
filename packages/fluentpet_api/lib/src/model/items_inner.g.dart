// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ItemsInnerTypeEnum _$itemsInnerTypeEnum_interaction =
    const ItemsInnerTypeEnum._('interaction');
const ItemsInnerTypeEnum _$itemsInnerTypeEnum_note =
    const ItemsInnerTypeEnum._('note');

ItemsInnerTypeEnum _$itemsInnerTypeEnumValueOf(String name) {
  switch (name) {
    case 'interaction':
      return _$itemsInnerTypeEnum_interaction;
    case 'note':
      return _$itemsInnerTypeEnum_note;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ItemsInnerTypeEnum> _$itemsInnerTypeEnumValues =
    BuiltSet<ItemsInnerTypeEnum>(const <ItemsInnerTypeEnum>[
  _$itemsInnerTypeEnum_interaction,
  _$itemsInnerTypeEnum_note,
]);

Serializer<ItemsInnerTypeEnum> _$itemsInnerTypeEnumSerializer =
    _$ItemsInnerTypeEnumSerializer();

class _$ItemsInnerTypeEnumSerializer
    implements PrimitiveSerializer<ItemsInnerTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'interaction': 'interaction',
    'note': 'note',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'interaction': 'interaction',
    'note': 'note',
  };

  @override
  final Iterable<Type> types = const <Type>[ItemsInnerTypeEnum];
  @override
  final String wireName = 'ItemsInnerTypeEnum';

  @override
  Object serialize(Serializers serializers, ItemsInnerTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ItemsInnerTypeEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ItemsInnerTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ItemsInner extends ItemsInner {
  @override
  final AnyOf anyOf;

  factory _$ItemsInner([void Function(ItemsInnerBuilder)? updates]) =>
      (ItemsInnerBuilder()..update(updates))._build();

  _$ItemsInner._({required this.anyOf}) : super._();
  @override
  ItemsInner rebuild(void Function(ItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ItemsInnerBuilder toBuilder() => ItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ItemsInner && anyOf == other.anyOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, anyOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ItemsInner')..add('anyOf', anyOf))
        .toString();
  }
}

class ItemsInnerBuilder implements Builder<ItemsInner, ItemsInnerBuilder> {
  _$ItemsInner? _$v;

  AnyOf? _anyOf;
  AnyOf? get anyOf => _$this._anyOf;
  set anyOf(AnyOf? anyOf) => _$this._anyOf = anyOf;

  ItemsInnerBuilder() {
    ItemsInner._defaults(this);
  }

  ItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _anyOf = $v.anyOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ItemsInner other) {
    _$v = other as _$ItemsInner;
  }

  @override
  void update(void Function(ItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ItemsInner build() => _build();

  _$ItemsInner _build() {
    final _$result = _$v ??
        _$ItemsInner._(
          anyOf: BuiltValueNullFieldError.checkNotNull(
              anyOf, r'ItemsInner', 'anyOf'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
