import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/models/imageSearch/ImageSearchResultModel.dart';
import 'package:furniswap/data/repository/imageSearch/ImageSearchRepo.dart';

class ImageSearchRepoImpl implements ImageSearchRepo {
  final Dio dio;

  ImageSearchRepoImpl(this.dio);

  @override
  Future<Either<Failure, List<ImageSearchResultModel>>> searchByImage(
      File imageFile) async {
    print('📷 ببدأ عملية البحث بالصور ...');
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path,
            filename: imageFile.path.split('/').last),
      });

      final response = await dio.post(
        'https://mahm0uda21-search-by-image.hf.space/search',
        data: formData,
        options: Options(
          headers: {'Accept': 'application/json'},
          contentType: 'multipart/form-data',
        ),
      );

      print('✅ تم استقبال الاستجابة');
      if (response.statusCode == 200) {
        List data = response.data['results'];
        final results =
            data.map((json) => ImageSearchResultModel.fromJson(json)).toList();
        print('🔎 النتائج: ${results.length}');
        return Right(results.cast<ImageSearchResultModel>());
      } else {
        print('❌ مشكلة في الاستجابة: ${response.statusCode}');
        return Left(ServerFailure(message: 'فشل في جلب النتائج'));
      }
    } catch (e) {
      print('🚨 خطأ اثناء البحث بالصور: $e');
      return Left(ServerFailure(message: toString()));
    }
  }
}
