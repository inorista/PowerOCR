import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:powerocr/core/constants/enum.dart';
import 'package:powerocr/core/di/locator.dart';
import 'package:powerocr/core/helpers/admob_helper.dart' show AdMobHelper;
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
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  // ADMOB
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  CameraController? _controller;

  late AnimationController _scanLineCtrl;
  late Animation<double> _scanLinePos;

  late ScanningBloc _bloc;
  final ImagePicker _picker = ImagePicker();
  bool _isInit = false;

  final BarcodeScanner _barcodeScanner = BarcodeScanner(
    formats: [BarcodeFormat.all],
  );
  bool _isQrScanning = false;
  bool _qrDetected = false;

  _FrameConfig get _frameConfig {
    final size = _cachedSize;
    switch (widget.featureOption) {
      case FeatureOption.scanQR:
        final side = size.width * 0.72;
        return _FrameConfig(width: side, height: side, cornerRadius: 20);
      case FeatureOption.scanId:
        final w = size.width * 0.88;
        return _FrameConfig(width: w, height: w / 1.586, cornerRadius: 16);
      case FeatureOption.scanDocument:
      case FeatureOption.batchScan:
        final w = size.width * 0.85;
        return _FrameConfig(width: w, height: w * 1.35, cornerRadius: 24);
    }
  }

  Size _cachedSize = Size.zero;

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
      begin: 0.05,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _scanLineCtrl, curve: Curves.easeInOut));

    _initCamera();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    if (kReleaseMode) {
      InterstitialAd.load(
        adUnitId: AdMobHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            setState(() {
              _interstitialAd = ad;
              ad.fullScreenContentCallback = FullScreenContentCallback(
                onAdDismissedFullScreenContent: (ad) {
                  ad.dispose();
                  _loadInterstitialAd();
                },
                onAdFailedToShowFullScreenContent: (ad, error) {
                  ad.dispose();
                  _loadInterstitialAd();
                },
              );
              _isAdLoaded = true;
            });
          },

          onAdFailedToLoad: (error) {
            print('Interstitial ad failed to load: $error');
          },
        ),
      );
    }
  }

  Future<void> _initCamera() async {
    // Tear down any existing controller before creating a new one
    _disposeCamera();

    final cameras = await availableCameras();
    if (cameras.isEmpty || !mounted) return;

    final cc = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    _controller = cc;

    try {
      await cc.initialize();
      if (!mounted || _controller != cc) {
        // Widget was disposed or a newer init replaced us — clean up silently
        try {
          cc.dispose();
        } catch (_) {}
        return;
      }
      setState(() => _isInit = true);
      _bloc.add(CameraReady());
      if (widget.featureOption == FeatureOption.scanQR) {
        _startQrImageStream();
      }
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  void _startQrImageStream() {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_isQrScanning) return;
    _isQrScanning = true;
    _controller!.startImageStream(_onCameraImage);
  }

  Future<void> _stopQrImageStream() async {
    if (!_isQrScanning) return;
    _isQrScanning = false;
    try {
      await _controller?.stopImageStream();
    } catch (_) {}
    await _barcodeScanner.close();
  }

  Future<void> _onCameraImage(CameraImage image) async {
    if (_qrDetected || !_isQrScanning) return;

    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(
      image.width.toDouble(),
      image.height.toDouble(),
    );

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw) ??
        InputImageFormat.nv21;

    final inputImageData = InputImageMetadata(
      size: imageSize,
      rotation: _rotationFromDeviceOrientation(),
      format: inputImageFormat,
      bytesPerRow: image.planes.first.bytesPerRow,
    );

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      metadata: inputImageData,
    );

    try {
      final barcodes = await _barcodeScanner.processImage(inputImage);
      if (barcodes.isNotEmpty && !_qrDetected && mounted) {
        _qrDetected = true;

        final detectedText = barcodes
            .map((b) => b.displayValue ?? b.rawValue ?? '')
            .where((s) => s.isNotEmpty)
            .join('\n');

        await _stopQrImageStream();

        if (!mounted) return;
        final imagePath = await _takePictureAndGetPath();

        if (!mounted) return;
        _bloc.add(
          QrStreamDetected(
            detectedText: detectedText,
            imagePath: imagePath,
            width: imageSize.width.toInt(),
            height: imageSize.height.toInt(),
          ),
        );
      }
    } catch (e) {
      debugPrint('QR stream scan error: $e');
    }
  }

  InputImageRotation _rotationFromDeviceOrientation() {
    return switch (_controller?.value.deviceOrientation) {
      DeviceOrientation.portraitUp => InputImageRotation.rotation0deg,
      DeviceOrientation.landscapeLeft => InputImageRotation.rotation90deg,
      DeviceOrientation.portraitDown => InputImageRotation.rotation180deg,
      DeviceOrientation.landscapeRight => InputImageRotation.rotation270deg,
      _ => InputImageRotation.rotation0deg,
    };
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scanLineCtrl.dispose();
    _interstitialAd?.dispose();
    _barcodeScanner.close();
    _disposeCamera();
    super.dispose();
  }

  /// Safely stops image stream (if active) then disposes the controller.
  /// Always nulls out [_controller] so double-dispose is impossible.
  void _disposeCamera() {
    final cc = _controller;
    _controller = null; // null first — prevents any race from using it again
    _isQrScanning = false;
    if (cc == null) return;
    try {
      if (cc.value.isStreamingImages) cc.stopImageStream();
    } catch (_) {}
    try {
      if (cc.value.isInitialized) cc.dispose();
    } catch (_) {}
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      // Fully tear down the camera; _controller is nulled inside _disposeCamera
      _disposeCamera();
      if (mounted) setState(() => _isInit = false);
    } else if (state == AppLifecycleState.resumed) {
      _qrDetected = false;
      _initCamera(); // _initCamera disposes any stale controller before re-init
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
    _cachedSize = MediaQuery.sizeOf(context);
    final size = _cachedSize;

    return BlocProvider<ScanningBloc>.value(
      value: _bloc,
      child: BlocListener<ScanningBloc, ScanningState>(
        listener: (context, state) {
          if (state.status == ScanningStatus.success &&
              state.result != null &&
              state.imagePath != null) {
            if (kReleaseMode) _interstitialAd?.show();
            context.replace(
              AppRouter.scanResult,
              extra: {'imagePath': state.imagePath!, 'result': state.result!},
            );
          } else if (state.status == ScanningStatus.batchFinished) {
            if (kReleaseMode) _interstitialAd?.show();
            context.replace(
              AppRouter.batchResult,
              extra: List<String>.from(state.batchImagePaths),
            );
          } else if (state.status == ScanningStatus.failure) {
            if (widget.featureOption == FeatureOption.scanQR) {
              _qrDetected = false;
              _startQrImageStream();
            }
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  margin: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: MediaQuery.paddingOf(context).bottom + 92,
                  ),
                  behavior: SnackBarBehavior.floating,
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
                          state.errorMessage ?? 'Quét thất bại',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: const Color(0xFFE57373),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
          }
          // Only update flash if the camera is still alive and initialized
          if (mounted &&
              _controller != null &&
              _controller!.value.isInitialized) {
            _onFlashModeChanged(state.flashMode);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: BlocConsumer<ScanningBloc, ScanningState>(
            listenWhen: (prev, curr) => prev.flashMode != curr.flashMode,
            listener: (context, state) {
              if (_isInit) _onFlashModeChanged(state.flashMode);
            },
            builder: (context, state) {
              if (state.status == ScanningStatus.loading) {
                return const LoadingView();
              } else if (state.status == ScanningStatus.success) {
                return const SizedBox.shrink();
              }

              return Stack(
                children: [
                  if (_isInit && _controller != null)
                    Positioned.fill(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width:
                              _controller!.value.previewSize?.height ??
                              size.width,
                          height:
                              _controller!.value.previewSize?.width ??
                              size.height,
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

                  _buildDimOverlay(size),

                  if (_isInit && _hasScanLine)
                    AnimatedBuilder(
                      animation: _scanLinePos,
                      builder: (context, _) => _buildScanLine(size),
                    ),

                  ScannerTopBar(
                    flashMode: state.flashMode,
                    featureOption: widget.featureOption,
                  ),

                  ScannerControls(
                    onGalleryTap: () => _pickImage(context),
                    onCaptureTap: () => _takePicture(context),
                    featureOption: widget.featureOption,
                    isAutoScan: widget.featureOption == FeatureOption.scanQR,
                    isRequireModel:
                        widget.featureOption == FeatureOption.scanDocument,
                  ),

                  if (widget.featureOption == FeatureOption.batchScan &&
                      state.batchImagePaths.isNotEmpty)
                    Positioned(
                      bottom: size.height * 0.18,
                      right: 24,
                      child: FloatingActionButton.extended(
                        heroTag: 'batch_finish_btn',
                        onPressed: () {
                          _bloc.add(FinishBatchScan());
                        },
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                        icon: const Icon(Icons.check_circle_outline_rounded),
                        label: Text(
                          'Xong (${state.batchImagePaths.length})',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  bool get _hasScanLine {
    return widget.featureOption == FeatureOption.scanDocument ||
        widget.featureOption == FeatureOption.batchScan ||
        widget.featureOption == FeatureOption.scanId;
  }

  // Punched-out viewport via srcOut blend
  Widget _buildDimOverlay(Size size) {
    final cfg = _frameConfig;
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black.withValues(alpha: 0.55),
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
            alignment: widget.featureOption == FeatureOption.scanId
                ? const Alignment(0, -0.1) // slightly above centre for card
                : Alignment.center,
            child: Container(
              width: cfg.width,
              height: cfg.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(cfg.cornerRadius),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanLine(Size size) {
    final cfg = _frameConfig;

    final frameTop = widget.featureOption == FeatureOption.scanId
        ? (size.height - cfg.height) / 2 - size.height * 0.05
        : (size.height - cfg.height) / 2;

    final lineY =
        frameTop + (_scanLinePos.value * cfg.height).clamp(0.0, cfg.height);
    final lineLeft = (size.width - cfg.width) / 2 + 4;

    // Colour varies by mode
    final Color lineColor = switch (widget.featureOption) {
      FeatureOption.scanId => const Color(0xFFFFD166),
      FeatureOption.scanQR => const Color(0xFF06D6A0),
      _ => const Color(0xFF8B8FE3),
    };

    return Positioned(
      top: lineY,
      left: lineLeft,
      width: cfg.width - 8,
      height: 1.5,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              lineColor,
              lineColor.withValues(alpha: 0.6),
              lineColor,
              Colors.transparent,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: lineColor.withValues(alpha: 0.7),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }

  /// Takes a still photo and returns its file path.
  /// Stops the QR stream first if it's still running.
  Future<String> _takePictureAndGetPath() async {
    if (_controller == null || !_controller!.value.isInitialized) return '';
    if (_isQrScanning) {
      _isQrScanning = false;
      try {
        await _controller!.stopImageStream();
      } catch (_) {}
    }
    try {
      final image = await _controller!.takePicture();
      return image.path;
    } catch (e) {
      debugPrint('Capture error: $e');
      return '';
    }
  }

  Future<void> _takePicture(BuildContext context) async {
    final path = await _takePictureAndGetPath();
    if (path.isEmpty || !mounted) return;
    _bloc.add(ScanImage(path, widget.featureOption));
  }

  Future<void> _pickImage(BuildContext context) async {
    try {
      if (_isQrScanning) {
        await _stopQrImageStream();
      } else if (_controller != null && _controller!.value.isInitialized) {
        await _controller!.pausePreview();
      }
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null && context.mounted) {
        _bloc.add(ScanImage(image.path, widget.featureOption));
      } else {
        // User cancelled — resume the live stream.
        if (widget.featureOption == FeatureOption.scanQR) {
          _qrDetected = false;
          _startQrImageStream();
        } else if (_controller != null && _controller!.value.isInitialized) {
          await _controller!.resumePreview();
        }
      }
    } catch (e) {
      debugPrint('Gallery error: $e');
      if (widget.featureOption == FeatureOption.scanQR) {
        _qrDetected = false;
        _startQrImageStream();
      } else if (_controller != null && _controller!.value.isInitialized) {
        await _controller!.resumePreview();
      }
    }
  }
}

class _FrameConfig {
  final double width;
  final double height;
  final double cornerRadius;
  const _FrameConfig({
    required this.width,
    required this.height,
    required this.cornerRadius,
  });
}
