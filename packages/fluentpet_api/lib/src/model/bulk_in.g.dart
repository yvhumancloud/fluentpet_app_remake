// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_in.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BulkInOperationEnum _$bulkInOperationEnum_assign =
    const BulkInOperationEnum._('assign');
const BulkInOperationEnum _$bulkInOperationEnum_delete =
    const BulkInOperationEnum._('delete');
const BulkInOperationEnum _$bulkInOperationEnum_merge =
    const BulkInOperationEnum._('merge');

BulkInOperationEnum _$bulkInOperationEnumValueOf(String name) {
  switch (name) {
    case 'assign':
      return _$bulkInOperationEnum_assign;
    case 'delete':
      return _$bulkInOperationEnum_delete;
    case 'merge':
      return _$bulkInOperationEnum_merge;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BulkInOperationEnum> _$bulkInOperationEnumValues =
    BuiltSet<BulkInOperationEnum>(const <BulkInOperationEnum>[
  _$bulkInOperationEnum_assign,
  _$bulkInOperationEnum_delete,
  _$bulkInOperationEnum_merge,
]);

Serializer<BulkInOperationEnum> _$bulkInOperationEnumSerializer =
    _$BulkInOperationEnumSerializer();

class _$BulkInOperationEnumSerializer
    implements PrimitiveSerializer<BulkInOperationEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'assign': 'assign',
    'delete': 'delete',
    'merge': 'merge',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'assign': 'assign',
    'delete': 'delete',
    'merge': 'merge',
  };

  @override
  final Iterable<Type> types = const <Type>[BulkInOperationEnum];
  @override
  final String wireName = 'BulkInOperationEnum';

  @override
  Object serialize(Serializers serializers, BulkInOperationEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BulkInOperationEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BulkInOperationEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BulkIn extends BulkIn {
  @override
  final BulkInOperationEnum operation;
  @override
  final BuiltList<int>? ids;
  @override
  final bool? all;
  @override
  final int? pusherId;

  factory _$BulkIn([void Function(BulkInBuilder)? updates]) =>
      (BulkInBuilder()..update(updates))._build();

  _$BulkIn._({required this.operation, this.ids, this.all, this.pusherId})
      : super._();
  @override
  BulkIn rebuild(void Function(BulkInBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BulkInBuilder toBuilder() => BulkInBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BulkIn &&
        operation == other.operation &&
        ids == other.ids &&
        all == other.all &&
        pusherId == other.pusherId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, operation.hashCode);
    _$hash = $jc(_$hash, ids.hashCode);
    _$hash = $jc(_$hash, all.hashCode);
    _$hash = $jc(_$hash, pusherId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BulkIn')
          ..add('operation', operation)
          ..add('ids', ids)
          ..add('all', all)
          ..add('pusherId', pusherId))
        .toString();
  }
}

class BulkInBuilder implements Builder<BulkIn, BulkInBuilder> {
  _$BulkIn? _$v;

  BulkInOperationEnum? _operation;
  BulkInOperationEnum? get operation => _$this._operation;
  set operation(BulkInOperationEnum? operation) =>
      _$this._operation = operation;

  ListBuilder<int>? _ids;
  ListBuilder<int> get ids => _$this._ids ??= ListBuilder<int>();
  set ids(ListBuilder<int>? ids) => _$this._ids = ids;

  bool? _all;
  bool? get all => _$this._all;
  set all(bool? all) => _$this._all = all;

  int? _pusherId;
  int? get pusherId => _$this._pusherId;
  set pusherId(int? pusherId) => _$this._pusherId = pusherId;

  BulkInBuilder() {
    BulkIn._defaults(this);
  }

  BulkInBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _operation = $v.operation;
      _ids = $v.ids?.toBuilder();
      _all = $v.all;
      _pusherId = $v.pusherId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BulkIn other) {
    _$v = other as _$BulkIn;
  }

  @override
  void update(void Function(BulkInBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BulkIn build() => _build();

  _$BulkIn _build() {
    _$BulkIn _$result;
    try {
      _$result = _$v ??
          _$BulkIn._(
            operation: BuiltValueNullFieldError.checkNotNull(
                operation, r'BulkIn', 'operation'),
            ids: _ids?.build(),
            all: all,
            pusherId: pusherId,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ids';
        _ids?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BulkIn', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
