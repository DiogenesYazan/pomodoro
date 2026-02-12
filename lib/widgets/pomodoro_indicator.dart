import 'package:flutter/material.dart';
import '../theme/tempus_colors.dart';

/// Indicador visual dos ciclos pomodoro completados.
class PomodoroIndicator extends StatelessWidget {
  final int completed;
  final int total;

  const PomodoroIndicator({
    super.key,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final isActive = i < completed;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? (isDark ? TempusColors.accent : TempusColors.deepPurple)
                : (isDark ? TempusColors.plum : TempusColors.lavender),
            border: Border.all(
              color: isDark
                  ? TempusColors.accent.withAlpha(80)
                  : TempusColors.orchid.withAlpha(80),
              width: 1,
            ),
          ),
        );
      }),
    );
  }
}
