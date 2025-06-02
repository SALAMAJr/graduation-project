import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/api_services/api_service.dart';
import 'package:furniswap/data/models/UserModel/UserModel.dart';
import 'package:furniswap/data/models/UserModel/UpdateUserRequestModel.dart';
import 'package:furniswap/data/repository/UseDetails/UserModelRepo.dart';

class UserRepoImpl implements UserRepo {
  final ApiService apiService;

  UserRepoImpl(this.apiService);

  @override
  Future<Either<Failure, UserModel>> getUserData() async {
    try {
      final token = await Hive.box('authBox').get('auth_token');
      print("🪪 Token: $token");

      final response = await apiService.get(
        endPoint: '/user/getUserDetails',
        headers: {'Authorization': 'Bearer $token'},
      );

      print("✅ Raw API Response: $response");

      final user = UserModel.fromJson(response);
      return Right(user);
    } on DioException catch (e) {
      print("❌ DioException in getUserData:");
      print("📄 Message: ${e.message}");
      print("📊 Status Code: ${e.response?.statusCode}");
      print("📄 Response Data: ${e.response?.data}");
      print("📎 Full Response: ${e.response}");
      return Left(ServerFailure(
        message:
            e.response?.data?.toString() ?? e.message ?? "Unknown Dio error",
      ));
    } catch (e) {
      print("❌ Unknown error in getUserData: $e");
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateUser(
    UpdateUserRequestModel data, {
    File? imageFile,
  }) async {
    try {
      final token = await Hive.box('authBox').get('auth_token');
      print("🛠 Updating User with token: $token");

      final response = await apiService.patchMultipart(
        endPoint: '/user/updateUserDetails',
        data: data.toJson(),
        file: imageFile,
        headers: {'Authorization': 'Bearer $token'},
      );

      print("✅ Update Response: $response");

      final user = UserModel.fromJson(response['data']);
      return Right(user);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure(
          message: e.response?.data.toString() ?? "Unknown Dio error",
        ));
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
