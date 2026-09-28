import 'package:shared_preferences/shared_preferences.dart';

/// Stores the chosen board background (gradient index, pattern index).
class SettingsDataSource {
  Future<(int, int)> load() async {
    final p = await SharedPreferences.getInstance();
    return (p.getInt('bg_gradient') ?? 0, p.getInt('bg_pattern') ?? 1);
  }

  Future<void> save(int gradient, int pattern) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt('bg_gradient', gradient);
    await p.setInt('bg_pattern', pattern);
  }
}
