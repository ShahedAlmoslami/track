import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantModel {
  final String id;     // restaurantId = doc.id داخل cities/{cityId}/restaurants/{restaurantId}
  final String cityId;

  final String name;
  final String imageUrl;
  final double rating;
  final int? reviews;
  final List<String>? cuisines;   // مثال: ["Egyptian","Italian"]
  final List<String>? imageList;

  const RestaurantModel({
    required this.id,
    required this.cityId,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    this.cuisines,
    this.imageList,
  });

  factory RestaurantModel.fromFirestore({
    required String cityId,
    required DocumentSnapshot<Map<String, dynamic>> doc,
  }) {
    final data = doc.data() ?? {};
    return RestaurantModel(
      id: doc.id,
      cityId: cityId,
      name: (data['name'] ?? '') as String,
      imageUrl: (data['imageUrl'] ?? '') as String,
      rating: (data['rating'] ?? 0).toDouble(),
      reviews: data['reviews'] == null ? null : (data['reviews'] as num).toInt(),
      cuisines: (data['cuisines'] as List?)?.map((e) => e.toString()).toList(),
      imageList: (data['imageList'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'imageUrl': imageUrl,
        'rating': rating,
        'reviews': reviews,
        'cuisines': cuisines,
        'imageList': imageList,
      };
}