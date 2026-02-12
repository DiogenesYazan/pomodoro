import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/timer_provider.dart';
import 'providers/settings_provider.dart';
import 'services/storage_service.dart';
import 'services/audio_service.dart';
import 'theme/tempus_theme.dart';
import 'widgets/tempus_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock portrait orientation (Android mobile-first)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final storage = StorageService();
  final audio = AudioService();

  runApp(
    MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storage),
        ChangeNotifierProvider<SettingsProvider>(
          create: (_) => SettingsProvider(storage: storage)..init(),
        ),
        ChangeNotifierProvider<TimerProvider>(
          create: (_) => TimerProvider(storage: storage, audio: audio)..init(),
        ),
      ],
      child: const TempusApp(),
    ),
  );
}

class TempusApp extends StatelessWidget {
  const TempusApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return MaterialApp(
      title: 'Tempus',
      debugShowCheckedModeBanner: false,
      theme: TempusTheme.light,
      darkTheme: TempusTheme.dark,
      themeMode: settings.themeMode,
      home: const TempusShell(),
    );
  }
}
