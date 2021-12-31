import 'package:dio/dio.dart';
import 'package:ebookapp/controller/api.dart';
import 'package:ebookapp/widget/common_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

saveToFavorite(
    {required BuildContext context,
    required String idCourse,
    required String idUser}) async {
  var data = {'id_course': idCourse, 'id_user': idUser};
  var req = await Dio()
      .post(ApiConstant().baseUrl + ApiConstant().saveFavorite, data: data);
  var checkFav = await Dio()
      .post(ApiConstant().baseUrl + ApiConstant().checkFavorite, data: data);

  if (req.data == "success") {
    await Alert(
        context: context,
        type: AlertType.success,
        onWillPopActive: true,
        title: 'Added to Favorite',
        desc: 'This Ebook was added to your Favorite',
        style: const AlertStyle(
          animationType: AnimationType.fromBottom,
          backgroundColor: Colors.white,
          titleStyle: TextStyle(color: Colors.black),
          descStyle: TextStyle(color: Colors.black54),
        ),
        buttons: [
          DialogButton(
            padding: EdgeInsets.all(1),
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: Colors.blueAccent, width: 1)),
              child: Center(
                child: Text(
                  'Okay',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            onPressed: () {
              //add save to favorite
              Navigator.pop(context);
              saveFavoriteEbook(checkFav.data);
            },
            width: 100,
          )
        ]).show();
  } else {
    await Alert(
        context: context,
        type: AlertType.warning,
        onWillPopActive: true,
        title: 'Delete from Favorite',
        desc: 'This Ebook was delete from your Favorite',
        style: AlertStyle(
          animationType: AnimationType.fromBottom,
          backgroundColor: Colors.white,
          titleStyle: TextStyle(color: Colors.black),
          descStyle: TextStyle(color: Colors.black54),
        ),
        buttons: [
          DialogButton(
            padding: EdgeInsets.all(1),
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: Colors.blueAccent, width: 1)),
              child: Center(
                child: Text(
                  'Okay',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              saveFavoriteEbook(checkFav.data);
            },
            width: 100,
          )
        ]).show();
  }
}
