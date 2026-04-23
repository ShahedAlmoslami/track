import 'package:cloud_firestore/cloud_firestore.dart';

class HotelModel {
  final String id;     // hotelId = doc.id داخل cities/{cityId}/hotels/{hotelId}
  final String cityId;

  final String name;
  final String imageUrl;
  final double rating;
  final int? reviews;
  final double priceFrom;
  final String currency;
  final int? stars;
  final List<String>? imageList;

  const HotelModel({
    required this.id,
    required this.cityId,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.priceFrom,
    required this.currency,
    this.stars,
    this.imageList,
  });

  factory HotelModel.fromJson({
    required String cityId,
    required DocumentSnapshot<Map<String, dynamic>> doc,
  }) {
    final data = doc.data() ?? {};
    return HotelModel(
      id: doc.id,
      cityId: cityId,
      name: (data['name'] ?? '') as String,
      imageUrl: (data['imageUrl'] ?? '') as String,
      rating: (data['rating'] ?? 0).toDouble(),
      reviews: data['reviews'] == null ? null : (data['reviews'] as num).toInt(),
      priceFrom: (data['priceFrom'] ?? 0).toDouble(),
      currency: (data['currency'] ?? 'EGP') as String,
      stars: data['stars'] == null ? null : (data['stars'] as num).toInt(),
      imageList: (data['imageList'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'imageUrl': imageUrl,
        'rating': rating,
        'reviews': reviews,
        'priceFrom': priceFrom,
        'currency': currency,
        'stars': stars,
        'imageList': imageList,
      };
}