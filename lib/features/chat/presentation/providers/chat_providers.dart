import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/chat_repository.dart';
import '../../data/groq_chat_service.dart';
import '../../domain/chat_message.dart';
import 'chat_list_state.dart';
import 'conversations_notifier.dart';

export 'chat_list_state.dart';
export 'conversations_notifier.dart';

final groqServiceProvider = Provider<GroqChatService>((ref) {
  return GroqChatService();
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository();
});

final chatListProvider =
    StateNotifierProvider<ConversationsNotifier, ChatListState>((ref) {
  return ConversationsNotifier(
    ref.read(chatRepositoryProvider),
    ref.read(groqServiceProvider),
  );
});

/// The active conversation's messages — what [ChatScreen] renders. Empty
/// until the initial load from storage finishes.
final activeMessagesProvider = Provider<List<ChatMessage>>((ref) {
  final state = ref.watch(chatListProvider);
  for (final c in state.conversations) {
    if (c.id == state.activeId) return c.messages;
  }
  return const [];
});