// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MeOut extends MeOut {
  @override
  final int id;
  @override
  final String email;
  @override
  final String? fullName;
  @override
  final String timezone;
  @override
  final String? appVersion;
  @override
  final bool isHouseholdAdmin;
  @override
  final HouseholdOut household;
  @override
  final BuiltList<PusherOut> pushers;
  @override
  final BuiltMap<String, JsonObject?> featureFlags;
  @override
  final BuiltList<InvitationOut> pendingInvitations;

  factory _$MeOut([void Function(MeOutBuilder)? updates]) =>
      (MeOutBuilder()..update(updates))._build();

  _$MeOut._(
      {required this.id,
      required this.email,
      this.fullName,
      required this.timezone,
      this.appVersion,
      required this.isHouseholdAdmin,
      required this.household,
      required this.pushers,
      required this.featureFlags,
      required this.pendingInvitations})
      : super._();
  @override
  MeOut rebuild(void Function(MeOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MeOutBuilder toBuilder() => MeOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MeOut &&
        id == other.id &&
        email == other.email &&
        fullName == other.fullName &&
        timezone == other.timezone &&
        appVersion == other.appVersion &&
        isHouseholdAdmin == other.isHouseholdAdmin &&
        household == other.household &&
        pushers == other.pushers &&
        featureFlags == other.featureFlags &&
        pendingInvitations == other.pendingInvitations;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, timezone.hashCode);
    _$hash = $jc(_$hash, appVersion.hashCode);
    _$hash = $jc(_$hash, isHouseholdAdmin.hashCode);
    _$hash = $jc(_$hash, household.hashCode);
    _$hash = $jc(_$hash, pushers.hashCode);
    _$hash = $jc(_$hash, featureFlags.hashCode);
    _$hash = $jc(_$hash, pendingInvitations.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MeOut')
          ..add('id', id)
          ..add('email', email)
          ..add('fullName', fullName)
          ..add('timezone', timezone)
          ..add('appVersion', appVersion)
          ..add('isHouseholdAdmin', isHouseholdAdmin)
          ..add('household', household)
          ..add('pushers', pushers)
          ..add('featureFlags', featureFlags)
          ..add('pendingInvitations', pendingInvitations))
        .toString();
  }
}

class MeOutBuilder implements Builder<MeOut, MeOutBuilder> {
  _$MeOut? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _timezone;
  String? get timezone => _$this._timezone;
  set timezone(String? timezone) => _$this._timezone = timezone;

  String? _appVersion;
  String? get appVersion => _$this._appVersion;
  set appVersion(String? appVersion) => _$this._appVersion = appVersion;

  bool? _isHouseholdAdmin;
  bool? get isHouseholdAdmin => _$this._isHouseholdAdmin;
  set isHouseholdAdmin(bool? isHouseholdAdmin) =>
      _$this._isHouseholdAdmin = isHouseholdAdmin;

  HouseholdOutBuilder? _household;
  HouseholdOutBuilder get household =>
      _$this._household ??= HouseholdOutBuilder();
  set household(HouseholdOutBuilder? household) =>
      _$this._household = household;

  ListBuilder<PusherOut>? _pushers;
  ListBuilder<PusherOut> get pushers =>
      _$this._pushers ??= ListBuilder<PusherOut>();
  set pushers(ListBuilder<PusherOut>? pushers) => _$this._pushers = pushers;

  MapBuilder<String, JsonObject?>? _featureFlags;
  MapBuilder<String, JsonObject?> get featureFlags =>
      _$this._featureFlags ??= MapBuilder<String, JsonObject?>();
  set featureFlags(MapBuilder<String, JsonObject?>? featureFlags) =>
      _$this._featureFlags = featureFlags;

  ListBuilder<InvitationOut>? _pendingInvitations;
  ListBuilder<InvitationOut> get pendingInvitations =>
      _$this._pendingInvitations ??= ListBuilder<InvitationOut>();
  set pendingInvitations(ListBuilder<InvitationOut>? pendingInvitations) =>
      _$this._pendingInvitations = pendingInvitations;

  MeOutBuilder() {
    MeOut._defaults(this);
  }

  MeOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _email = $v.email;
      _fullName = $v.fullName;
      _timezone = $v.timezone;
      _appVersion = $v.appVersion;
      _isHouseholdAdmin = $v.isHouseholdAdmin;
      _household = $v.household.toBuilder();
      _pushers = $v.pushers.toBuilder();
      _featureFlags = $v.featureFlags.toBuilder();
      _pendingInvitations = $v.pendingInvitations.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MeOut other) {
    _$v = other as _$MeOut;
  }

  @override
  void update(void Function(MeOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MeOut build() => _build();

  _$MeOut _build() {
    _$MeOut _$result;
    try {
      _$result = _$v ??
          _$MeOut._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'MeOut', 'id'),
            email:
                BuiltValueNullFieldError.checkNotNull(email, r'MeOut', 'email'),
            fullName: fullName,
            timezone: BuiltValueNullFieldError.checkNotNull(
                timezone, r'MeOut', 'timezone'),
            appVersion: appVersion,
            isHouseholdAdmin: BuiltValueNullFieldError.checkNotNull(
                isHouseholdAdmin, r'MeOut', 'isHouseholdAdmin'),
            household: household.build(),
            pushers: pushers.build(),
            featureFlags: featureFlags.build(),
            pendingInvitations: pendingInvitations.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'household';
        household.build();
        _$failedField = 'pushers';
        pushers.build();
        _$failedField = 'featureFlags';
        featureFlags.build();
        _$failedField = 'pendingInvitations';
        pendingInvitations.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'MeOut', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
