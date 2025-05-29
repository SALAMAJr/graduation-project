import 'dart:io';

class ProductEntity {
  final String name;
  final double price;
  final File imageFile;
  final String description;
  final String? imageUrl;
  final String condition; // used / likeNew
  final String type; // buy / repair / swap
  final String status; // active / on_hold / sold

  const ProductEntity({
    required this.name,
    required this.price,
    required this.imageFile,
    required this.description,
    this.imageUrl,
    required this.condition,
    required this.type,
    required this.status,
  });
}
