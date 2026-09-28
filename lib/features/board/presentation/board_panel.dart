import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskboard/core/theme/trello.dart';
import 'package:taskboard/core/ui/edge_zones.dart';
import 'package:taskboard/core/ui/panel_shell.dart';
import 'package:taskboard/features/board/presentation/providers/board_provider.dart';
import 'package:taskboard/features/board/presentation/widgets/add_list_column.dart';
import 'package:taskboard/features/board/presentation/widgets/list_column.dart';

class BoardPanel extends StatefulWidget {
  const BoardPanel({super.key});

  @override
  State<BoardPanel> createState() => _BoardPanelState();
}

class _BoardPanelState extends State<BoardPanel> {
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final board = context.watch<BoardProvider>();
    final lists = board.boardLists;
    return PanelShell(
      icon: Icons.view_column_outlined,
      title: board.currentProject?.title ?? 'Board',
      color: Trello.boardPanel,
      child: Stack(
        children: [
          Scrollbar(
            controller: _scroll,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _scroll,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final l in lists)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SizedBox(
                        width: 300,
                        child: ListColumn(key: ValueKey(l.id), list: l),
                      ),
                    ),
                  const SizedBox(width: 280, child: AddListColumn()),
                ],
              ),
            ),
          ),
          EdgeZones(controller: _scroll),
        ],
      ),
    );
  }
}
