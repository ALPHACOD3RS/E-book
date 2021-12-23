import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:ebookapp/controller/ads/admob.dart';
import 'package:ebookapp/controller/ads/con_ads.dart';
import 'package:ebookapp/controller/ads/unity.dart';
import 'package:ebookapp/controller/api.dart';
import 'package:ebookapp/controller/con_detail.dart';
import 'package:ebookapp/controller/con_save_favorite.dart';
import 'package:ebookapp/model/ebook/model_ebook.dart';
import 'package:ebookapp/widget/common_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:package_info/package_info.dart';
import 'package:unity_ads_plugin/unity_ads.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class EbookDetail extends StatefulWidget {
  int ebookId;
  int status;

  EbookDetail({required this.ebookId, required this.status});
  @override
  _EbookDetailState createState() => _EbookDetailState();
}

class _EbookDetailState extends State<EbookDetail> {
  Future<List<ModelEbook>>? getDetail;
  List<ModelEbook> listDetail = [];
  String id = '', name = '', email = '', checkFavorite = "0";
  late SharedPreferences preferences;

  RewardedAd? _rewardedAd;
  late BannerAd _bannerAd;
  bool _isBannerAdsReady = false;

  String admobReward = '', admobBanner = '', adsMode = '';
  // String androidAppId = '', iosAppId = '', accountAppId = '';
  String androidGameId = '',
      iosGaemId = '',
      androidBanner = '',
      androidInterstitial = '',
      androidReward = '',
      unityLiveMode = 'o';

