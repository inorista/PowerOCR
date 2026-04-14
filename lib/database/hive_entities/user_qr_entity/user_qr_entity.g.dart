// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_qr_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserQrEntityAdapter extends TypeAdapter<UserQrEntity> {
  @override
  final typeId = 5;

  @override
  UserQrEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserQrEntity(
      content: fields[1] as String,
      imagePath: fields[2] as String,
    )..id = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, UserQrEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserQrEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
