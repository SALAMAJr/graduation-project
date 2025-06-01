import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:furniswap/data/models/auth/reset_password/ResetPasswordRequestModel.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/repository/auth_repo.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final AuthRepo authRepo;

  ResetPasswordCubit(this.authRepo) : super(ResetPasswordInitial());

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    emit(ResetPasswordLoading());

    final result = await authRepo.resetPassword(
      ResetPasswordRequestModel(
        email: email,
        otp: otp,
        newPassword: newPassword,
      ),
    );

    result.fold(
      (failure) {
        final message =
            failure is ServerFailure ? failure.message : 'Something went wrong';
        emit(ResetPasswordFailure(message));
      },
      (response) {
        emit(ResetPasswordSuccess(response.message));
      },
    );
  }
}
