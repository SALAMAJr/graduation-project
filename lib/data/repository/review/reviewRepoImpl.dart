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

      final responseData = response['data'];

      // هنا الشيك المهم!
      if (responseData is Map<String, dynamic>) {
        final reviews = responseData.values
            .where((reviewJson) => reviewJson != null)
            .map((reviewJson) => ReviewModel.fromJson(reviewJson))
            .toList();

        return Right(reviews);
      } else {
        // مفيش داتا خالص أو راجعة فاضية
        return Right(<ReviewModel>[]);
      }
    } catch (e, stackTrace) {
      // كود الكاتش زي ما هو عندك
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

  @override
  Future<Either<Failure, ReviewModel>> updateReview({
    required String reviewId,
    required int rating,
    required String comment,
  }) async {
    try {
      final token = await Hive.box('authBox').get('auth_token');
      final response = await apiService.patch(
        endPoint: '/review/update/$reviewId',
        data: {
          "rating": rating,
          "comment": comment,
        },
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      final updatedReview = ReviewModel.fromJson(response['data']);
      return Right(updatedReview);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
