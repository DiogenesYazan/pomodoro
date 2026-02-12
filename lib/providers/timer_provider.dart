import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/session.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';

/// Possíveis estados do timer.
enum TimerPhase { work, shortBreak, longBreak }

/// Provider central do timer Pomodoro.
class TimerProvider extends ChangeNotifier {
  final StorageService _storage;
  final AudioService _audio;

  // ── Configuração ──────────────────────────────────────────────────
  int workMinutes = 25;
  int shortBreakMinutes = 5;
  int longBreakMinutes = 15;
  int longBreakInterval = 4;
  bool soundEnabled = true;

  // ── Estado ────────────────────────────────────────────────────────
  TimerPhase phase = TimerPhase.work;
  int totalSeconds = 25 * 60;
  int secondsLeft = 25 * 60;
  bool isRunning = false;
  bool isFinished = false;
  int completedPomodoros = 0;

  Timer? _timer;

  TimerProvider({
    required StorageService storage,
    required AudioService audio,
  })  : _storage = storage,
        _audio = audio;

  /// Carrega configurações do storage.
  Future<void> init() async {
    await _storage.migrateOldData();
    workMinutes = await _storage.getWorkDuration();
    shortBreakMinutes = await _storage.getBreakDuration();
    longBreakMinutes = await _storage.getLongBreakDuration();
    longBreakInterval = await _storage.getLongBreakInterval();
    soundEnabled = await _storage.getSoundEnabled();
    _applyPhase();
    notifyListeners();
  }

  // ── Controles ─────────────────────────────────────────────────────
  void start() {
    if (isRunning) return;
    isRunning = true;
    isFinished = false;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (secondsLeft > 0) {
        secondsLeft--;
        notifyListeners();
      } else {
        _timer?.cancel();
        isRunning = false;
        isFinished = true;

        // Gravar sessão
        await _storage.addSession(Session(
          timestamp: DateTime.now().millisecondsSinceEpoch,
          type: phase == TimerPhase.work ? 'work' : 'break',
          durationSeconds: totalSeconds,
        ));

        if (phase == TimerPhase.work) completedPomodoros++;

        if (soundEnabled) await _audio.playAlarm();
        notifyListeners();
      }
    });
  }

  void pause() {
    _timer?.cancel();
    isRunning = false;
    notifyListeners();
  }

  void resume() {
    if (!isRunning && secondsLeft > 0 && !isFinished) {
      start();
    }
  }

  void skip() {
    _timer?.cancel();
    isRunning = false;
    isFinished = false;
    _nextPhase();
    notifyListeners();
  }

  void reset() {
    _timer?.cancel();
    isRunning = false;
    isFinished = false;
    _applyPhase();
    notifyListeners();
  }

  void continueToNext() {
    isFinished = false;
    _nextPhase();
    start();
  }

  void resetAll() {
    _timer?.cancel();
    isRunning = false;
    isFinished = false;
    completedPomodoros = 0;
    phase = TimerPhase.work;
    _applyPhase();
    notifyListeners();
  }

  // ── Configuração em tempo de execução ─────────────────────────────
  Future<void> updateConfig({
    int? work,
    int? shortBreak,
    int? longBreak,
    int? interval,
    bool? sound,
  }) async {
    if (work != null) {
      workMinutes = work;
      await _storage.setWorkDuration(work);
    }
    if (shortBreak != null) {
      shortBreakMinutes = shortBreak;
      await _storage.setBreakDuration(shortBreak);
    }
    if (longBreak != null) {
      longBreakMinutes = longBreak;
      await _storage.setLongBreakDuration(longBreak);
    }
    if (interval != null) {
      longBreakInterval = interval;
      await _storage.setLongBreakInterval(interval);
    }
    if (sound != null) {
      soundEnabled = sound;
      await _storage.setSoundEnabled(sound);
    }
    // Reset timer com novas configurações
    _timer?.cancel();
    isRunning = false;
    isFinished = false;
    phase = TimerPhase.work;
    _applyPhase();
    notifyListeners();
  }

  // ── Helpers ───────────────────────────────────────────────────────
  double get progress => totalSeconds == 0 ? 0.0 : secondsLeft / totalSeconds;

  String get timeFormatted {
    final m = (secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get phaseLabel {
    switch (phase) {
      case TimerPhase.work:
        return 'FOCO';
      case TimerPhase.shortBreak:
        return 'PAUSA CURTA';
      case TimerPhase.longBreak:
        return 'PAUSA LONGA';
    }
  }

  void _applyPhase() {
    switch (phase) {
      case TimerPhase.work:
        totalSeconds = workMinutes * 60;
        break;
      case TimerPhase.shortBreak:
        totalSeconds = shortBreakMinutes * 60;
        break;
      case TimerPhase.longBreak:
        totalSeconds = longBreakMinutes * 60;
        break;
    }
    secondsLeft = totalSeconds;
  }

  void _nextPhase() {
    if (phase == TimerPhase.work) {
      if (completedPomodoros > 0 &&
          completedPomodoros % longBreakInterval == 0) {
        phase = TimerPhase.longBreak;
      } else {
        phase = TimerPhase.shortBreak;
      }
    } else {
      phase = TimerPhase.work;
    }
    _applyPhase();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audio.dispose();
    super.dispose();
  }
}
