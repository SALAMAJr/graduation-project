import 'package:dartz/dartz.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/api_services/api_sevice.dart';
import 'package:furniswap/data/models/createproduct/product_entity.dart';
import 'package:furniswap/data/models/createproduct/product_item.dart';
import 'package:furniswap/data/models/createproduct/product_model.dart';
import 'package:hive/hive.dart';
import 'product_repo.dart';
import 'package:dio/dio.dart';

class ProductRepoImpl implements ProductRepo {
  final ApiService apiService;

  ProductRepoImpl(this.apiService);

  @override
  Future<Either<Failure, ProductItem>> createProduct(
      ProductEntity product) async {
    try {
      final data = ProductModel.fromEntity(product);
      print("📦 Data to be sent:");
      data.forEach((key, value) => print("👉 $key: $value"));

      print("📁 Image file path: ${product.imageFile.path}");

      final token = await Hive.box('authBox').get('auth_token');
      print("🪪 Token: $token");

      final response = await apiService.postMultipart(
        endPoint: '/product/create',
        data: data,
        file: product.imageFile,
        headers: {'Authorization': 'Bearer $token'},
      );

      print("✅ API Response: $response");

      final productItem = ProductItem.fromJson(response['data']['product']);
      print("🎯 Product created: ${productItem.name} (${productItem.id})");

      return Right(productItem);
    } catch (e) {
      if (e is DioException) {
        print("❌ DioException caught:");
        print("📡 Status Code: ${e.response?.statusCode}");
        print("📨 Response Body: ${e.response?.data}");
        print("📃 Error Message: ${e.message}");

        return Left(ServerFailure(
          message: e.response?.data.toString() ?? "Unknown Dio error",
        ));
      }

      print("❌ Unknown Error: $e");
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
