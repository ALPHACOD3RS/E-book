import 'package:dio/dio.dart';
import 'package:ebookapp/controller/api.dart';
import 'package:ebookapp/model/ebook/model_ebook.dart';

Future<List<ModelEbook>> fetchByCategory(List<ModelEbook> fetch, int id) async {
  try {
    var request = await Dio().get(ApiConstant().baseUrl +
        ApiConstant().api +
        ApiConstant().pdfByCat +
        id.toString());

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
    }
  } catch (e) {
    print('network error');
  }

  return fetch;
}
