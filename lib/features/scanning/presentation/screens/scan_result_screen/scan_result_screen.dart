import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:powerocr/core/router/app_router.dart';
import 'package:powerocr/features/scanning/domain/entities/text_recognition_result.dart';
import 'package:powerocr/features/scanning/presentation/screens/scan_result_screen/widgets/glass_button.dart';
import 'package:powerocr/features/scanning/presentation/screens/scan_result_screen/widgets/outline_action_button.dart';
import 'package:powerocr/features/scanning/presentation/screens/scan_result_screen/widgets/primary_action_button.dart';

class ScanResultScreen extends StatefulWidget {
  final String imagePath;
  final TextRecognitionResult result;

  const ScanResultScreen({
    super.key,
    required this.imagePath,
    required this.result,
  });

  @override
  State<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends State<ScanResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late Animation<double> _imageFade;
  late Animation<Offset> _sheetSlide;
  late Animation<double> _sheetFade;
  late Animation<double> _actionsFade;

  bool _isCopied = false;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    _imageFade = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut)));

    _sheetSlide = Tween(begin: const Offset(0, 0.08), end: Offset.zero).animate(
        CurvedAnimation(
            parent: _entryCtrl,
            curve: const Interval(0.3, 0.8, curve: Curves.easeOut)));

    _sheetFade = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut)));

    _actionsFade = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.55, 1.0, curve: Curves.easeOut)));

    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  String get _extractedText => widget.result.text;
  int get _wordCount => _extractedText.trim().isEmpty
      ? 0
      : _extractedText.trim().split(RegExp(r'\s+')).length;
  int get _charCount => _extractedText.length;

  Future<void> _copyText() async {
    await Clipboard.setData(ClipboardData(text: _extractedText));
    setState(() => _isCopied = true);
    if (mounted) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                SizedBox(width: 10),
                Text('Copied to clipboard',
                    style: TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            backgroundColor: const Color(0xFF2D2D3F),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            duration: const Duration(seconds: 2),
          ),
        );
    }
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isCopied = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);
    final imageHeight = size.height * 0.42;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _imageFade,
              builder: (_, __) => Opacity(
                opacity: _imageFade.value,
                child: Image.file(
                  File(widget.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
              child: Container(color: Colors.black.withValues(alpha: 0.55)),
            ),
          ),
          Column(
            children: [
              AnimatedBuilder(
                animation: _imageFade,
                builder: (_, __) => Opacity(
                  opacity: _imageFade.value,
                  child: SizedBox(
                    height: imageHeight,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.file(
                            File(widget.imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 80,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  isDark
                                      ? const Color(0xFF23232F)
                                      : const Color(0xFFF5F6FA),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GlassButton(
                                    icon: Icons.arrow_back_ios_new_rounded,
                                    onTap: () => context.go(AppRouter.home),
                                  ),
                                  GlassButton(
                                    icon: Icons.share_rounded,
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: AnimatedBuilder(
                  animation: _entryCtrl,
                  builder: (_, __) => FadeTransition(
                    opacity: _sheetFade,
                    child: SlideTransition(
                      position: _sheetSlide,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF23232F)
                              : const Color(0xFFF5F6FA),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(28)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10, bottom: 4),
                              width: 36,
                              height: 4,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.15)
                                    : Colors.black.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Extracted Text',
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: -0.3,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '$_wordCount words · $_charCount characters',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.45),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.auto_awesome_rounded,
                                          size: 13,
                                          color: theme.colorScheme.primary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'AI scanned',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              child: Divider(
                                height: 1,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : Colors.black.withValues(alpha: 0.06),
                              ),
                            ),
                            Expanded(
                              child: _extractedText.trim().isEmpty
                                  ? _buildEmptyText(theme)
                                  : Scrollbar(
                                      child: SingleChildScrollView(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 0, 20, 20),
                                        child: SelectableText(
                                          _extractedText,
                                          style: TextStyle(
                                            fontSize: 15,
                                            height: 1.65,
                                            letterSpacing: 0.1,
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.88),
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _actionsFade,
              builder: (_, __) => FadeTransition(
                opacity: _actionsFade,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF23232F)
                        : const Color(0xFFF5F6FA),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(
                      20, 12, 20, MediaQuery.paddingOf(context).bottom + 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlineActionButton(
                          icon: Icons.camera_alt_rounded,
                          label: 'Re-scan',
                          theme: theme,
                          isDark: isDark,
                          onTap: () => context.go(AppRouter.scanning),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: PrimaryActionButton(
                          icon: _isCopied
                              ? Icons.check_rounded
                              : Icons.copy_rounded,
                          label: _isCopied ? 'Copied!' : 'Copy Text',
                          onTap: _copyText,
                          isCopied: _isCopied,
                        ),
                      ),
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

  Widget _buildEmptyText(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.text_fields_rounded,
              size: 48,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
          const SizedBox(height: 12),
          Text(
            'No text detected',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try scanning a clearer image',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}
