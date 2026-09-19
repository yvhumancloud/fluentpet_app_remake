// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserOut extends UserOut {
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

  factory _$UserOut([void Function(UserOutBuilder)? updates]) =>
      (UserOutBuilder()..update(updates))._build();

  _$UserOut._(
      {required this.id,
      required this.email,
      this.fullName,
      required this.timezone,
      this.appVersion,
      required this.isHouseholdAdmin})
      : super._();
  @override
  UserOut rebuild(void Function(UserOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserOutBuilder toBuilder() => UserOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserOut &&
        id == other.id &&
        email == other.email &&
        fullName == other.fullName &&
        timezone == other.timezone &&
        appVersion == other.appVersion &&
        isHouseholdAdmin == other.isHouseholdAdmin;
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
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserOut')
          ..add('id', id)
          ..add('email', email)
          ..add('fullName', fullName)
          ..add('timezone', timezone)
          ..add('appVersion', appVersion)
          ..add('isHouseholdAdmin', isHouseholdAdmin))
        .toString();
  }
}

class UserOutBuilder implements Builder<UserOut, UserOutBuilder> {
  _$UserOut? _$v;

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

  UserOutBuilder() {
    UserOut._defaults(this);
  }

  UserOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _email = $v.email;
      _fullName = $v.fullName;
      _timezone = $v.timezone;
      _appVersion = $v.appVersion;
      _isHouseholdAdmin = $v.isHouseholdAdmin;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserOut other) {
    _$v = other as _$UserOut;
  }

  @override
  void update(void Function(UserOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserOut build() => _build();

  _$UserOut _build() {
    final _$result = _$v ??
        _$UserOut._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'UserOut', 'id'),
          email:
              BuiltValueNullFieldError.checkNotNull(email, r'UserOut', 'email'),
          fullName: fullName,
          timezone: BuiltValueNullFieldError.checkNotNull(
              timezone, r'UserOut', 'timezone'),
          appVersion: appVersion,
          isHouseholdAdmin: BuiltValueNullFieldError.checkNotNull(
              isHouseholdAdmin, r'UserOut', 'isHouseholdAdmin'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
