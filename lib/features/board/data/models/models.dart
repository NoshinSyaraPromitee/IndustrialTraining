import 'package:taskboard/features/board/domain/entities/entities.dart';

class TaskCardModel extends TaskCard {
  const TaskCardModel({
    required super.id,
    required super.title,
    super.description = '',
    super.done = false,
    super.due,
    super.lat,
    super.lng,
    super.color,
  });

  factory TaskCardModel.fromJson(Map<String, dynamic> j) => TaskCardModel(
    id: j['id'] as String,
    title: j['title'] as String,
    description: (j['description'] as String?) ?? '',
    done: (j['done'] as bool?) ?? false,
    due: j['due'] == null ? null : DateTime.parse(j['due'] as String),
    lat: (j['lat'] as num?)?.toDouble(),
    lng: (j['lng'] as num?)?.toDouble(),
    color: j['color'] as int?,
  );

  factory TaskCardModel.fromEntity(TaskCard c) => TaskCardModel(
    id: c.id,
    title: c.title,
    description: c.description,
    done: c.done,
    due: c.due,
    lat: c.lat,
    lng: c.lng,
    color: c.color,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'done': done,
    'due': due?.toIso8601String(),
    'lat': lat,
    'lng': lng,
    'color': color,
  };
}

class TaskListModel extends TaskList {
  const TaskListModel({
    required super.id,
    required super.title,
    super.cards = const [],
    super.projectId = '',
  });

  factory TaskListModel.fromJson(Map<String, dynamic> j) => TaskListModel(
    id: j['id'] as String,
    title: j['title'] as String,
    projectId: (j['projectId'] as String?) ?? '',
    cards: ((j['cards'] as List?) ?? [])
        .map((e) => TaskCardModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  factory TaskListModel.fromEntity(TaskList l) => TaskListModel(
    id: l.id,
    title: l.title,
    cards: l.cards,
    projectId: l.projectId,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'projectId': projectId,
    'cards': cards.map((c) => TaskCardModel.fromEntity(c).toJson()).toList(),
  };
}

Project projectFromJson(Map<String, dynamic> j) =>
    Project(id: j['id'] as String, title: j['title'] as String);

Map<String, dynamic> projectToJson(Project p) => {'id': p.id, 'title': p.title};

BoardSnapshot snapshotFromJson(Map<String, dynamic> j) => BoardSnapshot(
  projects: <Project>[
    for (final e in ((j['projects'] as List?) ?? []))
      projectFromJson(e as Map<String, dynamic>),
  ],
  lists: <TaskList>[
    for (final e in ((j['lists'] as List?) ?? []))
      TaskListModel.fromJson(e as Map<String, dynamic>),
  ],
  currentProjectId: j['current'] as String?,
);

Map<String, dynamic> snapshotToJson(BoardSnapshot s) => {
  'projects': s.projects.map(projectToJson).toList(),
  'lists': s.lists.map((l) => TaskListModel.fromEntity(l).toJson()).toList(),
  'current': s.currentProjectId,
};
