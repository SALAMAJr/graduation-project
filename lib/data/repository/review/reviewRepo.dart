import 'package:dartz/dartz.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/models/revModel/ReviewRequestModel.dart';

abstract class ReviewRepo {
  Future<Either<Failure, Unit>> createReview(ReviewRequestModel review);
}
