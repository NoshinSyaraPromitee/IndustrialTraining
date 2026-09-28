import 'package:flutter/material.dart';
import 'package:taskboard/core/lego/brick.dart';
import 'package:taskboard/core/theme/trello.dart';

/// Trello-style "Views" dropdown, built from the registered view bricks.
class ViewSwitcher extends StatelessWidget {
  const ViewSwitcher({
    super.key,
    required this.views,
    required this.currentId,
    required this.onChanged,
  });
  final List<ViewBrick> views;
  final String currentId;
  final ValueChanged<String> onChanged;

  static const _dockIcon = Icons.view_column_outlined;

  PopupMenuItem<String> _item(String id, IconData icon, String label) =>
      PopupMenuItem(
        value: id,
        child: Row(
          children: [
            Icon(icon, size: 20, color: Trello.text),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: Trello.text,
                fontWeight: id == currentId
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final current = views.where((v) => v.id == currentId).firstOrNull;
    return PopupMenuButton<String>(
      tooltip: 'Views',
      color: const Color(0xFF282E33),
      position: PopupMenuPosition.under,
      onSelected: onChanged,
      itemBuilder: (_) => [
        _item(dockId, _dockIcon, 'Board'),
        for (final v in views) _item(v.id, v.icon, v.label),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(current?.icon ?? _dockIcon, size: 20, color: Trello.onAccent),
            const Icon(Icons.expand_more, size: 20, color: Trello.onAccent),
          ],
        ),
      ),
    );
  }
}
