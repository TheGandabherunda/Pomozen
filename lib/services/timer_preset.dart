import 'package:hive/hive.dart';

part 'timer_preset.g.dart';

@HiveType(typeId: 2)
class TimerPreset extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int focusDuration;

  @HiveField(2)
  int shortBreakDuration;

  @HiveField(3)
  int longBreakDuration;

  @HiveField(4)
  int totalSessions;

  TimerPreset({
    required this.name,
    required this.focusDuration,
    required this.shortBreakDuration,
    required this.longBreakDuration,
    required this.totalSessions,
  });

  // Method to convert a preset to a map, useful for saving and updating
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'focusDuration': focusDuration,
      'shortBreakDuration': shortBreakDuration,
      'longBreakDuration': longBreakDuration,
      'totalSessions': totalSessions,
    };
  }

  // Factory constructor to create a preset from a map
  factory TimerPreset.fromMap(Map<String, dynamic> map) {
    return TimerPreset(
      name: map['name'],
      focusDuration: map['focusDuration'],
      shortBreakDuration: map['shortBreakDuration'],
      longBreakDuration: map['longBreakDuration'],
      totalSessions: map['totalSessions'],
    );
  }
}
