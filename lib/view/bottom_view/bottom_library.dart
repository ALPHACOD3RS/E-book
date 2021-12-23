import 'package:ebookapp/controller/ads/admob.dart';
import 'package:ebookapp/controller/ads/con_ads.dart';
import 'package:ebookapp/controller/ads/unity.dart';
import 'package:ebookapp/controller/con_latest.dart';
import 'package:ebookapp/model/ebook/model_ebook.dart';
import 'package:ebookapp/view/detail/ebook_detail.dart';
import 'package:ebookapp/widget/ebook_routers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sizer/sizer.dart';
import 'package:unity_ads_plugin/ad/unity_banner_ad.dart';

class BottomLibrary extends StatefulWidget {
  @override
  _BottomLibraryState createState() => _BottomLibraryState();
}

class _BottomLibraryState extends State<BottomLibrary> {
  Future<List<ModelEbook>>? getLatest;
  List<ModelEbook> listlatest = [];

  late BannerAd _bannerAd;
  bool _isBannerAdsReady = false;

  String admobBanner = '', admobInterstitial = '', adsMode = '';
  // String androidAppId = '', iosAppId = '', accountAppId = '';
  String androidBanner = '';

  @override
  void initState() {
    super.initState();
    _initGoogleAdmob();
    getLatest = featchLatest(listlatest);
    fetchAds().then((value) {
      setState(() {
        adsMode = value[0].ads;
        admobBanner = value[0].banner;
        androidBanner = value[0].unityBanner;
        admobInterstitial = value[0].interstitial;
        _bannerAd = BannerAd(
            adUnitId: AdmobManager().bannerAdsUnitId(admobBanner, admobBanner),
            request: AdRequest(),
            size: AdSize.banner,
            listener: BannerAdListener(onAdLoaded: (_) {
              setState(() {
                _isBannerAdsReady = true;
              });
            }, onAdFailedToLoad: (ad, err) {
              print("admob ads any error $ad and error is $err");
              _isBannerAdsReady = false;
              ad.dispose();
            }));
        _bannerAd.load();
      });
    });
  }

  Future<InitializationStatus> _initGoogleAdmob() {
    return MobileAds.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        elevation: 0,
        title: const Text(
          'Library',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
          child: SingleChildScrollView(
        child: FutureBuilder(
          future: getLatest,
          builder:
              (BuildContext context, AsyncSnapshot<List<ModelEbook>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return GridView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      pushPage(
                          context,
                          EbookDetail(
                            ebookId: listlatest[index].id,
                            status: listlatest[index].statusNews,
                          ));
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              listlatest[index].photo,
                              fit: BoxFit.cover,
                              height: 16.h,
                              width: 24.w,
                            ),
                          ),
                          const SizedBox(
                            height: 0.5,
                          ),
                          Container(
                            width: 24.w,
                            child: Text(
                              listlatest[index].title,
                              style: TextStyle(color: Colors.black),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 5.5 / 9.0),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: Colors.blue,
                ),
              );
            }
          },
        ),
      )),
    );
  }
}
