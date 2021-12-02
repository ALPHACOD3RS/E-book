import 'package:card_swiper/card_swiper.dart';
import 'package:ebookapp/controller/con_coming.dart';
import 'package:ebookapp/controller/con_latest.dart';
import 'package:ebookapp/controller/con_slider.dart';
import 'package:ebookapp/model/ebook/model_ebook.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sizer/sizer.dart';

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

  @override
  void initState() {
    super.initState();
    getSlider = featchSlider(listSlider);
    getLatest = featchLatest(listlatest);
    getComing = featchComing(listComing);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: getSlider,
            builder: (BuildContext context,
                AsyncSnapshot<List<ModelEbook>> snapshot) {
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
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {},
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
                                              alignment: Alignment.bottomCenter,
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

                    //latest ebook
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
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        print(
                                            "what is index $index and snapshot ${snapshot.data!.length}");
                                        if (index == snapshot.data!.length) {
                                          return GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              width: 24.w,
                                              padding:
                                                  EdgeInsets.only(top: 15.w),
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
                                            onTap: () {},
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              child: Column(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                      listlatest[index].photo,
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
                                                      listlatest[index].title,
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      }),
                                  height: 22.h,
                                )
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                    //ads here

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
                                                  left: 12.h, top: 6.h),
                                              child: const Text(
                                                'Coming Soon',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 35,
                                                    letterSpacing: 6),

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
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return GestureDetector(
                                                onTap: () {},
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
                                                        width: 24.w,
                                                        child: Text(
                                                          listComing[index]
                                                              .title,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          height: 24.h,
                                        )
                                      ],
                                    ),
                                  );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    )
                    //catagory
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
            },
          ),
        ),
      ),
    );
  }
}
