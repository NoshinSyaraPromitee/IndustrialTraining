import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'message_action_bar.dart';

/// [MessageBuilder] used by [StreamMessageListView] to render every message
/// bubble with an always-visible action row underneath it (copy / react /
/// edit), instead of relying only on the SDK's hidden long-press menu.
///
/// Wire it up with:
/// ```dart
/// StreamMessageListView(messageBuilder: buildMessageWithActions)
/// ```
Widget buildMessageWithActions(
  BuildContext context,
  MessageDetails details,
  List<Message> messages,
  StreamMessageWidget defaultWidget,
) {
  return Column(
    crossAxisAlignment:
        details.isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    children: [
      defaultWidget,
      MessageActionBar(message: details.message, isMine: details.isMyMessage),
    ],
  );
}