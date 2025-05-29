import 'product_item.dart';

class ProductData {
  final ProductItem product;

  ProductData({required this.product});

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      product: ProductItem.fromJson(json['product']),
    );
  }
}
