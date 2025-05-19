import 'package:equatable/equatable.dart';

class Register extends Equatable {
  final String? message;
  final String? email;
  final String? token;
  final DateTime? expiresAt;
  final String? accountStatus;

  const Register({
    this.message,
    this.email,
    this.token,
    this.expiresAt,
    this.accountStatus,
  });

  factory Register.fromJson(Map<String, dynamic> json) => Register(
        message: json['message'] as String?,
        email: json['email'] as String?,
        token: json['token'] as String?,
        expiresAt: json['expiresAt'] == null
            ? null
            : DateTime.parse(json['expiresAt'] as String),
        accountStatus: json['accountStatus'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'email': email,
        'token': token,
        'expiresAt': expiresAt?.toIso8601String(),
        'accountStatus': accountStatus,
      };

  @override
  List<Object?> get props => [message, email, token, expiresAt, accountStatus];
}