  @override
  void initState() {
    super.initState();
    getDetail = fetchDetail(listDetail, widget.ebookId);
    fetchAds().then((value) {
      setState(() {
        adsMode = value[0].ads;
        admobBanner = value[0].banner;
        admobReward = value[0].admobReward;
        androidBanner = value[0].unityBanner;
        androidReward = value[0].unityReward;
        androidGameId = value[0].unityGameId;
        unityLiveMode = value[0].unityLiveMode;
        _loadRewardAdsAdmob(admobReward);

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
    loadLogin().then((value) {
      id = value[0];
      name = value[1];
      email = value[2];
      checkFavorites(id);
    });
  }

  checkFavorites(String userId) async {
    try {
      var data = {'id_course': widget.ebookId, 'id_user': userId};
      var checkFav = await Dio().post(
          ApiConstant().baseUrl + ApiConstant().checkFavorite,
          data: data);
      var response = checkFav.data;
      setState(() {
        checkFavorite = response;
      });
    } catch (e) {
      var err = "Network problem";
      print(err);
    }
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
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        child: FutureBuilder(
            future: getDetail,
            builder: (BuildContext context,
                AsyncSnapshot<List<ModelEbook>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  children: [
                    ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Container(
                                margin: EdgeInsets.all(14),
                                height: 25.h,
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      child: Image.network(
                                        listDetail[index].photo,
                                        fit: BoxFit.cover,
                                        width: 35.w,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    Flexible(
                                        child: Column(
                                      children: [
                                        Text(
                                          listDetail[index].title,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17,
                                              color: Colors.black),
                                          maxLines: 2,
                                          overflow: TextOverflow.clip,
                                        ),
                                        SizedBox(height: 1.3.h),
                                        Text(
                                          'Author: ${listDetail[index].authorName}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                              color: Colors.black),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 1.3.h),
                                        Text(
                                          'Publisher: ${listDetail[index].publisherName}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                              color: Colors.black),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [
                                            GestureDetector(
                                                onTap: () async {
                                                  await showDialog(
                                                    builder: (myFavorite) =>
                                                        FutureProgressDialog(
                                                            saveToFavorite(
                                                                context:
                                                                    myFavorite,
                                                                idCourse: widget
                                                                    .ebookId
                                                                    .toString(),
                                                                idUser: id)),
                                                    context: context,
                                                  ).then((value) async {
                                                    preferences =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    dynamic fav = preferences
                                                        .get('saveFavorite');
                                                    setState(() {
                                                      checkFavorite = fav;
                                                    });
                                                  });
                                                },
                                                child: checkFavorite ==
                                                        "already"
                                                    ? Icon(
                                                        Icons.bookmark,
                                                        color: Colors.blue,
                                                        size: 21.sp,
                                                      )
                                                    : Icon(
                                                        Icons.bookmark_border,
                                                        color: Colors.blue,
                                                        size: 21.sp)),
                                            SizedBox(width: 1.3.h),
                                            Text(
                                              '${listDetail[index].pages} Pages',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  color: Colors.black),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(width: 1.5.h),
                                            listDetail[index].free == 1
                                                ? const Text(
                                                    'Free',
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                                : const Text(
                                                    'Premium',
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                            Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                _share();
                                              },
                                              child: const Icon(
                                                Icons.share,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                    ))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 3.h,
                              ),
                              widget.status == 0
                                  ? Container(
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          color: Colors.blue),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          'Coming Soon',
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      margin:
                                          EdgeInsets.only(left: 14, right: 14),
                                    )
                                  : listDetail[index].free == 1
                                      ? GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => PDF(
                                                            swipeHorizontal:
                                                                true,
                                                            autoSpacing: false,
                                                            fitPolicy:
                                                                FitPolicy.BOTH)
                                                        .cachedFromUrl(
                                                            '${listDetail[index].pdf}',
                                                            placeholder:
                                                                (progress) =>
                                                                    MaterialApp(
                                                                      home:
                                                                          Scaffold(
                                                                        backgroundColor:
                                                                            Colors.white,
                                                                        body:
                                                                            Center(
                                                                          child:
                                                                              Text('$progress %'),
                                                                        ),
                                                                      ),
                                                                    ))));
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                color: Colors.blue),
                                            child: const Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Text(
                                                'Read Ebook (Free)',
                                                style: TextStyle(
                                                    color: Colors.white),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            margin: EdgeInsets.only(
                                                left: 14, right: 14),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            adsMode == "1"
                                                ? _rewardedAd?.show(
                                                    onUserEarnedReward:
                                                        (RewardedAd ad,
                                                            RewardItem reward) {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => PDF(
                                                                    swipeHorizontal:
                                                                        true,
                                                                    autoSpacing:
                                                                        false,
                                                                    fitPolicy:
                                                                        FitPolicy
                                                                            .BOTH)
                                                                .cachedFromUrl(
                                                                    '${listDetail[index].pdf}',
                                                                    placeholder:
                                                                        (progress) =>
                                                                            MaterialApp(
                                                                              home: Scaffold(
                                                                                backgroundColor: Colors.white,
                                                                                body: Center(
                                                                                  child: Text('$progress %'),
                                                                                ),
                                                                              ),
                                                                            ))));
                                                  })
                                                : adsMode == "2"
                                                    ? _loadRewardAdsUnity(
                                                        index, androidReward)
                                                    : _rewardedAd?.show(
                                                        onUserEarnedReward:
                                                            (RewardedAd ad,
                                                                RewardItem
                                                                    reward) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => PDF(
                                                                        swipeHorizontal:
                                                                            true,
                                                                        autoSpacing:
                                                                            false,
                                                                        fitPolicy:
                                                                            FitPolicy
                                                                                .BOTH)
                                                                    .cachedFromUrl(
                                                                        '${listDetail[index].pdf}',
                                                                        placeholder: (progress) =>
                                                                            MaterialApp(
                                                                              home: Scaffold(
                                                                                backgroundColor: Colors.white,
                                                                                body: Center(
                                                                                  child: Text('$progress %'),
                                                                                ),
                                                                              ),
                                                                            ))));
                                                      });
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                color: Colors.blue),
                                            child: const Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Text(
                                                'Read Ebook (Premium)',
                                                style: TextStyle(
                                                    color: Colors.white),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            margin: EdgeInsets.only(
                                                left: 14, right: 14),
                                          ),
                                        ),
                              SizedBox(
                                height: 3.h,
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 3.h),
                                margin: EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Colors.black12),
                                child: Column(
                                  children: [
                                    Text(
                                      'Description',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Html(
                                      data: '${listDetail[index].description}',
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 3.h,
                              )
                            ],
                          );
                        })
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: Colors.blue,
                  ),
                );
              }
            }),
      ),
    );
  }

  _share() async {
    PackageInfo pi = await PackageInfo.fromPlatform();
    Share.share(
        "Reading Ebook for free on ${pi.appName} '\n Dowload now : https://play.google.com/store/apps/details?id=${pi.packageName}");
  }

//rewarded adds are hereeeeee
  void _loadRewardAdsAdmob(String admobInerstitial) {
    RewardedAd.load(
      adUnitId:
          AdmobManager().rewardAdsUnitId(admobInerstitial, admobInerstitial),
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
        this._rewardedAd = ad;
        ad.fullScreenContentCallback =
            FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
          _loadRewardAdsAdmob(admobInerstitial);
        });
      }, onAdFailedToLoad: (err) {
        print("error load ads $err");
      }),
    );
  }

  void _loadRewardAdsUnity(int index, String androidReward) {
    UnityAds.showVideoAd(
        placementId: UnityManager().rewardAdsPlacementId(androidReward),
        listener: (state, arg) async {
          if (state == UnityAdState.complete) {
            //user can access pdf file or ebook from premium to free
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PDF(
                            swipeHorizontal: true,
                            autoSpacing: false,
                            fitPolicy: FitPolicy.BOTH)
                        .cachedFromUrl('${listDetail[index].pdf}',
                            placeholder: (progress) => MaterialApp(
                                  home: Scaffold(
                                    backgroundColor: Colors.white,
                                    body: Center(
                                      child: Text('$progress %'),
                                    ),
                                  ),
                                ))));
          } else if (state == UnityAdState.skipped) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'You skipped this Ads',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                    content: Text(
                      'If you skip this Ads, you cant open this premium ebook',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.black),
                          ))
                    ],
                  );
                });
          }
        });
  }
}
