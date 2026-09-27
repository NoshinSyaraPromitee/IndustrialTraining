import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/chat_message.dart';
import 'action_icon.dart';
import 'message_actions.dart';

/// Row of small icon buttons under a bubble: copy for every message, edit
/// for the user's own messages, and thumbs up/down feedback on AI replies.
class MessageActionBar extends ConsumerWidget {
  const MessageActionBar({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUser = message.role == ChatRole.user;

    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ActionIcon(
            icon: Icons.copy_rounded,
            tooltip: 'Copy',
            onTap: () => copyMessageText(context, message),
          ),
          if (isUser)
            ActionIcon(
              icon: Icons.edit_outlined,
              tooltip: 'Edit & resend',
              onTap: () => editAndResend(context, ref, message),
            )
          else ...[
            ActionIcon(
              icon: Icons.thumb_up_outlined,
              tooltip: 'Good response',
              onTap: () => sendFeedback(context, true),
            ),
            ActionIcon(
              icon: Icons.thumb_down_outlined,
              tooltip: 'Bad response',
              onTap: () => sendFeedback(context, false),
            ),
          ],
        ],
      ),
    );
  }
}