// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_history_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScanHistoryEntityAdapter extends TypeAdapter<ScanHistoryEntity> {
  @override
  final typeId = 2;

  @override
  ScanHistoryEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScanHistoryEntity(
      id: fields[0] as String?,
      imagePath: fields[1] as String,
      text: fields[2] as String,
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ScanHistoryEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imagePath)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScanHistoryEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
