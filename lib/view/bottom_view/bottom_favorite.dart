import 'package:ebookapp/controller/con_favorite.dart';
import 'package:ebookapp/model/ebook/model_ebook.dart';
import 'package:ebookapp/widget/common_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BottomFavorite extends StatefulWidget {
  @override
  _BottomFavoriteState createState() => _BottomFavoriteState();
}

class _BottomFavoriteState extends State<BottomFavorite> {
  Future<List<ModelEbook>>? getFavorite;
  List<ModelEbook> listFavorite = [];
  String id = '', name = '', email = '', photo = '';

  @override
  void initState() {
    super.initState();
    loadLogin().then((value) {
      setState(() {
        id = value[0];
        name = value[1];
        email = value[2];
        getFavorite = featchFavorite(listFavorite, id);
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
                      onTap: () {},
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
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: 5.5 / 9.0),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
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
