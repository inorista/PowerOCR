// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_setting_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThemeSettingEntityAdapter extends TypeAdapter<ThemeSettingEntity> {
  @override
  final typeId = 0;

  @override
  ThemeSettingEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThemeSettingEntity(
      id: fields[0] as String?,
      themeMode: fields[1] as ThemeModeOption,
    );
  }

  @override
  void write(BinaryWriter writer, ThemeSettingEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.themeMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeSettingEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
