import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  const SettingsState({
    this.themeMode = ThemeMode.light,
    this.distanceUnit = 'В километрах',
    this.language = 'Русский',
    this.hasSeenWarnings = false,
    this.isReady = false,
  });

  final ThemeMode themeMode;
  final String distanceUnit;
  final String language;
  final bool hasSeenWarnings;
  final bool isReady;

  String get themeLabel {
    switch (themeMode) {
      case ThemeMode.system:
        return 'Как в системе';
      case ThemeMode.dark:
        return 'Тёмная';
      case ThemeMode.light:
        return 'Светлая';
    }
  }

  SettingsState copyWith({
    ThemeMode? themeMode,
    String? distanceUnit,
    String? language,
    bool? hasSeenWarnings,
    bool? isReady,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      language: language ?? this.language,
      hasSeenWarnings: hasSeenWarnings ?? this.hasSeenWarnings,
      isReady: isReady ?? this.isReady,
    );
  }
}

class SettingsNotifier extends AsyncNotifier<SettingsState> {
  @override
  Future<SettingsState> build() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme_mode') ?? 'light';
    return SettingsState(
      themeMode: _themeFromValue(theme),
      distanceUnit: prefs.getString('distance_unit') ?? 'В километрах',
      language: prefs.getString('language') ?? 'Русский',
      hasSeenWarnings: prefs.getBool('has_seen_warnings') ?? false,
      isReady: true,
    );
  }

  Future<void> setThemeLabel(String value) async {
    final mode = switch (value) {
      'Тёмная' => ThemeMode.dark,
      'Как в системе' => ThemeMode.system,
      _ => ThemeMode.light,
    };
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', _themeValue(mode));
    state = AsyncData(state.valueOrNull!.copyWith(themeMode: mode));
  }

  Future<void> setDistanceUnit(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('distance_unit', value);
    state = AsyncData(state.valueOrNull!.copyWith(distanceUnit: value));
  }

  Future<void> setLanguage(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', value);
    state = AsyncData(state.valueOrNull!.copyWith(language: value));
  }

  Future<void> markWarningsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_warnings', true);
    state = AsyncData(state.valueOrNull!.copyWith(hasSeenWarnings: true));
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

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);
