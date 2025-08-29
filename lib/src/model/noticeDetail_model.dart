// To parse this JSON data, do
//
//     final noticeDetailsModel = noticeDetailsModelFromJson(jsonString);

import 'dart:convert';

NoticeDetailsModel noticeDetailsModelFromJson(String str) => NoticeDetailsModel.fromJson(json.decode(str));

String noticeDetailsModelToJson(NoticeDetailsModel data) => json.encode(data.toJson());

class NoticeDetailsModel {
    int id;
    String title;
    String content;
    String featuredImage;
    int author;
    DateTime publishedAt;

    NoticeDetailsModel({
        required this.id,
        required this.title,
        required this.content,
        required this.featuredImage,
        required this.author,
        required this.publishedAt,
    });

    factory NoticeDetailsModel.fromJson(Map<String, dynamic> json) => NoticeDetailsModel(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        featuredImage: json["featured_image"],
        author: json["author"],
        publishedAt: DateTime.parse(json["published_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "featured_image": featuredImage,
        "author": author,
        "published_at": publishedAt.toIso8601String(),
    };
}
