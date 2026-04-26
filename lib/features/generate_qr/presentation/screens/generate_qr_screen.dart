import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powerocr/core/commons/banner_ad_widget.dart';
import 'package:powerocr/core/di/locator.dart';
import 'package:powerocr/core/helpers/admob_helper.dart' show AdMobHelper;
import 'package:powerocr/core/services/interfaces/iuser_qr_service.dart';
import 'package:powerocr/core/utils/responsive.dart';
import 'package:powerocr/database/hive_entities/user_qr_entity/user_qr_entity.dart'
    show UserQrEntity;
import 'package:share_plus/share_plus.dart';

import 'package:powerocr/features/generate_qr/presentation/bloc/generate_qr_bloc.dart';
import 'package:powerocr/features/generate_qr/presentation/bloc/generate_qr_event.dart';
import 'package:powerocr/features/generate_qr/presentation/bloc/generate_qr_state.dart';
import 'package:powerocr/features/generate_qr/presentation/screens/widgets/qr_preview_card.dart';
import 'package:powerocr/features/generate_qr/presentation/screens/widgets/qr_style_options.dart';
import 'package:powerocr/l10n/app_localizations.dart';

class GenerateQrScreen extends StatelessWidget {
  const GenerateQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GenerateQrBloc>(
      create: (context) => GenerateQrBloc(),
      child: const _GenerateQrScreenView(),
    );
  }
}

class _GenerateQrScreenView extends StatefulWidget {
  const _GenerateQrScreenView();

  @override
  State<_GenerateQrScreenView> createState() => _GenerateQrScreenViewState();
}

