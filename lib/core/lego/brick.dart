import 'package:flutter/widgets.dart';

/// Id used for the default dock layout (Inbox / Planner / Board side by side).
const dockId = 'dock';

/// A self-contained piece of UI that plugs into the app shell.
/// Each feature exposes exactly one brick; the shell never imports feature internals.
abstract class Brick {
  const Brick({required this.id, required this.label, required this.icon});
  final String id;
  final String label;
  final IconData icon;
}

/// Lives in the dock; several can be visible side by side.
class PanelBrick extends Brick {
  const PanelBrick({
    required super.id,
    required super.label,
    required super.icon,
    required this.flex,
    required this.build,
  });
  final int flex;
  final WidgetBuilder build;
}

/// Full-screen alternative to the dock (Table, Calendar, Dashboard...).
class ViewBrick extends Brick {
  const ViewBrick({
    required super.id,
    required super.label,
    required super.icon,
    required this.build,
  });
  final Widget Function(BuildContext context, VoidCallback close) build;
}
