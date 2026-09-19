// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_patch.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MePatch extends MePatch {
  @override
  final String? fullName;
  @override
  final String? timezone;
  @override
  final String? appVersion;

  factory _$MePatch([void Function(MePatchBuilder)? updates]) =>
      (MePatchBuilder()..update(updates))._build();

  _$MePatch._({this.fullName, this.timezone, this.appVersion}) : super._();
  @override
  MePatch rebuild(void Function(MePatchBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MePatchBuilder toBuilder() => MePatchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MePatch &&
        fullName == other.fullName &&
        timezone == other.timezone &&
        appVersion == other.appVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, timezone.hashCode);
    _$hash = $jc(_$hash, appVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MePatch')
          ..add('fullName', fullName)
          ..add('timezone', timezone)
          ..add('appVersion', appVersion))
        .toString();
  }
}

class MePatchBuilder implements Builder<MePatch, MePatchBuilder> {
  _$MePatch? _$v;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _timezone;
  String? get timezone => _$this._timezone;
  set timezone(String? timezone) => _$this._timezone = timezone;

  String? _appVersion;
  String? get appVersion => _$this._appVersion;
  set appVersion(String? appVersion) => _$this._appVersion = appVersion;

  MePatchBuilder() {
    MePatch._defaults(this);
  }

  MePatchBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fullName = $v.fullName;
      _timezone = $v.timezone;
      _appVersion = $v.appVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MePatch other) {
    _$v = other as _$MePatch;
  }

  @override
  void update(void Function(MePatchBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MePatch build() => _build();

  _$MePatch _build() {
    final _$result = _$v ??
        _$MePatch._(
          fullName: fullName,
          timezone: timezone,
          appVersion: appVersion,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
