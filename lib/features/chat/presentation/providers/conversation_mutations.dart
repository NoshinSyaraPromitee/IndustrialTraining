import '../../domain/chat_message.dart';
import '../../domain/conversation.dart';

/// Pure helpers for updating the immutable conversation list. Split out of
/// [ConversationsNotifier] so that file stays short and these stay easy to
/// unit test on their own.

List<Conversation> withUpdatedConversation(
  List<Conversation> conversations,
  String id,
  Conversation Function(Conversation) update,
) {
  return [
    for (final c in conversations)
      if (c.id == id) update(c) else c,
  ];
}

Conversation appendMessage(Conversation conversation, ChatMessage message) {
  final isFirstUserMessage =
      conversation.messages.isEmpty && message.role == ChatRole.user;
  return conversation.copyWith(
    messages: [...conversation.messages, message],
    title: isFirstUserMessage ? titleFrom(message.text) : conversation.title,
    updatedAt: DateTime.now(),
  );
}

Conversation updateMessage(
  Conversation conversation,
  String messageId,
  ChatMessage Function(ChatMessage) update,
) {
  return conversation.copyWith(
    messages: [
      for (final m in conversation.messages)
        if (m.id == messageId) update(m) else m,
    ],
  );
}

String titleFrom(String text) {
  final oneLine = text.replaceAll('\n', ' ').trim();
  return oneLine.length <= 40 ? oneLine : '${oneLine.substring(0, 40)}…';
}