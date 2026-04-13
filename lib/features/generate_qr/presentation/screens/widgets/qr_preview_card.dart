import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

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

    // Check if the foreground color has good contrast with white background,
    // if not and dark is selected, we should ensure the QR is visible.
    // For simplicity, we just use the selected color and background.
    
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.qr_code_2_rounded,
                        size: 64,
                        color: theme.colorScheme.onSurface.withOpacity(0.1),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nhập nội dung để\ntạo mã QR',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.3),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : QrImageView(
                data: data,
                version: QrVersions.auto,
                size: 200,
                backgroundColor: Colors.transparent, // background is dictated by container
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
