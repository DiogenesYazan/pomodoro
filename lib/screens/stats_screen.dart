/* File: lib/screens/stats_screen.dart */
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  static const _kSessionsKey = 'pomodoro_sessions';
  late Future<Map<String, dynamic>> statsFuture;

  @override
  void initState() {
    super.initState();
    statsFuture = _loadWeeklyStats();
  }

  Future<Map<String, dynamic>> _loadWeeklyStats() async {
    final prefs = await SharedPreferences.getInstance();
    final listJson = prefs.getStringList(_kSessionsKey) ?? <String>[];
    final cutoff = DateTime.now().subtract(const Duration(days: 7)).millisecondsSinceEpoch;

    int workCount = 0, breakCount = 0;
    int workTime = 0, breakTime = 0;

    for (var e in listJson) {
      final obj = jsonDecode(e) as Map<String, dynamic>;
      final ts = obj['timestamp'] as int;
      if (ts < cutoff) continue;
      final type = obj['type'] as String;
      final dur = obj['duration'] as int;
      if (type == 'work') {
        workCount++;
        workTime += dur;
      } else {
        breakCount++;
        breakTime += dur;
      }
    }

    return {
      'pomodoros': workCount,
      'workTime': workTime,
      'workSessions': workCount,
      'breakTime': breakTime,
      'breakSessions': breakCount,
    };
  }

  Future<void> _resetStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kSessionsKey);
    setState(() {
      statsFuture = _loadWeeklyStats();
    });
  }

  void _confirmReset() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Zerar Estatísticas'),
        content: const Text('Deseja realmente apagar todas as estatísticas?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resetStats();
            },
            child: const Text('Zerar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estatísticas Semanais'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Zerar Estatísticas',
            onPressed: _confirmReset,
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: statsFuture,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final stats = snap.data!;
          final hWork = stats['workTime'] ~/ 3600;
          final mWork = (stats['workTime'] % 3600) ~/ 60;
          final hBreak = stats['breakTime'] ~/ 3600;
          final mBreak = (stats['breakTime'] % 3600) ~/ 60;

          final items = [
            _StatCard('Pomodoros', stats['pomodoros'].toString(), Icons.timer),
            _StatCard('Trabalho', '${hWork}h ${mWork}m', Icons.work),
            _StatCard('Sessões Trabalho', stats['workSessions'].toString(), Icons.check_circle),
            _StatCard('Descanso', '${hBreak}h ${mBreak}m', Icons.beach_access),
            _StatCard('Sessões Descanso', stats['breakSessions'].toString(), Icons.hotel),
          ];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: items,
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const _StatCard(this.title, this.value, this.icon, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Theme.of(context).primaryColor),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
}
}