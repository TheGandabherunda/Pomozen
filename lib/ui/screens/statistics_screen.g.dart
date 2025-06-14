// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_screen.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionDataAdapter extends TypeAdapter<SessionData> {
  @override
  final int typeId = 0;

  @override
  SessionData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionData(
      fields[5] as DateTime,
      fields[0] as DateTime,
      fields[1] as int,
      note: fields[2] as String?,
      labelName: fields[3] as String?,
      isCompleted: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SessionData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.focusMinutes)
      ..writeByte(2)
      ..write(obj.note)
      ..writeByte(3)
      ..write(obj.labelName)
      ..writeByte(4)
      ..write(obj.isCompleted)
      ..writeByte(5)
      ..write(obj.startTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
