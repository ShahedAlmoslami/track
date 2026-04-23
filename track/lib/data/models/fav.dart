import 'dart:convert';

class FavoriteItem {
  final String id;
  final String idS;
  final String title;
  final String image;
  final String type;

  FavoriteItem({
    required this.id,
    required this.title,
    required this.image,
    required this.type,
    required this.idS
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'type': type,
      'idS':idS
    };
  }

  factory FavoriteItem.fromMap(Map<String, dynamic> map) {
    return FavoriteItem(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      image: map['image'] ?? '',
      type: map['type'] ?? '',
            idS: map['idS'] ?? '',

    );
  }

  String toJson() => jsonEncode(toMap());

  factory FavoriteItem.fromJson(String source) {
    return FavoriteItem.fromMap(jsonDecode(source));
  }
}