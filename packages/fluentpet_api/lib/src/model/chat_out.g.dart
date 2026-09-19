// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatOut extends ChatOut {
  @override
  final String reply;
  @override
  final int remainingToday;

  factory _$ChatOut([void Function(ChatOutBuilder)? updates]) =>
      (ChatOutBuilder()..update(updates))._build();

  _$ChatOut._({required this.reply, required this.remainingToday}) : super._();
  @override
  ChatOut rebuild(void Function(ChatOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatOutBuilder toBuilder() => ChatOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatOut &&
        reply == other.reply &&
        remainingToday == other.remainingToday;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reply.hashCode);
    _$hash = $jc(_$hash, remainingToday.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatOut')
          ..add('reply', reply)
          ..add('remainingToday', remainingToday))
        .toString();
  }
}

class ChatOutBuilder implements Builder<ChatOut, ChatOutBuilder> {
  _$ChatOut? _$v;

  String? _reply;
  String? get reply => _$this._reply;
  set reply(String? reply) => _$this._reply = reply;

  int? _remainingToday;
  int? get remainingToday => _$this._remainingToday;
  set remainingToday(int? remainingToday) =>
      _$this._remainingToday = remainingToday;

  ChatOutBuilder() {
    ChatOut._defaults(this);
  }

  ChatOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reply = $v.reply;
      _remainingToday = $v.remainingToday;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatOut other) {
    _$v = other as _$ChatOut;
  }

  @override
  void update(void Function(ChatOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatOut build() => _build();

  _$ChatOut _build() {
    final _$result = _$v ??
        _$ChatOut._(
          reply:
              BuiltValueNullFieldError.checkNotNull(reply, r'ChatOut', 'reply'),
          remainingToday: BuiltValueNullFieldError.checkNotNull(
              remainingToday, r'ChatOut', 'remainingToday'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
