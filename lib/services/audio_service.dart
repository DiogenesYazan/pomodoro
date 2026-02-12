import 'package:audioplayers/audioplayers.dart';

/// Serviço de áudio isolado.
class AudioService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playAlarm() async {
    await _player.stop();
    await _player.play(AssetSource('sounds/alarm.mp3'));
  }

  Future<void> stop() async {
    await _player.stop();
  }

  void dispose() {
    _player.dispose();
  }
}
