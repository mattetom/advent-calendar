import 'package:shared_preferences/shared_preferences.dart';

class UnlockRepository {
  static const String _key = 'opened_days';

  Future<Set<int>> loadUnlockedDays() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_key);
    if (stored == null) {
      return <int>{};
    }
    return stored.map(int.parse).toSet();
  }

  Future<void> saveUnlockedDays(Set<int> days) async {
    final prefs = await SharedPreferences.getInstance();
    final values = days.map((day) => day.toString()).toList()..sort();
    await prefs.setStringList(_key, values);
  }
}
