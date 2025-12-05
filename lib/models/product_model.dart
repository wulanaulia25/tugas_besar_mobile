class ProductModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String image;
  final Rating rating;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
    required this.rating,
  });

  /// Membuat instance dari JSON dengan parsing aman
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] is String
          ? int.tryParse(json['id']) ?? 0
          : json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] is String
          ? double.tryParse(json['price']) ?? 0.0
          : (json['price'] != null ? (json['price'] as num).toDouble() : 0.0),
      category: json['category'] ?? 'Unknown',
      image: json['image'] ?? '',
      rating: json['rating'] != null
          ? Rating.fromJson(json['rating'])
          : Rating(rate: 0.0, count: 0),
    );
  }

  /// Mengubah instance menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'image': image,
      'rating': rating.toJson(),
    };
  }
}

class Rating {
  final double rate;
  final int count;

  Rating({
    required this.rate,
    required this.count,
  });

  /// Membuat instance dari JSON dengan aman
  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: json['rate'] != null
          ? (json['rate'] is String
              ? double.tryParse(json['rate']) ?? 0.0
              : (json['rate'] as num).toDouble())
          : 0.0,
      count: json['count'] is int
          ? json['count']
          : int.tryParse(json['count']?.toString() ?? '0') ?? 0,
    );
  }

  /// Mengubah instance menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'count': count,
    };
  }
}
