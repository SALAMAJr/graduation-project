part of 'getreviews_cubit.dart';

abstract class GetUserReviewsState extends Equatable {
  const GetUserReviewsState();

  @override
  List<Object?> get props => [];
}

class GetUserReviewsInitial extends GetUserReviewsState {}

class GetUserReviewsLoading extends GetUserReviewsState {}

class GetUserReviewsSuccess extends GetUserReviewsState {
  final List<ReviewModel> reviews;

  const GetUserReviewsSuccess({required this.reviews});

  @override
  List<Object?> get props => [reviews];
}

class GetUserReviewsFailure extends GetUserReviewsState {
  final String message;

  const GetUserReviewsFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
