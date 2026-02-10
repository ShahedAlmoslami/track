class ExperienceModel {
  final String? id; // id تبع الدوك (اختياري)
  final String title;
  final double price;
  final String currency;
  final int? duration; // اختياري
  final List<String> images;
  final double rating;
  final int reviews; 
    final List<String>? detailsImages;


  ExperienceModel({
    this.id,
    required this.title,
    required this.price,
    required this.currency,
    this.duration,
    required this.images,
    required this.rating,
    required this.reviews,
    this.detailsImages = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "price": price,
      "currency": currency,
      "duration": duration,
      "images": images,
    };
  }

  factory ExperienceModel.fromJson(String id, Map<String, dynamic> json) {
    return ExperienceModel(
      id: id,
      title: (json["title"] ?? "") as String,
      price: (json["price"] as num).toDouble(),
      currency: (json["currency"] ?? "EGP") as String,
      duration: json["duration"] as int?,
      images: List<String>.from(json["images"] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      reviews: json['reviews'] ?? 0,
      detailsImages: List<String>.from(json["detailsImages"] ?? []),
    );
  }
}
