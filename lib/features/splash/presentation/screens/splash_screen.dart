import 'dart:math' as math;
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

  final List<_Particle> _particles = [];
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
      _particles.add(_Particle(
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
                      painter: _ParticlePainter(
                        particles: _particles,
                        beamY: _scanPosition.value,
                        progress: _scanController.value,
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: _bgOpacity.value * 0.35,
                    child: CustomPaint(
                      painter: _GridPainter(),
                    ),
                  ),
                  if (_scanController.value > 0)
                    Positioned(
                      top: _scanPosition.value * size.height -
                          _ScanBeamPainter.kBeamHeight / 2,
                      left: 0,
                      right: 0,
                      height: _ScanBeamPainter.kBeamHeight,
                      child: Opacity(
                        opacity: _scanOpacity.value,
                        child: CustomPaint(
                          painter: _ScanBeamPainter(
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
                        painter: _CornerDecoPainter(
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
            painter: _LogoMarkPainter(
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

class _Particle {
  final double x, y, size, opacity, speed;
  _Particle(
      {required this.x,
      required this.y,
      required this.size,
      required this.opacity,
      required this.speed});
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double beamY;
  final double progress;

  _ParticlePainter(
      {required this.particles, required this.beamY, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final px = p.x * size.width;
      final py = p.y * size.height;

      final dy = ((py / size.height) - beamY).abs();
      final boost = (1.0 - (dy / 0.12).clamp(0.0, 1.0)) * 0.8 * progress;

      final paint = Paint()
        ..color = Color.fromARGB(
          ((p.opacity + boost) * 255).clamp(0, 255).toInt(),
          0,
          212,
          255,
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);

      canvas.drawCircle(Offset(px, py), p.size + boost, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) =>
      old.beamY != beamY || old.progress != progress;
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00D4FF).withValues(alpha: 0.07)
      ..strokeWidth = 0.5;

    const cols = 14;
    const rows = 24;
    for (int i = 0; i <= cols; i++) {
      final x = i * size.width / cols;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (int i = 0; i <= rows; i++) {
      final y = i * size.height / rows;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}

class _ScanBeamPainter extends CustomPainter {
  static const kBeamHeight = 80.0;
  final double progress;

  _ScanBeamPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final beamPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          const Color(0xFF00D4FF).withValues(alpha: 0.0),
          const Color(0xFF00D4FF).withValues(alpha: 0.12),
          const Color(0xFF00D4FF).withValues(alpha: 0.45),
          const Color(0xFF00AAFF).withValues(alpha: 0.65),
          const Color(0xFF00D4FF).withValues(alpha: 0.45),
          const Color(0xFF00D4FF).withValues(alpha: 0.12),
          const Color(0xFF00D4FF).withValues(alpha: 0.0),
          Colors.transparent,
        ],
        stops: const [0.0, 0.1, 0.3, 0.44, 0.5, 0.56, 0.7, 0.9, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), beamPaint);

    final linePaint = Paint()
      ..color = const Color(0xFFAAEEFF)
      ..strokeWidth = 1.2;
    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      linePaint,
    );

    final glowPaint = Paint()
      ..color = const Color(0xFF00D4FF).withValues(alpha: 0.6)
      ..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      glowPaint,
    );

    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    final rng = math.Random(7);
    for (int i = 0; i < 5; i++) {
      final x = size.width * rng.nextDouble();
      canvas.drawCircle(Offset(x, size.height * 0.5), 1.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_ScanBeamPainter old) => old.progress != progress;
}

class _CornerDecoPainter extends CustomPainter {
  final double glowIntensity;
  _CornerDecoPainter({required this.glowIntensity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB((180 * glowIntensity).toInt(), 0, 212, 255)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2 * glowIntensity);

    const margin = 24.0;
    const length = 32.0;

    canvas.drawPath(
        Path()
          ..moveTo(margin, margin + length)
          ..lineTo(margin, margin)
          ..lineTo(margin + length, margin),
        paint);

    canvas.drawPath(
        Path()
          ..moveTo(size.width - margin - length, margin)
          ..lineTo(size.width - margin, margin)
          ..lineTo(size.width - margin, margin + length),
        paint);

    canvas.drawPath(
        Path()
          ..moveTo(margin, size.height - margin - length)
          ..lineTo(margin, size.height - margin)
          ..lineTo(margin + length, size.height - margin),
        paint);

    canvas.drawPath(
        Path()
          ..moveTo(size.width - margin - length, size.height - margin)
          ..lineTo(size.width - margin, size.height - margin)
          ..lineTo(size.width - margin, size.height - margin - length),
        paint);

    final cy = size.height / 2 - 28;
    final cx = size.width / 2;
    final ringPaint = Paint()
      ..color = const Color(0xFF00D4FF).withValues(alpha: 0.15 * glowIntensity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(Offset(cx, cy), 60, ringPaint);
    canvas.drawCircle(
        Offset(cx, cy),
        80,
        ringPaint
          ..color =
              const Color(0xFF00D4FF).withValues(alpha: 0.08 * glowIntensity));
  }

  @override
  bool shouldRepaint(_CornerDecoPainter old) =>
      old.glowIntensity != glowIntensity;
}

class _LogoMarkPainter extends CustomPainter {
  final double progress;
  final double glow;
  _LogoMarkPainter({required this.progress, required this.glow});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.42;

    final ringPaint = Paint()
      ..color = const Color(0xFF00D4FF).withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4 * glow);
    canvas.drawCircle(Offset(cx, cy), r, ringPaint);

    final innerPaint = Paint()
      ..color = const Color(0xFF00AAFF).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(Offset(cx, cy), r * 0.65, innerPaint);

    final linePaint = Paint()
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    const lineCount = 6;
    for (int i = 0; i < lineCount; i++) {
      final t = i / (lineCount - 1);
      final lineY = cy - r * 0.7 + t * r * 1.4;

      final halfW = math.sqrt(math.max(0, r * r - math.pow(lineY - cy, 2)));
      if (halfW < 2) continue;

      final alpha = (0.3 + 0.4 * (1 - (t - 0.5).abs() * 2)) * progress;
      linePaint.color = Color.fromARGB((alpha * 255).toInt(), 0, 212, 255);
      canvas.drawLine(
          Offset(cx - halfW, lineY), Offset(cx + halfW, lineY), linePaint);
    }

    canvas.drawCircle(
        Offset(cx, cy),
        4,
        Paint()
          ..color = const Color(0xFF00D4FF)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3 * glow));
    canvas.drawCircle(Offset(cx, cy), 2, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_LogoMarkPainter old) =>
      old.progress != progress || old.glow != glow;
}
