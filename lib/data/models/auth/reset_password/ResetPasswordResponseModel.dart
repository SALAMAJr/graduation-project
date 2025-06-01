class ResetPasswordResponseModel {
  final String message;
  final String email;

  ResetPasswordResponseModel({
    required this.message,
    required this.email,
  });

  factory ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponseModel(
      message: json["message"],
      email: json["email"],
    );
  }
}
