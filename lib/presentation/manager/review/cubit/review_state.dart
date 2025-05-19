part of 'review_cubit.dart';

sealed class ReviewState extends Equatable {
  const ReviewState();
  @override
  List<Object?> get props => [];
}

final class ReviewInitial extends ReviewState {}

final class ReviewLoading extends ReviewState {}

final class ReviewSuccess extends ReviewState {
  final model.Review review;
  const ReviewSuccess(this.review);

  @override
  List<Object?> get props => [review];
}

final class ReviewFailure extends ReviewState {
  final String errorMessage;
  const ReviewFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
