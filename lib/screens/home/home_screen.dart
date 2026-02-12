import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../providers/timer_provider.dart';
import '../../theme/tempus_colors.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/pomodoro_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, timer, _) {
        return GradientBackground(
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),
                // ── Phase chips ─────────────────────────────
                _PhaseSelector(timer: timer),
                const Spacer(),
                // ── Timer circular ──────────────────────────
                _TimerDisplay(timer: timer),
                const SizedBox(height: 24),
                // ── Indicadores de pomodoro ──────────────────
                PomodoroIndicator(
                  completed: timer.completedPomodoros % timer.longBreakInterval,
                  total: timer.longBreakInterval,
                ),
                const SizedBox(height: 8),
                Text(
                  '${timer.completedPomodoros} pomodoro${timer.completedPomodoros != 1 ? 's' : ''} hoje',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                // ── Controles ───────────────────────────────
                _TimerControls(timer: timer),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ═════════════════════════════════════════════════════════════════════
//  PHASE SELECTOR — chips para trocar fase manualmente
// ═════════════════════════════════════════════════════════════════════
class _PhaseSelector extends StatelessWidget {
  final TimerProvider timer;
  const _PhaseSelector({required this.timer});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? TempusColors.accent : TempusColors.deepPurple;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: TimerPhase.values.map((phase) {
        final isSelected = timer.phase == phase;
        String label;
        switch (phase) {
          case TimerPhase.work:
            label = 'Foco';
            break;
          case TimerPhase.shortBreak:
            label = 'Pausa Curta';
            break;
          case TimerPhase.longBreak:
            label = 'Pausa Longa';
            break;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ChoiceChip(
            label: Text(label),
            selected: isSelected,
            onSelected: timer.isRunning
                ? null
                : (_) {
                    timer.phase = phase;
                    timer.reset();
                  },
            selectedColor: activeColor,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : null,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 13,
            ),
            backgroundColor:
                isDark ? TempusColors.cardDark : Colors.white.withAlpha(180),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════
//  TIMER DISPLAY — circular percent indicator + tempo
// ═════════════════════════════════════════════════════════════════════
class _TimerDisplay extends StatelessWidget {
  final TimerProvider timer;
  const _TimerDisplay({required this.timer});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progressColor = _phaseColor(timer.phase, isDark);
    final bgColor = isDark
        ? TempusColors.plum.withAlpha(120)
        : TempusColors.lavender.withAlpha(150);

    return CircularPercentIndicator(
      radius: 140,
      lineWidth: 14,
      percent: timer.progress.clamp(0.0, 1.0),
      animation: true,
      animateFromLastPercent: true,
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: progressColor,
      backgroundColor: bgColor,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            timer.timeFormatted,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: progressColor.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              timer.phaseLabel,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: progressColor,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _phaseColor(TimerPhase phase, bool isDark) {
    switch (phase) {
      case TimerPhase.work:
        return isDark ? TempusColors.accent : TempusColors.deepPurple;
      case TimerPhase.shortBreak:
        return TempusColors.success;
      case TimerPhase.longBreak:
        return TempusColors.orchid;
    }
  }
}

// ═════════════════════════════════════════════════════════════════════
//  TIMER CONTROLS — botões de ação
// ═════════════════════════════════════════════════════════════════════
class _TimerControls extends StatelessWidget {
  final TimerProvider timer;
  const _TimerControls({required this.timer});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Reset
        _ControlButton(
          icon: Icons.replay_rounded,
          label: 'Resetar',
          onPressed: timer.resetAll,
          outlined: true,
        ),
        const SizedBox(width: 16),

        // Main action (play / pause / continue)
        if (timer.isFinished)
          _ControlButton(
            icon: Icons.skip_next_rounded,
            label: 'Próximo',
            onPressed: timer.continueToNext,
            large: true,
          )
        else if (timer.isRunning)
          _ControlButton(
            icon: Icons.pause_rounded,
            label: 'Pausar',
            onPressed: timer.pause,
            large: true,
          )
        else
          _ControlButton(
            icon: Icons.play_arrow_rounded,
            label:
                timer.secondsLeft < timer.totalSeconds ? 'Retomar' : 'Iniciar',
            onPressed: timer.start,
            large: true,
          ),

        const SizedBox(width: 16),

        // Skip
        _ControlButton(
          icon: Icons.skip_next_rounded,
          label: 'Pular',
          onPressed: timer.isRunning ? null : timer.skip,
          outlined: true,
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool outlined;
  final bool large;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.outlined = false,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = large ? 64.0 : 50.0;
    final iconSize = large ? 32.0 : 22.0;

    if (outlined) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: const CircleBorder(),
              ),
              child: Icon(icon, size: iconSize),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: const CircleBorder(),
            ),
            child: Icon(icon, size: iconSize),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
