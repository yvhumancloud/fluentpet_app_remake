// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interaction_in.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InteractionIn extends InteractionIn {
  @override
  final int? pusherId;
  @override
  final String? note;
  @override
  final DateTime occurredAt;
  @override
  final String? deviceTimezone;
  @override
  final bool? isFavourite;
  @override
  final BuiltList<int>? buttonIds;
  @override
  final BuiltList<int>? contextIds;
  @override
  final BuiltList<int>? modeledPusherIds;

  factory _$InteractionIn([void Function(InteractionInBuilder)? updates]) =>
      (InteractionInBuilder()..update(updates))._build();

  _$InteractionIn._(
      {this.pusherId,
      this.note,
      required this.occurredAt,
      this.deviceTimezone,
      this.isFavourite,
      this.buttonIds,
      this.contextIds,
      this.modeledPusherIds})
      : super._();
  @override
  InteractionIn rebuild(void Function(InteractionInBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InteractionInBuilder toBuilder() => InteractionInBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InteractionIn &&
        pusherId == other.pusherId &&
        note == other.note &&
        occurredAt == other.occurredAt &&
        deviceTimezone == other.deviceTimezone &&
        isFavourite == other.isFavourite &&
        buttonIds == other.buttonIds &&
        contextIds == other.contextIds &&
        modeledPusherIds == other.modeledPusherIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pusherId.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, occurredAt.hashCode);
    _$hash = $jc(_$hash, deviceTimezone.hashCode);
    _$hash = $jc(_$hash, isFavourite.hashCode);
    _$hash = $jc(_$hash, buttonIds.hashCode);
    _$hash = $jc(_$hash, contextIds.hashCode);
    _$hash = $jc(_$hash, modeledPusherIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InteractionIn')
          ..add('pusherId', pusherId)
          ..add('note', note)
          ..add('occurredAt', occurredAt)
          ..add('deviceTimezone', deviceTimezone)
          ..add('isFavourite', isFavourite)
          ..add('buttonIds', buttonIds)
          ..add('contextIds', contextIds)
          ..add('modeledPusherIds', modeledPusherIds))
        .toString();
  }
}

class InteractionInBuilder
    implements Builder<InteractionIn, InteractionInBuilder> {
  _$InteractionIn? _$v;

  int? _pusherId;
  int? get pusherId => _$this._pusherId;
  set pusherId(int? pusherId) => _$this._pusherId = pusherId;

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

  bool? _isFavourite;
  bool? get isFavourite => _$this._isFavourite;
  set isFavourite(bool? isFavourite) => _$this._isFavourite = isFavourite;

  ListBuilder<int>? _buttonIds;
  ListBuilder<int> get buttonIds => _$this._buttonIds ??= ListBuilder<int>();
  set buttonIds(ListBuilder<int>? buttonIds) => _$this._buttonIds = buttonIds;

  ListBuilder<int>? _contextIds;
  ListBuilder<int> get contextIds => _$this._contextIds ??= ListBuilder<int>();
  set contextIds(ListBuilder<int>? contextIds) =>
      _$this._contextIds = contextIds;

  ListBuilder<int>? _modeledPusherIds;
  ListBuilder<int> get modeledPusherIds =>
      _$this._modeledPusherIds ??= ListBuilder<int>();
  set modeledPusherIds(ListBuilder<int>? modeledPusherIds) =>
      _$this._modeledPusherIds = modeledPusherIds;

  InteractionInBuilder() {
    InteractionIn._defaults(this);
  }

  InteractionInBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pusherId = $v.pusherId;
      _note = $v.note;
      _occurredAt = $v.occurredAt;
      _deviceTimezone = $v.deviceTimezone;
      _isFavourite = $v.isFavourite;
      _buttonIds = $v.buttonIds?.toBuilder();
      _contextIds = $v.contextIds?.toBuilder();
      _modeledPusherIds = $v.modeledPusherIds?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InteractionIn other) {
    _$v = other as _$InteractionIn;
  }

  @override
  void update(void Function(InteractionInBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InteractionIn build() => _build();

  _$InteractionIn _build() {
    _$InteractionIn _$result;
    try {
      _$result = _$v ??
          _$InteractionIn._(
            pusherId: pusherId,
            note: note,
            occurredAt: BuiltValueNullFieldError.checkNotNull(
                occurredAt, r'InteractionIn', 'occurredAt'),
            deviceTimezone: deviceTimezone,
            isFavourite: isFavourite,
            buttonIds: _buttonIds?.build(),
            contextIds: _contextIds?.build(),
            modeledPusherIds: _modeledPusherIds?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'buttonIds';
        _buttonIds?.build();
        _$failedField = 'contextIds';
        _contextIds?.build();
        _$failedField = 'modeledPusherIds';
        _modeledPusherIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'InteractionIn', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
