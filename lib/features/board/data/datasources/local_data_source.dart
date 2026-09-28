import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskboard/features/board/data/models/models.dart';
import 'package:taskboard/features/board/domain/entities/entities.dart';

class LocalDataSource {
  static const _key = 'board_v2';
  static const _legacyKey = 'board_v1';

  Future<BoardSnapshot> load() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(milliseconds: 1200)); // shows shimmer
    final raw = prefs.getString(_key);
    if (raw != null)
      return snapshotFromJson(jsonDecode(raw) as Map<String, dynamic>);
    final legacy = prefs.getString(_legacyKey);
    if (legacy != null) return _migrate(legacy);
    return _seed();
  }

  Future<void> save(BoardSnapshot snapshot) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(snapshotToJson(snapshot)));
  }

  /// v1 stored one flat list of lists: wrap them in a first project.
  BoardSnapshot _migrate(String raw) {
    const pid = 'p1';
    final old = (jsonDecode(raw) as List)
        .map((e) => TaskListModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final lists = <TaskList>[
      for (final l in old)
        l.id == inboxId
            ? l
            : TaskListModel(
                id: l.id,
                title: l.title,
                cards: l.cards,
                projectId: pid,
              ),
    ];
    return BoardSnapshot(
      projects: const [Project(id: pid, title: 'My Board')],
      lists: lists,
      currentProjectId: pid,
    );
  }

  BoardSnapshot _seed() => const BoardSnapshot(
    projects: [Project(id: 'p1', title: 'My Board')],
    lists: [
      TaskListModel(
        id: '1',
        title: 'To Do',
        projectId: 'p1',
        cards: [
          TaskCardModel(
            id: 'a',
            title: 'Welcome to your board',
            description: 'Long-press a card to drag it to another list',
          ),
        ],
      ),
      TaskListModel(id: '2', title: 'In Progress', projectId: 'p1'),
      TaskListModel(id: '3', title: 'Done', projectId: 'p1'),
    ],
    currentProjectId: 'p1',
  );
}
