import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:powerocr/core/router/app_router.dart';
import 'package:powerocr/features/splash/presentation/screens/widgets/corner_deco_painter.dart';
import 'package:powerocr/features/splash/presentation/screens/widgets/grid_painter.dart';
import 'package:powerocr/features/splash/presentation/screens/widgets/logo_mark_painter.dart';
import 'package:powerocr/features/splash/presentation/screens/widgets/particle_painter.dart';
import 'package:powerocr/features/splash/presentation/screens/widgets/scan_beam_painter.dart';
import 'package:powerocr/features/splash/presentation/screens/widgets/particle.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _scanController;
  late AnimationController _textController;
  late AnimationController _glowController;
  late AnimationController _exitController;

  late Animation<double> _bgOpacity;
  late Animation<double> _scanPosition;
  late Animation<double> _scanOpacity;
  late Animation<double> _titleReveal;
  late Animation<double> _subtitleReveal;
  late Animation<double> _taglineReveal;
  late Animation<double> _glowPulse;
  late Animation<double> _particleOpacity;
  late Animation<double> _exitScale;
  late Animation<double> _exitOpacity;

  final List<Particle> _particles = [];
  final int _particleCount = 60;

  @override
  void initState() {
    super.initState();
    _generateParticles();
    _setupAnimations();

    _bgController.forward().then((_) {
      _scanController.forward().then((_) {
        _textController.forward().then((_) {
          _glowController.repeat(reverse: true);
          Future.delayed(const Duration(milliseconds: 1200), () {
            _glowController.stop();
            _exitController.forward().then((_) {
              if (mounted) context.go(AppRouter.home);
            });
          });
        });
      });
    });
  }

  void _generateParticles() {
    final rng = math.Random(42);
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(Particle(
        x: rng.nextDouble(),
        y: rng.nextDouble(),
        size: rng.nextDouble() * 2.5 + 0.5,
        opacity: rng.nextDouble() * 0.5 + 0.1,
        speed: rng.nextDouble() * 0.3 + 0.1,
      ));
    }
  }

  void _setupAnimations() {
    _bgController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    _bgOpacity = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _bgController, curve: Curves.easeOut));
    _particleOpacity = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _bgController, curve: Curves.easeOut));

    _scanController = AnimationController(
        duration: const Duration(milliseconds: 900), vsync: this);
    _scanPosition = Tween(begin: -0.05, end: 1.05).animate(
        CurvedAnimation(parent: _scanController, curve: Curves.easeInOut));
    _scanOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 10),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 80),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 10),
    ]).animate(_scanController);

    _textController = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    _titleReveal = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOut)));
    _subtitleReveal = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.4, 0.75, curve: Curves.easeOut)));
    _taglineReveal = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeOut)));

    _glowController = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    _glowPulse = Tween(begin: 0.6, end: 1.0).animate(
        CurvedAnimation(parent: _glowController, curve: Curves.easeInOut));

    _exitController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _exitScale = Tween(begin: 1.0, end: 1.35).animate(
        CurvedAnimation(parent: _exitController, curve: Curves.easeInCubic));
    _exitOpacity = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _exitController, curve: Curves.easeInCubic));
  }

  @override
  void dispose() {
    _bgController.dispose();
    _scanController.dispose();
    _textController.dispose();
    _glowController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _bgController,
          _scanController,
          _textController,
          _glowController,
          _exitController,
        ]),
        builder: (context, _) {
          return FadeTransition(
            opacity: _exitOpacity,
            child: Transform.scale(
              scale: _exitScale.value,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Opacity(
                    opacity: _bgOpacity.value,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment(0, -0.2),
                          radius: 1.4,
                          colors: [
                            Color(0xFF0A0E1A),
                            Color(0xFF050810),
                            Color(0xFF000000),
                          ],
                          stops: [0.0, 0.55, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: _particleOpacity.value,
                    child: CustomPaint(
                      painter: ParticlePainter(
                        particles: _particles,
                        beamY: _scanPosition.value,
                        progress: _scanController.value,
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: _bgOpacity.value * 0.35,
                    child: CustomPaint(
                      painter: GridPainter(),
                    ),
                  ),
                  if (_scanController.value > 0)
                    Positioned(
                      top: _scanPosition.value * size.height -
                          ScanBeamPainter.kBeamHeight / 2,
                      left: 0,
                      right: 0,
                      height: ScanBeamPainter.kBeamHeight,
                      child: Opacity(
                        opacity: _scanOpacity.value,
                        child: CustomPaint(
                          painter: ScanBeamPainter(
                            progress: _scanController.value,
                          ),
                        ),
                      ),
                    ),
                  if (_scanController.value > 0.0 &&
                      _scanController.value < 1.0)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: _scanPosition.value * size.height,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF00D4FF).withValues(alpha: 0.0),
                              const Color(0xFF00D4FF)
                                  .withValues(alpha: 0.04 * _scanOpacity.value),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLogoMark(size),
                        const SizedBox(height: 32),
                        _buildTitle(),
                        const SizedBox(height: 12),
                        _buildSubtitle(),
                        const SizedBox(height: 28),
                        _buildTagline(),
                      ],
                    ),
                  ),
                  if (_bgOpacity.value > 0.5)
                    Opacity(
                      opacity: ((_bgOpacity.value - 0.5) * 2).clamp(0, 1),
                      child: CustomPaint(
                        painter: CornerDecoPainter(
                          glowIntensity: _glowController.isAnimating
                              ? _glowPulse.value
                              : 0.7,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogoMark(Size size) {
    if (_textController.value == 0) return const SizedBox.shrink();
    final t = _titleReveal.value;
    return Opacity(
      opacity: t,
      child: Transform.scale(
        scale: 0.7 + 0.3 * t,
        child: SizedBox(
          width: 80,
          height: 80,
          child: CustomPaint(
            painter: LogoMarkPainter(
              progress: t,
              glow: _glowController.isAnimating ? _glowPulse.value : 0.8,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    if (_titleReveal.value == 0) return const SizedBox.shrink();
    return ClipRect(
      child: Align(
        heightFactor: _titleReveal.value,
        child: ShaderMask(
          shaderCallback: (bounds) {
            final glowVal =
                _glowController.isAnimating ? _glowPulse.value : 0.75;
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF00D4FF),
                Color.lerp(
                    const Color(0xFF007AFF), const Color(0xFF00D4FF), glowVal)!,
                const Color(0xFFFFFFFF),
                const Color(0xFF00D4FF),
              ],
              stops: const [0.0, 0.3, 0.6, 1.0],
            ).createShader(bounds);
          },
          child: Text(
            'PowerOCR',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
              height: 1.0,
              foreground: Paint()..color = Colors.white,
              shadows: [
                Shadow(
                  color: const Color(0xFF00D4FF).withValues(
                      alpha: _glowController.isAnimating
                          ? _glowPulse.value * 0.8
                          : 0.5),
                  blurRadius: 24,
                ),
                Shadow(
                  color: const Color(0xFF00D4FF).withValues(
                      alpha: _glowController.isAnimating
                          ? _glowPulse.value * 0.5
                          : 0.3),
                  blurRadius: 48,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    if (_subtitleReveal.value == 0) return const SizedBox.shrink();
    return Opacity(
      opacity: _subtitleReveal.value,
      child: Transform.translate(
        offset: Offset(0, 8 * (1 - _subtitleReveal.value)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _cyanDot(),
            const SizedBox(width: 8),
            const Text(
              'AI-Powered Document Scanner',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF7ECFED),
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(width: 8),
            _cyanDot(),
          ],
        ),
      ),
    );
  }

  Widget _cyanDot() => Container(
        width: 4,
        height: 4,
        decoration: const BoxDecoration(
          color: Color(0xFF00D4FF),
          shape: BoxShape.circle,
        ),
      );

  Widget _buildTagline() {
    if (_taglineReveal.value == 0) return const SizedBox.shrink();
    return Opacity(
      opacity: _taglineReveal.value,
      child: Transform.translate(
        offset: Offset(0, 10 * (1 - _taglineReveal.value)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dividerLine(),
            const SizedBox(width: 14),
            Text(
              'SCAN · EXTRACT · CONQUER',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF00D4FF).withValues(alpha: 0.65),
                letterSpacing: 3.5,
              ),
            ),
            const SizedBox(width: 14),
            _dividerLine(),
          ],
        ),
      ),
    );
  }

  Widget _dividerLine() => Container(
        width: 28,
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            const Color(0xFF00D4FF).withValues(alpha: 0),
            const Color(0xFF00D4FF).withValues(alpha: 0.6),
          ]),
        ),
      );
}
