import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:furniswap/data/models/imageSearch/ImageSearchResultModel.dart';
import '../../../core/errors/failures.dart';

abstract class ImageSearchRepo {
  Future<Either<Failure, List<ImageSearchResultModel>>> searchByImage(
      File imageFile);
}
