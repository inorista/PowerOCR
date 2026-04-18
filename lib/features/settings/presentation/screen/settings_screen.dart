import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerocr/features/localization/cubit/locale_cubit.dart';
import 'package:powerocr/core/theme/cubit/theme_cubit.dart';
import 'package:powerocr/core/utils/responsive.dart';
import 'package:powerocr/features/home_screen/presentation/screens/widgets/home_header.dart';
import 'package:powerocr/features/settings/presentation/screen/widgets/custom_language_drop_down.dart';
import 'package:powerocr/l10n/app_localizations.dart' show AppLocalizations;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final hPad = AppBreakpoints.horizontalPadding(context);

    return Scaffold(
      body: SafeArea(
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
                // ── Header (reuses the same greeting header as Home) ──
                SliverToBoxAdapter(
                  child: HomeHeader(isDark: isDark, theme: theme),
                ),

                // ── Section title ─────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(hPad, 28, hPad, 12),
                    child: Text(
                      l10n.settingsTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),

                // ── Settings card ─────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPad),
                    child: _SettingsCard(
                      isDark: isDark,
                      theme: theme,
                      children: [
                        // Dark / Light mode toggle
                        _SettingRow(
                          isDark: isDark,
                          theme: theme,
                          label: l10n.visibilityMode,
                          trailing: HeaderIconButton(
                            isDark: isDark,
                            icon: isDark
                                ? Icons.light_mode_outlined
                                : Icons.dark_mode_outlined,
                            onTap: () {
                              context.read<ThemeCubit>().setTheme(
                                isDark ? ThemeMode.light : ThemeMode.dark,
                              );
                            },
                            theme: theme,
                          ),
                        ),

                        _SettingsDivider(isDark: isDark),

                        // Language selector
                        _SettingRow(
                          isDark: isDark,
                          theme: theme,
                          label: l10n.language,
                          trailing: BlocBuilder<LocaleCubit, LocaleState>(
                            builder: (context, state) {
                              return CustomLanguageDropdown(
                                currentLanguageCode: state.locale.languageCode,
                                englishText: l10n.english,
                                vietnameseText: l10n.vietnamese,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Shared card container ────────────────────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.isDark,
    required this.theme,
    required this.children,
  });

  final bool isDark;
  final ThemeData theme;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF2E2E3E).withValues(alpha: 0.7)
            : Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            spreadRadius: -4,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

// ─── Single settings row ──────────────────────────────────────────────────────

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.isDark,
    required this.theme,
    required this.label,
    required this.trailing,
  });

  final bool isDark;
  final ThemeData theme;
  final String label;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

// ─── Thin divider between rows ────────────────────────────────────────────────

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.5,
      indent: 20,
      endIndent: 20,
      color: isDark
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.black.withValues(alpha: 0.07),
    );
  }
}
