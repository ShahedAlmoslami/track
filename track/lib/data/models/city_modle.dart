// city_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class CityModel {
  final String? id;
  final String name;
  final String coverImage;
  final String? description;
  final bool isActive;
  final Timestamp? createdAt;
  final List<String> imageList;

  const CityModel({
    this.id,
    required this.name,
    this.coverImage = '',
    this.description,
    this.isActive = true,
    this.createdAt,
    this.imageList = const [],
  });

  factory CityModel.fromJson(Map<String, dynamic> map) {
    return CityModel(
      id: map['id']?.toString(),
      name: map['name']?.toString() ?? '',
      coverImage: map['coverImage']?.toString() ?? '',
      description: map['description']?.toString(),
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt'] as Timestamp?,
      imageList: List<String>.from(map['imageList'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'coverImage': coverImage,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt,
      'imageList': imageList,
    };
  }

  CityModel copyWith({
    String? id,
    String? name,
    String? coverImage,
    String? description,
    bool? isActive,
    Timestamp? createdAt,
    List<String>? imageList,
  }) {
    return CityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      coverImage: coverImage ?? this.coverImage,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      imageList: imageList ?? this.imageList,
    );
  }
}