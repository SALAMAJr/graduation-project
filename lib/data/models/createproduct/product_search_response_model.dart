import 'product_search_model.dart';

class ProductSearchResponseModel {
  final String status;
  final String message;
  final List<ProductSearchModel> products;

  ProductSearchResponseModel({
    required this.status,
    required this.message,
    required this.products,
  });

  factory ProductSearchResponseModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> productsJson = json['data']['products'];
    final List<ProductSearchModel> products = productsJson
        .map((productJson) => ProductSearchModel.fromJson(productJson))
        .toList();

    return ProductSearchResponseModel(
      status: json['status'],
      message: json['message'],
      products: products,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': {
        'products': products.map((p) => p.toJson()).toList(),
      },
    };
  }
}
