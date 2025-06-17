part of 'image_search_cubit.dart';

abstract class ImageSearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ImageSearchInitial extends ImageSearchState {}

class ImageSearchLoading extends ImageSearchState {}

class ImageSearchSuccess extends ImageSearchState {
  final List<ImageSearchResultModel> results;
  ImageSearchSuccess(this.results);

  @override
  List<Object?> get props => [results];
}

class ImageSearchFailure extends ImageSearchState {
  final String message;
  ImageSearchFailure(this.message);

  @override
  List<Object?> get props => [message];
}
