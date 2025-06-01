import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/repository/auth_repo.dart';

part 'forgot_password_state.dart'; // ✅ لازم يكون كده بالظبط

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepo authRepo;

  String? _email; // ✅ خزّن الإيميل هنا

  String? get sentEmail => _email; // ✅ getter نستخدمه في الشاشة

  ForgotPasswordCubit(this.authRepo) : super(ForgotPasswordInitial());

  Future<void> sendOtp({required String email}) async {
    emit(ForgotPasswordLoading());

    final result = await authRepo.sendForgotPasswordOtp(email);

    result.fold(
      (failure) {
        final errorMessage =
            failure is ServerFailure ? failure.message : 'Failed to send OTP';
        emit(ForgotPasswordFailure(errorMessage));
      },
      (sentEmail) {
        _email = sentEmail; // ✅ خزّنه هنا
        emit(ForgotPasswordSuccess(sentEmail));
      },
    );
  }
}
