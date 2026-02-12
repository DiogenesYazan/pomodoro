import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/stats/stats_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/about/about_screen.dart';
import '../screens/settings/settings_screen.dart';

/// Shell com BottomNavigationBar + botão de configurações.
class TempusShell extends StatefulWidget {
  const TempusShell({super.key});

  @override
  State<TempusShell> createState() => _TempusShellState();
}

class _TempusShellState extends State<TempusShell> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    StatsScreen(),
    ProfileScreen(),
    AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 60 : 20),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (i) {
              if (i == 4) {
                // Settings — abre como tela cheia
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
                return;
              }
              setState(() => _currentIndex = i);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.timer_rounded),
                activeIcon: Icon(Icons.timer_rounded),
                label: 'Timer',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_rounded),
                activeIcon: Icon(Icons.bar_chart_rounded),
                label: 'Stats',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                activeIcon: Icon(Icons.person_rounded),
                label: 'Perfil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info_outline_rounded),
                activeIcon: Icon(Icons.info_rounded),
                label: 'Sobre',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_rounded),
                activeIcon: Icon(Icons.settings_rounded),
                label: 'Config',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
