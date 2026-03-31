// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScanHistoryTypeAdapter extends TypeAdapter<ScanHistoryType> {
  @override
  final typeId = 4;

  @override
  ScanHistoryType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ScanHistoryType.document;
      case 1:
        return ScanHistoryType.qr;
      default:
        return ScanHistoryType.document;
    }
  }

  @override
  void write(BinaryWriter writer, ScanHistoryType obj) {
    switch (obj) {
      case ScanHistoryType.document:
        writer.writeByte(0);
      case ScanHistoryType.qr:
        writer.writeByte(1);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScanHistoryTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ThemeModeOptionAdapter extends TypeAdapter<ThemeModeOption> {
  @override
  final typeId = 1;

  @override
  ThemeModeOption read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ThemeModeOption.system;
      case 1:
        return ThemeModeOption.light;
      case 2:
        return ThemeModeOption.dark;
      default:
        return ThemeModeOption.system;
    }
  }

  @override
  void write(BinaryWriter writer, ThemeModeOption obj) {
    switch (obj) {
      case ThemeModeOption.system:
        writer.writeByte(0);
      case ThemeModeOption.light:
        writer.writeByte(1);
      case ThemeModeOption.dark:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeModeOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
