import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:powerocr/core/di/locator.dart';
import 'package:powerocr/core/domain/entities/scan_history.dart';
import 'package:powerocr/core/router/app_router.dart' show AppRouter;
import 'package:powerocr/core/services/interfaces/iscan_history_service.dart';
import 'package:powerocr/features/scan_history_screen/presentation/bloc/scan_history_screen_bloc.dart';
import 'package:powerocr/features/scan_history_screen/presentation/scan_history_screen/widgets/scan_history_grid_card.dart';
import 'dart:math' as math;

import 'package:powerocr/features/scanning/domain/entities/text_recognition_result.dart'
    show TextRecognitionResult;
import 'package:powerocr/l10n/app_localizations.dart';

class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen>
    with TickerProviderStateMixin {
  late final AnimationController _orbCtrl;
  late final AnimationController _entryCtrl;
  late final Animation<double> _orbRotate;
  late final Animation<double> _gridFade;

  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.1;

  @override
  void initState() {
    super.initState();

    _orbCtrl = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat();
    _orbRotate = Tween(begin: 0.0, end: 2 * math.pi).animate(_orbCtrl);

    _entryCtrl = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..forward();

    _gridFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    double offset = _scrollController.offset;
    double newOpacity = 0.1 + (offset / 100);
    newOpacity = newOpacity.clamp(0.1, 1.0);
    if (newOpacity != _appBarOpacity) {
      setState(() {
        _appBarOpacity = newOpacity;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _orbCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final size = MediaQuery.sizeOf(context);
    final topPadding = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocProvider<ScanHistoryScreenBloc>(
        create: (context) => ScanHistoryScreenBloc()..add(LoadScanHistory()),
        child: Stack(
          children: [
            RepaintBoundary(
              child: AnimatedBuilder(
                animation: _orbRotate,
                builder: (context, child) => CustomPaint(
                  size: size,
                  painter: _ScanHistoryOrbPainter(
                    rotate: _orbRotate.value,
                    isDark: isDark,
                    primary: primary,
                  ),
                ),
              ),
            ),

            BlocBuilder<ScanHistoryScreenBloc, ScanHistoryScreenBlocState>(
              builder: (context, state) {
                if (state.status == ScanHistoryScreenBlocStatus.initial) {
                  return const SizedBox();
                }
                return CustomScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(height: topPadding + 64),
                    ),

                    if (state.status == ScanHistoryScreenBlocStatus.loading)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: _LoadingIndicator()),
                      )
                    else if (state.status == ScanHistoryScreenBlocStatus.error)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _ErrorView(
                          message:
                              state.errorMessage ??
                              AppLocalizations.of(context)!.scanHistoryErrorMsg,
                          theme: theme,
                          isDark: isDark,
                          l10n: AppLocalizations.of(context)!,
                          onRetry: () => context
                              .read<ScanHistoryScreenBloc>()
                              .add(LoadScanHistory()),
                        ),
                      )
                    else if (state.scanHistory.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _EmptyView(
                          theme: theme,
                          isDark: isDark,
                          l10n: AppLocalizations.of(context)!,
                        ),
                      )
                    else ...[
                      SliverFadeTransition(
                        opacity: _gridFade,
                        sliver: SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                          sliver: SliverGrid.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.78,
                                ),
                            itemCount: state.scanHistory.length,
                            itemBuilder: (context, index) {
                              final item = state.scanHistory[index];
                              return ScanHistoryGridCard(
                                item: item,
                                theme: theme,
                                isDark: isDark,
                                onTap: () => onTapHistoryItem(item),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: _appBarOpacity,
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            color: theme.scaffoldBackgroundColor.withValues(
                              alpha: 0.65,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SafeArea(
                    bottom: false,
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child:
                          BlocBuilder<
                            ScanHistoryScreenBloc,
                            ScanHistoryScreenBlocState
                          >(
                            builder: (context, state) {
                              return Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: theme.colorScheme.onSurface,
                                      size: 20,
                                    ),
                                    onPressed: () => context.pop(),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.scanHistoryTitle,
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 20,
                                            letterSpacing: -0.3,
                                          ),
                                    ),
                                  ),
                                  if (state.status ==
                                          ScanHistoryScreenBlocStatus.loaded &&
                                      state.scanHistory.isNotEmpty) ...[
                                    Text(
                                      '${state.scanHistory.length}',
                                      style: theme.textTheme.labelMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: theme.colorScheme.primary,
                                          ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.tune_rounded,
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.6),
                                        size: 22,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ],
                                  const SizedBox(width: 4),
                                ],
                              );
                            },
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onTapHistoryItem(ScanHistory item) async {
    final scanHistory = await locator<IScanHistoryService>().getScanHistoryById(
      item.id,
    );
    if (scanHistory != null) {
      final scanHistoryTextBlocks = await locator<IScanHistoryService>()
          .getScanTextBlockHistoryByScanId(scanHistory.id);
      final textRecognitionResult = TextRecognitionResult.fromScanHistory(
        scanHistory,
        scanHistoryTextBlocks,
      );
      if (mounted) {
        context.push(
          AppRouter.scanResult,
          extra: {
            'imagePath': textRecognitionResult.imagePath,
            'result': textRecognitionResult,
          },
        );
      }
    }
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 36,
          height: 36,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.scanHistoryLoading,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }
}

class _EmptyView extends StatelessWidget {
  final ThemeData theme;
  final bool isDark;
  final AppLocalizations l10n;

  const _EmptyView({
    required this.theme,
    required this.isDark,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.document_scanner_outlined,
                size: 36,
                color: theme.colorScheme.primary.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.scanHistoryEmptyTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.scanHistoryEmptySubtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.42),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final ThemeData theme;
  final bool isDark;
  final AppLocalizations l10n;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.theme,
    required this.isDark,
    required this.l10n,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: theme.colorScheme.error.withValues(alpha: 0.65),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.scanHistoryErrorTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(l10n.scanHistoryRetryBtn),
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanHistoryOrbPainter extends CustomPainter {
  final double rotate;
  final bool isDark;
  final Color primary;

  _ScanHistoryOrbPainter({
    required this.rotate,
    required this.isDark,
    required this.primary,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Top-right orb
    final ox = size.width * 0.88 + math.cos(rotate) * 10;
    final oy = size.height * 0.05 + math.sin(rotate) * 8;
    _drawOrb(
      canvas,
      Offset(ox, oy),
      120,
      primary.withValues(alpha: isDark ? 0.14 : 0.08),
    );
    // Bottom-left orb
    final ox2 = size.width * 0.08 + math.sin(rotate) * 10;
    final oy2 = size.height * 0.7 + math.cos(rotate) * 12;
    _drawOrb(
      canvas,
      Offset(ox2, oy2),
      100,
      const Color(0xFF95E1D3).withValues(alpha: isDark ? 0.11 : 0.06),
    );
  }

  void _drawOrb(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color, Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_ScanHistoryOrbPainter old) =>
      old.rotate != rotate || old.isDark != isDark;
}
