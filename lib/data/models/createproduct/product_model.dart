import 'package:furniswap/data/models/createproduct/product_entity.dart';

class ProductModel {
  static Map<String, dynamic> fromEntity(ProductEntity entity) {
    return {
      "name": entity.name,
      "price": entity.price.toInt().toString(), // ✅ لو الـ API عايزه String
      "imageUrl": entity.imageUrl ?? "",
      "description": entity.description,
      "condition": entity.condition,
      "type": entity.type,
      "status": entity.status,
      "category": entity.category,
      "location": entity.location,
    };
  }
}
