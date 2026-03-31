import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:powerocr/core/constants/enum.dart';
import 'package:powerocr/core/di/locator.dart';
import 'package:powerocr/core/router/app_router.dart';

import 'package:powerocr/features/scanning/presentation/bloc/scanning_bloc.dart';
import 'package:powerocr/features/scanning/presentation/bloc/scanning_event.dart';
import 'package:powerocr/features/scanning/presentation/bloc/scanning_state.dart';
import 'package:powerocr/features/scanning/presentation/screens/scanning_screen/widgets/loading_widget.dart';
import 'package:powerocr/features/scanning/presentation/screens/scanning_screen/widgets/scanner_top_bar.dart';
import 'package:powerocr/features/scanning/presentation/screens/scanning_screen/widgets/scanner_controls.dart';

class ScanningScreen extends StatefulWidget {
  final FeatureOption featureOption;
  const ScanningScreen({super.key, required this.featureOption});

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  CameraController? _controller;
  late AnimationController _scanLineCtrl;
  late Animation<double> _scanLinePos;

  late AnimationController _beamCtrl;
  late Animation<double> _beamFade;

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseScale;
  late Animation<double> _pulseOpacity;
  late ScanningBloc _bloc;
  final ImagePicker _picker = ImagePicker();
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bloc = locator<ScanningBloc>();
    _scanLineCtrl = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _scanLinePos = Tween(
      begin: 0.1,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _scanLineCtrl, curve: Curves.easeInOut));

    _beamCtrl = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _beamFade = Tween(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(parent: _beamCtrl, curve: Curves.easeInOut));

    _pulseCtrl = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat();
    _pulseScale = Tween(
      begin: 1.0,
      end: 1.4,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOutCubic));
    _pulseOpacity = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOutCubic));

    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _controller = CameraController(
      cameras.first,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await _controller!.initialize();
      if (mounted) {
        setState(() => _isInit = true);
        _bloc.add(CameraReady());
      }
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _scanLineCtrl.dispose();
    _beamCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _onFlashModeChanged(FlashMode mode) async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      await _controller!.setFlashMode(mode);
    } catch (e) {
      debugPrint('Flash error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    // Frame dims
    final frameW = size.width * 0.85;
    final frameH = frameW * 1.25;

    return BlocProvider<ScanningBloc>.value(
      value: _bloc,
      child: BlocListener<ScanningBloc, ScanningState>(
        listener: (context, state) {
          if (state.status == ScanningStatus.success &&
              state.result != null &&
              state.imagePath != null) {
            context.replace(
              AppRouter.scanResult,
              extra: {'imagePath': state.imagePath!, 'result': state.result!},
            );
          } else if (state.status == ScanningStatus.failure) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: Theme.of(context).colorScheme.error,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          state.errorMessage ?? 'Scan failed',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: const Color(0xFFE57373),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                ),
              );
          }
          _controller?.setFlashMode(state.flashMode);
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: BlocConsumer<ScanningBloc, ScanningState>(
            listenWhen: (prev, curr) => prev.flashMode != curr.flashMode,
            listener: (context, state) {
              if (_isInit) {
                _onFlashModeChanged(state.flashMode);
              }
            },
            builder: (context, state) {
              if (state.status == ScanningStatus.loading) {
                return const LoadingView();
              } else if (state.status == ScanningStatus.success) {
                return const SizedBox.shrink();
              }
              final flashMode = state.flashMode;
              return Stack(
                children: [
                  if (_isInit && _controller != null)
                    Positioned.fill(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width:
                              _controller!.value.previewSize?.height ??
                              MediaQuery.sizeOf(context).width,
                          height:
                              _controller!.value.previewSize?.width ??
                              MediaQuery.sizeOf(context).height,
                          child: CameraPreview(_controller!),
                        ),
                      ),
                    )
                  else
                    Container(
                      color: const Color(0xFF121212),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF8B8FE3),
                          strokeWidth: 2,
                        ),
                      ),
                    ),

                  _buildCameraOverlay(context, size),

                  if (_isInit)
                    AnimatedBuilder(
                      animation: _beamFade,
                      builder: (context, child) {
                        final beamY = (size.height - frameH) / 2 + (frameH / 2);
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
                                    const Color(
                                      0xFF8B8FE3,
                                    ).withValues(alpha: 0.08),
                                    const Color(
                                      0xFF95E1D3,
                                    ).withValues(alpha: 0.45),
                                    const Color(
                                      0xFF8B8FE3,
                                    ).withValues(alpha: 0.08),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                  if (_isInit)
                    AnimatedBuilder(
                      animation: _scanLinePos,
                      builder: (context, child) {
                        final topOffset = (size.height - frameH) / 2;
                        final lineY =
                            topOffset +
                            (_scanLinePos.value * frameH).clamp(0, frameH);
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
                                  color: const Color(
                                    0xFF8B8FE3,
                                  ).withValues(alpha: 0.8),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                  ScannerTopBar(flashMode: flashMode),

                  ScannerControls(
                    onGalleryTap: () => _pickImage(context),
                    onCaptureTap: () => _takePicture(context),
                    pulseScale: _pulseScale,
                    pulseOpacity: _pulseOpacity,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCameraOverlay(BuildContext context, Size size) {
    final frameW = size.width * 0.82;
    final frameH = frameW * 1.35;

    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black.withValues(alpha: 0.45),
        BlendMode.srcOut,
      ),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              backgroundBlendMode: BlendMode.dstOut,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: frameW,
              height: frameH,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _takePicture(BuildContext context) async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }
    try {
      final image = await _controller!.takePicture();
      if (!context.mounted) {
        return;
      }
      context.read<ScanningBloc>().add(
        ScanImage(image.path, widget.featureOption),
      );
    } catch (e) {
      debugPrint('Capture error: $e');
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    try {
      if (_controller != null && _controller!.value.isInitialized) {
        await _controller!.pausePreview();
      }

      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null && context.mounted) {
        context.read<ScanningBloc>().add(
          ScanImage(image.path, widget.featureOption),
        );
      } else {
        if (_controller != null && _controller!.value.isInitialized) {
          await _controller!.resumePreview();
        }
      }
    } catch (e) {
      debugPrint('Gallery error: $e');
      if (_controller != null && _controller!.value.isInitialized) {
        await _controller!.resumePreview();
      }
    }
  }
}
