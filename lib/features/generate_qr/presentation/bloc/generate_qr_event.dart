import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'generate_qr_state.dart';

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

class QrEyeStyleChanged extends GenerateQrEvent {
  final QrEyeStyle style;
  const QrEyeStyleChanged(this.style);

  @override
  List<Object?> get props => [style];
}

class QrModuleStyleChanged extends GenerateQrEvent {
  final QrModuleStyle style;
  const QrModuleStyleChanged(this.style);

  @override
  List<Object?> get props => [style];
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
