import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:taskboard/app/bricks.dart';
import 'package:taskboard/app/shell/dock_bar.dart';
import 'package:taskboard/app/shell/view_switcher.dart';
import 'package:taskboard/core/lego/brick.dart';
import 'package:taskboard/features/background/presentation/background_dialog.dart';
import 'package:taskboard/features/background/presentation/board_backdrop.dart';
import 'package:taskboard/features/board/presentation/providers/board_provider.dart';
import 'package:taskboard/features/board/presentation/widgets/board_shimmer.dart';

/// Composes the registered bricks. Knows nothing about what any brick contains.
class HomePage extends StatefulWidget {
  const HomePage({super.key, this.viewId});

  /// Id of the full-screen view from the route, or null for the dock.
  final String? viewId;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Set<String> _on = {for (final b in panelBricks) b.id};
  String get _mode => widget.viewId ?? dockId;

  void _go(String id) => context.go(id == dockId ? '/' : '/view/$id');

  /// Wide screens can show several panels; narrow ones show a single panel.
  List<PanelBrick> _shown(bool wide) => wide
      ? panelBricks.where((b) => _on.contains(b.id)).toList()
      : [panelBricks.reversed.firstWhere((b) => _on.contains(b.id))];

  void _toggle(String id, bool wide) => setState(() {
    if (!wide) {
      _on = {id};
      return;
    }
    final next = {..._on};
    if (!next.remove(id)) next.add(id);
    if (next.isNotEmpty) _on = next;
  });

  Widget _row(BuildContext context, List<PanelBrick> shown) => Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final b in shown)
        Expanded(
          key: ValueKey(b.id),
          flex: b.flex,
          child: Padding(
            padding: EdgeInsets.fromLTRB(8, 8, b == shown.last ? 8 : 0, 72),
            child: b.build(context),
          ),
        ),
    ],
  );

  Widget _body(BuildContext context, BoardProvider board, Widget? _) {
    if (board.loading) return const BoardShimmer();
    if (board.error != null) {
      return Center(
        child: FilledButton(
          onPressed: board.load,
          child: Text('Retry: ${board.error}'),
        ),
      );
    }
    final view = viewBricks.where((v) => v.id == _mode).firstOrNull;
    if (view != null) {
      return Padding(
        key: ValueKey(_mode),
        padding: const EdgeInsets.all(8),
        child: view.build(context, () => _go(dockId)),
      );
    }
    return LayoutBuilder(
      builder: (context, box) {
        final wide = box.maxWidth >= 1100;
        final shown = _shown(wide);
        return Stack(
          children: [
            Positioned.fill(child: _row(context, shown)),
            Positioned(
              left: 0,
              right: 0,
              bottom: 12,
              child: Center(
                child: DockBar(
                  bricks: panelBricks,
                  active: {for (final b in shown) b.id},
                  onToggle: (id) => _toggle(id, wide),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => BoardBackdrop(
    child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black38,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'TaskBoard',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 16),
            ViewSwitcher(views: viewBricks, currentId: _mode, onChanged: _go),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Background',
            icon: const Icon(Icons.palette_outlined),
            onPressed: () => showBackgroundDialog(context),
          ),
        ],
      ),
      body: Consumer<BoardProvider>(builder: _body),
    ),
  );
}
