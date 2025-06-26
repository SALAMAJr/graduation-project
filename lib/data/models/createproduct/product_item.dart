class ProductItem {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final String condition;
  final String type;
  final String status;
  final String userId;
  final String? category;

  ProductItem({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.condition,
    required this.type,
    required this.status,
    required this.userId,
    this.category,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      condition: json['condition'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      userId: json['user']?['id'] ?? '',
      category: json['category']?.toString(), // ✅ آمنة 100%
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'condition': condition,
      'type': type,
      'status': status,
      'user': {'id': userId},
      'category': category,
    };
  }
}
