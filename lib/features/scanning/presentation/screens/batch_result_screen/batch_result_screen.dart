import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:powerocr/core/di/locator.dart';
import 'package:powerocr/core/services/interfaces/ipdf_service.dart';
import 'dart:math' as math;
import 'package:go_router/go_router.dart';
import 'package:powerocr/l10n/app_localizations.dart';

class BatchResultScreen extends StatefulWidget {
  final List<String> imagePaths;
  const BatchResultScreen({super.key, required this.imagePaths});

  @override
  State<BatchResultScreen> createState() => _BatchResultScreenState();
}

class _BatchResultScreenState extends State<BatchResultScreen>
    with TickerProviderStateMixin {
  bool _isExporting = false;
  late final AnimationController _orbCtrl;
  late final Animation<double> _orbRotate;
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.1;

  @override
  void initState() {
    super.initState();
    _orbCtrl = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat();
    _orbRotate = Tween(begin: 0.0, end: 2 * math.pi).animate(_orbCtrl);

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    double offset = _scrollController.offset;
    double newOpacity = 0.1 + (offset / 100);
    newOpacity = newOpacity.clamp(0.1, 1.0);
    if (newOpacity != _appBarOpacity) {
      setState(() {
        _appBarOpacity = newOpacity;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _orbCtrl.dispose();
    super.dispose();
  }

  Future<void> _exportToPdf() async {
    setState(() => _isExporting = true);
    try {
      await locator<IPdfService>().exportToPdf(widget.imagePaths);
    } catch (e) {
      debugPrint('Export PDF Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            margin: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.paddingOf(context).bottom + 92,
            ),
            behavior: SnackBarBehavior.floating,
            content: Text(AppLocalizations.of(context)!.exportPdfFailed(e.toString())),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final size = MediaQuery.sizeOf(context);
    final topPadding = MediaQuery.paddingOf(context).top;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background Orbs
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _orbRotate,
              builder: (context, child) => CustomPaint(
                size: size,
                painter: _BatchResultOrbPainter(
                  rotate: _orbRotate.value,
                  isDark: isDark,
                  primary: primary,
                ),
              ),
            ),
          ),

          // Content
          _isExporting
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(height: topPadding + 64),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      sliver: SliverGrid.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: widget.imagePaths.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(widget.imagePaths[index]),
                                  fit: BoxFit.cover,
                                  cacheHeight: 350,
                                  cacheWidth: 250,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                left: 8,
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: theme.colorScheme.onPrimary,
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),

          // Custom App Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: _appBarOpacity,
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          color: theme.scaffoldBackgroundColor.withValues(
                            alpha: 0.65,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: theme.colorScheme.onSurface,
                            size: 20,
                          ),
                          onPressed: () => context.pop(),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.batchResultPageCount(widget.imagePaths.length),
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.picture_as_pdf_rounded),
                          onPressed: _isExporting ? null : _exportToPdf,
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FilledButton.icon(
            onPressed: _isExporting ? null : _exportToPdf,
            icon: const Icon(Icons.share_rounded),
            label: Text(l10n.batchResultExportPdfBtn),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BatchResultOrbPainter extends CustomPainter {
  final double rotate;
  final bool isDark;
  final Color primary;

  _BatchResultOrbPainter({
    required this.rotate,
    required this.isDark,
    required this.primary,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Top-right orb
    final ox = size.width * 0.88 + math.cos(rotate) * 10;
    final oy = size.height * 0.05 + math.sin(rotate) * 8;
    _drawOrb(
      canvas,
      Offset(ox, oy),
      120,
      primary.withValues(alpha: isDark ? 0.14 : 0.08),
    );
    // Bottom-left orb
    final ox2 = size.width * 0.08 + math.sin(rotate) * 10;
    final oy2 = size.height * 0.7 + math.cos(rotate) * 12;
    _drawOrb(
      canvas,
      Offset(ox2, oy2),
      100,
      const Color(0xFF95E1D3).withValues(alpha: isDark ? 0.11 : 0.06),
    );
  }

  void _drawOrb(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color, Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_BatchResultOrbPainter old) =>
      old.rotate != rotate || old.isDark != isDark;
}
