import 'dart:convert';

class Blog {
  int? id;
  String? title;
  String? title_sub;
  String? category;
  String? description;
  String? image_url;
  DateTime? created_at;

  Blog({this.id, this.title, this.title_sub, this.category, this.description, this.image_url, this.created_at});
  factory Blog.fromJson(Map<String, dynamic> map) {
    return Blog(
        id: map["id"], title: map["title"], title_sub: map["title_sub"], category: map["category"], description: map["description"], image_url: map["image_url"], created_at: DateTime.parse(map["created_at"]));
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "title": title, "title_sub": title_sub, "category": category, "description": description, "image_url": image_url, "created_at": created_at?.toIso8601String()};
  }

  @override
  String toString() {
    return 'Blog{id: $id, title: $title, title_sub: $title_sub, category: $category, description: $description, image_url: $image_url, created_at: $created_at}';
  }
}

List<Blog> blogFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Blog>.from((data as List).map((item) => Blog.fromJson(item)));
}

String blogToJson(Blog data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
