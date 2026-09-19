// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invitations_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InvitationsOut extends InvitationsOut {
  @override
  final BuiltList<InvitationOut> sent;
  @override
  final BuiltList<InvitationOut> received;

  factory _$InvitationsOut([void Function(InvitationsOutBuilder)? updates]) =>
      (InvitationsOutBuilder()..update(updates))._build();

  _$InvitationsOut._({required this.sent, required this.received}) : super._();
  @override
  InvitationsOut rebuild(void Function(InvitationsOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InvitationsOutBuilder toBuilder() => InvitationsOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InvitationsOut &&
        sent == other.sent &&
        received == other.received;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sent.hashCode);
    _$hash = $jc(_$hash, received.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InvitationsOut')
          ..add('sent', sent)
          ..add('received', received))
        .toString();
  }
}

class InvitationsOutBuilder
    implements Builder<InvitationsOut, InvitationsOutBuilder> {
  _$InvitationsOut? _$v;

  ListBuilder<InvitationOut>? _sent;
  ListBuilder<InvitationOut> get sent =>
      _$this._sent ??= ListBuilder<InvitationOut>();
  set sent(ListBuilder<InvitationOut>? sent) => _$this._sent = sent;

  ListBuilder<InvitationOut>? _received;
  ListBuilder<InvitationOut> get received =>
      _$this._received ??= ListBuilder<InvitationOut>();
  set received(ListBuilder<InvitationOut>? received) =>
      _$this._received = received;

  InvitationsOutBuilder() {
    InvitationsOut._defaults(this);
  }

  InvitationsOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sent = $v.sent.toBuilder();
      _received = $v.received.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InvitationsOut other) {
    _$v = other as _$InvitationsOut;
  }

  @override
  void update(void Function(InvitationsOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InvitationsOut build() => _build();

  _$InvitationsOut _build() {
    _$InvitationsOut _$result;
    try {
      _$result = _$v ??
          _$InvitationsOut._(
            sent: sent.build(),
            received: received.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sent';
        sent.build();
        _$failedField = 'received';
        received.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'InvitationsOut', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
