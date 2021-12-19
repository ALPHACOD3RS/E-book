import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:unity_ads_plugin/unity_ads.dart';

class UnityManager {
  String gameId(String androidGameId, String iosGameId) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return androidGameId;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return iosGameId;
    }
    return '';
  }

  String bannerAdsPlacementId(String androidBanner) {
    return androidBanner;
  }

  String interstitialAdsPlacementId(String androidInterstitial) {
    return androidInterstitial;
  }

  String rewardAdsPlacementId(String androidReward) {
    return androidReward;
  }
}

class UnityInit {
  getInit(String androidGameId, String iosGameId, String testMode) {
    UnityAds.init(
        gameId: UnityManager().gameId(androidGameId, iosGameId),
        testMode: testMode == "0" ? true : false,
        listener: (state, arg) => print('My Uniyt show $state and $arg'));
  }
}
