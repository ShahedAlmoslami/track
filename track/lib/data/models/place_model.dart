import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceModel {
  final String id;

  final String name;
  final String imageUrl;
  final double rating;
  final int? reviews;
  final double price;
  final String currency;
  final bool isPopular;
  final List<String>? imageList;

  final String? history;
  

  const PlaceModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.currency,
    this.isPopular = false,
    this.imageList,
    this.history, 
  });

  factory PlaceModel.fromJson({
    required String cityId,
    required DocumentSnapshot<Map<String, dynamic>> doc,
  }) {
    final data = doc.data() ?? {};
    return PlaceModel(
      id: doc.id,
      name: (data['name'] ?? '') as String,
      imageUrl: (data['imageUrl'] ?? '') as String,
      rating: (data['rating'] ?? 0).toDouble(),
      reviews: data['reviews'] == null ? null : (data['reviews'] as num).toInt(),
      price: (data['price'] ?? 0).toDouble(),
      currency: (data['currency'] ?? 'EGP') as String,
      isPopular: (data['isPopular'] ?? false) as bool,
      imageList: (data['imageList'] as List?)?.map((e) => e.toString()).toList(),

      
      history: data['history'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'imageUrl': imageUrl,
        'rating': rating,
        'reviews': reviews,
        'price': price,
        'currency': currency,
        'isPopular': isPopular,
        'imageList': imageList,

        
        'history': history,
      };
}