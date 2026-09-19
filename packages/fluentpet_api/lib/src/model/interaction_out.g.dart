// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interaction_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const InteractionOutTypeEnum _$interactionOutTypeEnum_interaction =
    const InteractionOutTypeEnum._('interaction');

InteractionOutTypeEnum _$interactionOutTypeEnumValueOf(String name) {
  switch (name) {
    case 'interaction':
      return _$interactionOutTypeEnum_interaction;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<InteractionOutTypeEnum> _$interactionOutTypeEnumValues =
    BuiltSet<InteractionOutTypeEnum>(const <InteractionOutTypeEnum>[
  _$interactionOutTypeEnum_interaction,
]);

Serializer<InteractionOutTypeEnum> _$interactionOutTypeEnumSerializer =
    _$InteractionOutTypeEnumSerializer();

class _$InteractionOutTypeEnumSerializer
    implements PrimitiveSerializer<InteractionOutTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'interaction': 'interaction',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'interaction': 'interaction',
  };

  @override
  final Iterable<Type> types = const <Type>[InteractionOutTypeEnum];
  @override
  final String wireName = 'InteractionOutTypeEnum';

  @override
  Object serialize(Serializers serializers, InteractionOutTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InteractionOutTypeEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InteractionOutTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$InteractionOut extends InteractionOut {
  @override
  final InteractionOutTypeEnum? type;
  @override
  final int id;
  @override
  final int? pusherId;
  @override
  final PusherOut? pusher;
  @override
  final String? note;
  @override
  final DateTime occurredAt;
  @override
  final String? deviceTimezone;
  @override
  final String origin;
  @override
  final bool isFavourite;
  @override
  final bool isHidden;
  @override
  final int numPresses;
  @override
  final num durationSeconds;
  @override
  final BuiltList<PressOut> presses;
  @override
  final BuiltList<ContextOut> contexts;
  @override
  final BuiltList<PusherOut> modeledPushers;
  @override
  final int? createdByBaseId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$InteractionOut([void Function(InteractionOutBuilder)? updates]) =>
      (InteractionOutBuilder()..update(updates))._build();

  _$InteractionOut._(
      {this.type,
      required this.id,
      this.pusherId,
      this.pusher,
      this.note,
      required this.occurredAt,
      this.deviceTimezone,
      required this.origin,
      required this.isFavourite,
      required this.isHidden,
      required this.numPresses,
      required this.durationSeconds,
      required this.presses,
      required this.contexts,
      required this.modeledPushers,
      this.createdByBaseId,
      required this.createdAt,
      required this.updatedAt})
      : super._();
  @override
  InteractionOut rebuild(void Function(InteractionOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InteractionOutBuilder toBuilder() => InteractionOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InteractionOut &&
        type == other.type &&
        id == other.id &&
        pusherId == other.pusherId &&
        pusher == other.pusher &&
        note == other.note &&
        occurredAt == other.occurredAt &&
        deviceTimezone == other.deviceTimezone &&
        origin == other.origin &&
        isFavourite == other.isFavourite &&
        isHidden == other.isHidden &&
        numPresses == other.numPresses &&
        durationSeconds == other.durationSeconds &&
        presses == other.presses &&
        contexts == other.contexts &&
        modeledPushers == other.modeledPushers &&
        createdByBaseId == other.createdByBaseId &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, pusherId.hashCode);
    _$hash = $jc(_$hash, pusher.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, occurredAt.hashCode);
    _$hash = $jc(_$hash, deviceTimezone.hashCode);
    _$hash = $jc(_$hash, origin.hashCode);
    _$hash = $jc(_$hash, isFavourite.hashCode);
    _$hash = $jc(_$hash, isHidden.hashCode);
    _$hash = $jc(_$hash, numPresses.hashCode);
    _$hash = $jc(_$hash, durationSeconds.hashCode);
    _$hash = $jc(_$hash, presses.hashCode);
    _$hash = $jc(_$hash, contexts.hashCode);
    _$hash = $jc(_$hash, modeledPushers.hashCode);
    _$hash = $jc(_$hash, createdByBaseId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InteractionOut')
          ..add('type', type)
          ..add('id', id)
          ..add('pusherId', pusherId)
          ..add('pusher', pusher)
          ..add('note', note)
          ..add('occurredAt', occurredAt)
          ..add('deviceTimezone', deviceTimezone)
          ..add('origin', origin)
          ..add('isFavourite', isFavourite)
          ..add('isHidden', isHidden)
          ..add('numPresses', numPresses)
          ..add('durationSeconds', durationSeconds)
          ..add('presses', presses)
          ..add('contexts', contexts)
          ..add('modeledPushers', modeledPushers)
          ..add('createdByBaseId', createdByBaseId)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class InteractionOutBuilder
    implements Builder<InteractionOut, InteractionOutBuilder> {
  _$InteractionOut? _$v;

  InteractionOutTypeEnum? _type;
  InteractionOutTypeEnum? get type => _$this._type;
  set type(InteractionOutTypeEnum? type) => _$this._type = type;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _pusherId;
  int? get pusherId => _$this._pusherId;
  set pusherId(int? pusherId) => _$this._pusherId = pusherId;

  PusherOutBuilder? _pusher;
  PusherOutBuilder get pusher => _$this._pusher ??= PusherOutBuilder();
  set pusher(PusherOutBuilder? pusher) => _$this._pusher = pusher;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  DateTime? _occurredAt;
  DateTime? get occurredAt => _$this._occurredAt;
  set occurredAt(DateTime? occurredAt) => _$this._occurredAt = occurredAt;

  String? _deviceTimezone;
  String? get deviceTimezone => _$this._deviceTimezone;
  set deviceTimezone(String? deviceTimezone) =>
      _$this._deviceTimezone = deviceTimezone;

  String? _origin;
  String? get origin => _$this._origin;
  set origin(String? origin) => _$this._origin = origin;

  bool? _isFavourite;
  bool? get isFavourite => _$this._isFavourite;
  set isFavourite(bool? isFavourite) => _$this._isFavourite = isFavourite;

  bool? _isHidden;
  bool? get isHidden => _$this._isHidden;
  set isHidden(bool? isHidden) => _$this._isHidden = isHidden;

  int? _numPresses;
  int? get numPresses => _$this._numPresses;
  set numPresses(int? numPresses) => _$this._numPresses = numPresses;

  num? _durationSeconds;
  num? get durationSeconds => _$this._durationSeconds;
  set durationSeconds(num? durationSeconds) =>
      _$this._durationSeconds = durationSeconds;

  ListBuilder<PressOut>? _presses;
  ListBuilder<PressOut> get presses =>
      _$this._presses ??= ListBuilder<PressOut>();
  set presses(ListBuilder<PressOut>? presses) => _$this._presses = presses;

  ListBuilder<ContextOut>? _contexts;
  ListBuilder<ContextOut> get contexts =>
      _$this._contexts ??= ListBuilder<ContextOut>();
  set contexts(ListBuilder<ContextOut>? contexts) =>
      _$this._contexts = contexts;

  ListBuilder<PusherOut>? _modeledPushers;
  ListBuilder<PusherOut> get modeledPushers =>
      _$this._modeledPushers ??= ListBuilder<PusherOut>();
  set modeledPushers(ListBuilder<PusherOut>? modeledPushers) =>
      _$this._modeledPushers = modeledPushers;

  int? _createdByBaseId;
  int? get createdByBaseId => _$this._createdByBaseId;
  set createdByBaseId(int? createdByBaseId) =>
      _$this._createdByBaseId = createdByBaseId;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  InteractionOutBuilder() {
    InteractionOut._defaults(this);
  }

  InteractionOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _id = $v.id;
      _pusherId = $v.pusherId;
      _pusher = $v.pusher?.toBuilder();
      _note = $v.note;
      _occurredAt = $v.occurredAt;
      _deviceTimezone = $v.deviceTimezone;
      _origin = $v.origin;
      _isFavourite = $v.isFavourite;
      _isHidden = $v.isHidden;
      _numPresses = $v.numPresses;
      _durationSeconds = $v.durationSeconds;
      _presses = $v.presses.toBuilder();
      _contexts = $v.contexts.toBuilder();
      _modeledPushers = $v.modeledPushers.toBuilder();
      _createdByBaseId = $v.createdByBaseId;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InteractionOut other) {
    _$v = other as _$InteractionOut;
  }

  @override
  void update(void Function(InteractionOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InteractionOut build() => _build();

  _$InteractionOut _build() {
    _$InteractionOut _$result;
    try {
      _$result = _$v ??
          _$InteractionOut._(
            type: type,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'InteractionOut', 'id'),
            pusherId: pusherId,
            pusher: _pusher?.build(),
            note: note,
            occurredAt: BuiltValueNullFieldError.checkNotNull(
                occurredAt, r'InteractionOut', 'occurredAt'),
            deviceTimezone: deviceTimezone,
            origin: BuiltValueNullFieldError.checkNotNull(
                origin, r'InteractionOut', 'origin'),
            isFavourite: BuiltValueNullFieldError.checkNotNull(
                isFavourite, r'InteractionOut', 'isFavourite'),
            isHidden: BuiltValueNullFieldError.checkNotNull(
                isHidden, r'InteractionOut', 'isHidden'),
            numPresses: BuiltValueNullFieldError.checkNotNull(
                numPresses, r'InteractionOut', 'numPresses'),
            durationSeconds: BuiltValueNullFieldError.checkNotNull(
                durationSeconds, r'InteractionOut', 'durationSeconds'),
            presses: presses.build(),
            contexts: contexts.build(),
            modeledPushers: modeledPushers.build(),
            createdByBaseId: createdByBaseId,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'InteractionOut', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'InteractionOut', 'updatedAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'pusher';
        _pusher?.build();

        _$failedField = 'presses';
        presses.build();
        _$failedField = 'contexts';
        contexts.build();
        _$failedField = 'modeledPushers';
        modeledPushers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'InteractionOut', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
