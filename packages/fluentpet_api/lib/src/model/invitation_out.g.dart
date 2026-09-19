// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invitation_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InvitationOut extends InvitationOut {
  @override
  final int id;
  @override
  final int householdId;
  @override
  final String householdName;
  @override
  final String invitedBy;
  @override
  final String email;
  @override
  final String status;
  @override
  final DateTime expiresAt;

  factory _$InvitationOut([void Function(InvitationOutBuilder)? updates]) =>
      (InvitationOutBuilder()..update(updates))._build();

  _$InvitationOut._(
      {required this.id,
      required this.householdId,
      required this.householdName,
      required this.invitedBy,
      required this.email,
      required this.status,
      required this.expiresAt})
      : super._();
  @override
  InvitationOut rebuild(void Function(InvitationOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InvitationOutBuilder toBuilder() => InvitationOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InvitationOut &&
        id == other.id &&
        householdId == other.householdId &&
        householdName == other.householdName &&
        invitedBy == other.invitedBy &&
        email == other.email &&
        status == other.status &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, householdId.hashCode);
    _$hash = $jc(_$hash, householdName.hashCode);
    _$hash = $jc(_$hash, invitedBy.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InvitationOut')
          ..add('id', id)
          ..add('householdId', householdId)
          ..add('householdName', householdName)
          ..add('invitedBy', invitedBy)
          ..add('email', email)
          ..add('status', status)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class InvitationOutBuilder
    implements Builder<InvitationOut, InvitationOutBuilder> {
  _$InvitationOut? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _householdId;
  int? get householdId => _$this._householdId;
  set householdId(int? householdId) => _$this._householdId = householdId;

  String? _householdName;
  String? get householdName => _$this._householdName;
  set householdName(String? householdName) =>
      _$this._householdName = householdName;

  String? _invitedBy;
  String? get invitedBy => _$this._invitedBy;
  set invitedBy(String? invitedBy) => _$this._invitedBy = invitedBy;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  InvitationOutBuilder() {
    InvitationOut._defaults(this);
  }

  InvitationOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _householdId = $v.householdId;
      _householdName = $v.householdName;
      _invitedBy = $v.invitedBy;
      _email = $v.email;
      _status = $v.status;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InvitationOut other) {
    _$v = other as _$InvitationOut;
  }

  @override
  void update(void Function(InvitationOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InvitationOut build() => _build();

  _$InvitationOut _build() {
    final _$result = _$v ??
        _$InvitationOut._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'InvitationOut', 'id'),
          householdId: BuiltValueNullFieldError.checkNotNull(
              householdId, r'InvitationOut', 'householdId'),
          householdName: BuiltValueNullFieldError.checkNotNull(
              householdName, r'InvitationOut', 'householdName'),
          invitedBy: BuiltValueNullFieldError.checkNotNull(
              invitedBy, r'InvitationOut', 'invitedBy'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'InvitationOut', 'email'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'InvitationOut', 'status'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'InvitationOut', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
