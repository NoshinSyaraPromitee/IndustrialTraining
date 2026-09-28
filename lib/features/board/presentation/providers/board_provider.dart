import 'package:flutter/foundation.dart';
import 'package:taskboard/core/utils/dates.dart';
import 'package:taskboard/features/board/domain/entities/entities.dart';
import 'package:taskboard/features/board/domain/usecases/color_card.dart';
import 'package:taskboard/features/board/domain/usecases/locate_card.dart';
import 'package:taskboard/features/board/domain/usecases/project_usecases.dart';
import 'package:taskboard/features/board/domain/usecases/schedule_card.dart';
import 'package:taskboard/features/board/domain/usecases/toggle_card.dart';
import 'package:taskboard/features/board/domain/usecases/usecases.dart';

class BoardProvider extends ChangeNotifier {
  BoardProvider({required this._loadBoard, required this._saveBoard});

  final LoadBoard _loadBoard;
  final SaveBoard _saveBoard;
  final _addList = AddList();
  final _renameList = RenameList();
  final _deleteList = DeleteList();
  final _addCard = AddCard();
  final _editCard = EditCard();
  final _deleteCard = DeleteCard();
  final _moveCard = MoveCard();
  final _toggleCard = ToggleCard();
  final _scheduleCard = ScheduleCard();
  final _locateCard = LocateCard();
  final _colorCard = ColorCard();
  final _addProject = AddProject();
  final _renameProject = RenameProject();
  final _deleteProject = DeleteProject();

  List<Project> projects = [];
  String? currentProjectId;
  List<TaskList> lists = [];
  bool loading = true;
  String? error;

  static const _emptyInbox = TaskList(id: inboxId, title: 'Inbox');

  Project? get currentProject =>
      projects.where((p) => p.id == currentProjectId).firstOrNull;

  TaskList get inbox =>
      lists.firstWhere((l) => l.id == inboxId, orElse: () => _emptyInbox);

  /// Lists of the selected project.
  List<TaskList> get boardLists => lists
      .where((l) => l.id != inboxId && l.projectId == currentProjectId)
      .toList();

  int projectCardCount(String projectId) => lists
      .where((l) => l.projectId == projectId)
      .fold<int>(0, (n, l) => n + l.cards.length);

  /// "Project / List" once there is more than one project.
  String listLabel(TaskList l) {
    if (l.id == inboxId) return l.title;
    final p = projects.where((p) => p.id == l.projectId).firstOrNull;
    return (p == null || projects.length < 2)
        ? l.title
        : '${p.title} / ${l.title}';
  }

  /// Every card (inbox included) paired with a label of the list it is in.
  List<(TaskCard, String)> get allCards => [
    for (final l in lists)
      for (final c in l.cards) (c, listLabel(l)),
  ];

  List<TaskCard> cardsOn(DateTime day) => [
    for (final l in lists)
      for (final c in l.cards)
        if (c.due != null && sameDay(c.due!, day)) c,
  ];

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final snap = await _loadBoard();
      projects = List<Project>.of(snap.projects);
      lists = List<TaskList>.of(snap.lists);
      currentProjectId = snap.currentProjectId;
      if (projects.isEmpty)
        projects = [Project(id: newId(), title: 'My Board')];
      if (!projects.any((p) => p.id == currentProjectId)) {
        currentProjectId = projects.first.id;
      }
      if (!lists.any((l) => l.id == inboxId)) lists = [_emptyInbox, ...lists];
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }

  Future<void> _saving = Future.value();

  Future<void> _commit() {
    notifyListeners(); // optimistic UI
    final snap = BoardSnapshot(
      projects: projects,
      lists: lists,
      currentProjectId: currentProjectId,
    );
    // Queue writes so they hit storage in order and the newest state wins.
    return _saving = _saving
        .catchError((_) {})
        .then((_) => _saveBoard(snap))
        .catchError((Object e) => debugPrint('Saving board failed: $e'));
  }

  Future<void> _apply(List<TaskList> next) {
    lists = next;
    return _commit();
  }

  // projects
  Future<void> addProject(String title) {
    projects = _addProject(projects, title);
    currentProjectId = projects.last.id;
    return _commit();
  }

  Future<void> renameProject(String id, String title) {
    projects = _renameProject(projects, id, title);
    return _commit();
  }

  Future<void> deleteProject(String id) {
    if (projects.length <= 1) return Future.value();
    projects = _deleteProject(projects, id);
    lists = lists.where((l) => l.projectId != id).toList();
    if (currentProjectId == id) currentProjectId = projects.first.id;
    return _commit();
  }

  Future<void> selectProject(String id) {
    currentProjectId = id;
    return _commit();
  }

  // lists
  Future<void> addList(String title) =>
      _apply(_addList(lists, title, currentProjectId ?? ''));
  Future<void> renameList(String id, String title) =>
      _apply(_renameList(lists, id, title));
  Future<void> deleteList(String id) => _apply(_deleteList(lists, id));

  // cards
  Future<void> addCard(String listId, String title) =>
      _apply(_addCard(lists, listId, title));

  /// Creates a card with a due date (an "event"). Goes into [listId], else the
  /// first list of the current project, else the inbox.
  Future<void> addEvent(String title, DateTime day, {String? listId}) {
    final target =
        listId ?? (boardLists.isNotEmpty ? boardLists.first.id : inboxId);
    final card = TaskCard(id: newId(), title: title, due: dateOnly(day));
    return _apply([
      for (final l in lists)
        if (l.id == target) l.copyWith(cards: [...l.cards, card]) else l,
    ]);
  }

  Future<void> editCard(String id, String title, String desc) =>
      _apply(_editCard(lists, id, title, desc));
  Future<void> deleteCard(String id) => _apply(_deleteCard(lists, id));
  Future<void> toggleCard(String id) => _apply(_toggleCard(lists, id));
  Future<void> scheduleCard(String id, DateTime? day) =>
      _apply(_scheduleCard(lists, id, day));
  Future<void> locateCard(String id, double? lat, double? lng) =>
      _apply(_locateCard(lists, id, lat, lng));
  Future<void> colorCard(String id, int? color) =>
      _apply(_colorCard(lists, id, color));
  Future<void> moveCard(
    String cardId,
    String toListId, {
    String? beforeCardId,
  }) => _apply(_moveCard(lists, cardId, toListId, beforeCardId: beforeCardId));
}
