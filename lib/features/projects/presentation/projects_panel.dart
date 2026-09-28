import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskboard/core/theme/trello.dart';
import 'package:taskboard/core/ui/panel_shell.dart';
import 'package:taskboard/features/board/domain/entities/entities.dart';
import 'package:taskboard/features/board/presentation/providers/board_provider.dart';

class ProjectsPanel extends StatefulWidget {
  const ProjectsPanel({super.key});

  @override
  State<ProjectsPanel> createState() => _ProjectsPanelState();
}

class _ProjectsPanelState extends State<ProjectsPanel> {
  final _add = TextEditingController();
  final _edit = TextEditingController();
  String? _editingId;

  @override
  void dispose() {
    _add.dispose();
    _edit.dispose();
    super.dispose();
  }

  void _addProject(String t) {
    final v = t.trim();
    if (v.isNotEmpty) context.read<BoardProvider>().addProject(v);
    _add.clear();
  }

  void _startEdit(Project p) {
    _edit.text = p.title;
    setState(() => _editingId = p.id);
  }

  void _commitEdit(Project p) {
    if (_editingId != p.id) return;
    final v = _edit.text.trim();
    if (v.isNotEmpty && v != p.title) {
      context.read<BoardProvider>().renameProject(p.id, v);
    }
    setState(() => _editingId = null);
  }

  Future<void> _delete(Project p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete "${p.title}"?'),
        content: const Text(
          'This also deletes its lists and all cards in them.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true && mounted)
      context.read<BoardProvider>().deleteProject(p.id);
  }

  InputDecoration _field(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Trello.subtle),
    filled: true,
    fillColor: Trello.card,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
  );

  Widget _row(BoardProvider board, Project p) {
    final selected = p.id == board.currentProjectId;
    final editing = _editingId == p.id;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: selected ? const Color(0x33579DFF) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: editing
            ? Padding(
                padding: const EdgeInsets.all(6),
                child: TextField(
                  controller: _edit,
                  autofocus: true,
                  style: const TextStyle(color: Trello.text),
                  decoration: _field('Project name'),
                  onSubmitted: (_) => _commitEdit(p),
                  onTapOutside: (_) => _commitEdit(p),
                ),
              )
            : InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => board.selectProject(p.id),
                onDoubleTap: () => _startEdit(p),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 4, 0, 4),
                  child: Row(
                    children: [
                      Icon(
                        selected ? Icons.folder_open : Icons.folder_outlined,
                        size: 20,
                        color: selected ? Trello.accent : Trello.subtle,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          p.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Trello.text,
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      Text(
                        '${board.projectCardCount(p.id)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Trello.subtle,
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_horiz,
                          size: 20,
                          color: Trello.subtle,
                        ),
                        onSelected: (v) =>
                            v == 'rename' ? _startEdit(p) : _delete(p),
                        itemBuilder: (_) => [
                          const PopupMenuItem(
                            value: 'rename',
                            child: Text('Rename'),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            enabled: board.projects.length > 1,
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final board = context.watch<BoardProvider>();
    return PanelShell(
      icon: Icons.folder_outlined,
      title: 'Projects',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
        children: [
          TextField(
            controller: _add,
            onSubmitted: _addProject,
            style: const TextStyle(color: Trello.text),
            decoration: _field('New project'),
          ),
          const SizedBox(height: 12),
          for (final p in board.projects) _row(board, p),
        ],
      ),
    );
  }
}
