import 'product_data.dart';

class ProductResponseModel {
  final String status;
  final String message;
  final ProductData data;

  ProductResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: ProductData.fromJson(json['data']),
    );
  }
}
