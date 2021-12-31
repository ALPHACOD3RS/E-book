import 'package:ebookapp/controller/ads/admob.dart';
import 'package:ebookapp/controller/ads/con_ads.dart';
import 'package:ebookapp/controller/ads/unity.dart';
import 'package:ebookapp/controller/con_favorite.dart';
import 'package:ebookapp/model/ebook/model_ebook.dart';
import 'package:ebookapp/view/detail/ebook_detail.dart';
import 'package:ebookapp/widget/common_pref.dart';
import 'package:ebookapp/widget/ebook_routers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sizer/sizer.dart';
import 'package:unity_ads_plugin/ad/unity_banner_ad.dart';

class BottomFavorite extends StatefulWidget {
  @override
  _BottomFavoriteState createState() => _BottomFavoriteState();
}

class _BottomFavoriteState extends State<BottomFavorite> {
  Future<List<ModelEbook>>? getFavorite;
  List<ModelEbook> listFavorite = [];
  String id = '', name = '', email = '', photo = '';

  late BannerAd _bannerAd;
  bool _isBannerAdsReady = false;

  String admobBanner = '', admobInterstitial = '', adsMode = '';
  // String androidAppId = '', iosAppId = '', accountAppId = '';
  String androidBanner = '';

  @override
  void initState() {
    super.initState();

    loadLogin().then((value) {
      setState(() {
        id = value[0];
        name = value[1];
        email = value[2];
        getFavorite = featchFavorite(listFavorite, id);

        fetchAds().then((value) {
          setState(() {
            adsMode = value[0].ads;
            admobBanner = value[0].banner;
            androidBanner = value[0].unityBanner;
            admobInterstitial = value[0].interstitial;
            _bannerAd = BannerAd(
                adUnitId:
                    AdmobManager().bannerAdsUnitId(admobBanner, admobBanner),
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
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Favorite',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: FutureBuilder(
            future: getFavorite,
            builder: (BuildContext context,
                AsyncSnapshot<List<ModelEbook>> snapshot) {
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
                              ebookId: listFavorite[index].id,
                              status: listFavorite[index].statusNews,
                            ));
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                listFavorite[index].photo,
                                fit: BoxFit.cover,
                                height: 16.h,
                                width: 24.w,
                              ),
                            ),
                            SizedBox(
                              height: 0.7,
                            ),
                            Container(
                              width: 24.w,
                              child: Text(
                                listFavorite[index].title,
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
        ),
        //ads are here>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        //ads>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      ),
    );
  }
}
