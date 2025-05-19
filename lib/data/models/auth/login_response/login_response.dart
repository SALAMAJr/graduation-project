import 'package:equatable/equatable.dart';

import 'login_user.dart';

class LoginResponse extends Equatable {
  final String? message;
  final User? user;
  final String? username;
  final String? id;
  final String? email;
  final bool? status;
  final bool? isOAuthUser;
  final String? accessToken;

  const LoginResponse({
    this.message,
    this.user,
    this.username,
    this.id,
    this.email,
    this.status,
    this.isOAuthUser,
    this.accessToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        message: json['message'] as String?,
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
        username: json['username'] as String?,
        id: json['id'] as String?,
        email: json['email'] as String?,
        status: json['status'] as bool?,
        isOAuthUser: json['isOAuthUser'] as bool?,
        accessToken: json['access_token'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'user': user?.toJson(),
        'username': username,
        'id': id,
        'email': email,
        'status': status,
        'isOAuthUser': isOAuthUser,
        'access_token': accessToken,
      };

  @override
  List<Object?> get props {
    return [
      message,
      user,
      username,
      id,
      email,
      status,
      isOAuthUser,
      accessToken,
    ];
  }
}
