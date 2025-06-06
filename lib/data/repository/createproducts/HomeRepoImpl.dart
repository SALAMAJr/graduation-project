import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/api_services/api_service.dart';
import 'package:furniswap/data/models/createproduct/HomeModel%20.dart';
import 'package:furniswap/data/repository/createproducts/homeRepo.dart';
import 'package:hive/hive.dart';

class HomeRepoImpl implements HomeRepo {
  final ApiService apiService;

  HomeRepoImpl(this.apiService);

  @override
  Future<Either<Failure, List<HomeModel>>> getHomeProducts({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final token = await Hive.box('authBox').get('auth_token');
      print("🏠 Fetching home products...");
      print("🔐 Token: $token");

      final response = await apiService.get(
        endPoint: '/product/home?page=$page&limits=$limit',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print("✅ Home Products API Response: $response");

      final productsJson = response['data']['products'] as List;
      final products = productsJson.map((e) => HomeModel.fromJson(e)).toList();
      print("🪑 Fetched ${products.length} home products");

      return Right(products);
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

        print("❌ DioException caught during home products fetch:");
        print("📡 Status Code: ${e.response?.statusCode}");
        print("📨 Response Body: ${e.response?.data}");
        print("📃 Error Message: ${e.message}");
        print("🧨 Extracted Error: $errorMessage");
        print("📌 StackTrace: $stackTrace");

        return Left(ServerFailure(message: errorMessage));
      }

      print("❌ Unknown Error during home products fetch: $e");
      print("📌 StackTrace: $stackTrace");
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
