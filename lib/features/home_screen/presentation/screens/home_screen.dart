import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:powerocr/core/constants/enum.dart';
import 'package:powerocr/core/di/locator.dart';
import 'package:powerocr/core/utils/responsive.dart';

import 'package:powerocr/core/router/app_router.dart';
import 'package:powerocr/core/domain/entities/scan_history.dart';
import 'package:powerocr/core/services/interfaces/iscan_history_service.dart';
import 'package:powerocr/features/home_screen/presentation/bloc/home_bloc.dart';
import 'package:powerocr/l10n/app_localizations.dart';

import 'package:powerocr/features/home_screen/presentation/bloc/home_state.dart';
import 'package:powerocr/features/home_screen/presentation/screens/widgets/ambient_orbs.dart';
import 'package:powerocr/features/home_screen/presentation/screens/widgets/empty_state_view.dart';
import 'package:powerocr/features/home_screen/presentation/screens/widgets/history_item.dart';
import 'package:powerocr/features/home_screen/presentation/screens/widgets/home_header.dart';
import 'package:powerocr/features/home_screen/presentation/screens/widgets/home_hero_card.dart';
import 'package:powerocr/features/home_screen/presentation/screens/widgets/home_stats_row.dart';
import 'package:powerocr/features/home_screen/presentation/screens/widgets/quick_actions_grid.dart';
import 'dart:math' as math;

import 'package:powerocr/features/scanning/domain/entities/text_recognition_result.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late AnimationController _heroShimmerCtrl;
  late AnimationController _orbCtrl;
  late AnimationController _statCtrl;

  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _heroFade;
  late Animation<Offset> _heroSlide;
  late Animation<double> _statFade;
  late Animation<double> _actionsFade;
  late Animation<Offset> _actionsSlide;

  late Animation<double> _orbRotate;
  late Animation<double> _shimmerPos;

  @override
  void initState() {
    super.initState();

    _entryCtrl = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _headerFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    _headerSlide = Tween(begin: const Offset(0, -0.15), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entryCtrl,
            curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
          ),
        );

    _heroFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.15, 0.55, curve: Curves.easeOut),
      ),
    );
    _heroSlide = Tween(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.15, 0.55, curve: Curves.easeOut),
      ),
    );

    _statFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.40, 0.70, curve: Curves.easeOut),
      ),
    );

    _actionsFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.58, 0.90, curve: Curves.easeOut),
      ),
    );
    _actionsSlide = Tween(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entryCtrl,
            curve: const Interval(0.58, 0.90, curve: Curves.easeOut),
          ),
        );

    _orbCtrl = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat();
    _orbRotate = Tween(begin: 0.0, end: 2 * math.pi).animate(_orbCtrl);

    _heroShimmerCtrl = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    )..repeat(min: 0, max: 1);
    _shimmerPos = Tween(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _heroShimmerCtrl, curve: Curves.easeInOut),
    );

    _statCtrl = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _entryCtrl.forward().then((_) => _statCtrl.forward());
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _heroShimmerCtrl.dispose();
    _orbCtrl.dispose();
    _statCtrl.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final size = MediaQuery.sizeOf(context);
    final isTablet = AppBreakpoints.isTablet(context);
    final hPad = AppBreakpoints.horizontalPadding(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _orbRotate,
              builder: (context, child) => AmbientOrbs(
                rotate: _orbRotate.value,
                isDark: isDark,
                primary: primary,
                size: size,
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppBreakpoints.maxContentWidth,
                ),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    SliverToBoxAdapter(
                      child: FadeTransition(
                        opacity: _headerFade,
                        child: SlideTransition(
                          position: _headerSlide,
                          child: HomeHeader(isDark: isDark, theme: theme),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: FadeTransition(
                        opacity: _heroFade,
                        child: SlideTransition(
                          position: _heroSlide,
                          child: HomeHeroCard(
                            shimmerPos: _shimmerPos,
                            isDark: isDark,
                            onTap: () => context.push(
                              AppRouter.scanning,
                              extra: FeatureOption.scanDocument,
                            ),
                            theme: theme,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: FadeTransition(
                        opacity: _statFade,
                        child: HomeStatsRow(
                          theme: theme,
                          isDark: isDark,
                          statCtrl: _statCtrl,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: FadeTransition(
                        opacity: _actionsFade,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(hPad, 28, hPad, 12),
                          child: Text(
                            AppLocalizations.of(context)!.homeQuickActions,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: FadeTransition(
                        opacity: _actionsFade,
                        child: SlideTransition(
                          position: _actionsSlide,
                          child: QuickActionsGrid(theme: theme, isDark: isDark),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 14.0),
                      sliver: SliverToBoxAdapter(
                        child: FadeTransition(
                          opacity: _actionsFade,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: hPad),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.homeRecentHistory,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.push(AppRouter.scanHistory);
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: theme.colorScheme.primary,
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(44, 32),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.historySeeAll,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    BlocSelector<HomeBloc, HomeState, List<ScanHistory>>(
                      selector: (state) => state.history,
                      builder: (context, history) {
                        if (history.isEmpty) {
                          return SliverToBoxAdapter(
                            child: FadeTransition(
                              opacity: _actionsFade,
                              child: EmptyStateView(
                                theme: theme,
                                isDark: isDark,
                              ),
                            ),
                          );
                        }
                        final displayCount = history.length > 5
                            ? 5
                            : history.length;
                        // Tablet: 2-column grid; phone: single-column list
                        if (isTablet) {
                          return SliverPadding(
                            padding: EdgeInsets.symmetric(horizontal: hPad),
                            sliver: SliverGrid.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    mainAxisExtent: 90,
                                  ),
                              itemCount: displayCount,
                              itemBuilder: (context, index) {
                                final item = history[index];
                                return FadeTransition(
                                  opacity: _actionsFade,
                                  child: SlideTransition(
                                    position: _actionsSlide,
                                    child: HistoryItem(
                                      theme: theme,
                                      isDark: isDark,
                                      item: item,
                                      isCompact: true,
                                      onTap: () async {
                                        await onTapHistoryItem(item);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return SliverList.builder(
                          itemCount: displayCount,
                          itemBuilder: (context, index) {
                            final item = history[index];
                            return FadeTransition(
                              opacity: _actionsFade,
                              child: SlideTransition(
                                position: _actionsSlide,
                                child: HistoryItem(
                                  theme: theme,
                                  isDark: isDark,
                                  item: item,
                                  onTap: () async {
                                    await onTapHistoryItem(item);
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