class _GenerateQrScreenViewState extends State<_GenerateQrScreenView> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final GlobalKey _qrKey = GlobalKey();

  // ADMOB
  InterstitialAd? _interstitialAd;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdMobHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _interstitialAd = ad;
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                _shareQrCode(context.read<GenerateQrBloc>().state);
                _loadInterstitialAd();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                ad.dispose();
                _loadInterstitialAd();
              },
            );
            print('Interstitial ad loaded');
          });
        },

        onAdFailedToLoad: (error) {
          print('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  @override
  void dispose() {
    _textController.dispose();
    _titleController.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  Future<void> _shareQrCode(GenerateQrState state) async {
    final userQrService = locator<IUserQrService>();
    if (state.qrData.trim().isEmpty) return;

    final bloc = context.read<GenerateQrBloc>();
    final l10n = AppLocalizations.of(context)!;
    bloc.add(const QrShareStatusChanged(true));

    try {
      final boundary =
          _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 5.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes != null) {
        final tempDir = await getApplicationDocumentsDirectory();
        final fileName =
            '${tempDir.path}/custom_qr/qr_code_${DateTime.now().millisecondsSinceEpoch}.png';
        final file = await File(fileName).create(recursive: true);
        await file.writeAsBytes(pngBytes);

        userQrService.saveUserQr(
          UserQrEntity(
            content: state.qrData,
            imagePath: fileName,
            title: _titleController.text.trim(),
          ),
        );
        if (mounted) {
          final box = context.findRenderObject() as RenderBox?;
          await SharePlus.instance.share(
            ShareParams(
              files: [XFile(file.path)],
              text: l10n.generateQrShareTitle,
              sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.generateQrShareError(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        bloc.add(const QrShareStatusChanged(false));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final isTablet = AppBreakpoints.isTablet(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.generateQrTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: theme.colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        actions: const [],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocBuilder<GenerateQrBloc, GenerateQrState>(
          builder: (context, state) {
            return isTablet
                ? _buildTabletLayout(context, state, theme, isDark, l10n)
                : _buildPhoneLayout(context, state, theme, isDark, l10n);
          },
        ),
      ),
    );
  }

  Widget _buildPhoneLayout(
    BuildContext context,
    GenerateQrState state,
    ThemeData theme,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 40),
              child: Column(
                children: [
                  if (kReleaseMode) const BannerAdWidget(),
                  const SizedBox(height: 24),
                  Center(
                    child: QrPreviewCard(
                      boundaryKey: _qrKey,
                      data: state.qrData,
                      foregroundColor: state.selectedColor,
                      isDarkBackground: state.isDarkBackground,
                      eyeShape: state.eyeShape,
                      dataModuleShape: state.dataShape,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildFormFields(context, state, theme, isDark, l10n),
                ],
              ),
            ),
          ),
          _buildShareButton(context, state, theme, l10n),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(
    BuildContext context,
    GenerateQrState state,
    ThemeData theme,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return SafeArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left pane — QR preview (45%)
          Expanded(
            flex: 45,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: QrPreviewCard(
                  boundaryKey: _qrKey,
                  data: state.qrData,
                  foregroundColor: state.selectedColor,
                  isDarkBackground: state.isDarkBackground,
                  eyeShape: state.eyeShape,
                  dataModuleShape: state.dataShape,
                ),
              ),
            ),
          ),
          // Divider
          VerticalDivider(
            width: 1,
            color: theme.dividerColor.withValues(alpha: 0.4),
          ),
          // Right pane — form + share button (55%)
          Expanded(
            flex: 55,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
                    child: _buildFormFields(
                      context,
                      state,
                      theme,
                      isDark,
                      l10n,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: _buildShareButtonChild(context, state, theme, l10n),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields(
    BuildContext context,
    GenerateQrState state,
    ThemeData theme,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.generateQrReminderName,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _titleController,
            maxLines: 1,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: l10n.generateQrReminderNameHint,
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              filled: true,
              fillColor: isDark
                  ? const Color(0xFF1A1A26)
                  : const Color(0xFFF5F6FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(14),
              prefixIcon: Icon(
                Icons.label_important_outline_rounded,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Content Input Field
          Text(
            l10n.generateQrContent,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _textController,
            onChanged: (val) {
              context.read<GenerateQrBloc>().add(QrDataChanged(val));
            },
            textInputAction: TextInputAction.done,
            maxLines: 3,
            minLines: 1,
            decoration: InputDecoration(
              hintText: l10n.generateQrInputHint,
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              filled: true,
              fillColor: isDark
                  ? const Color(0xFF1A1A26)
                  : const Color(0xFFF5F6FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14.0,
                vertical: 20.0,
              ),
              prefixIcon: Icon(
                Icons.text_fields_rounded,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ),
          const SizedBox(height: 24),
          QrStyleOptions(
            selectedColor: state.selectedColor,
            onColorChanged: (c) =>
                context.read<GenerateQrBloc>().add(QrColorChanged(c)),
            selectedEyeShape: state.eyeShape,
            onEyeShapeChanged: (s) =>
                context.read<GenerateQrBloc>().add(QrEyeShapeChanged(s)),
            selectedDataShape: state.dataShape,
            onDataShapeChanged: (s) =>
                context.read<GenerateQrBloc>().add(QrDataShapeChanged(s)),
            isDarkBackground: state.isDarkBackground,
            onBackgroundChanged: (b) =>
                context.read<GenerateQrBloc>().add(QrBackgroundChanged(b)),
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton(
    BuildContext context,
    GenerateQrState state,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _buildShareButtonChild(context, state, theme, l10n),
    );
  }

  Widget _buildShareButtonChild(
    BuildContext context,
    GenerateQrState state,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return ElevatedButton(
      onPressed: state.qrData.trim().isEmpty || state.isSharing
          ? null
          : () {
              if (_interstitialAd != null) {
                _interstitialAd!.show();
              } else {
                _shareQrCode(state);
              }
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
      ),
      child: state.isSharing
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
          : Row(
              spacing: 8.0,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.share_rounded, size: 20),
                Text(
                  l10n.generateQrBtnShare,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
    );
  }
}
