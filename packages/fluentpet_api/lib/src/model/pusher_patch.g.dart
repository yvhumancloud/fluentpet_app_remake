// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pusher_patch.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PusherPatch extends PusherPatch {
  @override
  final String? name;
  @override
  final bool? isHuman;
  @override
  final Date? birthDate;
  @override
  final String? sex;
  @override
  final int? learnerTypeId;
  @override
  final String? subType;
  @override
  final String? country;
  @override
  final String? language;
  @override
  final Date? trainingStartedAt;
  @override
  final bool? isHidden;

  factory _$PusherPatch([void Function(PusherPatchBuilder)? updates]) =>
      (PusherPatchBuilder()..update(updates))._build();

  _$PusherPatch._(
      {this.name,
      this.isHuman,
      this.birthDate,
      this.sex,
      this.learnerTypeId,
      this.subType,
      this.country,
      this.language,
      this.trainingStartedAt,
      this.isHidden})
      : super._();
  @override
  PusherPatch rebuild(void Function(PusherPatchBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PusherPatchBuilder toBuilder() => PusherPatchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PusherPatch &&
        name == other.name &&
        isHuman == other.isHuman &&
        birthDate == other.birthDate &&
        sex == other.sex &&
        learnerTypeId == other.learnerTypeId &&
        subType == other.subType &&
        country == other.country &&
        language == other.language &&
        trainingStartedAt == other.trainingStartedAt &&
        isHidden == other.isHidden;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, isHuman.hashCode);
    _$hash = $jc(_$hash, birthDate.hashCode);
    _$hash = $jc(_$hash, sex.hashCode);
    _$hash = $jc(_$hash, learnerTypeId.hashCode);
    _$hash = $jc(_$hash, subType.hashCode);
    _$hash = $jc(_$hash, country.hashCode);
    _$hash = $jc(_$hash, language.hashCode);
    _$hash = $jc(_$hash, trainingStartedAt.hashCode);
    _$hash = $jc(_$hash, isHidden.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PusherPatch')
          ..add('name', name)
          ..add('isHuman', isHuman)
          ..add('birthDate', birthDate)
          ..add('sex', sex)
          ..add('learnerTypeId', learnerTypeId)
          ..add('subType', subType)
          ..add('country', country)
          ..add('language', language)
          ..add('trainingStartedAt', trainingStartedAt)
          ..add('isHidden', isHidden))
        .toString();
  }
}

class PusherPatchBuilder implements Builder<PusherPatch, PusherPatchBuilder> {
  _$PusherPatch? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  bool? _isHuman;
  bool? get isHuman => _$this._isHuman;
  set isHuman(bool? isHuman) => _$this._isHuman = isHuman;

  Date? _birthDate;
  Date? get birthDate => _$this._birthDate;
  set birthDate(Date? birthDate) => _$this._birthDate = birthDate;

  String? _sex;
  String? get sex => _$this._sex;
  set sex(String? sex) => _$this._sex = sex;

  int? _learnerTypeId;
  int? get learnerTypeId => _$this._learnerTypeId;
  set learnerTypeId(int? learnerTypeId) =>
      _$this._learnerTypeId = learnerTypeId;

  String? _subType;
  String? get subType => _$this._subType;
  set subType(String? subType) => _$this._subType = subType;

  String? _country;
  String? get country => _$this._country;
  set country(String? country) => _$this._country = country;

  String? _language;
  String? get language => _$this._language;
  set language(String? language) => _$this._language = language;

  Date? _trainingStartedAt;
  Date? get trainingStartedAt => _$this._trainingStartedAt;
  set trainingStartedAt(Date? trainingStartedAt) =>
      _$this._trainingStartedAt = trainingStartedAt;

  bool? _isHidden;
  bool? get isHidden => _$this._isHidden;
  set isHidden(bool? isHidden) => _$this._isHidden = isHidden;

  PusherPatchBuilder() {
    PusherPatch._defaults(this);
  }

  PusherPatchBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _isHuman = $v.isHuman;
      _birthDate = $v.birthDate;
      _sex = $v.sex;
      _learnerTypeId = $v.learnerTypeId;
      _subType = $v.subType;
      _country = $v.country;
      _language = $v.language;
      _trainingStartedAt = $v.trainingStartedAt;
      _isHidden = $v.isHidden;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PusherPatch other) {
    _$v = other as _$PusherPatch;
  }

  @override
  void update(void Function(PusherPatchBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PusherPatch build() => _build();

  _$PusherPatch _build() {
    final _$result = _$v ??
        _$PusherPatch._(
          name: name,
          isHuman: isHuman,
          birthDate: birthDate,
          sex: sex,
          learnerTypeId: learnerTypeId,
          subType: subType,
          country: country,
          language: language,
          trainingStartedAt: trainingStartedAt,
          isHidden: isHidden,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
