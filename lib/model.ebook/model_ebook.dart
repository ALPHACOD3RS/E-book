//import 'dart:html';

import 'package:json_annotation/json_annotation.dart';
part 'model_ebook.g.dart';

@JsonSerializable()
class modelEbook {
  int id;
  String title;
  String photo;
  String description;
  int catId;
  int statusNews;
  String pdf;
  String date;
  String authorName;
  String publisherName;
  int pages;
  String language;
  int rating;
  int free;

  modelEbook({
    required this.id,
    required this.title,
    required this.photo,
    required this.description,
    required this.catId,
    required this.statusNews,
    required this.pdf,
    required this.date,
    required this.authorName,
    required this.publisherName,
    required this.pages,
    required this.language,
    required this.rating,
    required this.free,
  });

  factory modelEbook.freeJson(Map<String, dynamic> json) =>
      _$modelEbookFromJson(json);

  Map<String, dynamic> toJson() => _$modelEbookToJson(this);
}
