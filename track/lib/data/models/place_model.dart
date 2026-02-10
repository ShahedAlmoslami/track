class PlaceModel {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final int reviews;
  final double price;
  final String currency;
  final String cityId;
  

  PlaceModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.currency,
    required this.cityId,
  });

  /// من Firebase
  factory PlaceModel.fromJson(String id, Map<String, dynamic> json) {
    return PlaceModel(
      id: id,
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviews: json['reviews'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'EGP',
      cityId: json['cityId'] ?? '',
    );
  }

  /// إلى Firebase
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviews': reviews,
      'price': price,
      'currency': currency,
      'cityId': cityId,
    };
  }
}
