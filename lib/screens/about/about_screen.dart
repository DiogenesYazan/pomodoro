import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/tempus_colors.dart';
import '../../widgets/gradient_background.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      final launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o link')),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao abrir o link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? TempusColors.accent : TempusColors.deepPurple;

    return GradientBackground(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            const SizedBox(height: 32),

            // ── Logo ─────────────────────────────────────
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: TempusColors.accentGradient,
                  boxShadow: [
                    BoxShadow(
                      color: TempusColors.deepPurple.withAlpha(80),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.timer_rounded,
                  size: 52,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Tempus',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                'Versão 1.0.0',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Timer Pomodoro Profissional',
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // ── Descrição ────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline_rounded, color: accentColor),
                        const SizedBox(width: 8),
                        Text('Sobre',
                            style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tempus é um timer Pomodoro projetado para ajudar você a manter o foco e aumentar sua produtividade. '
                      'Baseado na técnica Pomodoro, o app alterna períodos de trabalho intenso com pausas estratégicas '
                      'para otimizar seu desempenho mental.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── O que é a Técnica Pomodoro ───────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline_rounded,
                            color: TempusColors.warning),
                        const SizedBox(width: 8),
                        Text('A Técnica Pomodoro',
                            style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _StepRow(
                        number: '1', text: 'Escolha uma tarefa para focar'),
                    _StepRow(number: '2', text: 'Inicie o timer de 25 minutos'),
                    _StepRow(number: '3', text: 'Trabalhe até o alarme tocar'),
                    _StepRow(number: '4', text: 'Faça uma pausa curta (5 min)'),
                    _StepRow(
                        number: '5',
                        text: 'A cada 4 ciclos, pausa longa (15 min)'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Developer ────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.code_rounded, color: accentColor),
                        const SizedBox(width: 8),
                        Text('Desenvolvedor',
                            style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: TempusColors.primaryGradient,
                          ),
                          child: const Center(
                            child: Text(
                              'DY',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Diogenes Yazan',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Desenvolvedor de Software',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            _openUrl(context, 'https://diogenesyuri.works/'),
                        icon: const Icon(Icons.language_rounded),
                        label: const Text('Visitar Portfólio'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Tecnologias ──────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.build_rounded, color: TempusColors.orchid),
                        const SizedBox(width: 8),
                        Text('Feito com',
                            style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        _TechChip('Flutter'),
                        _TechChip('Dart'),
                        _TechChip('Provider'),
                        _TechChip('Material 3'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Footer ──────────────────────────────────
            Center(
              child: Text(
                '© 2026 Diogenes Yazan. Todos os direitos reservados.',
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════
//  STEP ROW
// ═════════════════════════════════════════════════════════════════════
class _StepRow extends StatelessWidget {
  final String number;
  final String text;
  const _StepRow({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? TempusColors.accent : TempusColors.deepPurple;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor.withAlpha(20),
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════
//  TECH CHIP
// ═════════════════════════════════════════════════════════════════════
class _TechChip extends StatelessWidget {
  final String label;
  const _TechChip(this.label);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? TempusColors.accent : TempusColors.deepPurple;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: accentColor.withAlpha(15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withAlpha(40)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: accentColor,
        ),
      ),
    );
  }
}
