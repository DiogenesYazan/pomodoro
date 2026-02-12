import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/storage_service.dart';
import '../../theme/tempus_colors.dart';
import '../../widgets/gradient_background.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<_ProfileData> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadProfile();
  }

  Future<_ProfileData> _loadProfile() async {
    final storage = context.read<StorageService>();
    final sessions = await storage.getSessions();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    int totalWork = 0;
    int todayWork = 0;
    int totalFocusSeconds = 0;
    final Set<String> activeDays = {};

    for (final s in sessions) {
      if (s.isWork) {
        totalWork++;
        totalFocusSeconds += s.durationSeconds;
        final dt = s.dateTime;
        activeDays.add('${dt.year}-${dt.month}-${dt.day}');
        if (dt.isAfter(today)) todayWork++;
      }
    }

    // Streak
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

    return _ProfileData(
      totalPomodoros: totalWork,
      todayPomodoros: todayWork,
      totalFocusHours: totalFocusSeconds / 3600.0,
      streak: streak,
      activeDays: activeDays.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? TempusColors.accent : TempusColors.deepPurple;

    return GradientBackground(
      child: SafeArea(
        child: FutureBuilder<_ProfileData>(
          future: _dataFuture,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            final d = snap.data!;
            final goalProgress = settings.dailyGoal > 0
                ? (d.todayPomodoros / settings.dailyGoal).clamp(0.0, 1.0)
                : 0.0;

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(height: 16),

                // ── Avatar + nome ──────────────────────────
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: TempusColors.accentGradient,
                          boxShadow: [
                            BoxShadow(
                              color: TempusColors.deepPurple.withAlpha(60),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('Meu Perfil',
                          style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 4),
                      Text(
                        'Foco é superpoder ⚡',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // ── Meta diária ────────────────────────────
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.flag_rounded, color: accentColor),
                            const SizedBox(width: 8),
                            Text('Meta Diária',
                                style: Theme.of(context).textTheme.titleMedium),
                            const Spacer(),
                            Text(
                              '${d.todayPomodoros} / ${settings.dailyGoal}',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: accentColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: goalProgress,
                            minHeight: 10,
                            backgroundColor: isDark
                                ? TempusColors.plum
                                : TempusColors.lavender,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(accentColor),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          goalProgress >= 1.0
                              ? '🎉 Meta atingida! Parabéns!'
                              : 'Faltam ${settings.dailyGoal - d.todayPomodoros} pomodoro${settings.dailyGoal - d.todayPomodoros != 1 ? 's' : ''}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Resumo cards ───────────────────────────
                Row(
                  children: [
                    Expanded(
                        child: _MiniCard(
                      icon: Icons.whatshot_rounded,
                      value: '${d.streak}',
                      label: 'Streak',
                      color: TempusColors.warning,
                    )),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _MiniCard(
                      icon: Icons.emoji_events_rounded,
                      value: '${d.totalPomodoros}',
                      label: 'Total',
                      color: accentColor,
                    )),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: _MiniCard(
                      icon: Icons.schedule_rounded,
                      value: '${d.totalFocusHours.toStringAsFixed(1)}h',
                      label: 'Foco Total',
                      color: TempusColors.orchid,
                    )),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _MiniCard(
                      icon: Icons.calendar_today_rounded,
                      value: '${d.activeDays}',
                      label: 'Dias Ativos',
                      color: TempusColors.success,
                    )),
                  ],
                ),
                const SizedBox(height: 32),

                // ── Achievements ───────────────────────────
                Text('Conquistas',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                _AchievementTile(
                  icon: Icons.star_rounded,
                  title: 'Primeiro Pomodoro',
                  description: 'Complete seu primeiro pomodoro',
                  unlocked: d.totalPomodoros >= 1,
                ),
                _AchievementTile(
                  icon: Icons.local_fire_department_rounded,
                  title: 'Semana de Fogo',
                  description: 'Mantenha um streak de 7 dias',
                  unlocked: d.streak >= 7,
                ),
                _AchievementTile(
                  icon: Icons.military_tech_rounded,
                  title: 'Centurião',
                  description: 'Complete 100 pomodoros no total',
                  unlocked: d.totalPomodoros >= 100,
                ),
                _AchievementTile(
                  icon: Icons.access_time_filled_rounded,
                  title: 'Maratonista',
                  description: 'Acumule 50 horas de foco',
                  unlocked: d.totalFocusHours >= 50,
                ),
                const SizedBox(height: 32),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════
//  DATA
// ═════════════════════════════════════════════════════════════════════
class _ProfileData {
  final int totalPomodoros, todayPomodoros, streak, activeDays;
  final double totalFocusHours;

  const _ProfileData({
    required this.totalPomodoros,
    required this.todayPomodoros,
    required this.totalFocusHours,
    required this.streak,
    required this.activeDays,
  });
}

// ═════════════════════════════════════════════════════════════════════
//  MINI CARD
// ═════════════════════════════════════════════════════════════════════
class _MiniCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _MiniCard({
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
            const SizedBox(height: 2),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════
//  ACHIEVEMENT TILE
// ═════════════════════════════════════════════════════════════════════
class _AchievementTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool unlocked;

  const _AchievementTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.unlocked,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? TempusColors.accent : TempusColors.deepPurple;

    return Card(
      color: unlocked
          ? null
          : (isDark
              ? TempusColors.cardDark.withAlpha(120)
              : Colors.grey.shade100),
      child: ListTile(
        leading: Icon(
          icon,
          color: unlocked ? TempusColors.warning : Colors.grey,
          size: 32,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: unlocked ? null : Colors.grey,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(color: unlocked ? null : Colors.grey),
        ),
        trailing: unlocked
            ? Icon(Icons.check_circle_rounded, color: accentColor)
            : const Icon(Icons.lock_rounded, color: Colors.grey, size: 20),
      ),
    );
  }
}
