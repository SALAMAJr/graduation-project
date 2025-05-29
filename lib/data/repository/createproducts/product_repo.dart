import 'package:dartz/dartz.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/models/createproduct/product_entity.dart';
import 'package:furniswap/data/models/createproduct/product_item.dart';

abstract class ProductRepo {
  Future<Either<Failure, ProductItem>> createProduct(ProductEntity product);
}
