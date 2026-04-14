import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerocr/core/constants/enum.dart';
import 'package:powerocr/features/home_screen/presentation/bloc/home_bloc.dart';
import 'package:powerocr/features/home_screen/presentation/bloc/home_state.dart';
import 'package:powerocr/features/home_screen/presentation/screens/widgets/stat_card.dart';
import 'package:powerocr/l10n/app_localizations.dart';

class HomeStatsRow extends StatelessWidget {
  final ThemeData theme;
  final bool isDark;
  final AnimationController statCtrl;

  const HomeStatsRow({
    super.key,
    required this.theme,
    required this.isDark,
    required this.statCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        spacing: 12.0,
        children: [
          Expanded(
            child: BlocSelector<HomeBloc, HomeState, int>(
              selector: (state) => state.history.length,
              builder: (context, historyCount) {
                return StatCard(
                  label: l10n.homeStatsScannedDocs,
                  value: historyCount,
                  icon: Icons.document_scanner_rounded,
                  isDark: isDark,
                  theme: theme,
                  controller: statCtrl,
                );
              },
            ),
          ),
          Expanded(
            child: BlocSelector<HomeBloc, HomeState, int>(
              selector: (state) {
                return state.history
                    .where((element) => element.type == ScanHistoryType.qr)
                    .length;
              },
              builder: (context, qrCount) {
                return StatCard(
                  label: l10n.homeStatsScannedQr,
                  value: qrCount,
                  icon: Icons.qr_code_2_rounded,
                  isDark: isDark,
                  theme: theme,
                  controller: statCtrl,
                );
              },
            ),
          ),
          Expanded(
            child: BlocSelector<HomeBloc, HomeState, int>(
              selector: (state) => state.history.length,
              builder: (context, savedCount) {
                return StatCard(
                  label: l10n.homeStatsSaved,
                  value: savedCount,
                  icon: Icons.bookmark_rounded,
                  isDark: isDark,
                  theme: theme,
                  controller: statCtrl,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
