// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_model_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OcrModelEntityAdapter extends TypeAdapter<OcrModelEntity> {
  @override
  final typeId = 6;

  @override
  OcrModelEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OcrModelEntity(
      model: fields[1] as String,
      language: fields[2] as String,
      languageName: fields[3] as String,
    )..id = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, OcrModelEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.model)
      ..writeByte(2)
      ..write(obj.language)
      ..writeByte(3)
      ..write(obj.languageName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OcrModelEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
