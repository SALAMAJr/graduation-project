import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';

import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/models/auth/login_response/login_response.dart';
import 'package:furniswap/data/repository/auth_repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepo authRepo;

  LoginCubit(this.authRepo) : super(LoginInitial());

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());

    final result = await authRepo.loginUser({
      'email': email,
      'password': password,
    });

    await result.fold(
      (failure) async {
        final errorMessage =
            failure is ServerFailure ? failure.message : 'Login Failed';
        emit(LoginFailure(errorMessage));
      },
      (loginResponse) async {
        // ✅ 1. خزّن accessToken في Hive
        final token = loginResponse.accessToken;
        if (token != null && token.isNotEmpty) {
          await Hive.box('authBox').put('auth_token', token);
          print('🔐 Token saved: $token');
        } else {
          print('⚠️ No access token received!');
        }

        // ✅ 2. احصل على FCM Token
        final fcmToken = await FirebaseMessaging.instance.getToken();
        print('📲 FCM Token: $fcmToken');

        // ✅ 3. ابعته للسيرفر (مع التوكن)
        if (fcmToken != null && fcmToken.isNotEmpty) {
          final fcmResult = await authRepo.sendFcmToken(fcmToken);

          fcmResult.fold(
            (fcmFailure) {
              final error = fcmFailure is ServerFailure
                  ? fcmFailure.message
                  : 'Error sending FCM token';
              print('❌ $error');
            },
            (successMsg) => print('✅ FCM Token sent successfully: $successMsg'),
          );
        } else {
          print('⚠️ No FCM token available.');
        }

        // ✅ 4. كمل نجاح الـ login
        emit(LoginSuccess(loginResponse));
      },
    );
  }
}
