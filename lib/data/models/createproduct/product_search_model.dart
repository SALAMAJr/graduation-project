import 'package:furniswap/data/models/UserModel/UserModel.dart';
import 'package:furniswap/data/models/createproduct/product_item.dart';

class ProductSearchModel extends ProductItem {
  final bool isFeatured;
  final String? location;
  final DateTime createdAt;
  final UserModel? user; // خليها nullable

  ProductSearchModel({
    required super.id,
    required super.name,
    required super.price,
    required super.description,
    required super.imageUrl,
    required super.type,
    required super.condition,
    required super.status,
    required super.category,
    required super.userId,
    required this.isFeatured,
    required this.location,
    required this.createdAt,
    this.user,
  });

  factory ProductSearchModel.fromJson(Map<String, dynamic> json) {
    return ProductSearchModel(
      id: json['id'],
      name: json['name'],
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'],
      imageUrl: json['imageUrl'],
      type: json['type'],
      condition: json['condition'],
      status: json['status'],
      category: json['category'],
      userId: json['user']?['id'] ?? '', // جاي من الـ ProductItem
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
      'userId': userId,
      'isFeatured': isFeatured,
      'location': location,
      'createdAt': createdAt.toIso8601String(),
      'user': user?.toJson(),
    };
  }
}
