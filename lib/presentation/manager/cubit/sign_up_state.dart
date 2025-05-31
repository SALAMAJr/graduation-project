part of 'sign_up_cubit.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();
  @override
  List<Object?> get props => [];
}

final class SignUpInitial extends SignUpState {}

final class SignUpLoading extends SignUpState {}

final class SignUpSuccess extends SignUpState {
  final Register register;
  const SignUpSuccess(this.register);
  @override
  List<Object?> get props => [register];
}

final class SignUpFailure extends SignUpState {
  final String errorMessage;
  const SignUpFailure(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}

final class OtpVerifiedSuccess extends SignUpState {
  final String message;
  const OtpVerifiedSuccess(this.message);
  @override
  List<Object?> get props => [message];
}
