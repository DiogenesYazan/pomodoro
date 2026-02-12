import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/storage_service.dart';
import '../../theme/tempus_colors.dart';
import '../../widgets/gradient_background.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  late Future<_StatsData> _statsFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = _loadStats();
  }

  Future<_StatsData> _loadStats() async {
    final storage = context.read<StorageService>();
    final sessions = await storage.getSessions();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));

    int todayWork = 0, todayBreak = 0;
    int weekWork = 0, weekBreak = 0;
    int todayWorkTime = 0, weekWorkTime = 0;
    int totalSessions = sessions.length;
    int totalWorkTime = 0;

    // Streak calculation
    final Set<String> activeDays = {};

    for (final s in sessions) {
      final dt = s.dateTime;
      final dayKey = '${dt.year}-${dt.month}-${dt.day}';
      if (s.isWork) activeDays.add(dayKey);

      totalWorkTime += s.isWork ? s.durationSeconds : 0;

      if (dt.isAfter(today)) {
        if (s.isWork) {
          todayWork++;
          todayWorkTime += s.durationSeconds;
        } else {
          todayBreak++;
        }
      }
      if (dt.isAfter(weekStart)) {
        if (s.isWork) {
          weekWork++;
          weekWorkTime += s.durationSeconds;
        } else {
          weekBreak++;
        }
      }
    }

    // Calculate streak
    int streak = 0;
    var checkDay = today;
    while (true) {
      final key = '${checkDay.year}-${checkDay.month}-${checkDay.day}';
      if (activeDays.contains(key)) {
        streak++;
        checkDay = checkDay.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return _StatsData(
      todayPomodoros: todayWork,
      todayBreaks: todayBreak,
      todayFocusMinutes: todayWorkTime ~/ 60,
      weekPomodoros: weekWork,
      weekBreaks: weekBreak,
      weekFocusMinutes: weekWorkTime ~/ 60,
      totalSessions: totalSessions,
      totalFocusHours: totalWorkTime ~/ 3600,
      streak: streak,
    );
  }

  void _confirmReset() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Zerar Estatísticas'),
        content: const Text(
            'Deseja realmente apagar todas as estatísticas? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: TempusColors.error),
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<StorageService>().clearSessions();
              setState(() {
                _statsFuture = _loadStats();
              });
            },
            child: const Text('Zerar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GradientBackground(
      child: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Text(
                    'Estatísticas',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded),
                    tooltip: 'Zerar estatísticas',
                    onPressed: _confirmReset,
                  ),
                ],
              ),
            ),

            // ── Body ────────────────────────────────────────
            Expanded(
              child: FutureBuilder<_StatsData>(
                future: _statsFuture,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final d = snap.data!;
                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      // ── Streak card ───────────────────────
                      _StreakCard(streak: d.streak),
                      const SizedBox(height: 20),

                      // ── Hoje ──────────────────────────────
                      Text('Hoje',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                              child: _StatTile(
                            icon: Icons.local_fire_department_rounded,
                            value: '${d.todayPomodoros}',
                            label: 'Pomodoros',
                            color: isDark
                                ? TempusColors.accent
                                : TempusColors.deepPurple,
                          )),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _StatTile(
                            icon: Icons.schedule_rounded,
                            value: '${d.todayFocusMinutes}m',
                            label: 'Foco',
                            color: TempusColors.orchid,
                          )),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ── Semana ────────────────────────────
                      Text('Esta Semana',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                              child: _StatTile(
                            icon: Icons.local_fire_department_rounded,
                            value: '${d.weekPomodoros}',
                            label: 'Pomodoros',
                            color: isDark
                                ? TempusColors.accent
                                : TempusColors.deepPurple,
                          )),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _StatTile(
                            icon: Icons.schedule_rounded,
                            value: '${d.weekFocusMinutes}m',
                            label: 'Foco',
                            color: TempusColors.orchid,
                          )),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                              child: _StatTile(
                            icon: Icons.coffee_rounded,
                            value: '${d.weekBreaks}',
                            label: 'Pausas',
                            color: TempusColors.success,
                          )),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _StatTile(
                            icon: Icons.emoji_events_rounded,
                            value: '${d.totalFocusHours}h',
                            label: 'Total Foco',
                            color: TempusColors.warning,
                          )),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════
//  DATA CLASS
// ═════════════════════════════════════════════════════════════════════
class _StatsData {
  final int todayPomodoros, todayBreaks, todayFocusMinutes;
  final int weekPomodoros, weekBreaks, weekFocusMinutes;
  final int totalSessions, totalFocusHours, streak;

  const _StatsData({
    required this.todayPomodoros,
    required this.todayBreaks,
    required this.todayFocusMinutes,
    required this.weekPomodoros,
    required this.weekBreaks,
    required this.weekFocusMinutes,
    required this.totalSessions,
    required this.totalFocusHours,
    required this.streak,
  });
}

// ═════════════════════════════════════════════════════════════════════
//  STREAK CARD
// ═════════════════════════════════════════════════════════════════════
class _StreakCard extends StatelessWidget {
  final int streak;
  const _StreakCard({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: TempusColors.accentGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TempusColors.deepPurple.withAlpha(60),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.whatshot_rounded, color: Colors.white, size: 40),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$streak dia${streak != 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Sequência de foco',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════
//  STAT TILE CARD
// ═════════════════════════════════════════════════════════════════════
class _StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
