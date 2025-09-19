// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_preset.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimerPresetAdapter extends TypeAdapter<TimerPreset> {
  @override
  final int typeId = 2;

  @override
  TimerPreset read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimerPreset(
      name: fields[0] as String,
      focusDuration: fields[1] as int,
      shortBreakDuration: fields[2] as int,
      longBreakDuration: fields[3] as int,
      totalSessions: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TimerPreset obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.focusDuration)
      ..writeByte(2)
      ..write(obj.shortBreakDuration)
      ..writeByte(3)
      ..write(obj.longBreakDuration)
      ..writeByte(4)
      ..write(obj.totalSessions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerPresetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
