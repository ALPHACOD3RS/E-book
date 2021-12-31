import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobManager {
  String bannerAdsUnitId(String androidBanner, String iosBanner) {
    if (Platform.isAndroid) {
      return androidBanner;
    } else if (Platform.isIOS) {
      return iosBanner;
    } else {
      throw new UnsupportedError('No platform available');
    }
  }

  String interstitialAdsUnitId(String androidBanner, String iosBanner) {
    if (Platform.isAndroid) {
      return androidBanner;
    } else if (Platform.isIOS) {
      return iosBanner;
    } else {
      throw new UnsupportedError('No platform available');
    }
  }

  String rewardAdsUnitId(String androidBanner, String iosBanner) {
    if (Platform.isAndroid) {
      return androidBanner;
    } else if (Platform.isIOS) {
      return iosBanner;
    } else {
      throw new UnsupportedError('No platform available');
    }
  }
}
