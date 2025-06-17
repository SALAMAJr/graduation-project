import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/models/imageSearch/ImageSearchResultModel.dart';
import 'package:furniswap/data/repository/imageSearch/ImageSearchRepo.dart';

part 'image_search_state.dart';

class ImageSearchCubit extends Cubit<ImageSearchState> {
  final ImageSearchRepo repo;
  ImageSearchCubit(this.repo) : super(ImageSearchInitial());

  Future<void> searchByImage(File imageFile) async {
    emit(ImageSearchLoading());
    final result = await repo.searchByImage(imageFile);
    result.fold(
      (failure) => emit(ImageSearchFailure(
          failure is ServerFailure ? failure.message : "حدث خطأ أثناء البحث")),
      (results) => emit(ImageSearchSuccess(results)),
    );
  }
}
