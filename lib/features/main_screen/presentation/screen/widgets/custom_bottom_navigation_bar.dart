import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocSelector, ReadContext;
import 'package:google_mobile_ads/google_mobile_ads.dart'
    show BannerAd, AdRequest, AdSize, BannerAdListener, AdWidget;
import 'package:powerocr/core/helpers/admob_helper.dart' show AdMobHelper;
import 'package:powerocr/features/main_screen/presentation/cubit/main_screen_cubit.dart'
    show MainScreenCubit, MainScreenState;
import 'package:powerocr/features/main_screen/presentation/screen/widgets/bottom_navigation_item.dart';
import 'package:powerocr/l10n/app_localizations.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: AdMobHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 85 + (_isLoaded ? _bannerAd!.size.height.toDouble() + 35 : 0),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  width: double.infinity,
                  height:
                      85 +
                      (_isLoaded ? _bannerAd!.size.height.toDouble() + 35 : 0),
                  color: Theme.of(context).colorScheme.surface.withAlpha(20),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10),
                width: double.infinity,
                height: 80,
                child: Row(
                  children: [
                    _buildNavItem(
                      context,
                      0,
                      l10n.homeTabHome,
                      'assets/images/home_icon.svg',
                    ),
                    _buildNavItem(
                      context,
                      1,
                      l10n.homeTabQr,
                      'assets/images/qr_icon.svg',
                    ),
                    _buildNavItem(
                      context,
                      2,
                      l10n.homeTabSetting,
                      'assets/images/setting_icon.svg',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              if (_isLoaded && _bannerAd != null)
                SafeArea(
                  child: SizedBox(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    String label,
    String iconPath,
  ) {
    return Expanded(
      child: BlocSelector<MainScreenCubit, MainScreenState, int>(
        selector: (state) => state.screenIndex,
        builder: (context, screenIndex) => BottomNavigationItem(
          onTap: () => context.read<MainScreenCubit>().changeScreen(index),
          isSelected: screenIndex == index,
          label: label,
          iconPath: iconPath,
        ),
      ),
    );
  }
}
