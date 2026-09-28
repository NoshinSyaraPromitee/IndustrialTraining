import 'package:flutter/material.dart';
import 'package:taskboard/core/lego/brick.dart';
import 'package:taskboard/core/theme/trello.dart';

/// Floating bottom bar that shows/hides the registered panel bricks.
class DockBar extends StatelessWidget {
  const DockBar({
    super.key,
    required this.bricks,
    required this.active,
    required this.onToggle,
  });
  final List<PanelBrick> bricks;
  final Set<String> active;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) => Material(
    color: const Color(0xF01D2125),
    elevation: 8,
    borderRadius: BorderRadius.circular(12),
    child: Padding(
      padding: const EdgeInsets.all(6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final b in bricks)
            _Item(
              icon: b.icon,
              label: b.label,
              on: active.contains(b.id),
              onTap: () => onToggle(b.id),
            ),
        ],
      ),
    ),
  );
}

class _Item extends StatelessWidget {
  const _Item({
    required this.icon,
    required this.label,
    required this.on,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = on ? const Color(0xFF669DF1) : Trello.text;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: on ? const Color(0xFF1C2B41) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: fg),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: fg, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
