class ExperienceModel {
  final String? id; // doc id (اختياري)
  final String title;
  final double price;
  final String currency;
  final int? duration;
  final List<String> images;
  final double rating;
  final int reviews;
  final String detailsImages;

  ExperienceModel({
    this.id,
    required this.title,
    required this.price,
    required this.currency,
    this.duration,
    required this.images,
    required this.rating,
    required this.reviews,
    required this.detailsImages 
  });

  Map<String, dynamic> toJson() {
    return {
      "id":id,
      "title": title,
      "price": price,
      "currency": currency,
      "duration": duration,
      "images": images,
      "rating": rating,
      "reviews": reviews,
      "detailsImages": detailsImages,
    };
  }

  factory ExperienceModel.fromJson(String id, Map<String, dynamic> json) {
    return ExperienceModel(
      id: id,
      title: (json["title"] ?? "") as String,
      price: (json["price"] ?? 0).toDouble(),
      currency: (json["currency"] ?? "EGP") as String,
      duration: json["duration"] as int?,
      images: (json["images"] as List?)?.map((e) => e.toString()).toList() ?? const [],
      rating: (json["rating"] ?? 0).toDouble(),
      reviews: (json["reviews"] ?? 0) as int,
      detailsImages: (json["detailsImages"] as String?) ?? "",
    );
  }
}