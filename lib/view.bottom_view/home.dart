import 'package:card_swiper/card_swiper.dart';
import 'package:ebookapp/controller/con_ebook.dart';
import 'package:ebookapp/model.ebook/model_ebook.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<ModelEbook>>? getSlider;
  List<ModelEbook> listSlider = [];

  @override
  void initState() {
    super.initState();
    getSlider = featchEbook(listSlider);
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {},
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Container(
                                          child: Stack(
                                            children: [
                                              ClipRect(
                                                child: Image.network(
                                                  listSlider[index].photo,
                                                  fit: BoxFit.cover,
                                                  width: 100.0.w,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    )

                    //latest ebook

                    //ads here

                    //coming soon

                    //catagory
                  ],
                );
              } else {
                //display circular progress indecator
                return Center(
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
