// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pusher_detail_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PusherDetailOut extends PusherDetailOut {
  @override
  final int id;
  @override
  final String name;
  @override
  final bool isHuman;
  @override
  final bool isHidden;
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
  final int interactionsCount;
  @override
  final String? avatarUrl;

  factory _$PusherDetailOut([void Function(PusherDetailOutBuilder)? updates]) =>
      (PusherDetailOutBuilder()..update(updates))._build();

  _$PusherDetailOut._(
      {required this.id,
      required this.name,
      required this.isHuman,
      required this.isHidden,
      this.birthDate,
      this.sex,
      this.learnerTypeId,
      this.subType,
      this.country,
      this.language,
      this.trainingStartedAt,
      required this.interactionsCount,
      this.avatarUrl})
      : super._();
  @override
  PusherDetailOut rebuild(void Function(PusherDetailOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PusherDetailOutBuilder toBuilder() => PusherDetailOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PusherDetailOut &&
        id == other.id &&
        name == other.name &&
        isHuman == other.isHuman &&
        isHidden == other.isHidden &&
        birthDate == other.birthDate &&
        sex == other.sex &&
        learnerTypeId == other.learnerTypeId &&
        subType == other.subType &&
        country == other.country &&
        language == other.language &&
        trainingStartedAt == other.trainingStartedAt &&
        interactionsCount == other.interactionsCount &&
        avatarUrl == other.avatarUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, isHuman.hashCode);
    _$hash = $jc(_$hash, isHidden.hashCode);
    _$hash = $jc(_$hash, birthDate.hashCode);
    _$hash = $jc(_$hash, sex.hashCode);
    _$hash = $jc(_$hash, learnerTypeId.hashCode);
    _$hash = $jc(_$hash, subType.hashCode);
    _$hash = $jc(_$hash, country.hashCode);
    _$hash = $jc(_$hash, language.hashCode);
    _$hash = $jc(_$hash, trainingStartedAt.hashCode);
    _$hash = $jc(_$hash, interactionsCount.hashCode);
    _$hash = $jc(_$hash, avatarUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PusherDetailOut')
          ..add('id', id)
          ..add('name', name)
          ..add('isHuman', isHuman)
          ..add('isHidden', isHidden)
          ..add('birthDate', birthDate)
          ..add('sex', sex)
          ..add('learnerTypeId', learnerTypeId)
          ..add('subType', subType)
          ..add('country', country)
          ..add('language', language)
          ..add('trainingStartedAt', trainingStartedAt)
          ..add('interactionsCount', interactionsCount)
          ..add('avatarUrl', avatarUrl))
        .toString();
  }
}

class PusherDetailOutBuilder
    implements Builder<PusherDetailOut, PusherDetailOutBuilder> {
  _$PusherDetailOut? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  bool? _isHuman;
  bool? get isHuman => _$this._isHuman;
  set isHuman(bool? isHuman) => _$this._isHuman = isHuman;

  bool? _isHidden;
  bool? get isHidden => _$this._isHidden;
  set isHidden(bool? isHidden) => _$this._isHidden = isHidden;

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

  int? _interactionsCount;
  int? get interactionsCount => _$this._interactionsCount;
  set interactionsCount(int? interactionsCount) =>
      _$this._interactionsCount = interactionsCount;

  String? _avatarUrl;
  String? get avatarUrl => _$this._avatarUrl;
  set avatarUrl(String? avatarUrl) => _$this._avatarUrl = avatarUrl;

  PusherDetailOutBuilder() {
    PusherDetailOut._defaults(this);
  }

  PusherDetailOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _isHuman = $v.isHuman;
      _isHidden = $v.isHidden;
      _birthDate = $v.birthDate;
      _sex = $v.sex;
      _learnerTypeId = $v.learnerTypeId;
      _subType = $v.subType;
      _country = $v.country;
      _language = $v.language;
      _trainingStartedAt = $v.trainingStartedAt;
      _interactionsCount = $v.interactionsCount;
      _avatarUrl = $v.avatarUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PusherDetailOut other) {
    _$v = other as _$PusherDetailOut;
  }

  @override
  void update(void Function(PusherDetailOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PusherDetailOut build() => _build();

  _$PusherDetailOut _build() {
    final _$result = _$v ??
        _$PusherDetailOut._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'PusherDetailOut', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'PusherDetailOut', 'name'),
          isHuman: BuiltValueNullFieldError.checkNotNull(
              isHuman, r'PusherDetailOut', 'isHuman'),
          isHidden: BuiltValueNullFieldError.checkNotNull(
              isHidden, r'PusherDetailOut', 'isHidden'),
          birthDate: birthDate,
          sex: sex,
          learnerTypeId: learnerTypeId,
          subType: subType,
          country: country,
          language: language,
          trainingStartedAt: trainingStartedAt,
          interactionsCount: BuiltValueNullFieldError.checkNotNull(
              interactionsCount, r'PusherDetailOut', 'interactionsCount'),
          avatarUrl: avatarUrl,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
