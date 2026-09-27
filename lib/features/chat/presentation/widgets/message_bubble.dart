import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../../domain/chat_message.dart';
import 'message_action_bar.dart';

/// Renders one chat bubble plus its action row (copy / edit / feedback).
/// While [ChatMessage.isStreaming] is true and no text has arrived yet, a
/// small spinner stands in for the "assistant is typing" moment.
class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatRole.user;
    final theme = Theme.of(context);
    final bubbleColor = isUser
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surfaceContainerHighest;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: message.text.isEmpty && message.isStreaming
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : isUser
                      ? SelectableText(message.text)
                      : MarkdownBody(
                          // noScroll: renders as a plain Column, not its
                          // own scrollable — the outer ListView.builder in
                          // chat_screen.dart owns scrolling for the whole
                          // conversation.
                          data: message.text,
                          selectable: true,
                          styleSheet: MarkdownStyleSheet.fromTheme(theme)
                              .copyWith(
                            p: theme.textTheme.bodyMedium,
                          ),
                        ),
            ),
          ),
          if (!message.isStreaming) MessageActionBar(message: message),
        ],
      ),
    );
  }
}