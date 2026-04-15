import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:powerocr/features/generate_qr/presentation/screens/widgets/qr_style_options.dart';

class GenerateQrState extends Equatable {
  final String qrData;
  final Color selectedColor;
  final QrEyeShape eyeShape;
  final QrDataModuleShape dataShape;
  final bool isDarkBackground;
  final bool isSharing;

  const GenerateQrState({
    this.qrData = '',
    this.selectedColor = const Color(0xFF000000), // Default value
    this.eyeShape = QrEyeShape.square,
    this.dataShape = QrDataModuleShape.square,
    this.isDarkBackground = false,
    this.isSharing = false,
  });

  factory GenerateQrState.initial() {
    return GenerateQrState(selectedColor: defaultColors[0].color);
  }

  GenerateQrState copyWith({
    String? qrData,
    Color? selectedColor,
    QrEyeShape? eyeShape,
    QrDataModuleShape? dataShape,
    bool? isDarkBackground,
    bool? isSharing,
  }) {
    return GenerateQrState(
      qrData: qrData ?? this.qrData,
      selectedColor: selectedColor ?? this.selectedColor,
      eyeShape: eyeShape ?? this.eyeShape,
      dataShape: dataShape ?? this.dataShape,
      isDarkBackground: isDarkBackground ?? this.isDarkBackground,
      isSharing: isSharing ?? this.isSharing,
    );
  }

  @override
  List<Object?> get props => [
    qrData,
    selectedColor,
    eyeShape,
    dataShape,
    isDarkBackground,
    isSharing,
  ];
}
