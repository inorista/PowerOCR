import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:powerocr/core/router/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _pulseController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Entry animations
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    // Continuous pulse for the glowing background orb
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _textSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeIn),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.8, end: 1.3).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOutSine,
      ),
    );

    _entryController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) context.go(AppRouter.home);
      });
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Modern slate ultra-light
      body: Stack(
        children: [
          // Animated Glowing Orb in the background
          Positioned.fill(
            child: Center(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _glowAnimation.value,
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Heavy glass blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: const SizedBox(),
            ),
          ),

          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                AnimatedBuilder(
                  animation: _entryController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoOpacityAnimation.value,
                      child: Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF0EA5E9), // Sky blue
                          Color(0xFF2563EB), // Royal blue
                        ],
                      ),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.5),
                          blurRadius: 2,
                          offset: const Offset(0, -2),
                          spreadRadius: -1,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons
                            .document_scanner_rounded, // Use rounded for elegance
                        size: 52,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Typography
                AnimatedBuilder(
                  animation: _entryController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _textOpacityAnimation.value,
                      child: SlideTransition(
                        position: _textSlideAnimation,
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      const Text(
                        'PowerOCR',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                          color: Color(0xFF0F172A), // Slate 900
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9), // Slate 100
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0), // Slate 200
                          ),
                        ),
                        child: const Text(
                          'AI VISION ENGINE',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2.5,
                            color: Color(0xFF3B82F6), // Blue 500
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
