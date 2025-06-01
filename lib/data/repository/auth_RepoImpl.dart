import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/api_services/api_service.dart';
import 'package:furniswap/data/models/auth/ResetPasswordRequestModel.dart';
import 'package:furniswap/data/models/auth/ResetPasswordResponseModel.dart';
import 'package:furniswap/data/models/auth/login_response/login_response.dart';
import 'package:furniswap/data/models/auth/signup_response/register.response.dart';
import 'package:furniswap/data/repository/auth_repo.dart';
import 'package:hive/hive.dart';

class AuthRepoImpl implements AuthRepo {
  final ApiService apiService;

  AuthRepoImpl(this.apiService);

  @override
  Future<Either<Failure, Register>> registerUser(
      Map<String, dynamic> data) async {
    try {
      final response =
          await apiService.post(endPoint: '/auth/signup', data: data);
      final register = Register.fromJson(response);
      return right(register);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await apiService.post(
        endPoint: '/auth/otp/verify',
        data: {"email": email, "otp": otp},
      );
      return right(response['message'] ?? 'OTP verified successfully');
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginResponse>> loginUser(
      Map<String, dynamic> data) async {
    try {
      final response =
          await apiService.post(endPoint: '/auth/login', data: data);
      final loginResponse = LoginResponse.fromJson(response);
      return right(loginResponse);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> sendFcmToken(String token) async {
    try {
      final authToken = Hive.box('authBox').get('auth_token');

      final response = await apiService.patch(
        endPoint: '/user/updateFcmToken',
        data: {"fcmToken": token},
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      return right(response['message'] ?? 'FCM token sent successfully');
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> sendForgotPasswordOtp(String email) async {
    try {
      final response = await apiService.post(
        endPoint: '/auth/forgot-password',
        data: {"email": email},
      );

      return right(response['email']);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ResetPasswordResponseModel>> resetPassword(
      ResetPasswordRequestModel model) async {
    try {
      print('🚀 Sending reset password request with: ${model.toJson()}');

      final response = await apiService.patch(
        endPoint: '/auth/reset-password',
        data: model.toJson(),
      );

      print('✅ Response received: $response');

      final result = ResetPasswordResponseModel.fromJson(response);

      print('📦 Parsed model: ${result.message}');

      return right(result);
    } catch (e) {
      if (e is DioException) {
        print('❌ DioException caught:');
        print('📍 URL: ${e.requestOptions.uri}');
        print('📦 Sent Data: ${e.requestOptions.data}');
        print('📄 Response: ${e.response?.data}');
        print('📊 Status Code: ${e.response?.statusCode}');
        print('🧾 Headers: ${e.requestOptions.headers}');
      } else {
        print('❌ Unknown error: $e');
      }

      return left(
        ServerFailure(
            message: "خطأ أثناء إعادة تعيين كلمة المرور: ${e.toString()}"),
      );
    }
  }
}
