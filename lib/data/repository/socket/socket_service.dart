abstract class SocketService {
  /// فتح الاتصال بالسيرفر
  void connect();

  /// الاستماع لقائمة المحادثات

  /// إرسال رسالة لغرفة معينة
  void sendMessage({required String receiverId, required String content});

  /// الاستماع للرسائل الجديدة
  void onMessage(Function(Map<String, dynamic>) callback);

  /// قفل الاتصال
  void dispose();
}
