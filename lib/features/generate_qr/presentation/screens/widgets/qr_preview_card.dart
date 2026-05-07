import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocSelector;
import 'package:powerocr/features/generate_qr/presentation/bloc/generate_qr_bloc.dart'
    show GenerateQrBloc;
import 'package:powerocr/features/generate_qr/presentation/bloc/generate_qr_state.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:powerocr/l10n/app_localizations.dart';

/// Maps [QrModuleStyle] → [PrettyQrShape] for the data modules.
PrettyQrShape _buildQrShape({
  required QrModuleStyle moduleStyle,
  required QrEyeStyle eyeStyle,
  required Color color,
}) {
  final PrettyQrShape moduleShape;
  switch (moduleStyle) {
    case QrModuleStyle.dots:
      moduleShape = PrettyQrDotsSymbol(color: color);
      break;
    case QrModuleStyle.smooth:
      moduleShape = PrettyQrSmoothSymbol(color: color);
      break;
    case QrModuleStyle.square:
      moduleShape = PrettyQrSquaresSymbol(color: color);
      break;
  }

  final PrettyQrShape eyeShape;
  switch (eyeStyle) {
    case QrEyeStyle.dots:
      eyeShape = PrettyQrDotsSymbol(color: color);
      break;
    case QrEyeStyle.smooth:
      eyeShape = PrettyQrSmoothSymbol(color: color);
      break;
    case QrEyeStyle.square:
      eyeShape = PrettyQrSquaresSymbol(color: color);
      break;
  }

  // If both are the same, just return the module shape directly
  if (moduleStyle.index == eyeStyle.index) {
    return moduleShape;
  }

  // Use PrettyQrShape.custom to combine different module + finder styles
  return PrettyQrShape.custom(moduleShape, finderPattern: eyeShape);
}

class QrPreviewCard extends StatefulWidget {
  final GlobalKey boundaryKey;
  final String data;
  final Color foregroundColor;
  final bool isDarkBackground;
  final QrEyeStyle eyeStyle;
  final QrModuleStyle moduleStyle;

  const QrPreviewCard({
    super.key,
    required this.boundaryKey,
    required this.data,
    required this.foregroundColor,
    required this.isDarkBackground,
    required this.eyeStyle,
    required this.moduleStyle,
  });

  @override
  State<QrPreviewCard> createState() => _QrPreviewCardState();
}

class _QrPreviewCardState extends State<QrPreviewCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;

    final bgColor = widget.isDarkBackground
        ? (isDark ? const Color(0xFF1A1A26) : const Color(0xFF2D2D3F))
        : Colors.white;

    return RepaintBoundary(
      key: widget.boundaryKey,
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          // Outer glow
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.15),
              blurRadius: 40,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.4)
                  : Colors.black.withValues(alpha: 0.06),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              // Gradient mesh background
              Positioned.fill(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    gradient: widget.isDarkBackground
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF1E1E30),
                              Color(0xFF252540),
                              Color(0xFF1A1A2E),
                            ],
                          )
                        : const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              Color(0xFFF8F9FF),
                              Color(0xFFF0F2FF),
                            ],
                          ),
                  ),
                ),
              ),

              // Subtle animated shimmer overlay
              AnimatedBuilder(
                animation: _shimmerController,
                builder: (context, child) {
                  return Positioned.fill(
                    child: CustomPaint(
                      painter: _ShimmerPainter(
                        progress: _shimmerController.value,
                        color: primary.withValues(alpha: 0.04),
                      ),
                    ),
                  );
                },
              ),

              // Decorative corner dots
              Positioned(
                top: 12,
                left: 12,
                child: _CornerDot(color: primary.withValues(alpha: 0.2)),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: _CornerDot(color: primary.withValues(alpha: 0.15)),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: _CornerDot(color: primary.withValues(alpha: 0.15)),
              ),
              Positioned(
                bottom: 12,
                right: 12,
                child: _CornerDot(color: primary.withValues(alpha: 0.2)),
              ),

              // Inner border
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : primary.withValues(alpha: 0.1),
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              // Content
              Center(
                child: widget.data.trim().isEmpty
                    ? _buildPlaceholder(context, theme)
                    : _buildQrCode(bgColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context, ThemeData theme) {
    return BlocSelector<GenerateQrBloc, GenerateQrState, bool>(
      selector: (state) => state.isDarkBackground,
      builder: (context, isDarkBg) {
        final textColor = isDarkBg
            ? const Color(0xFFB0B0CC)
            : const Color(0xFF8888AA);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: textColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.qr_code_2_rounded,
                size: 40,
                color: textColor.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.generateQrPlaceholder,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQrCode(Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: 240,
      width: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.0),
        color: bgColor,
      ),
      child: PrettyQrView(
        qrImage: QrImage(
          QrCode.fromData(
            data: widget.data,
            errorCorrectLevel: QrErrorCorrectLevel.H,
          ),
        ),
        decoration: PrettyQrDecoration(
          background: bgColor,
          shape: _buildQrShape(
            moduleStyle: widget.moduleStyle,
            eyeStyle: widget.eyeStyle,
            color: widget.foregroundColor,
          ),
        ),
      ),
    );
  }
}

class _CornerDot extends StatelessWidget {
  final Color color;
  const _CornerDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _ShimmerPainter extends CustomPainter {
  final double progress;
  final Color color;

  _ShimmerPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width * (0.5 + 0.5 * math.cos(progress * 2 * math.pi)),
      size.height * (0.5 + 0.5 * math.sin(progress * 2 * math.pi)),
    );

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color, color.withValues(alpha: 0)],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: size.width * 0.6));

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(_ShimmerPainter old) => old.progress != progress;
}
