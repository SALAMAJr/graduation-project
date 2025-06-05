import 'package:dartz/dartz.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/models/createproduct/product_search_response_model.dart';

abstract class ProductSearchRepo {
  Future<Either<Failure, ProductSearchResponseModel>> searchProducts({
    required String query,
    int page,
    int limit,
  });
}
