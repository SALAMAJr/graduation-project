import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/api_services/api_service.dart';
import 'package:furniswap/data/models/createproduct/product_search_response_model.dart';
import 'package:furniswap/data/repository/createproducts/product_search_repo.dart';
import 'package:hive/hive.dart';

class ProductSearchRepoImpl implements ProductSearchRepo {
  final ApiService apiService;

  ProductSearchRepoImpl(this.apiService);

  @override
  Future<Either<Failure, ProductSearchResponseModel>> searchProducts({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final token = await Hive.box('authBox').get('auth_token');
      print("🔍 Searching for products with query: '$query'");
      print("🔐 Token: $token");

      final response = await apiService.get(
        endPoint: '/product/search?q=$query&page=$page&limit=$limit',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print("✅ Search API Response: $response");

      final result = ProductSearchResponseModel.fromJson(response);
      print("🔎 Fetched ${result.products.length} products");

      return Right(result);
    } catch (e, stackTrace) {
      if (e is DioException) {
        final responseData = e.response?.data;

        String errorMessage = "Unknown server error";

        if (responseData is Map) {
          errorMessage = responseData['error'] ??
              responseData['details'] ??
              responseData['message'] ??
              "Unknown server error";
        } else if (responseData is String) {
          errorMessage = responseData;
        }

        print("❌ DioException caught during search:");
        print("📡 Status Code: ${e.response?.statusCode}");
        print("📨 Response Body: ${e.response?.data}");
        print("📃 Error Message: ${e.message}");
        print("🧨 Extracted Error: $errorMessage");
        print("📌 StackTrace: $stackTrace");

        return Left(ServerFailure(message: errorMessage));
      }

      print("❌ Unknown Error during product search: $e");
      print("📌 StackTrace: $stackTrace");
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
