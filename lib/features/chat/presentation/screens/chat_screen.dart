import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/chat_providers.dart';
import '../widgets/chat_input.dart';
import '../widgets/chat_list_drawer.dart';
import '../widgets/message_bubble.dart';

/// The whole chatbot screen: a sidebar of saved chats, a scrolling message
/// list for the active one, and an input bar.
///
/// Auto-scrolls to the newest content whenever the active conversation
/// changes — including every incremental chunk while the assistant's
/// reply is still streaming in — so the latest text is always visible,
/// ChatGPT-style.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(activeMessagesProvider);
    ref.listen(activeMessagesProvider, (_, __) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chatbot'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_outlined),
            tooltip: 'New chat',
            onPressed: () =>
                ref.read(chatListProvider.notifier).startNewConversation(),
          ),
        ],
      ),
      drawer: const ChatListDrawer(),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? const Center(child: Text('Say hello to get started.'))
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: messages.length,
                    itemBuilder: (context, index) =>
                        MessageBubble(message: messages[index]),
                  ),
          ),
          const ChatInput(),
        ],
      ),
    );
  }
}