import 'package:dio/dio.dart';
import 'package:ebookapp/controller/api.dart';
import 'package:ebookapp/model/ads/model_ads.dart';

Future<List<ModelAds>> fetchAds() async {
  var req = await Dio()
      .get(ApiConstant().baseUrl + ApiConstant().api + ApiConstant().ads);
  var adsData = req.data;

  List<ModelAds> adsFetchFromServer = [];
  for (Map<String, dynamic> ad in adsData) {
    adsFetchFromServer.add(ModelAds(
        ads: ad['ads'],
        // startAppLiveMode: startAppLiveMode,
        // startAppAccountId: startAppAccountId,
        androidAppId: ad['androidappid'],
        iosAppId: ad['iosappid'],
        admobReward: ad['admobreward'],
        banner: ad['banner'],
        interstitial: ad['interstitial'],
        unityLiveMode: ad['unitylivemode'],
        unityGameId: ad['unitygameid'],
        unityBanner: ad['unitybanner'],
        unityInterstitial: ad['unityinterstitial'],
        unityReward: ad['unityreward']));
  }
  return adsFetchFromServer;
}
