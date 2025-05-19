import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/models/review/review.dart' as model;
import 'package:furniswap/data/repository/review/review_repo.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final ReviewRepo reviewRepo;

  ReviewCubit(this.reviewRepo) : super(ReviewInitial());

  Future<void> createReview(Map<String, dynamic> data) async {
    emit(ReviewLoading());

    final Either<Failure, model.Review> result =
        await reviewRepo.createReview(data);

    result.fold(
      (failure) => emit(ReviewFailure(
        failure is ServerFailure ? failure.message : 'Something went wrong',
      )),
      (model.Review review) => emit(ReviewSuccess(review)),
    );
  }
}
