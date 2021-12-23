import 'package:dio/dio.dart';
import 'package:ebookapp/controller/api.dart';
import 'package:ebookapp/model/category/model_category.dart';
import 'package:ebookapp/model/ebook/model_ebook.dart';
import 'package:flutter/foundation.dart';

Future<List<ModelCategory>> featchCategory(List<ModelCategory> fetch) async {
  try {
    var request = await Dio().get(
        ApiConstant().baseUrl + ApiConstant().api + ApiConstant().category);

    for (Map<String, dynamic> category in request.data) {
      fetch.add(ModelCategory(
          catId: category['cat_id'],
          photoCat: category['photo_cat'],
          name: category['name'],
          status: category['status']));
    }
  } catch (e) {
    print('Network error!, Please refresh the page');
  }

  return fetch;
}
