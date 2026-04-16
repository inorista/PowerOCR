import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerocr/core/localization/cubit/locale_cubit.dart';
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

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: HomeHeader(isDark: isDark, theme: theme),
            ),
        SliverToBoxAdapter(
              child: ResponsiveContentBox(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    spacing: 12.0,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            l10n.visibilityMode,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                          HeaderIconButton(
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
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            l10n.language,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                          BlocBuilder<LocaleCubit, LocaleState>(
                            builder: (context, state) {
                              return CustomLanguageDropdown(
                                currentLanguageCode: state.locale.languageCode,
                                englishText: l10n.english,
                                vietnameseText: l10n.vietnamese,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
