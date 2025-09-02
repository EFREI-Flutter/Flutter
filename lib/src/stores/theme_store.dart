import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeStore extends ChangeNotifier {
  ThemeMode mode = ThemeMode.system;
  static const _key = 'theme_mode';
  Future<void> init() async {
    final p = await SharedPreferences.getInstance();
    final v = p.getString(_key);
    if (v == 'light') mode = ThemeMode.light;
    if (v == 'dark') mode = ThemeMode.dark;
  }
  Future<void> setMode(ThemeMode m) async {
    mode = m;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    if (m == ThemeMode.light) await p.setString(_key, 'light');
    if (m == ThemeMode.dark) await p.setString(_key, 'dark');
    if (m == ThemeMode.system) await p.remove(_key);
  }
}
