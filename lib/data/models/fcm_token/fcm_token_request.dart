class FcmTokenRequest {
  final String fcmToken;

  FcmTokenRequest({required this.fcmToken});

  Map<String, dynamic> toJson() {
    return {
      "fcmToken": fcmToken,
    };
  }
}
