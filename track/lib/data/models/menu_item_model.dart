import 'package:cloud_firestore/cloud_firestore.dart';

class MenuItemModel {
  final String? id;
  final String categoryId;
  final String name;
  final int price;
  final String deshTime;
  final String description;
  final String image;
  final bool isAvailable;
  final Timestamp? createdAt;

  MenuItemModel({
    this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.deshTime,
    required this.description,
    required this.image,
    this.isAvailable = true,
    this.createdAt,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> map, String docId) {
    return MenuItemModel(
      id: docId,
      categoryId: map['categoryId'] ?? '',
      name: map['name'] ?? '',
      price: map['price'] ?? 0,
      deshTime: map['deshTime'] ?? '',
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      createdAt: map['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'name': name,
      'price': price,
      'deshTime': deshTime,
      'description': description,
      'image': image,
      'isAvailable': isAvailable,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  MenuItemModel copyWith({
    String? id,
    String? categoryId,
    String? name,
    int? price,
    String? deshTime,
    String? description,
    String? image,
    bool? isAvailable,
    Timestamp? createdAt,
  }) {
    return MenuItemModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      price: price ?? this.price,
      deshTime: deshTime ?? this.deshTime,
      description: description ?? this.description,
      image: image ?? this.image,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}