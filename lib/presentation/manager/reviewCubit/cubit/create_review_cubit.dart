import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/models/revModel/ReviewResponseModel.dart';
import 'package:furniswap/data/repository/review/reviewRepo.dart';

part 'create_review_state.dart';

class CreateReviewCubit extends Cubit<CreateReviewState> {
  final ReviewRepo reviewRepo;

  CreateReviewCubit(this.reviewRepo) : super(CreateReviewInitial());

  // لإنشاء ريفيو
  Future<void> createReview({
    required int rating,
    required String comment,
    required String productId,
  }) async {
    emit(CreateReviewLoading());
    final result = await reviewRepo.createReview(
      rating: rating,
      comment: comment,
      productId: productId,
    );

    result.fold(
      (failure) {
        String errorMessage = "حدث خطأ غير متوقع";
        if (failure is ServerFailure)
          errorMessage = failure.message;
        else if (failure is NetworkFailure)
          errorMessage = failure.message;
        else if (failure is UnknownFailure) errorMessage = failure.message;

        emit(CreateReviewFailure(message: errorMessage));
      },
      (reviewResponse) =>
          emit(CreateReviewSuccess(reviewResponse: reviewResponse)),
    );
  }

  // لجلب كل الريفيوز بتاعة اليوزر
}
