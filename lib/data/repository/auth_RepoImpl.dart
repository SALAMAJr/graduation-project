import 'package:dartz/dartz.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/api_services/api_sevice.dart';
import 'package:furniswap/data/models/auth/login_response/login_response.dart';
import 'package:furniswap/data/models/auth/signup_response/register.response.dart';
import 'package:furniswap/data/repository/auth_repo.dart';

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
  Future<Either<Failure, String>> verifyOtp(
      {required String email, required String otp}) async {
    try {
      final response = await apiService.post(
          endPoint: '/auth/otp/verify', data: {"email": email, "otp": otp});
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
}
