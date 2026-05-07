import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:powerocr/features/generate_qr/presentation/screens/widgets/qr_style_options.dart';

/// Defines available QR module (data) shapes.
enum QrModuleStyle { square, dots, smooth }

/// Defines available QR eye (finder-pattern) shapes.
enum QrEyeStyle { square, dots, smooth }

class GenerateQrState extends Equatable {
  final String qrData;
  final Color selectedColor;
  final QrEyeStyle eyeStyle;
  final QrModuleStyle moduleStyle;
  final bool isDarkBackground;
  final bool isSharing;

  const GenerateQrState({
    this.qrData = '',
    this.selectedColor = const Color(0xFF000000),
    this.eyeStyle = QrEyeStyle.square,
    this.moduleStyle = QrModuleStyle.square,
    this.isDarkBackground = false,
    this.isSharing = false,
  });

  factory GenerateQrState.initial() {
    return GenerateQrState(selectedColor: defaultColors[0].color);
  }

  GenerateQrState copyWith({
    String? qrData,
    Color? selectedColor,
    QrEyeStyle? eyeStyle,
    QrModuleStyle? moduleStyle,
    bool? isDarkBackground,
    bool? isSharing,
  }) {
    return GenerateQrState(
      qrData: qrData ?? this.qrData,
      selectedColor: selectedColor ?? this.selectedColor,
      eyeStyle: eyeStyle ?? this.eyeStyle,
      moduleStyle: moduleStyle ?? this.moduleStyle,
      isDarkBackground: isDarkBackground ?? this.isDarkBackground,
      isSharing: isSharing ?? this.isSharing,
    );
  }

  @override
  List<Object?> get props => [
    qrData,
    selectedColor,
    eyeStyle,
    moduleStyle,
    isDarkBackground,
    isSharing,
  ];
}
