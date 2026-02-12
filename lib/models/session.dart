/// Modelo de uma sessão de pomodoro concluída.
class Session {
  final int timestamp;
  final String type; // 'work' | 'break'
  final int durationSeconds;

  const Session({
    required this.timestamp,
    required this.type,
    required this.durationSeconds,
  });

  bool get isWork => type == 'work';

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp,
        'type': type,
        'duration': durationSeconds,
      };

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        timestamp: json['timestamp'] as int,
        type: json['type'] as String,
        durationSeconds: json['duration'] as int,
      );

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(timestamp);
}
