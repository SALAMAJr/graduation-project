abstract class SocketService {
  /// فتح الاتصال بالسيرفر
  void connect();

  /// الاستماع لقائمة المحادثات
  void getChatList(Function(List<Map<String, dynamic>>) onData);

  /// إرسال رسالة لغرفة معينة
  void sendMessage(Map<String, dynamic> message);

  /// الاستماع للرسائل الجديدة
  void onMessage(Function(Map<String, dynamic>) callback);

  /// قفل الاتصال
  void dispose();
}
