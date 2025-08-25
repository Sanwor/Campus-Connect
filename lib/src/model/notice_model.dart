class NoticeModel {
  int id;
  String title;
  String content;
  String featuredImage;
  int author;
  DateTime publishedAt;

  NoticeModel({
    required this.id,
    required this.title,
    required this.content,
    required this.featuredImage,
    required this.author,
    required this.publishedAt,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) => NoticeModel(
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
