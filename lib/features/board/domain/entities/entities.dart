const inboxId = 'inbox';

class TaskCard {
  final String id;
  final String title;
  final String description;
  final bool done;
  final DateTime? due;
  final double? lat;
  final double? lng;

  /// ARGB color value chosen by the user, or null for the default card color.
  final int? color;

  const TaskCard({
    required this.id,
    required this.title,
    this.description = '',
    this.done = false,
    this.due,
    this.lat,
    this.lng,
    this.color,
  });

  bool get hasLocation => lat != null && lng != null;

  TaskCard copyWith({
    String? title,
    String? description,
    bool? done,
    DateTime? due,
    bool clearDue = false,
    double? lat,
    double? lng,
    bool clearLocation = false,
    int? color,
    bool clearColor = false,
  }) => TaskCard(
    id: id,
    title: title ?? this.title,
    description: description ?? this.description,
    done: done ?? this.done,
    due: clearDue ? null : (due ?? this.due),
    lat: clearLocation ? null : (lat ?? this.lat),
    lng: clearLocation ? null : (lng ?? this.lng),
    color: clearColor ? null : (color ?? this.color),
  );
}

class TaskList {
  final String id;
  final String title;
  final List<TaskCard> cards;

  /// Project this list belongs to ('' for the global Inbox).
  final String projectId;

  const TaskList({
    required this.id,
    required this.title,
    this.cards = const [],
    this.projectId = '',
  });

  int get doneCount => cards.where((c) => c.done).length;
  double get progress => cards.isEmpty ? 0 : doneCount / cards.length;

  TaskList copyWith({String? title, List<TaskCard>? cards}) => TaskList(
    id: id,
    title: title ?? this.title,
    cards: cards ?? this.cards,
    projectId: projectId,
  );
}

/// A project folder that groups task lists.
class Project {
  final String id;
  final String title;
  const Project({required this.id, required this.title});

  Project copyWith({String? title}) =>
      Project(id: id, title: title ?? this.title);
}

/// Everything that gets persisted.
class BoardSnapshot {
  final List<Project> projects;
  final List<TaskList> lists;
  final String? currentProjectId;
  const BoardSnapshot({
    required this.projects,
    required this.lists,
    this.currentProjectId,
  });
}
