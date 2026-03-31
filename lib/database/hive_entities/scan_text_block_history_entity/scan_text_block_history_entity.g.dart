// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_text_block_history_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScanTextBlockHistoryEntityAdapter
    extends TypeAdapter<ScanTextBlockHistoryEntity> {
  @override
  final typeId = 3;

  @override
  ScanTextBlockHistoryEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScanTextBlockHistoryEntity(
      id: fields[0] as String?,
      text: fields[1] as String,
      boundingBox: (fields[2] as List).cast<double>(),
      scanHistoryId: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ScanTextBlockHistoryEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.boundingBox)
      ..writeByte(3)
      ..write(obj.scanHistoryId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScanTextBlockHistoryEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
