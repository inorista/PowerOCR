import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

abstract class GenerateQrEvent extends Equatable {
  const GenerateQrEvent();

  @override
  List<Object?> get props => [];
}

class QrDataChanged extends GenerateQrEvent {
  final String data;
  const QrDataChanged(this.data);

  @override
  List<Object?> get props => [data];
}

class QrColorChanged extends GenerateQrEvent {
  final Color color;
  const QrColorChanged(this.color);

  @override
  List<Object?> get props => [color];
}

class QrEyeShapeChanged extends GenerateQrEvent {
  final QrEyeShape shape;
  const QrEyeShapeChanged(this.shape);

  @override
  List<Object?> get props => [shape];
}

class QrDataShapeChanged extends GenerateQrEvent {
  final QrDataModuleShape shape;
  const QrDataShapeChanged(this.shape);

  @override
  List<Object?> get props => [shape];
}

class QrBackgroundChanged extends GenerateQrEvent {
  final bool isDark;
  const QrBackgroundChanged(this.isDark);

  @override
  List<Object?> get props => [isDark];
}

class QrShareStatusChanged extends GenerateQrEvent {
  final bool isSharing;
  const QrShareStatusChanged(this.isSharing);

  @override
  List<Object?> get props => [isSharing];
}
