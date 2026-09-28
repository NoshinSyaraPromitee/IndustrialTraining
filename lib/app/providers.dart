import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:taskboard/features/background/data/settings_data_source.dart';
import 'package:taskboard/features/background/presentation/background_provider.dart';
import 'package:taskboard/features/board/data/datasources/local_data_source.dart';
import 'package:taskboard/features/board/data/repositories/board_repository_impl.dart';
import 'package:taskboard/features/board/domain/usecases/usecases.dart';
import 'package:taskboard/features/board/presentation/providers/board_provider.dart';

/// Composition root: the only place where data implementations meet the domain.
List<SingleChildWidget> buildProviders() {
  final repo = BoardRepositoryImpl(LocalDataSource());
  return [
    ChangeNotifierProvider(
      create: (_) =>
          BoardProvider(loadBoard: LoadBoard(repo), saveBoard: SaveBoard(repo))
            ..load(),
    ),
    ChangeNotifierProvider(
      create: (_) => BackgroundProvider(SettingsDataSource())..load(),
    ),
  ];
}
