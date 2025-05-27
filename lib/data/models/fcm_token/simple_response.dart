class SimpleResponse {
  final String status;
  final String message;

  SimpleResponse({required this.status, required this.message});

  factory SimpleResponse.fromJson(Map<String, dynamic> json) {
    return SimpleResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}
