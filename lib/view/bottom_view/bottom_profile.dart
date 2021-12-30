import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:ebookapp/controller/ads/admob.dart';
import 'package:ebookapp/controller/ads/con_ads.dart';
import 'package:ebookapp/controller/ads/unity.dart';
import 'package:ebookapp/controller/api.dart';
import 'package:ebookapp/view/login/ebook_login.dart';
import 'package:ebookapp/widget/common_pref.dart';
import 'package:ebookapp/widget/ebook_routers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:unity_ads_plugin/ad/unity_banner_ad.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomProfile extends StatefulWidget {
  @override
  _BottomProfileState createState() => _BottomProfileState();
}

class _BottomProfileState extends State<BottomProfile> {
  String id = '', name = '', email = '', photoUser = '';
  late SharedPreferences preferences;
  File _file = File('');
  final picker = ImagePicker();

  late BannerAd _bannerAd;
  bool _isBannerAdsReady = false;

  String admobBanner = '', admobInterstitial = '', adsMode = '';
  // String androidAppId = '', iosAppId = '', accountAppId = '';
  String androidBanner = '';

  String _url = 'https://alphacod3rs.github.io/website/';

  @override
  void initState() {
    super.initState();
    _initGoogleAdmob();
    loadLogin().then((value) {
      setState(() {
        id = value[0];
        name = value[1];
        email = value[2];
        displayPhoto(id);

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

  Future<InitializationStatus> _initGoogleAdmob() {
    return MobileAds.instance.initialize();
  }

  Future updatePhotoUser() async {
    var req = http.MultipartRequest(
        'POST', Uri.parse(ApiConstant().baseUrl + ApiConstant().updatePhoto));
    req.fields['iduser'] = id;
    var photo = await http.MultipartFile.fromPath('photo', _file.path);
    req.files.add(photo);
    var response = await req.send();
    if (response.statusCode == 200) {
      setState(() {
        _file = File('');
      });
      displayPhoto(id);
    }
  }

  Future displayPhoto(String userId) async {
    try {
      var request = await Dio().post(
          ApiConstant().baseUrl + ApiConstant().viewPhoto,
          data: {'id': userId});
      var decode = request.data;
      if (decode != "no_img") {
        setState(() {
          photoUser = decode;
        });
      } else {
        setState(() {
          photoUser = '';
        });
      }
    } catch (e) {
      print('Network Problem');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          GestureDetector(
              onTap: () {
                updatePhotoUser();
              },
              child: _file.path != ''
                  ? const Center(
                      child: Text(
                        'Update',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                    )
                  : Text(''))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 24, left: 10, right: 10),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      imagePicker(context);
                    },
                    child: Container(
                      height: 15.h,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          photoUser != ''
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                    '$photoUser',
                                    fit: BoxFit.cover,
                                    width: 30.w,
                                    height: 30.h,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.asset(
                                    'assets/image/noimage.jpg',
                                    fit: BoxFit.cover,
                                    width: 30.w,
                                    height: 30.h,
                                  ),
                                ),
                          _file.path == ''
                              ? Text('')
                              : Text(
                                  'Change to ->',
                                  style: TextStyle(color: Colors.black),
                                ),
                          _file.path == ''
                              ? Text('')
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: _file.path == ''
                                      ? Image.asset(
                                          'assets/image/noimage.jpg',
                                          fit: BoxFit.cover,
                                          width: 30.w,
                                          height: 30.h,
                                        )
                                      : Image.file(
                                          _file,
                                          fit: BoxFit.cover,
                                          width: 30.w,
                                          height: 30.h,
                                        ))
                        ],
                      ),
                    )),
                Container(
                  child: Text(
                    name,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      color: Colors.red,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Text(
                        email,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 25.sp),
                    child: Text(
                      'Amharic Books Support',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 15.sp),
                    child: GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'About Ebook',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 15.sp),
                    child: GestureDetector(
                      onTap: () {
                        _launchURL();
                      },
                      child: const Text(
                        'Give a Rating',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 15.sp),
                    child: GestureDetector(
                      onTap: () {
                        _share();
                      },
                      child: const Text(
                        'Share this App',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 15.sp),
                    child: GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'More App',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    preferences = await SharedPreferences.getInstance();
                    preferences.remove('login');
                    pushAndRemove(context, EbookLogin());
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 25.sp, bottom: 10.sp),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                //ads are here>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
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
                //ads>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
              ],
            ),
          ),
        ),
      ),
    );
  }

  _share() async {
    PackageInfo pi = await PackageInfo.fromPlatform();
    Share.share(
        "Reading Ebook for free on ${pi.appName} '\n Dowload now : https://play.google.com/store/apps/details?id=${pi.packageName}");
  }

  imageFromGallery() async {
    var imgFromGallery = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxHeight: 100,
        maxWidth: 100);
    setState(() {
      if (imgFromGallery != null) {
        _file = File(imgFromGallery.path);
      } else {
        print("This file don't have any data");
      }
    });
  }

  imageFromCamera() async {
    var imageFromCamera = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
        maxHeight: 100,
        maxWidth: 100);
    setState(() {
      if (imageFromCamera != null) {
        _file = File(imageFromCamera.path);
      } else {
        print("This file don't have any data");
      }
    });
  }

  void imagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.library_add,
                    color: Colors.blue,
                  ),
                  title: Text(
                    'Sellect photo fro Gallery',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: () {
                    imageFromGallery();
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.camera,
                    color: Colors.blue,
                  ),
                  title: Text(
                    'Photo from camera',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: () {
                    imageFromCamera();
                  },
                )
              ],
            ),
          );
        });
  }

  void _launchURL() async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }
}
