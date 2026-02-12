import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/timer_provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/tempus_colors.dart';
import '../../widgets/gradient_background.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final timer = context.watch<TimerProvider>();
    final settings = context.watch<SettingsProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
      ),
      body: KeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.escape) {
            if (Navigator.canPop(context)) Navigator.pop(context);
          }
        },
        child: GradientBackground(
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(height: 12),
                const SizedBox(height: 12),

                // ══════════════════════════════════════════════════
                //  APARÊNCIA
                // ══════════════════════════════════════════════════
                _SectionTitle('Aparência'),
                Card(
                  child: SwitchListTile(
                    secondary: Icon(
                      isDark
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      color: isDark
                          ? TempusColors.accent
                          : TempusColors.deepPurple,
                    ),
                    title: const Text('Modo Escuro'),
                    subtitle: Text(isDark ? 'Ativado' : 'Desativado'),
                    value: settings.isDarkMode,
                    onChanged: (_) => settings.toggleDarkMode(),
                  ),
                ),
                const SizedBox(height: 20),

                // ══════════════════════════════════════════════════
                //  TIMER
                // ══════════════════════════════════════════════════
                _SectionTitle('Timer'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _SliderRow(
                          icon: Icons.work_rounded,
                          label: 'Foco',
                          value: timer.workMinutes,
                          min: 1,
                          max: 60,
                          unit: 'min',
                          onChanged: (v) => timer.updateConfig(work: v),
                        ),
                        const Divider(height: 24),
                        _SliderRow(
                          icon: Icons.coffee_rounded,
                          label: 'Pausa Curta',
                          value: timer.shortBreakMinutes,
                          min: 1,
                          max: 30,
                          unit: 'min',
                          onChanged: (v) => timer.updateConfig(shortBreak: v),
                        ),
                        const Divider(height: 24),
                        _SliderRow(
                          icon: Icons.beach_access_rounded,
                          label: 'Pausa Longa',
                          value: timer.longBreakMinutes,
                          min: 5,
                          max: 45,
                          unit: 'min',
                          onChanged: (v) => timer.updateConfig(longBreak: v),
                        ),
                        const Divider(height: 24),
                        _SliderRow(
                          icon: Icons.repeat_rounded,
                          label: 'Intervalo Longo',
                          value: timer.longBreakInterval,
                          min: 2,
                          max: 8,
                          unit: 'ciclos',
                          onChanged: (v) => timer.updateConfig(interval: v),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ══════════════════════════════════════════════════
                //  SOM & NOTIFICAÇÕES
                // ══════════════════════════════════════════════════
                _SectionTitle('Som'),
                Card(
                  child: SwitchListTile(
                    secondary: Icon(
                      timer.soundEnabled
                          ? Icons.volume_up_rounded
                          : Icons.volume_off_rounded,
                      color: isDark
                          ? TempusColors.accent
                          : TempusColors.deepPurple,
                    ),
                    title: const Text('Som de Alarme'),
                    subtitle:
                        Text(timer.soundEnabled ? 'Ativado' : 'Desativado'),
                    value: timer.soundEnabled,
                    onChanged: (v) => timer.updateConfig(sound: v),
                  ),
                ),
                const SizedBox(height: 20),

                // ══════════════════════════════════════════════════
                //  META DIÁRIA
                // ══════════════════════════════════════════════════
                _SectionTitle('Meta Diária'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _SliderRow(
                      icon: Icons.flag_rounded,
                      label: 'Meta',
                      value: settings.dailyGoal,
                      min: 1,
                      max: 20,
                      unit: 'pomodoros',
                      onChanged: (v) => settings.setDailyGoal(v),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════
//  SECTION TITLE
// ═════════════════════════════════════════════════════════════════════
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════
//  SLIDER ROW
// ═════════════════════════════════════════════════════════════════════
class _SliderRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final int min;
  final int max;
  final String unit;
  final ValueChanged<int> onChanged;

  const _SliderRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Row(
          children: [
            Icon(icon,
                size: 20,
                color: isDark ? TempusColors.accent : TempusColors.deepPurple),
            const SizedBox(width: 8),
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (isDark ? TempusColors.accent : TempusColors.deepPurple)
                    .withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$value $unit',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? TempusColors.accent : TempusColors.deepPurple,
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: value.toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: max - min,
          onChanged: (v) => onChanged(v.toInt()),
        ),
      ],
    );
  }
}
