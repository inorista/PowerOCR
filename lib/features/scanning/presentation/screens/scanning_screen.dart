import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:powerocr/core/router/app_router.dart';
import 'package:powerocr/features/scanning/presentation/bloc/scanning_bloc.dart';
import 'package:powerocr/features/scanning/presentation/bloc/scanning_event.dart';
import 'package:powerocr/features/scanning/presentation/bloc/scanning_state.dart';

class ScanningScreen extends StatefulWidget {
  const ScanningScreen({super.key});

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  final ImagePicker _picker = ImagePicker();

  late final ScanningBloc _bloc;

  late AnimationController _scanLineCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _cornerCtrl;

  late Animation<double> _scanLinePos;
  late Animation<double> _pulseScale;
  late Animation<double> _pulseOpacity;
  late Animation<double> _cornerGlow;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _scanLineCtrl = AnimationController(
        duration: const Duration(milliseconds: 2800), vsync: this)
      ..repeat();
    _scanLinePos = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _scanLineCtrl, curve: Curves.easeInOut));

    _pulseCtrl = AnimationController(
        duration: const Duration(milliseconds: 900), vsync: this)
      ..repeat(reverse: true);
    _pulseScale = Tween(begin: 1.0, end: 1.07)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _pulseOpacity = Tween(begin: 0.5, end: 1.0)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _cornerCtrl = AnimationController(
        duration: const Duration(milliseconds: 1400), vsync: this)
      ..repeat(reverse: true);
    _cornerGlow = Tween(begin: 0.5, end: 1.0)
        .animate(CurvedAnimation(parent: _cornerCtrl, curve: Curves.easeInOut));

    _bloc = ScanningBloc();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _controller = CameraController(
          _cameras[0],
          ResolutionPreset.high,
          enableAudio: false,
          imageFormatGroup: ImageFormatGroup.jpeg,
        );
        await _controller!.initialize();

        if (!_bloc.isClosed) _bloc.add(CameraReady());
      }
    } catch (e) {
      debugPrint('Camera init error: $e');
      if (!_bloc.isClosed) _bloc.add(CameraNotReady());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _bloc.close();
    _scanLineCtrl.dispose();
    _pulseCtrl.dispose();
    _cornerCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cam = _controller;
    if (state == AppLifecycleState.inactive) {
      cam?.dispose();
      if (!_bloc.isClosed) _bloc.add(CameraNotReady());
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScanningBloc>.value(
      value: _bloc,
      child: BlocListener<ScanningBloc, ScanningState>(
        listener: (context, state) {
          if (state.status == ScanningStatus.success &&
              state.result != null &&
              state.imagePath != null) {
            context.push(
              AppRouter.scanResult,
              extra: {
                'imagePath': state.imagePath!,
                'result': state.result!,
              },
            );
          } else if (state.status == ScanningStatus.failure) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          state.errorMessage ?? 'Scan failed',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: const Color(0xFFE57373),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                ),
              );
          }

          _controller?.setFlashMode(state.flashMode);
        },
        child: BlocBuilder<ScanningBloc, ScanningState>(
          builder: (context, state) {
            if (state.status == ScanningStatus.loading) {
              return _buildLoadingView();
            }
            return _buildCameraView(
              context,
              flashMode: state.flashMode,
              isCameraInitialized: state.isCameraInitialized,
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 72,
              height: 72,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF8B8FE3)),
                  ),
                  Icon(Icons.auto_awesome_rounded,
                      color: const Color(0xFF8B8FE3).withValues(alpha: 0.8),
                      size: 28),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Recognizing text...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'AI is processing your image',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraView(
    BuildContext context, {
    required FlashMode flashMode,
    required bool isCameraInitialized,
  }) {
    final size = MediaQuery.sizeOf(context);

    final frameW = size.width * 0.85;
    final frameH = frameW * 1.25;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (isCameraInitialized && _controller != null)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller!.value.previewSize?.height ??
                      MediaQuery.sizeOf(context).width,
                  height: _controller!.value.previewSize?.width ??
                      MediaQuery.sizeOf(context).height,
                  child: CameraPreview(_controller!),
                ),
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white38),
              ),
            ),
          if (isCameraInitialized)
            ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Color(0xBB000000),
                BlendMode.srcOut,
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      backgroundBlendMode: BlendMode.dstOut,
                    ),
                  ),
                  Center(
                    child: Container(
                      width: frameW,
                      height: frameH,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (isCameraInitialized)
            AnimatedBuilder(
              animation: _cornerGlow,
              builder: (_, __) => Center(
                child: CustomPaint(
                  size: Size(frameW, frameH),
                  painter: _CornerBracketPainter(
                    glow: _cornerGlow.value,
                    color: const Color(0xFF8B8FE3),
                  ),
                ),
              ),
            ),
          if (isCameraInitialized)
            AnimatedBuilder(
              animation: _scanLinePos,
              builder: (_, __) {
                final topOffset = (size.height - frameH) / 2;
                final beamY =
                    topOffset + (_scanLinePos.value * frameH).clamp(0, frameH);
                return Positioned(
                  top: beamY - 24,
                  left: (size.width - frameW) / 2,
                  width: frameW,
                  height: 48,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            const Color(0xFF8B8FE3).withValues(alpha: 0.08),
                            const Color(0xFF95E1D3).withValues(alpha: 0.45),
                            const Color(0xFF8B8FE3).withValues(alpha: 0.08),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          if (isCameraInitialized)
            AnimatedBuilder(
              animation: _scanLinePos,
              builder: (_, __) {
                final topOffset = (size.height - frameH) / 2;
                final lineY =
                    topOffset + (_scanLinePos.value * frameH).clamp(0, frameH);
                return Positioned(
                  top: lineY,
                  left: (size.width - frameW) / 2 + 4,
                  width: frameW - 8,
                  height: 1.5,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Colors.transparent,
                          Color(0xFF95E1D3),
                          Color(0xFF8B8FE3),
                          Color(0xFF95E1D3),
                          Colors.transparent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B8FE3).withValues(alpha: 0.8),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      _TopBarButton(
                        icon: Icons.close_rounded,
                        onTap: () => context.go(AppRouter.home),
                      ),
                      const Spacer(),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.document_scanner_rounded,
                                    color: Colors.white70, size: 14),
                                SizedBox(width: 6),
                                Text(
                                  'Align document in frame',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      _FlashButton(
                        mode: flashMode,
                        onTap: () =>
                            context.read<ScanningBloc>().add(ToggleFlash()),
                      ),
                    ],
                  )),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.45),
                  padding: EdgeInsets.fromLTRB(
                      32, 20, 32, MediaQuery.paddingOf(context).bottom + 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _ControlButton(
                        icon: Icons.photo_library_rounded,
                        label: 'Gallery',
                        onTap: () => _pickImage(context),
                      ),
                      const SizedBox(width: 8),
                      AnimatedBuilder(
                        animation: _pulseCtrl,
                        builder: (_, __) => GestureDetector(
                          onTap: () => _takePicture(context),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Transform.scale(
                                scale: _pulseScale.value,
                                child: Container(
                                  width: 84,
                                  height: 84,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                          alpha: _pulseOpacity.value * 0.5),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF8B8FE3),
                                      Color(0xFF55C7B5),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF8B8FE3)
                                          .withValues(alpha: 0.5),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const SizedBox(width: 52),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _takePicture(BuildContext context) async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      final image = await _controller!.takePicture();
      if (!context.mounted) return;
      context.read<ScanningBloc>().add(ScanImage(image.path));
    } catch (e) {
      debugPrint('Capture error: $e');
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null && context.mounted) {
        context.read<ScanningBloc>().add(ScanImage(image.path));
      }
    } catch (e) {
      debugPrint('Gallery error: $e');
    }
  }
}

class _CornerBracketPainter extends CustomPainter {
  final double glow;
  final Color color;
  _CornerBracketPainter({required this.glow, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: glow)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2 * glow);

    const len = 28.0;
    const r = 16.0;

    void drawCorner(Offset corner, bool flipX, bool flipY) {
      final sx = flipX ? -1.0 : 1.0;
      final sy = flipY ? -1.0 : 1.0;
      canvas.drawPath(
        Path()
          ..moveTo(corner.dx + sx * (len + r), corner.dy)
          ..lineTo(corner.dx + sx * r, corner.dy)
          ..arcToPoint(
            Offset(corner.dx, corner.dy + sy * r),
            radius: const Radius.circular(r),
            clockwise: flipX == flipY,
          )
          ..lineTo(corner.dx, corner.dy + sy * (len + r)),
        paint,
      );
    }

    drawCorner(Offset.zero, false, false);
    drawCorner(Offset(size.width, 0), true, false);
    drawCorner(Offset(0, size.height), false, true);
    drawCorner(Offset(size.width, size.height), true, true);
  }

  @override
  bool shouldRepaint(_CornerBracketPainter old) => old.glow != glow;
}

