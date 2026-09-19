// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_in.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatIn extends ChatIn {
  @override
  final BuiltList<ChatMessage> messages;

  factory _$ChatIn([void Function(ChatInBuilder)? updates]) =>
      (ChatInBuilder()..update(updates))._build();

  _$ChatIn._({required this.messages}) : super._();
  @override
  ChatIn rebuild(void Function(ChatInBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatInBuilder toBuilder() => ChatInBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatIn && messages == other.messages;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, messages.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatIn')..add('messages', messages))
        .toString();
  }
}

class ChatInBuilder implements Builder<ChatIn, ChatInBuilder> {
  _$ChatIn? _$v;

  ListBuilder<ChatMessage>? _messages;
  ListBuilder<ChatMessage> get messages =>
      _$this._messages ??= ListBuilder<ChatMessage>();
  set messages(ListBuilder<ChatMessage>? messages) =>
      _$this._messages = messages;

  ChatInBuilder() {
    ChatIn._defaults(this);
  }

  ChatInBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _messages = $v.messages.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatIn other) {
    _$v = other as _$ChatIn;
  }

  @override
  void update(void Function(ChatInBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatIn build() => _build();

  _$ChatIn _build() {
    _$ChatIn _$result;
    try {
      _$result = _$v ??
          _$ChatIn._(
            messages: messages.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'messages';
        messages.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ChatIn', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
