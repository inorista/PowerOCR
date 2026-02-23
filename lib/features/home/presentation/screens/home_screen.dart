import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:powerocr/core/router/app_router.dart';
import 'package:powerocr/core/theme/cubit/theme_cubit.dart';
import 'package:powerocr/features/home/presentation/screens/widgets/ambient_orbs.dart';
import 'package:powerocr/features/home/presentation/screens/widgets/stat_card.dart';

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
        duration: const Duration(milliseconds: 900), vsync: this);

    _headerFade = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut)));
    _headerSlide = Tween(begin: const Offset(0, -0.15), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _entryCtrl,
            curve: const Interval(0.0, 0.45, curve: Curves.easeOut)));

    _heroFade = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.15, 0.55, curve: Curves.easeOut)));
    _heroSlide = Tween(begin: const Offset(0, 0.1), end: Offset.zero).animate(
        CurvedAnimation(
            parent: _entryCtrl,
            curve: const Interval(0.15, 0.55, curve: Curves.easeOut)));

    _statFade = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.40, 0.70, curve: Curves.easeOut)));

    _actionsFade = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.58, 0.90, curve: Curves.easeOut)));
    _actionsSlide = Tween(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _entryCtrl,
            curve: const Interval(0.58, 0.90, curve: Curves.easeOut)));

    _orbCtrl =
        AnimationController(duration: const Duration(seconds: 12), vsync: this)
          ..repeat();
    _orbRotate = Tween(begin: 0.0, end: 2 * math.pi).animate(_orbCtrl);

    _heroShimmerCtrl = AnimationController(
        duration: const Duration(milliseconds: 2200), vsync: this)
      ..repeat(min: 0, max: 1);
    _shimmerPos = Tween(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(parent: _heroShimmerCtrl, curve: Curves.easeInOut));

    _statCtrl = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this);

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
              builder: (_, __) => AmbientOrbs(
                rotate: _orbRotate.value,
                isDark: isDark,
                primary: primary,
                size: size,
              ),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _headerFade,
                    child: SlideTransition(
                      position: _headerSlide,
                      child: _buildHeader(context, theme, isDark),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _heroFade,
                    child: SlideTransition(
                      position: _heroSlide,
                      child: _buildHeroCard(context, theme, isDark),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _statFade,
                    child: _buildStats(theme, isDark),
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
                      child: _buildQuickActions(context, theme, isDark),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _actionsFade,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
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
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              foregroundColor: theme.colorScheme.primary,
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(44, 32),
                            ),
                            child: const Text(
                              'See all',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _actionsFade,
                    child: _buildEmptyState(theme, isDark),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good ${_greeting()},',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 3),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: isDark
                        ? [
                            const Color(0xFFCBCDEC),
                            const Color(0xFF95E1D3),
                          ]
                        : [
                            const Color(0xFF6B6FCC),
                            const Color(0xFF55C7B5),
                          ],
                  ).createShader(bounds),
                  child: Text(
                    'PowerOCR',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _HeaderIconButton(
            isDark: isDark,
            icon: isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            onTap: () {
              context.read<ThemeCubit>().setTheme(
                    isDark ? ThemeMode.light : ThemeMode.dark,
                  );
            },
            theme: theme,
          ),
          const SizedBox(width: 10),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child:
                const Icon(Icons.person_rounded, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context, ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: _AnimatedHeroCard(
        shimmerPos: _shimmerPos,
        isDark: isDark,
        onTap: () => context.push(AppRouter.scanning),
        theme: theme,
      ),
    );
  }

  Widget _buildStats(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: StatCard(
              label: 'Scanned',
              value: 0,
              icon: Icons.document_scanner_rounded,
              isDark: isDark,
              theme: theme,
              controller: _statCtrl,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(
              label: 'Extracted',
              value: 0,
              icon: Icons.text_snippet_rounded,
              isDark: isDark,
              theme: theme,
              controller: _statCtrl,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(
              label: 'Saved',
              value: 0,
              icon: Icons.bookmark_rounded,
              isDark: isDark,
              theme: theme,
              controller: _statCtrl,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(
      BuildContext context, ThemeData theme, bool isDark) {
    final actions = [
      _QuickAction(
        icon: Icons.camera_alt_rounded,
        label: 'Camera\nScan',
        gradient: [const Color(0xFF8B8FE3), const Color(0xFF6B6FCC)],
        onTap: () => context.push(AppRouter.scanning),
      ),
      _QuickAction(
        icon: Icons.photo_library_rounded,
        label: 'Gallery\nImport',
        gradient: [const Color(0xFF95E1D3), const Color(0xFF5ABCAE)],
        onTap: () => context.push(AppRouter.scanning),
      ),
      _QuickAction(
        icon: Icons.history_rounded,
        label: 'Scan\nHistory',
        gradient: [const Color(0xFFFFB7A3), const Color(0xFFE8896E)],
        onTap: () {},
      ),
      _QuickAction(
        icon: Icons.share_rounded,
        label: 'Share\nText',
        gradient: [const Color(0xFFA8E6CF), const Color(0xFF68C49A)],
        onTap: () {},
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        mainAxisSpacing: 0,
        crossAxisSpacing: 10,
        childAspectRatio: 0.82,
        children: actions
            .map((a) =>
                _QuickActionTile(action: a, isDark: isDark, theme: theme))
            .toList(),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isDark) {
    final cardColor = isDark
        ? const Color(0xFF2E2E3E).withValues(alpha: 0.7)
        : Colors.white.withValues(alpha: 0.8);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.document_scanner_outlined,
                size: 30,
                color: theme.colorScheme.primary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No scans yet',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Your scanned documents will appear here.\nTap Scan to get started!',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }
}

class _AnimatedHeroCard extends StatefulWidget {
  final Animation<double> shimmerPos;
  final bool isDark;
  final VoidCallback onTap;
  final ThemeData theme;

  const _AnimatedHeroCard({
    required this.shimmerPos,
    required this.isDark,
    required this.onTap,
    required this.theme,
  });

  @override
  State<_AnimatedHeroCard> createState() => _AnimatedHeroCardState();
}

class _AnimatedHeroCardState extends State<_AnimatedHeroCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late Animation<double> _pressScale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
        duration: const Duration(milliseconds: 120), vsync: this);
    _pressScale = Tween(begin: 1.0, end: 0.97)
        .animate(CurvedAnimation(parent: _pressCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.shimmerPos, _pressCtrl]),
      builder: (_, __) {
        return GestureDetector(
          onTapDown: (_) => _pressCtrl.forward(),
          onTapUp: (_) {
            _pressCtrl.reverse();
            widget.onTap();
          },
          onTapCancel: () => _pressCtrl.reverse(),
          child: Transform.scale(
            scale: _pressScale.value,
            child: Container(
              height: 164,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF7A7EDB),
                    Color(0xFF5A9ED4),
                    Color(0xFF55C7B5)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 0.5, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B8FE3).withValues(alpha: 0.45),
                    blurRadius: 28,
                    spreadRadius: -4,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Transform.translate(
                        offset: Offset(widget.shimmerPos.value * 360 - 60, 0),
                        child: Container(
                          width: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.0),
                                Colors.white.withValues(alpha: 0.12),
                                Colors.white.withValues(alpha: 0.0),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -28,
                      right: -28,
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -40,
                      right: 60,
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(22),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                    Icons.document_scanner_rounded,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                ),
                                const Spacer(),
                                const Text(
                                  'Start Scanning',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.3,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Digitize any document instantly with AI',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.75),
                                    fontSize: 12.5,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });
}

class _QuickActionTile extends StatefulWidget {
  final _QuickAction action;
  final bool isDark;
  final ThemeData theme;

  const _QuickActionTile({
    required this.action,
    required this.isDark,
    required this.theme,
  });

  @override
  State<_QuickActionTile> createState() => _QuickActionTileState();
}

class _QuickActionTileState extends State<_QuickActionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late Animation<double> _pressScale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    _pressScale = Tween(begin: 1.0, end: 0.93)
        .animate(CurvedAnimation(parent: _pressCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final action = widget.action;
    final isDark = widget.isDark;

    return AnimatedBuilder(
      animation: _pressCtrl,
      builder: (_, __) => GestureDetector(
        onTapDown: (_) => _pressCtrl.forward(),
        onTapUp: (_) {
          _pressCtrl.reverse();
          action.onTap();
        },
        onTapCancel: () => _pressCtrl.reverse(),
        child: Transform.scale(
          scale: _pressScale.value,
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: action.gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: action.gradient.first.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(action.icon, color: Colors.white, size: 26),
              ),
              const SizedBox(height: 8),
              Text(
                action.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                  color: widget.theme.colorScheme.onSurface
                      .withValues(alpha: isDark ? 0.75 : 0.65),
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatefulWidget {
  final bool isDark;
  final IconData icon;
  final VoidCallback onTap;
  final ThemeData theme;

  const _HeaderIconButton({
    required this.isDark,
    required this.icon,
    required this.onTap,
    required this.theme,
  });

  @override
  State<_HeaderIconButton> createState() => _HeaderIconButtonState();
}

class _HeaderIconButtonState extends State<_HeaderIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    _scale = Tween(begin: 1.0, end: 0.88)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) {
          _ctrl.reverse();
          widget.onTap();
        },
        onTapCancel: () => _ctrl.reverse(),
        child: Transform.scale(
          scale: _scale.value,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: widget.isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(widget.icon,
                color:
                    widget.theme.colorScheme.onSurface.withValues(alpha: 0.7),
                size: 20),
          ),
        ),
      ),
    );
  }
}
