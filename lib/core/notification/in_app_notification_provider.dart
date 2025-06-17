import 'package:flutter/material.dart';

class InAppNotificationProvider extends ChangeNotifier {
  String? senderName;
  String? message;
  String? imageUrl;
  VoidCallback? onTap;

  void showNotification(
      {required String senderName,
      required String message,
      String? imageUrl,
      VoidCallback? onTap}) {
    this.senderName = senderName;
    this.message = message;
    this.imageUrl = imageUrl;
    this.onTap = onTap;
    notifyListeners();
  }

  void clear() {
    senderName = null;
    message = null;
    imageUrl = null;
    onTap = null;
    notifyListeners();
  }
}
