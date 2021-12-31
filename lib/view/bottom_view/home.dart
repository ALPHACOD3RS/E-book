//import 'dart:math';

import 'package:card_swiper/card_swiper.dart';
import 'package:dio/dio.dart';
import 'package:ebookapp/controller/ads/admob.dart';
import 'package:ebookapp/controller/ads/con_ads.dart';
import 'package:ebookapp/controller/ads/unity.dart';
import 'package:ebookapp/controller/api.dart';
import 'package:ebookapp/controller/con_category.dart';
import 'package:ebookapp/controller/con_coming.dart';
import 'package:ebookapp/controller/con_latest.dart';
import 'package:ebookapp/controller/con_slider.dart';
import 'package:ebookapp/model/category/model_category.dart';
import 'package:ebookapp/model/ebook/model_ebook.dart';
import 'package:ebookapp/view/bottom_view/bottom_library.dart';
import 'package:ebookapp/view/detail/ebook_detail.dart';
import 'package:ebookapp/view/pdf_by_cat/ebook_category.dart';
import 'package:ebookapp/widget/common_pref.dart';
import 'package:ebookapp/widget/ebook_routers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sizer/sizer.dart';
import 'package:unity_ads_plugin/unity_ads.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<ModelEbook>>? getSlider;
  List<ModelEbook> listSlider = [];

  Future<List<ModelEbook>>? getLatest;
  List<ModelEbook> listlatest = [];

  Future<List<ModelEbook>>? getComing;
  List<ModelEbook> listComing = [];

  Future<List<ModelCategory>>? getCategory;
  List<ModelCategory> listCategory = [];

  String id = '', name = '', email = '', photo = '';

  //this variables for ads
  late BannerAd _bannerAd;
  bool _isBannerAdsReady = false;

  String admobBanner = '', admobInterstitial = '', adsMode = '';
  // String androidAppId = '', iosAppId = '', accountAppId = '';
  String androidBanner = '';

  @override
  void initState() {
    super.initState();
    _initGoogleAdmob();

    getSlider = featchSlider(listSlider);
    getLatest = featchLatest(listlatest);
    getComing = featchComing(listComing);
    getCategory = featchCategory(listCategory);
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

    loadLogin().then((value) {
      setState(() {
        id = value[0];
        name = value[1];
        email = value[2];
        photo = value[3];
        getPhoto(id);
      });
    });
  }

  Future<InitializationStatus> _initGoogleAdmob() {
    return MobileAds.instance.initialize();
  }

  Future getPhoto(String idOfUser) async {
    try {
      var req = await Dio().post(
          ApiConstant().baseUrl + ApiConstant().viewPhoto,
          data: {'id': idOfUser});
      var decode = req.data;
      if (decode != "no_img") {
        setState(() {
          photo = decode;
        });
      } else {
        setState(() {
          photo = "";
        });
      }
    } catch (e) {
      print("network problem please refresh the page");
    }
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white70,
        title: Row(
          children: [
            Container(
                child: photo == ''
                    ? ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        child: Image.asset(
                          'assets/image/noimage.jpg',
                          fit: BoxFit.cover,
                          width: 14.w,
                          height: 7,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        child: Image.network(photo,
                            fit: BoxFit.cover, width: 13.w, height: 45),
                      )),
            SizedBox(
              width: 2.w,
            ),
            Text(
              name,
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
        actions: [],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: getSlider,
            builder: (BuildContext context,
                AsyncSnapshot<List<ModelEbook>> snapshot) {
              try {
                if (snapshot.connectionState == ConnectionState.done) {
                  //display data on here
                  return Column(
                    children: [
                      //slider
                      Container(
                        child: FutureBuilder(
                          future: getSlider,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<ModelEbook>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              //create design in here
                              return SizedBox(
                                height: 27.0.h,
                                child: Swiper(
                                  autoplay: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        pushPage(
                                            context,
                                            EbookDetail(
                                              ebookId: listSlider[index].id,
                                              status:
                                                  listSlider[index].statusNews,
                                            ));
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Container(
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                child: Image.network(
                                                  listSlider[index].photo,
                                                  fit: BoxFit.cover,
                                                  width: 100.0.w,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(15),
                                                      bottomRight:
                                                          Radius.circular(15),
                                                    ),
                                                    gradient: LinearGradient(
                                                        end: Alignment(0.0, -1),
                                                        begin:
                                                            Alignment(0.0, 0.2),
                                                        colors: [
                                                          Colors.black,
                                                          Colors.black
                                                              .withOpacity(0.0)
                                                        ]),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: Text(
                                                      listSlider[index].title,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 17,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),

                      //latest ebook>>>>>>>>>>>>>>>>>>>>>>>
                      Container(
                        child: FutureBuilder(
                            future: getLatest,
                            builder: (BuildContext context,
                                AsyncSnapshot<List<ModelEbook>> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        'Latest Ebook',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 17),
                                      ),
                                    ),
                                    SizedBox(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: snapshot.data!.length + 1,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            print(
                                                "what is index $index and snapshot ${snapshot.data!.length}");
                                            if (index ==
                                                snapshot.data!.length) {
                                              return GestureDetector(
                                                onTap: () {
                                                  pushPage(
                                                      context,
                                                      EbookDetail(
                                                        ebookId:
                                                            listlatest[index]
                                                                .id,
                                                        status:
                                                            listlatest[index]
                                                                .statusNews,
                                                      ));
                                                },
                                                child: Container(
                                                  width: 24.w,
                                                  padding: EdgeInsets.only(
                                                      top: 15.w),
                                                  child: const Text(
                                                    'See All',
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return GestureDetector(
                                                onTap: () {
                                                  pushPage(
                                                      context,
                                                      EbookDetail(
                                                        ebookId:
                                                            listlatest[index]
                                                                .id,
                                                        status:
                                                            listlatest[index]
                                                                .statusNews,
                                                      ));
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(8),
                                                  child: Column(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: Image.network(
                                                          listlatest[index]
                                                              .photo,
                                                          fit: BoxFit.cover,
                                                          height: 15.h,
                                                          width: 24.w,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 0.5.h,
                                                      ),
                                                      Container(
                                                        width: 24.w,
                                                        child: Text(
                                                          listlatest[index]
                                                              .title,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                          }),
                                      height: 25.h,
                                    )
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            }),
                      ),
                      //ads here>>>>>>>>>>>>>>>>>>>>>>>>>>>

                      adsMode == "1"
                          ? _isBannerAdsReady
                              ? Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    width: _bannerAd.size.width.toDouble(),
                                    height: _bannerAd.size.height.toDouble(),
                                    child: AdWidget(
                                      ad: _bannerAd,
                                    ),
                                  ),
                                )
                              : Container(
                                  child: Text('Loading'),
                                )
                          : adsMode == "2"
                              ? UnityBannerAd(
                                  placementId: UnityManager()
                                      .gameId(androidBanner, androidBanner),
                                  listener: (state, arg) {
                                    print(
                                        "unity ads in flutter $state and this $arg");
                                  },
                                )
                              : Container(),
                      //coming soon
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: FutureBuilder(
                          future: getComing,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<ModelEbook>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return snapshot.data!.length == 0
                                  ? Container()
                                  : Container(
                                      color: Colors.blueGrey.withOpacity(0.5),
                                      padding: EdgeInsets.only(top: 2.0.h),
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Container(
                                              padding: EdgeInsets.all(6),
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 16.h, top: 6.h),
                                                child: const Text(
                                                  'Coming Soon',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 30,
                                                      letterSpacing:
                                                          4), /*changed*/

                                                  //textAlign: TextAlign.right,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: snapshot.data!.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    pushPage(
                                                        context,
                                                        EbookDetail(
                                                          ebookId:
                                                              listComing[index]
                                                                  .id,
                                                          status:
                                                              listComing[index]
                                                                  .statusNews,
                                                        ));
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(8),
                                                    child: Column(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Image.network(
                                                            listComing[index]
                                                                .photo,
                                                            fit: BoxFit.cover,
                                                            height: 15.h,
                                                            width: 24.w,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 0.5.h,
                                                        ),
                                                        Container(
                                                          width: 25.w,
                                                          child: Text(
                                                            listComing[index]
                                                                .title,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            height: 25.h,
                                          )
                                        ],
                                      ),
                                    );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                      //catagory>>>>>>>>>>>>>>>>>>>>>>>>>>>

                      Container(
                        child: FutureBuilder(
                          future: getCategory,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<ModelCategory>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      'Category',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data!.length,
                                      //scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            pushPage(
                                                context,
                                                EbookCategory(
                                                    catId: listCategory[index]
                                                        .catId));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            child: Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    listCategory[index]
                                                        .photoCat,
                                                    fit: BoxFit.cover,
                                                    height: 15.h,
                                                    width: 24.w,
                                                  ),
                                                ),
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                    height: 15.h,
                                                    width: 24.w,
                                                  ),
                                                ),
                                                Positioned(
                                                  child: Center(
                                                    child: Text(
                                                      listCategory[index].name,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      maxLines: 1,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  bottom: 0,
                                                  top: 0,
                                                  right: 0,
                                                  left: 0,
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    height: 14.h,
                                  )
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  //display circular progress indecator
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  );
                }
              } catch (e) {
                print('Network Problem!');
                rethrow;
              }
            },
          ),
        ),
      ),
    );
  }
}
