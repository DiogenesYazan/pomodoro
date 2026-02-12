import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/session.dart';

/// Abstração sobre SharedPreferences para persistência de dados.
class StorageService {
  static const _kSessions = 'tempus_sessions';
  static const _kWorkDuration = 'tempus_work_duration';
  static const _kBreakDuration = 'tempus_break_duration';
  static const _kLongBreakDuration = 'tempus_long_break_duration';
  static const _kLongBreakInterval = 'tempus_long_break_interval';
  static const _kSoundEnabled = 'tempus_sound_enabled';
  static const _kDarkMode = 'tempus_dark_mode';
  static const _kDailyGoal = 'tempus_daily_goal';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _p async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // ── Timer config ──────────────────────────────────────────────────
  Future<int> getWorkDuration() async =>
      (await _p).getInt(_kWorkDuration) ?? 25;

  Future<void> setWorkDuration(int minutes) async =>
      (await _p).setInt(_kWorkDuration, minutes);

  Future<int> getBreakDuration() async =>
      (await _p).getInt(_kBreakDuration) ?? 5;

  Future<void> setBreakDuration(int minutes) async =>
      (await _p).setInt(_kBreakDuration, minutes);

  Future<int> getLongBreakDuration() async =>
      (await _p).getInt(_kLongBreakDuration) ?? 15;

  Future<void> setLongBreakDuration(int minutes) async =>
      (await _p).setInt(_kLongBreakDuration, minutes);

  Future<int> getLongBreakInterval() async =>
      (await _p).getInt(_kLongBreakInterval) ?? 4;

  Future<void> setLongBreakInterval(int count) async =>
      (await _p).setInt(_kLongBreakInterval, count);

  // ── Preferences ───────────────────────────────────────────────────
  Future<bool> getSoundEnabled() async =>
      (await _p).getBool(_kSoundEnabled) ?? true;

  Future<void> setSoundEnabled(bool v) async =>
      (await _p).setBool(_kSoundEnabled, v);

  Future<bool> getDarkMode() async => (await _p).getBool(_kDarkMode) ?? false;

  Future<void> setDarkMode(bool v) async => (await _p).setBool(_kDarkMode, v);

  Future<int> getDailyGoal() async => (await _p).getInt(_kDailyGoal) ?? 8;

  Future<void> setDailyGoal(int pomodoros) async =>
      (await _p).setInt(_kDailyGoal, pomodoros);

  // ── Sessions ──────────────────────────────────────────────────────
  Future<List<Session>> getSessions() async {
    final list = (await _p).getStringList(_kSessions) ?? <String>[];
    return list
        .map((e) => Session.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList();
  }

  Future<void> addSession(Session session) async {
    final prefs = await _p;
    final list = prefs.getStringList(_kSessions) ?? <String>[];
    list.add(jsonEncode(session.toJson()));
    await prefs.setStringList(_kSessions, list);
  }

  Future<void> clearSessions() async {
    (await _p).remove(_kSessions);
  }

  // ── Migrate from old keys ─────────────────────────────────────────
  Future<void> migrateOldData() async {
    final prefs = await _p;
    final old = prefs.getStringList('pomodoro_sessions');
    if (old != null && old.isNotEmpty) {
      final existing = prefs.getStringList(_kSessions) ?? <String>[];
      existing.addAll(old);
      await prefs.setStringList(_kSessions, existing);
      await prefs.remove('pomodoro_sessions');
    }
  }
}
