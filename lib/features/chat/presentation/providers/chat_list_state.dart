import '../../domain/conversation.dart';

/// All saved conversations plus which one is currently open.
class ChatListState {
  const ChatListState({required this.conversations, this.activeId});

  final List<Conversation> conversations;
  final String? activeId;

  ChatListState copyWith({
    List<Conversation>? conversations,
    String? activeId,
  }) {
    return ChatListState(
      conversations: conversations ?? this.conversations,
      activeId: activeId ?? this.activeId,
    );
  }
}