import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:powerocr/core/di/locator.dart';
import 'package:powerocr/features/scanning/presentation/bloc/scanning_bloc.dart';
import 'package:powerocr/features/scanning/presentation/bloc/scanning_event.dart';
import 'package:powerocr/features/scanning/presentation/bloc/scanning_state.dart';

class ScanningScreen extends StatefulWidget {
  const ScanningScreen({super.key});

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
        );
        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<ScanningBloc>(),
      child: BlocConsumer<ScanningBloc, ScanningState>(
        listener: (context, state) {
          if (state is ScanningFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ScanningSuccess) {
            return _buildResultView(context, state);
          } else if (state is ScanningLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            return _buildCameraView(context);
          }
        },
      ),
    );
  }

  Widget _buildCameraView(BuildContext context) {
    if (!_isCameraInitialized || _controller == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: CameraPreview(_controller!),
          ),
          // Scanner Overlay
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 1.2,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // Controls
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.photo_library, color: Colors.white, size: 30),
                  onPressed: () => _pickImage(context),
                ),
                GestureDetector(
                  onTap: () => _takePicture(context),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
                const SizedBox(width: 30), // Placeholder for balance
              ],
            ),
          ),
          // Back Button
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultView(BuildContext context, ScanningSuccess state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<ScanningBloc>().add(ResetScan());
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.file(File(state.imagePath)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SelectableText(state.result.text),
            ),
          ],
        ),
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
      debugPrint('Error capturing image: $e');
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        if (!context.mounted) return;
        context.read<ScanningBloc>().add(ScanImage(image.path));
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }
}
