import 'package:flutter/material.dart';
import '../services/storage_service.dart';

/// Provider de preferências do app (dark mode, daily goal).
class SettingsProvider extends ChangeNotifier {
  final StorageService _storage;

  bool _isDarkMode = false;
  int _dailyGoal = 8;

  bool get isDarkMode => _isDarkMode;
  int get dailyGoal => _dailyGoal;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  SettingsProvider({required StorageService storage}) : _storage = storage;

  Future<void> init() async {
    _isDarkMode = await _storage.getDarkMode();
    _dailyGoal = await _storage.getDailyGoal();
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _storage.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    await _storage.setDarkMode(value);
    notifyListeners();
  }

  Future<void> setDailyGoal(int goal) async {
    _dailyGoal = goal;
    await _storage.setDailyGoal(goal);
    notifyListeners();
  }
}
