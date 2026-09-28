import 'package:flutter/material.dart';
import 'package:taskboard/core/theme/trello.dart';

/// Rounded dark panel with an icon + title header (Inbox / Planner / Board).
class PanelShell extends StatelessWidget {
  const PanelShell({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
    this.trailing,
    this.color = Trello.panel,
  });
  final IconData icon;
  final String title;
  final Widget child;
  final Widget? trailing;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 8, 6),
          child: Row(
            children: [
              Icon(icon, size: 20, color: Trello.text),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Trello.text,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
        ),
        Expanded(child: child),
      ],
    ),
  );
}
