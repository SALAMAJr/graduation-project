import 'dart:io';

class ProductEntity {
  final String? id; // من الـ API
  final String name;
  final double price;
  final File? imageFile; // ✅ خليه اختياري
  final String description;
  final String? imageUrl; // من الـ API
  final String condition; // used / likeNew
  final String type; // buy / repair / swap
  final String status; // active / on_hold / sold
  final String? location; // ✅ جديد
  final String? category; // ✅ جديد

  const ProductEntity({
    this.id,
    required this.name,
    required this.price,
    this.imageFile,
    required this.description,
    this.imageUrl,
    required this.condition,
    required this.type,
    required this.status,
    this.location, // ✅ جديد
    this.category, // ✅ جديد
  });

  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      id: json['id'],
      name: json['name'] ?? '',
      price: (json['price'] as num).toDouble(),
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'],
      condition: json['condition'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      location: json['location'], // ✅ جديد
      category: json['category'], // ✅ جديد
    );
  }
}
