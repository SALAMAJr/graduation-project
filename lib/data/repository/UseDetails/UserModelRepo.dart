import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/models/UserModel/UpdateUserRequestModel.dart';
import 'package:furniswap/data/models/UserModel/UserModel.dart';

abstract class UserRepo {
  Future<Either<Failure, UserModel>> getUserData();

  Future<Either<Failure, UserModel>> updateUser(
    UpdateUserRequestModel data, {
    File? imageFile,
  });
}
