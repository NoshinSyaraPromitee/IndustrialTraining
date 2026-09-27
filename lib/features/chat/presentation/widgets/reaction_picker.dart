import 'package:flutter/material.dart';

/// A small emoji strip shown in a bottom sheet when the user taps the
/// "react" action on a message. Returns the Stream reaction `type` string
/// for the emoji the user picked (via `Navigator.pop`), or `null` if they
/// dismissed the sheet without picking one.
class ReactionPicker extends StatelessWidget {
  const ReactionPicker({super.key});

  /// Emoji shown to the user, mapped to the reaction `type` sent to Stream.
  static const Map<String, String> reactions = {
    '👍': 'like',
    '❤️': 'love',
    '😂': 'haha',
    '😮': 'wow',
    '😢': 'sad',
    '🙏': 'pray',
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          children: [
            for (final entry in reactions.entries)
              InkWell(
                borderRadius: BorderRadius.circular(28),
                onTap: () => Navigator.of(context).pop(entry.value),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(entry.key, style: const TextStyle(fontSize: 28)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}