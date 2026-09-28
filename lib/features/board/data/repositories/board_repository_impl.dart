import 'package:taskboard/features/board/data/datasources/local_data_source.dart';
import 'package:taskboard/features/board/domain/entities/entities.dart';
import 'package:taskboard/features/board/domain/repositories/board_repository.dart';

class BoardRepositoryImpl implements BoardRepository {
  final LocalDataSource _ds;
  BoardRepositoryImpl(this._ds);

  @override
  Future<BoardSnapshot> load() => _ds.load();

  @override
  Future<void> save(BoardSnapshot snapshot) => _ds.save(snapshot);
}
