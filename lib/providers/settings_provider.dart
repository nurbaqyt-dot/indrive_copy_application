import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider() {
    loadPreferences();
  }

  ThemeMode _themeMode = ThemeMode.light;
  String _distanceUnit = 'В километрах';
  String _language = 'Русский';
  bool _hasSeenWarnings = false;

  ThemeMode get themeMode => _themeMode;
  String get distanceUnit => _distanceUnit;
  String get language => _language;
  bool get hasSeenWarnings => _hasSeenWarnings;

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme_mode') ?? 'light';
    _themeMode = _themeFromValue(theme);
    _distanceUnit = prefs.getString('distance_unit') ?? 'В километрах';
    _language = prefs.getString('language') ?? 'Русский';
    _hasSeenWarnings = prefs.getBool('has_seen_warnings') ?? false;
    notifyListeners();
  }

  Future<void> setThemeLabel(String value) async {
    _themeMode = switch (value) {
      'Тёмная' => ThemeMode.dark,
      'Как в системе' => ThemeMode.system,
      _ => ThemeMode.light,
    };
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', _themeValue(_themeMode));
    notifyListeners();
  }

  Future<void> setDistanceUnit(String value) async {
    _distanceUnit = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('distance_unit', value);
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    _language = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', value);
    notifyListeners();
  }

  Future<void> markWarningsSeen() async {
    _hasSeenWarnings = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_warnings', true);
    notifyListeners();
  }

  String get themeLabel {
    switch (_themeMode) {
      case ThemeMode.system:
        return 'Как в системе';
      case ThemeMode.dark:
        return 'Тёмная';
      case ThemeMode.light:
        return 'Светлая';
    }
  }

  ThemeMode _themeFromValue(String value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  String _themeValue(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
    }
  }
}
