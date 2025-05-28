import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:furniswap/data/repository/chating/chat_repo.dart';
import 'package:hive/hive.dart';

import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/models/auth/login_response/login_response.dart';
import 'package:furniswap/data/repository/auth_repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepo authRepo;
  final ChatRepo chatRepo;

  LoginCubit(this.authRepo, this.chatRepo) : super(LoginInitial());

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
        final token = loginResponse.accessToken;
        final userId = loginResponse.id;

        // ✅ تأكد من فتح authBox
        final box = await Hive.openBox('authBox');

        // ✅ 1. خزّن التوكن
        if (token != null && token.isNotEmpty) {
          await box.put('auth_token', token);
          print('🔐 Token saved: $token');
        } else {
          print('⚠️ No access token received!');
        }

        // ✅ 2. خزّن الـ userId
        if (userId != null && userId.isNotEmpty) {
          await box.put('user_id', userId);
          print('🆔 User ID saved to device: $userId');
        } else {
          print('⚠️ No user ID received!');
        }

        // ✅ 3. FCM Token
        final fcmToken = await FirebaseMessaging.instance.getToken();
        print('📲 FCM Token: $fcmToken');

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

        // ✅ 4. توصيل socket
        final socketResult = await chatRepo.connect();
        socketResult.fold(
          (failure) {
            String errorMessage = 'Socket connection failed';

            if (failure is ServerFailure) {
              errorMessage = failure.message;
            } else if (failure is NetworkFailure) {
              errorMessage = failure.message;
            } else if (failure is UnknownFailure) {
              errorMessage = failure.message;
            }

            print('❌ $errorMessage');
          },
          (_) => print("✅ Socket connected after login"),
        );

        // ✅ 5. Success
        emit(LoginSuccess(loginResponse));
      },
    );
  }
}
