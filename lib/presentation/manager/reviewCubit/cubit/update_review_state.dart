part of 'update_review_cubit.dart';

abstract class UpdateReviewState extends Equatable {
  const UpdateReviewState();

  @override
  List<Object?> get props => [];
}

class UpdateReviewInitial extends UpdateReviewState {}

class UpdateReviewLoading extends UpdateReviewState {}

class UpdateReviewSuccess extends UpdateReviewState {
  final ReviewModel review;
  const UpdateReviewSuccess(this.review);

  @override
  List<Object?> get props => [review];
}

class UpdateReviewFailure extends UpdateReviewState {
  final String message;
  const UpdateReviewFailure(this.message);

  @override
  List<Object?> get props => [message];
}
