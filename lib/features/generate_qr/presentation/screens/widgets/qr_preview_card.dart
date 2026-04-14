import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocSelector;
import 'package:powerocr/features/generate_qr/presentation/bloc/generate_qr_bloc.dart'
    show GenerateQrBloc;
import 'package:powerocr/features/generate_qr/presentation/bloc/generate_qr_state.dart'
    show GenerateQrState;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:powerocr/l10n/app_localizations.dart';

class QrPreviewCard extends StatelessWidget {
  final GlobalKey boundaryKey;
  final String data;
  final Color foregroundColor;
  final bool isDarkBackground;
  final QrEyeShape eyeShape;
  final QrDataModuleShape dataModuleShape;

  const QrPreviewCard({
    super.key,
    required this.boundaryKey,
    required this.data,
    required this.foregroundColor,
    required this.isDarkBackground,
    required this.eyeShape,
    required this.dataModuleShape,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDarkBackground
        ? (isDark ? const Color(0xFF1A1A26) : const Color(0xFF2D2D3F))
        : Colors.white;

    return RepaintBoundary(
      key: boundaryKey,
      child: Container(
        width: 280,
        height: 280,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.05),
          ),
        ),
        alignment: Alignment.center,
        child: data.trim().isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: BlocSelector<GenerateQrBloc, GenerateQrState, bool>(
                    selector: (state) {
                      return state.isDarkBackground;
                    },
                    builder: (context, state) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.qr_code_2_rounded,
                            size: 64,
                            color: state
                                ? const Color(0xFFE0E0E0)
                                : Colors.black87,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context)!.generateQrPlaceholder,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: state
                                  ? const Color(0xFFE0E0E0)
                                  : Colors.black87,
                              height: 1.5,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              )
            : QrImageView(
                data: data,
                version: QrVersions.auto,
                size: 200,
                backgroundColor: Colors.transparent,
                eyeStyle: QrEyeStyle(
                  eyeShape: eyeShape,
                  color: foregroundColor,
                ),
                dataModuleStyle: QrDataModuleStyle(
                  dataModuleShape: dataModuleShape,
                  color: foregroundColor,
                ),
                errorCorrectionLevel: QrErrorCorrectLevel.H,
              ),
      ),
    );
  }
}
