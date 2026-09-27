import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'action_icon.dart';
import 'message_actions.dart';

/// Row of small, always-visible icon buttons shown under a message bubble:
/// copy text, react with an emoji, and (for the sender only) edit the text.
class MessageActionBar extends StatelessWidget {
  const MessageActionBar({
    super.key,
    required this.message,
    required this.isMine,
  });

  final Message message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;

    return Padding(
      padding: EdgeInsets.only(
        left: isMine ? 0 : 12,
        right: isMine ? 12 : 0,
        bottom: 6,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          ActionIcon(
            icon: Icons.copy_rounded,
            tooltip: 'Copy',
            onTap: () => copyMessageText(context, message),
          ),
          ActionIcon(
            icon: Icons.emoji_emotions_outlined,
            tooltip: 'React',
            onTap: () => reactToMessage(context, channel, message),
          ),
          if (isMine)
            ActionIcon(
              icon: Icons.edit_outlined,
              tooltip: 'Edit',
              onTap: () => editMessage(context, channel, message),
            ),
        ],
      ),
    );
  }
}