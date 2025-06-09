class ReviewModel {
  final String id;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final ProductModel product;

  ReviewModel({
    required this.id,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.product,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? "",
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? "",
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      product: ProductModel.fromJson(json['product'] ?? {}),
    );
  }
}

class ProductModel {
  final String id;
  final String name;
  final String imageUrl;

  ProductModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      imageUrl: json['imageUrl'] ?? "",
    );
  }
}
