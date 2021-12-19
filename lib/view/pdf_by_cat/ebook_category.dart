import 'package:ebookapp/controller/con_latest.dart';
import 'package:ebookapp/controller/con_pdf_by_cat.dart';
import 'package:ebookapp/model/ebook/model_ebook.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EbookCategory extends StatefulWidget {
  int catId;
  EbookCategory({required this.catId});
  @override
  _EbookCategoryState createState() => _EbookCategoryState();
}

class _EbookCategoryState extends State<EbookCategory> {
  Future<List<ModelEbook>>? getLatest;
  List<ModelEbook> listlatest = [];

  @override
  void initState() {
    super.initState();
    getLatest = fetchByCategory(listlatest, widget.catId);
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
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            /*child: new Container(
                                child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/log.jpg',
                                    image: listlatest[index].photo)),*/
                            child: Image.network(
                              listlatest[index].photo,
                              fit: BoxFit.cover,
                              height: 16.h,
                              width: 24.w,
                            ),
                          ),
                          SizedBox(
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
      )),
    );
  }
}
