import 'package:flutter/material.dart';
import 'package:taskboard/core/theme/trello.dart';

class ViewCloseButton extends StatelessWidget {
  const ViewCloseButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: 'Close view',
    icon: const Icon(Icons.close),
    color: Trello.text,
    onPressed: onPressed,
  );
}
