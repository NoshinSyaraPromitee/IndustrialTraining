import 'package:flutter/foundation.dart';
import 'package:taskboard/features/background/data/settings_data_source.dart';
import 'package:taskboard/features/background/domain/backgrounds.dart';

class BackgroundProvider extends ChangeNotifier {
  BackgroundProvider(this._store);
  final SettingsDataSource _store;

  int gradient = 0;
  BgPattern pattern = BgPattern.dots;

  Future<void> load() async {
    final s = await _store.load();
    gradient = s.$1.clamp(0, bgPresets.length - 1);
    pattern = BgPattern.values[s.$2.clamp(0, BgPattern.values.length - 1)];
    notifyListeners();
  }

  void setGradient(int i) {
    gradient = i;
    notifyListeners();
    _store.save(gradient, pattern.index);
  }

  void setPattern(BgPattern p) {
    pattern = p;
    notifyListeners();
    _store.save(gradient, pattern.index);
  }
}
