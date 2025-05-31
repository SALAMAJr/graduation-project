import 'package:dartz/dartz.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/api_services/api_service.dart';
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

      if (product.imageFile != null) {
        print("📁 Image file path: ${product.imageFile!.path}");
      } else {
        print("⚠️ Warning: No image file provided.");
      }

      final token = await Hive.box('authBox').get('auth_token');
      print("🪪 Token: $token");

      final response = await apiService.postMultipart(
        endPoint: '/product/create',
        data: data,
        file: product.imageFile!,
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

  @override
  Future<Either<Failure, List<ProductItem>>> getMyProducts() async {
    try {
      final token = await Hive.box('authBox').get('auth_token');
      print("🔐 Fetching my products with token: $token");

      final response = await apiService.get(
        endPoint: '/product/availableProducts',
        headers: {'Authorization': 'Bearer $token'},
      );

      print("✅ Products API Response: ${response['data']}");

      // ✅ تأمين ضد null
      final List productsJson = response['data']?['products'] ?? [];

      final products =
          productsJson.map((json) => ProductItem.fromJson(json)).toList();

      return Right(products);
    } catch (e) {
      if (e is DioException) {
        print("❌ DioException caught while fetching products:");
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

  @override
  Future<Either<Failure, ProductItem>> updateProduct(
      ProductEntity product) async {
    try {
      final data = ProductModel.fromEntity(product);
      final token = await Hive.box('authBox').get('auth_token');

      print("🛠 Updating product ID: ${product.id}");
      print("🔐 Token: $token");
      print("📦 Data: $data");

      final response = await apiService.patchMultipart(
        endPoint: '/product/update/${product.id}',
        data: data,
        file: product.imageFile,
        headers: {'Authorization': 'Bearer $token'},
      );

      print("✅ Product updated successfully");
      print("📨 Updated Product: ${response['data']['updatedProduct']}");

      final updatedProduct =
          ProductItem.fromJson(response['data']['updatedProduct']);

      return Right(updatedProduct);
    } catch (e) {
      if (e is DioException) {
        print("❌ DioException caught while updating product:");
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

  @override
  Future<Either<Failure, Unit>> deleteProduct(String productId) async {
    try {
      final token = await Hive.box('authBox').get('auth_token');
      print("🗑️ Deleting product ID: $productId");
      print("🔐 Token: $token");

      final response = await apiService.delete(
        endPoint: '/product/delete/$productId',
        headers: {'Authorization': 'Bearer $token'},
      );

      print("✅ Product deleted successfully");

      return Right(unit);
    } catch (e) {
      if (e is DioException) {
        print("❌ DioException caught while deleting product:");
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
