import 'package:dartz/dartz.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/models/review/review.dart' as model;

abstract class ReviewRepo {
  Future<Either<Failure, model.Review>> createReview(Map<String, dynamic> data);
}
