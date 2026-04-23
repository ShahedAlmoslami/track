import 'package:cloud_firestore/cloud_firestore.dart';

class MenuCategoryModel{
  final String ?id;
  final String restaurantId;
  final String name;
  final String coverImage;
  final bool isActive;
  final Timestamp? createdAt;

  MenuCategoryModel({
     this.id,
    required this.restaurantId,
    required this.name,
    required this.coverImage,
    this.isActive = true,
    this.createdAt,
  });

  factory MenuCategoryModel.fromJson(Map<String, dynamic> map, String docId) {
    return MenuCategoryModel(
      id: docId,
      restaurantId: map['restaurantId'] ?? '',
      name: map['name'] ?? '',
      coverImage: map['coverImage'] ?? '',
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurantId': restaurantId,
      'name': name,
      'coverImage': coverImage,
      'isActive': isActive,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}