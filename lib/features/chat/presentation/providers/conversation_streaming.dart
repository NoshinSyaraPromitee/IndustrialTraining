part of 'conversations_notifier.dart';

/// The message-sending / reply-streaming half of [ConversationsNotifier],
/// split into its own file to keep each file short. `part of` keeps this
/// in the same library as conversations_notifier.dart, so it can still
/// use that class's private `_mutate`, `_nextId`, `_service`, `_persist`.
extension ConversationStreaming on ConversationsNotifier {
  /// Sends [text] as a new user message in the active conversation and
  /// streams the assistant's reply.
  Future<void> sendMessage(String text) async {
    final conversationId = state.activeId;
    final trimmed = text.trim();
    if (conversationId == null || trimmed.isEmpty) return;

    _mutate(
      conversationId,
      (c) => appendMessage(
        c,
        ChatMessage(id: _nextId(), role: ChatRole.user, text: trimmed),
      ),
    );
    await _persist();
    await _streamAssistantReply(conversationId);
  }

  /// Edits an earlier user message: drops everything from that point
  /// onward and resends the edited text, so the assistant regenerates its
  /// reply — the same behaviour as editing a message in ChatGPT.
  Future<void> regenerateFrom(String userMessageId, String newText) async {
    final conversationId = state.activeId;
    if (conversationId == null) return;
    final convo =
        state.conversations.firstWhere((c) => c.id == conversationId);
    final index = convo.messages.indexWhere((m) => m.id == userMessageId);
    if (index == -1) return;
    _mutate(conversationId,
        (c) => c.copyWith(messages: c.messages.sublist(0, index)));
    await sendMessage(newText);
  }

  Future<void> _streamAssistantReply(String conversationId) async {
    final convo =
        state.conversations.firstWhere((c) => c.id == conversationId);
    final historyForApi = List<ChatMessage>.from(convo.messages);
    final assistantId = _nextId();

    _mutate(
      conversationId,
      (c) => appendMessage(
        c,
        ChatMessage(
            id: assistantId,
            role: ChatRole.assistant,
            text: '',
            isStreaming: true),
      ),
    );

    try {
      await for (final chunk in _service.streamReply(historyForApi)) {
        _mutate(
          conversationId,
          (c) => updateMessage(
              c, assistantId, (m) => m.copyWith(text: m.text + chunk)),
        );
      }
    } catch (e) {
      _mutate(
        conversationId,
        (c) => updateMessage(
            c,
            assistantId,
            (m) => m.copyWith(
                text: 'Something went wrong: $e', isStreaming: false)),
      );
      await _persist();
      return;
    }

    _mutate(
      conversationId,
      (c) =>
          updateMessage(c, assistantId, (m) => m.copyWith(isStreaming: false)),
    );
    await _persist();
  }
}