class _TopBarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TopBarButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Icon(icon, color: Colors.white70, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _FlashButton extends StatelessWidget {
  final FlashMode mode;
  final VoidCallback onTap;

  const _FlashButton({required this.mode, required this.onTap});

  IconData get _icon => switch (mode) {
        FlashMode.always => Icons.flash_on_rounded,
        FlashMode.off => Icons.flash_off_rounded,
        _ => Icons.flash_auto_rounded,
      };

  String get _label => switch (mode) {
        FlashMode.always => 'On',
        FlashMode.off => 'Off',
        _ => 'Auto',
      };

  Color get _iconColor => switch (mode) {
        FlashMode.off => Colors.white60,
        _ => const Color(0xFFFFD54F),
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: 52,
            height: 44,
            decoration: BoxDecoration(
              color: mode == FlashMode.off
                  ? Colors.black.withValues(alpha: 0.4)
                  : const Color(0xFFFFD54F).withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: mode == FlashMode.off
                    ? Colors.white.withValues(alpha: 0.12)
                    : const Color(0xFFFFD54F).withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    _icon,
                    key: ValueKey(mode),
                    color: _iconColor,
                    size: 18,
                  ),
                ),
                const SizedBox(height: 2),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: Text(
                    _label,
                    key: ValueKey(mode),
                    style: TextStyle(
                      color: _iconColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
