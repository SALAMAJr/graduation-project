import 'package:dartz/dartz.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/models/revModel/ReviewResponseModel.dart';

abstract class ReviewRepo {
  Future<Either<Failure, ReviewResponseModel>> createReview({
    required int rating,
    required String comment,
    required String productId,
  });
  Future<Either<Failure, List<ReviewModel>>> getUserReviews();
  Future<Either<Failure, ReviewModel>> updateReview({
    required String reviewId,
    required int rating,
    required String comment,
  });
}
