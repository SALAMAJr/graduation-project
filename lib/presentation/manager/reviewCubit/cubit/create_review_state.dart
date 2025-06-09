part of 'create_review_cubit.dart';

abstract class CreateReviewState extends Equatable {
  const CreateReviewState();

  @override
  List<Object?> get props => [];
}

class CreateReviewInitial extends CreateReviewState {}

class CreateReviewLoading extends CreateReviewState {}

class CreateReviewSuccess extends CreateReviewState {
  final ReviewResponseModel reviewResponse;

  const CreateReviewSuccess({required this.reviewResponse});

  @override
  List<Object?> get props => [reviewResponse];
}

class CreateReviewFailure extends CreateReviewState {
  final String message;

  const CreateReviewFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
