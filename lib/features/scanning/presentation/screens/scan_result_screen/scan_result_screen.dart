import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:powerocr/core/router/app_router.dart';
import 'package:powerocr/features/home_screen/presentation/bloc/home_bloc.dart';
import 'package:powerocr/features/home_screen/presentation/bloc/home_event.dart';
import 'package:powerocr/features/scanning/domain/entities/text_recognition_result.dart';
import 'package:powerocr/features/scanning/presentation/screens/scan_result_screen/widgets/outline_action_button.dart';
import 'package:powerocr/features/scanning/presentation/screens/scan_result_screen/widgets/primary_action_button.dart';
import 'package:powerocr/features/scanning/presentation/screens/scan_result_screen/widgets/result_sliver_app_bar.dart';
import 'package:powerocr/features/scanning/presentation/screens/scan_result_screen/widgets/result_header_section.dart';
import 'package:powerocr/features/scanning/presentation/screens/scan_result_screen/widgets/result_text_section.dart';
import 'package:powerocr/features/scanning/presentation/screens/scan_result_screen/utils/text_alignment_utils.dart';

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
  late Animation<double> _contentFade;

  bool _isCopied = false;
  bool _showAlignedFormat = false;
  String? _cachedAlignedString;

  String get _alignedText {
    _cachedAlignedString ??= TextAlignmentUtils.alignText(widget.result);
    return _cachedAlignedString!;
  }

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _imageFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _contentFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.35, 0.85, curve: Curves.easeOut),
      ),
    );

    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  String get _extractedText =>
      _showAlignedFormat ? _alignedText : widget.result.text;

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
                Text(
                  'Copied to clipboard',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF2D2D3F),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    final expandedImageHeight = size.height * 0.46;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.read<HomeBloc>().add(LoadHomeData());
        }
      },
      child: Scaffold(
        backgroundColor: isDark
            ? const Color(0xFF1A1A26)
            : const Color(0xFFF2F3F8),
        body: Stack(
          children: [
            FadeTransition(
              opacity: _imageFade,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  ResultSliverAppBar(
                    imagePath: widget.imagePath,
                    expandedHeight: expandedImageHeight,
                    isDark: isDark,
                  ),
                  ResultHeaderSection(
                    wordCount: _wordCount,
                    charCount: _charCount,
                    isDark: isDark,
                    showAlignedFormat: _showAlignedFormat,
                    onToggleFormat: (val) =>
                        setState(() => _showAlignedFormat = val),
                    contentFade: _contentFade,
                  ),
                  ResultTextSection(
                    extractedText: _extractedText,
                    showAlignedFormat: _showAlignedFormat,
                    isDark: isDark,
                    bottomPadding: bottomPad,
                    contentFade: _contentFade,
                  ),
                ],
              ),
            ),

            _buildBottomBar(context, theme, isDark, bottomPad),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    double bottomPad,
  ) {
    return AnimatedBuilder(
      animation: _contentFade,
      builder: (context, child) => Opacity(
        opacity: _contentFade.value,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1A1A26).withValues(alpha: 0.85)
                      : const Color(0xFFF2F3F8).withValues(alpha: 0.9),
                  border: Border(
                    top: BorderSide(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.black.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPad + 12),
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
      ),
    );
  }
}
