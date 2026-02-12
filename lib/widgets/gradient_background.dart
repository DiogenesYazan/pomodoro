import 'package:flutter/material.dart';
import '../theme/tempus_colors.dart';

/// Fundo com gradiente reutilizável para qualquer tela.
class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient:
            isDark ? TempusColors.darkGradient : TempusColors.lightGradient,
      ),
      child: child,
    );
  }
}
