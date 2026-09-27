import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/chat_message.dart';
import '../providers/chat_providers.dart';

/// Copies [message]'s text to the clipboard and confirms with a snackbar.
Future<void> copyMessageText(BuildContext context, ChatMessage message) async {
  await Clipboard.setData(ClipboardData(text: message.text));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Copied to clipboard'),
      duration: Duration(seconds: 1),
    ),
  );
}

/// Local-only thumbs up/down acknowledgement on an assistant reply. There's
/// no backend here to persist it to — this just demonstrates the
/// interaction, matching what a class assignment needs to show.
void sendFeedback(BuildContext context, bool positive) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(positive ? 'Thanks for the feedback!' : 'Feedback noted.'),
      duration: const Duration(seconds: 1),
    ),
  );
}

/// Opens an edit dialog for one of the user's own messages. Saving it
/// discards every message after it and resends the edited text so the
/// assistant regenerates its reply from that point.
Future<void> editAndResend(
  BuildContext context,
  WidgetRef ref,
  ChatMessage message,
) async {
  final controller = TextEditingController(text: message.text);
  final newText = await showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Edit message'),
      content: TextField(
        controller: controller,
        autofocus: true,
        maxLines: null,
        decoration: const InputDecoration(border: OutlineInputBorder()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.of(dialogContext).pop(controller.text.trim()),
          child: const Text('Save & resend'),
        ),
      ],
    ),
  );
  controller.dispose();
  if (newText == null || newText.isEmpty || newText == message.text) return;
 await ref.read(chatListProvider.notifier).regenerateFrom(
      message.id,
      newText,
    );
}