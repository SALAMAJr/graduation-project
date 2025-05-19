import 'package:dartz/dartz.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/api_services/api_sevice.dart';
import 'package:furniswap/data/models/review/review.dart' as model;
import 'package:furniswap/data/repository/review/review_repo.dart';

class ReviewRepoImpl implements ReviewRepo {
  final ApiService apiService;

  ReviewRepoImpl(this.apiService);

  @override
  Future<Either<Failure, model.Review>> createReview(
      Map<String, dynamic> data) async {
    try {
      final response =
          await apiService.post(endPoint: '/review/create', data: data);
      final review = model.Review.fromJson(response);
      return right(review);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }
}
