part of 'forgot_password_cubit.dart'; // ✅ لازم ده يكون أول سطر

sealed class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object?> get props => [];
}

final class ForgotPasswordInitial extends ForgotPasswordState {}

final class ForgotPasswordLoading extends ForgotPasswordState {}

final class ForgotPasswordSuccess extends ForgotPasswordState {
  final String email;

  const ForgotPasswordSuccess(this.email);

  @override
  List<Object?> get props => [email];
}

final class ForgotPasswordFailure extends ForgotPasswordState {
  final String message;

  const ForgotPasswordFailure(this.message);

  @override
  List<Object?> get props => [message];
}
