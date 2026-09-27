import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'reaction_picker.dart';

/// Copies [message]'s text to the clipboard and confirms with a snackbar.
Future<void> copyMessageText(BuildContext context, Message message) async {
  await Clipboard.setData(ClipboardData(text: message.text ?? ''));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Copied to clipboard'),
      duration: Duration(seconds: 1),
    ),
  );
}

/// Opens the emoji [ReactionPicker] and sends the chosen reaction type.
Future<void> reactToMessage(
  BuildContext context,
  Channel channel,
  Message message,
) async {
  final type = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (_) => const ReactionPicker(),
  );
  if (type == null) return;
  try {
    await channel.sendReaction(message, type);
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Could not react: $e')));
  }
}

/// Opens an edit dialog pre-filled with [message]'s text and saves the
/// change via [Channel.updateMessage] if the user confirms.
Future<void> editMessage(
  BuildContext context,
  Channel channel,
  Message message,
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
          child: const Text('Save'),
        ),
      ],
    ),
  );
  controller.dispose();
  if (newText == null || newText.isEmpty || newText == message.text) return;
  try {
    await channel.updateMessage(message.copyWith(text: newText));
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Could not save edit: $e')));
  }
}