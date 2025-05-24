import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'stats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int workSeconds = 60;
  int breakSeconds = 60;
  late int totalSeconds;
  late int secondsLeft;
  bool isWork = true;
  bool isRunning = false;
  bool canContinue = false;
  Timer? _timer;
  final AudioPlayer _player = AudioPlayer();
  static const _kSessionsKey = 'pomodoro_sessions';

  @override
  void initState() {
    super.initState();
    totalSeconds = workSeconds;
    secondsLeft = totalSeconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _playAlarm() async {
    await _player.stop();
    await _player.play(AssetSource('sounds/alarm.mp3'));
  }

  void startTimer() {
    if (isRunning) return;
    setState(() {
      isRunning = true;
      canContinue = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (secondsLeft > 0) {
        setState(() => secondsLeft--);
      } else {
        timer.cancel();
        await _playAlarm();
        await _recordSession(isWork, totalSeconds);
        setState(() {
          isRunning = false;
          canContinue = true;
        });
      }
    });
  }

  void continueTimer() {
    setState(() {
      isWork = !isWork;
      totalSeconds = isWork ? workSeconds : breakSeconds;
      secondsLeft = totalSeconds;
      canContinue = false;
    });
    startTimer();
  }

  void pauseTimer() {
    _timer?.cancel();
    setState(() => isRunning = false);
  }

  void resetTimer() {
    _timer?.cancel();
    setState(() {
      isWork = true;
      totalSeconds = workSeconds;
      secondsLeft = totalSeconds;
      isRunning = false;
      canContinue = false;
    });
  }

  Future<void> _recordSession(bool work, int duration) async {
    final prefs = await SharedPreferences.getInstance();
    final listJson = prefs.getStringList(_kSessionsKey) ?? <String>[];
    final entry = jsonEncode({
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'type': work ? 'work' : 'break',
      'duration': duration,
    });
    listJson.add(entry);
    await prefs.setStringList(_kSessionsKey, listJson);
  }

  String _formatTime(int secs) {
    final m = (secs ~/ 60).toString().padLeft(2, '0');
    final s = (secs % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _showSettings() async {
    int w = workSeconds ~/ 60;
    int b = breakSeconds ~/ 60;

    final result = await showDialog<Map<String, int>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Configurar Tempos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Trabalho: $w min'),
              Slider(
                value: w.toDouble(),
                min: 1,
                max: 60,
                divisions: 59,
                label: '$w',
                onChanged: (v) => setState(() => w = v.toInt()),
              ),
              const SizedBox(height: 16),
              Text('Pausa: $b min'),
              Slider(
                value: b.toDouble(),
                min: 1,
                max: 30,
                divisions: 29,
                label: '$b',
                onChanged: (v) => setState(() => b = v.toInt()),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, {'work': w * 60, 'break': b * 60}),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      setState(() {
        workSeconds = result['work']!;
        breakSeconds = result['break']!;
        isWork = true;
        totalSeconds = workSeconds;
        secondsLeft = totalSeconds;
        isRunning = false;
        canContinue = false;
        _timer?.cancel();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final percent = totalSeconds == 0 ? 0.0 : secondsLeft / totalSeconds;
    return Scaffold(
      backgroundColor: isWork ? Colors.red.shade100 : Colors.green.shade100,
      appBar: AppBar(
        title: const Text('Pomodoro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Estatísticas',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StatsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Configurações',
            onPressed: _showSettings,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 140,
              lineWidth: 16,
              percent: percent,
              animation: true,
              animateFromLastPercent: true,
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: isWork ? Colors.redAccent : Colors.green,
              backgroundColor: Colors.grey.shade300,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatTime(secondsLeft),
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isWork ? 'TRABALHO' : 'PAUSA',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isRunning && !canContinue)
                  ElevatedButton(onPressed: startTimer, child: const Text('Iniciar')),
                if (isRunning)
                  ElevatedButton(onPressed: pauseTimer, child: const Text('Pausar')),
                if (!isRunning && canContinue)
                  ElevatedButton(onPressed: continueTimer, child: const Text('Continuar')),
                const SizedBox(width: 16),
                ElevatedButton(onPressed: resetTimer, child: const Text('Resetar')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
