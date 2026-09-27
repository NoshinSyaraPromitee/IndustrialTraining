import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/chat_providers.dart';

/// Sidebar listing every saved conversation, newest first — tap one to
/// switch to it, delete via the trash icon, or start a new chat. Mirrors
/// the ChatGPT-style sidebar pattern.
class ChatListDrawer extends ConsumerWidget {
  const ChatListDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatListProvider);
    final conversations = [...chatState.conversations]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Chats',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_comment_outlined),
                    tooltip: 'New chat',
                    onPressed: () {
                      ref.read(chatListProvider.notifier).startNewConversation();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: conversations.isEmpty
                  ? const Center(child: Text('No chats yet'))
                  : ListView.builder(
                      itemCount: conversations.length,
                      itemBuilder: (context, index) {
                        final convo = conversations[index];
                        final isActive = convo.id == chatState.activeId;
                        return ListTile(
                          selected: isActive,
                          selectedTileColor:
                              Theme.of(context).colorScheme.secondaryContainer,
                          leading: const Icon(Icons.chat_bubble_outline),
                          title: Text(
                            convo.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            tooltip: 'Delete chat',
                            onPressed: () => ref
                                .read(chatListProvider.notifier)
                                .deleteConversation(convo.id),
                          ),
                          onTap: () {
                            ref
                                .read(chatListProvider.notifier)
                                .selectConversation(convo.id);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}