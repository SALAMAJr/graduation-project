import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/api_services/api_service.dart';
import 'package:furniswap/data/models/adress/address_model.dart';
import 'package:furniswap/data/repository/Adress/address_repo.dart';
import 'package:hive/hive.dart';

class AddressRepoImpl implements AddressRepo {
  final ApiService apiService;

  AddressRepoImpl(this.apiService);

  @override
  Future<Either<Failure, AddressModel>> createAddress(
      AddressModel address) async {
    try {
      final token = await Hive.box('authBox').get('auth_token');
      print("🏠 Creating address...");
      print("📦 Address Body: ${address.toJson()}");
      print("🔐 Token: $token");

      final response = await apiService.post(
        endPoint: '/address/create',
        data: address.toJson(),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print("✅ Address Created Response: $response");

      final savedAddress = AddressModel.fromJson(response['savedAddress']);
      return Right(savedAddress);
    } catch (e, stackTrace) {
      return _handleDioException<AddressModel>(e, stackTrace,
          context: 'creation');
    }
  }

  @override
  Future<Either<Failure, List<AddressModel>>> getAllAddresses() async {
    try {
      final token = await Hive.box('authBox').get('auth_token');
      final response = await apiService.get(
        endPoint: '/address/get',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final List<dynamic> addressesJson = response['addresses'];
      final addresses =
          addressesJson.map((json) => AddressModel.fromJson(json)).toList();

      return Right(addresses);
    } catch (e, stackTrace) {
      return _handleDioException<List<AddressModel>>(e, stackTrace,
          context: 'fetching');
    }
  }

  Either<Failure, T> _handleDioException<T>(
    Object e,
    StackTrace stack, {
    required String context,
  }) {
    if (e is DioException) {
      final responseData = e.response?.data;
      String errorMessage = "Unknown server error";

      if (responseData is Map) {
        errorMessage = responseData['error'] ??
            responseData['details'] ??
            responseData['message'] ??
            "Unknown server error";
      } else if (responseData is String) {
        errorMessage = responseData;
      }

      print("❌ DioException caught during address $context:");
      print("📡 Status Code: ${e.response?.statusCode}");
      print("📨 Response Body: ${e.response?.data}");
      print("📃 Error Message: ${e.message}");
      print("🧨 Extracted Error: $errorMessage");
      print("📌 StackTrace: $stack");

      return Left(ServerFailure(message: errorMessage));
    }

    print("❌ Unknown Error during address $context: $e");
    print("📌 StackTrace: $stack");
    return Left(ServerFailure(message: e.toString()));
  }
}
