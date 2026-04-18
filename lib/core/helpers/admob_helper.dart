import 'dart:io';
import 'package:flutter/foundation.dart';

class AdMobHelper {
  static String get bannerAdUnitId {
    if (Platform.isIOS) {
      if (kReleaseMode) {
        return 'ca-app-pub-2544326207129982/3228309505';
      } else {
        return 'ca-app-pub-3940256099942544/2934735716';
      }
    }
    throw UnsupportedError('Unsupported platform');
  }

  static String get interstitialAdUnitId {
    if (Platform.isIOS) {
      if (kReleaseMode) {
        return 'ca-app-pub-2544326207129982/7713303249';
      } else {
        return 'ca-app-pub-3940256099942544/1033173712';
      }
    }
    throw UnsupportedError('Unsupported platform');
  }
}
