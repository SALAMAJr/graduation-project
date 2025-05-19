import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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

    result.fold(
      (failure) => emit(LoginFailure(
          failure is ServerFailure ? failure.message : 'Login Failed')),
      (loginResponse) => emit(LoginSuccess(loginResponse)),
    );
  }
}
