import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/api_services/api_service.dart';
import 'package:furniswap/data/models/revModel/ReviewResponseModel.dart';
import 'package:furniswap/data/repository/review/reviewRepo.dart';

import 'package:hive/hive.dart';

class ReviewRepoImpl implements ReviewRepo {
  final ApiService apiService;

  ReviewRepoImpl(this.apiService);

  @override
  Future<Either<Failure, ReviewResponseModel>> createReview({
    required int rating,
    required String comment,
    required String productId,
  }) async {
    try {
      final token = await Hive.box('authBox').get('auth_token');
      print("✍️ Creating review for product: $productId");
      print("🔐 Token: $token");

      final body = {
        "createReviewDto": {
          "rating": rating,
          "comment": comment,
        },
        "productId": productId,
      };

      final response = await apiService.post(
        endPoint: '/review/create',
        data: body,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print("✅ Review Created Response: $response");

      final result = ReviewResponseModel.fromJson(response);

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

        print("❌ DioException caught during review creation:");
        print("📡 Status Code: ${e.response?.statusCode}");
        print("📨 Response Body: ${e.response?.data}");
        print("📃 Error Message: ${e.message}");
        print("🧨 Extracted Error: $errorMessage");
        print("📌 StackTrace: $stackTrace");

        return Left(ServerFailure(message: errorMessage));
      }

      print("❌ Unknown Error during review creation: $e");
      print("📌 StackTrace: $stackTrace");
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReviewModel>>> getUserReviews() async {
    try {
      final token = await Hive.box('authBox').get('auth_token');
      print("🔎 Getting user reviews...");
      print("🔐 Token: $token");

      final response = await apiService.get(
        endPoint: '/review/userReviews',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print("✅ User Reviews Response: $response");

      // لو الـ data جاية Map زي الصورة اللي بعتها
      final data = response['data'] as Map<String, dynamic>;

      final reviews = data.values
          .map((reviewJson) => ReviewModel.fromJson(reviewJson))
          .toList();

      return Right(reviews);
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

        print("❌ DioException caught during getUserReviews:");
        print("📡 Status Code: ${e.response?.statusCode}");
        print("📨 Response Body: ${e.response?.data}");
        print("📃 Error Message: ${e.message}");
        print("🧨 Extracted Error: $errorMessage");
        print("📌 StackTrace: $stackTrace");

        return Left(ServerFailure(message: errorMessage));
      }

      print("❌ Unknown Error during getUserReviews: $e");
      print("📌 StackTrace: $stackTrace");
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
