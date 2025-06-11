import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/models/revModel/ReviewResponseModel.dart';
import 'package:furniswap/data/repository/review/reviewRepo.dart';

part 'update_review_state.dart';

class UpdateReviewCubit extends Cubit<UpdateReviewState> {
  final ReviewRepo reviewRepo;
  UpdateReviewCubit(this.reviewRepo) : super(UpdateReviewInitial());

  Future<void> updateReview({
    required String reviewId,
    required int rating,
    required String comment,
  }) async {
    emit(UpdateReviewLoading());
    final result = await reviewRepo.updateReview(
      reviewId: reviewId,
      rating: rating,
      comment: comment,
    );
    result.fold(
      (failure) {
        String errorMessage = "حدث خطأ غير متوقع";
        // حاول تاخد الرسالة من أي نوع Failure انت عارفه
        if (failure is ServerFailure) {
          errorMessage = failure.message;
        } else if (failure is NetworkFailure) {
          errorMessage = failure.message;
        } else if (failure is UnknownFailure) {
          errorMessage = failure.message;
        }
        emit(UpdateReviewFailure(errorMessage));
      },
      (review) => emit(UpdateReviewSuccess(review)),
    );
  }
}
