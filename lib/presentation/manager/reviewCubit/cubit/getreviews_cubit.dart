import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/repository/review/reviewRepo.dart';
import 'package:furniswap/data/models/revModel/ReviewResponseModel.dart';

part 'getreviews_state.dart';

class GetUserReviewsCubit extends Cubit<GetUserReviewsState> {
  final ReviewRepo reviewRepo;

  GetUserReviewsCubit(this.reviewRepo) : super(GetUserReviewsInitial());

  Future<void> getUserReviews() async {
    emit(GetUserReviewsLoading());

    final result = await reviewRepo.getUserReviews();

    result.fold(
      (failure) {
        String errorMessage = "حدث خطأ غير متوقع";
        if (failure is ServerFailure)
          errorMessage = failure.message;
        else if (failure is NetworkFailure)
          errorMessage = failure.message;
        else if (failure is UnknownFailure) errorMessage = failure.message;

        emit(GetUserReviewsFailure(message: errorMessage));
      },
      (reviewsList) {
        emit(GetUserReviewsSuccess(reviews: reviewsList));
      },
    );
  }
}
