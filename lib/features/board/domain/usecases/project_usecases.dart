import 'package:taskboard/features/board/domain/entities/entities.dart';
import 'package:taskboard/features/board/domain/usecases/usecases.dart';

class AddProject {
  List<Project> call(List<Project> projects, String title) => [
    ...projects,
    Project(id: newId(), title: title),
  ];
}

class RenameProject {
  List<Project> call(List<Project> projects, String id, String title) =>
      projects.map((p) => p.id == id ? p.copyWith(title: title) : p).toList();
}

class DeleteProject {
  List<Project> call(List<Project> projects, String id) =>
      projects.where((p) => p.id != id).toList();
}
