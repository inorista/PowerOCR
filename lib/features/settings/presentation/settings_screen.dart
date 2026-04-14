import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerocr/core/localization/cubit/locale_cubit.dart';
import 'package:powerocr/core/theme/cubit/theme_cubit.dart';
import 'package:powerocr/features/home_screen/presentation/screens/widgets/home_header.dart';
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
                            return _CustomLanguageDropdown(
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
          ],
        ),
      ),
    );
  }
}

class _CustomLanguageDropdown extends StatelessWidget {
  final String currentLanguageCode;
  final String englishText;
  final String vietnameseText;

  const _CustomLanguageDropdown({
    required this.currentLanguageCode,
    required this.englishText,
    required this.vietnameseText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final currentLabel = currentLanguageCode == 'vi'
        ? vietnameseText
        : englishText;
    final currentFlag = currentLanguageCode == 'vi' ? '🇻🇳' : '🇬🇧';

    return Theme(
      data: theme.copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: PopupMenuButton<String>(
        splashRadius: 0,
        initialValue: currentLanguageCode,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: theme.colorScheme.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        offset: const Offset(0, 48),
        onSelected: (String value) {
          context.read<LocaleCubit>().setLocale(Locale(value));
        },
        surfaceTintColor: Colors.transparent,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'vi',
            child: Row(
              children: [
                const Text('🇻🇳', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 12),
                Text(
                  vietnameseText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: currentLanguageCode == 'vi'
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: currentLanguageCode == 'vi'
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                if (currentLanguageCode == 'vi')
                  Icon(
                    Icons.check_circle_rounded,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'en',
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('🇬🇧', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 12),
                Text(
                  englishText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: currentLanguageCode == 'en'
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: currentLanguageCode == 'en'
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                if (currentLanguageCode == 'en')
                  Icon(
                    Icons.check_circle_rounded,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
              ],
            ),
          ),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? Colors.white12 : Colors.black.withOpacity(0.05),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(currentFlag, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text(
                currentLabel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
