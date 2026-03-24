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
  late Animation<double> _contentFade;

  bool _isCopied = false;
  bool _showAlignedFormat = false;
  String? _cachedAlignedString;

  String get _alignedText {
    if (_cachedAlignedString != null) return _cachedAlignedString!;
    if (widget.result.blocks.isEmpty) {
      _cachedAlignedString = widget.result.text;
      return _cachedAlignedString!;
    }

    var sortedBlocks = List<TextBlock>.from(widget.result.blocks);
    sortedBlocks.sort((a, b) {
      double aCenterY = (a.boundingBox[1] + a.boundingBox[3]) / 2;
      double bCenterY = (b.boundingBox[1] + b.boundingBox[3]) / 2;
      return aCenterY.compareTo(bCenterY);
    });

    List<List<TextBlock>> lines = [];
    List<TextBlock> currentLine = [sortedBlocks.first];

    for (int i = 1; i < sortedBlocks.length; i++) {
      final curr = sortedBlocks[i];
      double currentLineAvgY =
          currentLine
              .map((b) => (b.boundingBox[1] + b.boundingBox[3]) / 2)
              .reduce((a, b) => a + b) /
          currentLine.length;
      double currCenterY = (curr.boundingBox[1] + curr.boundingBox[3]) / 2;
      double currHeight = (curr.boundingBox[3] - curr.boundingBox[1]).abs();

      if ((currCenterY - currentLineAvgY).abs() < currHeight * 0.6) {
        currentLine.add(curr);
      } else {
        lines.add(currentLine);
        currentLine = [curr];
      }
    }
    if (currentLine.isNotEmpty) {
      lines.add(currentLine);
    }

    double totalCharWidth = 0;
    int totalChars = 0;
    double minGlobalX = double.infinity;
    for (var block in sortedBlocks) {
      if (block.boundingBox[0] < minGlobalX) {
        minGlobalX = block.boundingBox[0];
      }
      double w = (block.boundingBox[2] - block.boundingBox[0]).abs();
      totalCharWidth += w;
      totalChars += block.text.length;
    }
    double avgCharWidth = totalChars > 0
        ? (totalCharWidth / totalChars) * 1.05
        : 9.0;
    if (avgCharWidth <= 0) avgCharWidth = 9.0;

    StringBuffer sb = StringBuffer();

    for (var line in lines) {
      line.sort((a, b) => a.boundingBox[0].compareTo(b.boundingBox[0]));

      int currentColumn = 0;
      for (int i = 0; i < line.length; i++) {
        var block = line[i];
        double startX = block.boundingBox[0];

        int targetColumn = ((startX - minGlobalX) / avgCharWidth).round();
        int spacesToAdd = targetColumn - currentColumn;

        if (spacesToAdd > 0) {
          sb.write(' ' * spacesToAdd);
          currentColumn += spacesToAdd;
        } else if (i > 0) {
          sb.write(' ');
          currentColumn += 1;
        }
        sb.write(block.text);
        currentColumn += block.text.length;
      }
      sb.writeln();
    }

    _cachedAlignedString = sb.toString();
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
    // Expanded image height for SliverAppBar
    final expandedImageHeight = size.height * 0.46;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1A1A26)
          : const Color(0xFFF2F3F8),
      body: Stack(
        children: [
          // ──────── CustomScrollView ────────
          FadeTransition(
            opacity: _imageFade,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── SliverAppBar: image hero ──
                SliverAppBar(
                  pinned: true,
                  expandedHeight: expandedImageHeight,
                  backgroundColor: Colors.black,
                  leading: const SizedBox(),
                  flexibleSpace: LayoutBuilder(
                    builder: (ctx, constraints) {
                      final isCollapsed =
                          constraints.maxHeight <= kToolbarHeight + 4;
                      return FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(
                              File(widget.imagePath),
                              fit: BoxFit.cover,
                            ),
                            // Bottom fade into sheet color
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 100,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      isDark
                                          ? const Color(0xFF1A1A26)
                                          : const Color(0xFFF2F3F8),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Overlay buttons row
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
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
                            // Collapsed appbar backdrop (when scrolled up)
                            if (isCollapsed)
                              Positioned.fill(
                                child: ClipRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 20,
                                      sigmaY: 20,
                                    ),
                                    child: Container(
                                      color: Colors.black.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // ── SliverToBoxAdapter: header chip ──
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _contentFade,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1A1A26)
                            : const Color(0xFFF2F3F8),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(28),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Drag handle
                          Center(
                            child: Container(
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
                          ),
                          // Title row
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                              color:
                                                  theme.colorScheme.onSurface,
                                            ),
                                      ),
                                      const SizedBox(height: 3),
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
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.12,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
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

                          // Divider
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            child: Divider(
                              height: 1,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : Colors.black.withValues(alpha: 0.06),
                            ),
                          ),

                          // Segmented toggle Pure / Visual
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 0,
                            ),
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.black.withValues(alpha: 0.25)
                                    : Colors.black.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  _SegmentButton(
                                    label: 'Pure Text',
                                    selected: !_showAlignedFormat,
                                    theme: theme,
                                    onTap: () => setState(
                                      () => _showAlignedFormat = false,
                                    ),
                                  ),
                                  _SegmentButton(
                                    label: 'Visual Layout',
                                    selected: _showAlignedFormat,
                                    theme: theme,
                                    onTap: () => setState(
                                      () => _showAlignedFormat = true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── SliverFillRemaining (or SliverToBoxAdapter): text body ──
                _extractedText.trim().isEmpty
                    ? SliverFillRemaining(
                        hasScrollBody: false,
                        child: FadeTransition(
                          opacity: _contentFade,
                          child: _buildEmptyText(theme),
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: FadeTransition(
                          opacity: _contentFade,
                          child: Container(
                            color: isDark
                                ? const Color(0xFF1A1A26)
                                : const Color(0xFFF2F3F8),
                            padding: EdgeInsets.fromLTRB(
                              20,
                              0,
                              20,
                              bottomPad + 90,
                            ),
                            child: _showAlignedFormat
                                ? _buildAlignedTextView(theme)
                                : _buildPureTextView(theme),
                          ),
                        ),
                      ),
              ],
            ),
          ),

          // ──────── Bottom action bar (always on top) ────────
          AnimatedBuilder(
            animation: _contentFade,
            builder: (_, __) => Opacity(
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
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyText(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Icon(
          Icons.text_fields_rounded,
          size: 48,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
        ),
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
    );
  }

  Widget _buildPureTextView(ThemeData theme) {
    return SelectableText(
      _extractedText,
      style: TextStyle(
        fontSize: 15,
        height: 1.7,
        letterSpacing: 0.1,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.88),
      ),
    );
  }

  Widget _buildAlignedTextView(ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SelectableText(
        _extractedText,
        style: TextStyle(
          fontFamily: 'Courier',
          fontSize: 14,
          height: 1.65,
          letterSpacing: 0,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.88),
        ),
      ),
    );
  }
}

// ─────────────── Helper widget ───────────────
class _SegmentButton extends StatelessWidget {
  final String label;
  final bool selected;
  final ThemeData theme;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: selected ? theme.colorScheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: selected
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurface.withValues(alpha: 0.45),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
