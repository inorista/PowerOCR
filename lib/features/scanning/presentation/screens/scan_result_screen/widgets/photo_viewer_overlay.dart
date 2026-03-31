import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhotoViewerOverlay extends StatefulWidget {
  final String imagePath;

  final Object? heroTag;

  const PhotoViewerOverlay({super.key, required this.imagePath, this.heroTag});
  static Future<void> show(
    BuildContext context, {
    required String imagePath,
    Object? heroTag,
  }) {
    HapticFeedback.lightImpact();
    return Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 280),
        pageBuilder: (_, _, _) =>
            PhotoViewerOverlay(imagePath: imagePath, heroTag: heroTag),
        transitionsBuilder: (_, animation, _, child) => FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  State<PhotoViewerOverlay> createState() => _PhotoViewerOverlayState();
}

class _PhotoViewerOverlayState extends State<PhotoViewerOverlay>
    with TickerProviderStateMixin {
  final TransformationController _transformCtrl = TransformationController();

  static const double _minScale = 0.9;
  static const double _maxScale = 5.0;
  static const double _doubleTapScale = 2.5;

  late AnimationController _doubleTapAnimCtrl;
  Animation<Matrix4>? _doubleTapAnim;

  late AnimationController _dismissAnimCtrl;

  double _dragOffsetY = 0.0;
  double _backgroundOpacity = 1.0;
  bool _isDraggingToDismiss = false;

  double _currentScale = 1.0;
  bool _showZoomBadge = false;
  late AnimationController _zoomBadgeCtrl;

  @override
  void initState() {
    super.initState();

    _doubleTapAnimCtrl =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 280),
        )..addListener(() {
          if (_doubleTapAnim != null) {
            _transformCtrl.value = _doubleTapAnim!.value;
          }
        });

    _dismissAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _zoomBadgeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _transformCtrl.addListener(_onTransformChanged);
  }

  @override
  void dispose() {
    _transformCtrl.removeListener(_onTransformChanged);
    _transformCtrl.dispose();
    _doubleTapAnimCtrl.dispose();
    _dismissAnimCtrl.dispose();
    _zoomBadgeCtrl.dispose();
    super.dispose();
  }

  void _onTransformChanged() {
    final scale = _transformCtrl.value.getMaxScaleOnAxis();
    if ((scale - _currentScale).abs() > 0.01) {
      setState(() => _currentScale = scale);
      _flashZoomBadge();
    }
  }

  void _flashZoomBadge() {
    if (!_showZoomBadge) setState(() => _showZoomBadge = true);
    _zoomBadgeCtrl.forward(from: 0);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        _zoomBadgeCtrl.reverse().then((_) {
          if (mounted) setState(() => _showZoomBadge = false);
        });
      }
    });
  }

  bool get _isAtNormalScale =>
      (_transformCtrl.value.getMaxScaleOnAxis() - 1.0).abs() < 0.05;

  void _onDoubleTapDown(TapDownDetails details) {
    if (_doubleTapAnimCtrl.isAnimating) return;

    final Matrix4 target;
    if (_isAtNormalScale) {
      final focalPoint = details.localPosition;
      final scale = _doubleTapScale;
      target = Matrix4.identity()
        ..translate(-focalPoint.dx * (scale - 1), -focalPoint.dy * (scale - 1))
        ..scale(scale);
    } else {
      target = Matrix4.identity();
    }

    _doubleTapAnim = Matrix4Tween(begin: _transformCtrl.value, end: target)
        .animate(
          CurvedAnimation(
            parent: _doubleTapAnimCtrl,
            curve: Curves.easeInOutCubicEmphasized,
          ),
        );

    _doubleTapAnimCtrl.forward(from: 0);
    HapticFeedback.selectionClick();
  }

  void _startDismissDrag(DragStartDetails _) {
    if (!_isAtNormalScale) return;
    setState(() => _isDraggingToDismiss = true);
  }

  void _updateDismissDrag(DragUpdateDetails details) {
    if (!_isDraggingToDismiss) return;
    final dy = details.delta.dy;
    setState(() {
      _dragOffsetY += dy;
      if (_dragOffsetY < 0) _dragOffsetY *= 0.4;
      final progress = (_dragOffsetY.abs() / 300).clamp(0.0, 1.0);
      _backgroundOpacity = 1.0 - progress * 0.85;
    });
  }

  void _endDismissDrag(DragEndDetails details) {
    if (!_isDraggingToDismiss) return;
    final velocity = details.velocity.pixelsPerSecond.dy;
    final shouldDismiss = _dragOffsetY > 100 || velocity > 600;

    if (shouldDismiss) {
      Navigator.of(context).pop();
    } else {
      // Spring back
      setState(() {
        _dragOffsetY = 0;
        _backgroundOpacity = 1.0;
        _isDraggingToDismiss = false;
      });
    }
  }

  void _close() {
    HapticFeedback.lightImpact();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;

    return Material(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: _backgroundOpacity,
                duration: Duration.zero,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                  child: Container(color: Colors.black.withValues(alpha: 0.92)),
                ),
              ),
            ),

            Positioned.fill(
              child: GestureDetector(
                onVerticalDragStart: _startDismissDrag,
                onVerticalDragUpdate: _updateDismissDrag,
                onVerticalDragEnd: _endDismissDrag,
                child: Transform.translate(
                  offset: Offset(0, _dragOffsetY),
                  child: _buildInteractiveViewer(context),
                ),
              ),
            ),

            Positioned(
              top: topPad + 8,
              left: 16,
              right: 16,
              child: AnimatedOpacity(
                opacity: _isDraggingToDismiss ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 150),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _GlassIconButton(icon: Icons.close_rounded, onTap: _close),
                    _buildZoomBadge(),
                    _GlassIconButton(
                      icon: Icons.fit_screen_rounded,
                      onTap: () {
                        _doubleTapAnimCtrl.stop();
                        final anim =
                            Matrix4Tween(
                              begin: _transformCtrl.value,
                              end: Matrix4.identity(),
                            ).animate(
                              CurvedAnimation(
                                parent: _doubleTapAnimCtrl,
                                curve: Curves.easeInOutCubicEmphasized,
                              ),
                            );
                        _doubleTapAnim = anim;
                        _doubleTapAnimCtrl.forward(from: 0);
                        HapticFeedback.selectionClick();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveViewer(BuildContext context) {
    final imageWidget = Image.file(
      File(widget.imagePath),
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => const Center(
        child: Icon(
          Icons.broken_image_rounded,
          color: Colors.white38,
          size: 64,
        ),
      ),
    );

    final child = widget.heroTag != null
        ? Hero(tag: widget.heroTag!, child: imageWidget)
        : imageWidget;

    return InteractiveViewer(
      transformationController: _transformCtrl,
      minScale: _minScale,
      maxScale: _maxScale,
      clipBehavior: Clip.none,
      onInteractionStart: (_) => setState(() => _isDraggingToDismiss = false),
      child: GestureDetector(
        onDoubleTapDown: _onDoubleTapDown,
        onDoubleTap: () {},
        child: Center(child: child),
      ),
    );
  }

  Widget _buildZoomBadge() {
    return AnimatedOpacity(
      opacity: _showZoomBadge ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 0.5,
              ),
            ),
            child: Text(
              '${(_currentScale * 100).round()}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.40),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.18),
                width: 0.5,
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}
