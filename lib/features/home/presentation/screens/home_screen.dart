import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:powerocr/core/router/app_router.dart';
import '../bloc/example_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f6fc),
      appBar: AppBar(
        title: const Text('PowerOCR'),
      ),
      body: const Center(
        child: Text('Press the camera button to start scanning'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AppRouter.scanning);
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
