import 'package:furniswap/data/models/UserModel/UserModel.dart'; // عدل المسار لو مختلف

class HomeModel {
  final String id;
  final String name;
  final int price;
  final String description;
  final String imageUrl;
  final String type;
  final String condition;
  final String status;
  final String category;
  final String location;
  final DateTime createdAt;
  final String priceType;
  final UserModel? user; // << أضف دي

  HomeModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.type,
    required this.condition,
    required this.status,
    required this.category,
    required this.location,
    required this.createdAt,
    required this.priceType,
    this.user, // << أضف دي
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      type: json['type'] ?? '',
      condition: json['condition'] ?? '',
      status: json['status'] ?? '',
      category: json['category'] ?? '',
      location: json['location'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      priceType: json['priceType'] ?? '',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }
}
