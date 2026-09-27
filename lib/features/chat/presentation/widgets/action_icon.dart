import 'package:flutter/material.dart';

/// A compact, low-emphasis icon button used inside [MessageActionBar].
class ActionIcon extends StatelessWidget {
  const ActionIcon({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 16),
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      padding: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      onPressed: onTap,
    );
  }
}