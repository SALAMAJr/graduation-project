import 'package:furniswap/data/models/UserModel/UserModel.dart';

class ProductSearchModel {
  final String id;
  final String name;
  final int price;
  final String description;
  final String imageUrl;
  final String type;
  final String condition;
  final String status;
  final String category;
  final bool isFeatured;
  final String? location;
  final DateTime createdAt;
  final UserModel? user; // خليها nullable

  ProductSearchModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.type,
    required this.condition,
    required this.status,
    required this.category,
    required this.isFeatured,
    required this.location,
    required this.createdAt,
    this.user, // nullable هنا
  });

  factory ProductSearchModel.fromJson(Map<String, dynamic> json) {
    return ProductSearchModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      type: json['type'],
      condition: json['condition'],
      status: json['status'],
      category: json['category'],
      isFeatured: json['isFeatured'] == true,
      location: json['location'],
      createdAt: DateTime.parse(json['createdAt']),
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'type': type,
      'condition': condition,
      'status': status,
      'category': category,
      'isFeatured': isFeatured,
      'location': location,
      'createdAt': createdAt.toIso8601String(),
      'user': user?.toJson(), // استخدم ?. هنا
    };
  }
}
