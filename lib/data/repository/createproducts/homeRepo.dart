import 'package:dartz/dartz.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/models/createproduct/HomeModel%20.dart';

abstract class HomeRepo {
  Future<Either<Failure, List<HomeModel>>> getHomeProducts({
    int page,
    int limit,
  });
}
