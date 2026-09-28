import 'package:taskboard/features/board/domain/entities/entities.dart';

abstract class BoardRepository {
  Future<BoardSnapshot> load();
  Future<void> save(BoardSnapshot snapshot);
}
