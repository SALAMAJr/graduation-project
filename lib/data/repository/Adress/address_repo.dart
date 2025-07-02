import 'package:dartz/dartz.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/models/adress/address_model.dart';

abstract class AddressRepo {
  Future<Either<Failure, AddressModel>> createAddress(AddressModel address);
  Future<Either<Failure, List<AddressModel>>> getAllAddresses();
}
