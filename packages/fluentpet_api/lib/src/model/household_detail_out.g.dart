// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'household_detail_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$HouseholdDetailOut extends HouseholdDetailOut {
  @override
  final int id;
  @override
  final String name;
  @override
  final BuiltList<UserOut> members;
  @override
  final BuiltList<InvitationOut> invitations;

  factory _$HouseholdDetailOut(
          [void Function(HouseholdDetailOutBuilder)? updates]) =>
      (HouseholdDetailOutBuilder()..update(updates))._build();

  _$HouseholdDetailOut._(
      {required this.id,
      required this.name,
      required this.members,
      required this.invitations})
      : super._();
  @override
  HouseholdDetailOut rebuild(
          void Function(HouseholdDetailOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HouseholdDetailOutBuilder toBuilder() =>
      HouseholdDetailOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HouseholdDetailOut &&
        id == other.id &&
        name == other.name &&
        members == other.members &&
        invitations == other.invitations;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, members.hashCode);
    _$hash = $jc(_$hash, invitations.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HouseholdDetailOut')
          ..add('id', id)
          ..add('name', name)
          ..add('members', members)
          ..add('invitations', invitations))
        .toString();
  }
}

class HouseholdDetailOutBuilder
    implements Builder<HouseholdDetailOut, HouseholdDetailOutBuilder> {
  _$HouseholdDetailOut? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ListBuilder<UserOut>? _members;
  ListBuilder<UserOut> get members =>
      _$this._members ??= ListBuilder<UserOut>();
  set members(ListBuilder<UserOut>? members) => _$this._members = members;

  ListBuilder<InvitationOut>? _invitations;
  ListBuilder<InvitationOut> get invitations =>
      _$this._invitations ??= ListBuilder<InvitationOut>();
  set invitations(ListBuilder<InvitationOut>? invitations) =>
      _$this._invitations = invitations;

  HouseholdDetailOutBuilder() {
    HouseholdDetailOut._defaults(this);
  }

  HouseholdDetailOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _members = $v.members.toBuilder();
      _invitations = $v.invitations.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HouseholdDetailOut other) {
    _$v = other as _$HouseholdDetailOut;
  }

  @override
  void update(void Function(HouseholdDetailOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HouseholdDetailOut build() => _build();

  _$HouseholdDetailOut _build() {
    _$HouseholdDetailOut _$result;
    try {
      _$result = _$v ??
          _$HouseholdDetailOut._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'HouseholdDetailOut', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'HouseholdDetailOut', 'name'),
            members: members.build(),
            invitations: invitations.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'members';
        members.build();
        _$failedField = 'invitations';
        invitations.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'HouseholdDetailOut', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
