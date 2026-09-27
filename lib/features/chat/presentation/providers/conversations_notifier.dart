import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/chat_repository.dart';
import '../../data/groq_chat_service.dart';
import '../../domain/chat_message.dart';
import '../../domain/conversation.dart';
import 'chat_list_state.dart';
import 'conversation_mutations.dart';

part 'conversation_streaming.dart';

/// Owns every conversation: loading/saving them to [ChatRepository],
/// switching the active one, and (via the `part` file above) streaming
/// replies from Groq into it. Split into two physical files to stay
/// short; `part`/`part of` keeps them one library so the streaming half
/// can still reach this class's private state and helpers.
class ConversationsNotifier extends StateNotifier<ChatListState> {
  ConversationsNotifier(this._repo, this._service)
      : super(const ChatListState(conversations: [])) {
    _load();
  }

  final ChatRepository _repo;
  final GroqChatService _service;
  int _idCounter = 0;

  String _nextId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${_idCounter++}';

  Future<void> _load() async {
    final loaded = await _repo.loadConversations();
    if (loaded.isEmpty) {
      final convo = _blankConversation();
      state = ChatListState(conversations: [convo], activeId: convo.id);
      await _persist();
      return;
    }
    final savedActiveId = await _repo.loadActiveId();
    final activeId = loaded.any((c) => c.id == savedActiveId)
        ? savedActiveId
        : loaded.first.id;
    state = ChatListState(conversations: loaded, activeId: activeId);
  }

  Conversation _blankConversation() => Conversation(
        id: _nextId(),
        title: 'New chat',
        messages: const [],
        updatedAt: DateTime.now(),
      );

  /// Starts a fresh, empty conversation and makes it active.
  void startNewConversation() {
    final convo = _blankConversation();
    state = ChatListState(
      conversations: [convo, ...state.conversations],
      activeId: convo.id,
    );
    _persist();
  }

  void selectConversation(String id) {
    state = state.copyWith(activeId: id);
    _persist();
  }

  /// Deletes a conversation. If it was the active one, falls back to the
  /// next most recent conversation, or a new blank one if that was the
  /// last conversation left.
  void deleteConversation(String id) {
    final remaining = state.conversations.where((c) => c.id != id).toList();
    if (remaining.isEmpty) {
      final convo = _blankConversation();
      state = ChatListState(conversations: [convo], activeId: convo.id);
      _persist();
      return;
    }
    final newActiveId =
        state.activeId == id ? remaining.first.id : state.activeId;
    state = ChatListState(conversations: remaining, activeId: newActiveId);
    _persist();
  }

  /// Applies [update] to the conversation with [conversationId].
  void _mutate(
      String conversationId, Conversation Function(Conversation) update) {
    state = state.copyWith(
      conversations:
          withUpdatedConversation(state.conversations, conversationId, update),
    );
  }

  Future<void> _persist() async {
    await _repo.saveConversations(state.conversations);
    await _repo.saveActiveId(state.activeId);
  }
}