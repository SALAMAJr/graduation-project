class ImageSearchResultModel {
  final String imgName;
  final ProductImageInfo imgInfo;

  ImageSearchResultModel({required this.imgName, required this.imgInfo});

  factory ImageSearchResultModel.fromJson(Map<String, dynamic> json) {
    return ImageSearchResultModel(
      imgName: json['img_name'] ?? "",
      imgInfo: json['img_info'] != null && (json['img_info'] as Map).isNotEmpty
          ? ProductImageInfo.fromJson(json['img_info'])
          : ProductImageInfo.empty(),
    );
  }
}

class ProductImageInfo {
  final String name;
  final double? price;
  final String? location;
  final String? createdAt;
  final String? imageUrl;
  final String? category;
  final String? description;
  final String? priceType;
  final String? type;
  final String? condition;
  final String? userId;
  final String? id;

  ProductImageInfo({
    required this.name,
    this.price,
    this.location,
    this.createdAt,
    this.imageUrl,
    this.category,
    this.description,
    this.priceType,
    this.type,
    this.condition,
    this.userId,
    this.id,
  });

  factory ProductImageInfo.fromJson(Map<String, dynamic> json) {
    return ProductImageInfo(
      name: json['name'] ?? "",
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] is double)
              ? json['price']
              : null,
      location: json['location'],
      createdAt: json['createdAt'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      description: json['description'],
      priceType: json['priceType'],
      type: json['type'],
      condition: json['condition'],
      userId: json['userId'],
      id: json['id'],
    );
  }

  factory ProductImageInfo.empty() {
    return ProductImageInfo(name: "");
  }
}
