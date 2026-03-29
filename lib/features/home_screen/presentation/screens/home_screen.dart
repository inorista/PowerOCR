import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:powerocr/core/constants/enum.dart';

import 'package:powerocr/core/router/app_router.dart';
import 'package:powerocr/core/domain/entities/scan_history.dart';
import 'package:powerocr/features/home_screen/presentation/bloc/home_bloc.dart';

import 'package:powerocr/features/home_screen/presentation/bloc/home_state.dart';
import 'package:powerocr/features/home_screen/presentation/screens/widgets/ambient_orbs.dart';
import 'package:powerocr/features/home_screen/presentation/screens/widgets/empty_state_view.dart';
import 'package:powerocr/features/home_screen/presentation/screens/widgets/history_item.dart';
import 'package:powerocr/features/home_screen/presentation/screens/widgets/home_header.dart';
import 'package:powerocr/features/home_screen/presentation/screens/widgets/home_hero_card.dart';
import 'package:powerocr/features/home_screen/presentation/screens/widgets/home_stats_row.dart';
import 'package:powerocr/features/home_screen/presentation/screens/widgets/quick_actions_grid.dart';
import 'dart:math' as math;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final size = MediaQuery.sizeOf(context);

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
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
                      child: Text(
                        'Quick Actions',
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
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _actionsFade,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Scans',
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
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'See all',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                        ],
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
                          child: EmptyStateView(theme: theme, isDark: isDark),
                        ),
                      );
                    }
                    return SliverList.builder(
                      itemCount: history.length > 5 ? 5 : history.length,
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
                              onTap: () {},
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
        ],
      ),
    );
  }
}
