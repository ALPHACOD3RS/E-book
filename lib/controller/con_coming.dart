import 'package:dio/dio.dart';
import 'package:ebookapp/controller/api.dart';
import 'package:ebookapp/model/ebook/model_ebook.dart';
import 'package:flutter/widgets.dart';

Future<List<ModelEbook>> featchComing(List<ModelEbook> fetch) async {
  while (true) {
    try {
      var request = await Dio().get(
          ApiConstant().baseUrl + ApiConstant().api + ApiConstant().coming);

      for (Map<String, dynamic> ebook in request.data) {
        fetch.add(ModelEbook(
            id: ebook['id'],
            title: ebook['title'],
            photo: ebook['photo'],
            description: ebook['description'],
            catId: ebook['cat_id'],
            statusNews: ebook['status_news'],
            pdf: ebook['pdf'],
            date: ebook['date'],
            authorName: ebook['author_name'],
            publisherName: ebook['publisher_name'],
            pages: ebook['pages'],
            language: ebook['language'],
            rating: ebook['rating'],
            free: ebook['free']));
        break;
      }
    } catch (e) {
      print('Network problem');
    }
  }

  return fetch;
}
