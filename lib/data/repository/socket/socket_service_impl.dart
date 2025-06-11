import 'package:furniswap/data/repository/socket/socket_service.dart';
import 'package:hive/hive.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketServiceImpl implements SocketService {
  late IO.Socket _socket;

  @override
  void connect() {
    final userId = Hive.box('authBox').get('user_id');
    print("🔑 [SocketServiceImpl] Connecting with userId: $userId");

    _socket = IO.io(
      'http://63.177.194.209:3002',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setExtraHeaders({
            'auth': userId,
          })
          .build(),
    );

    print("🟡 [SocketServiceImpl] Trying to connect to socket server...");

    _socket.onConnect((_) {
      print("✅ [SocketServiceImpl] Connected to socket server!");
    });

    _socket.onDisconnect((_) {
      print("❌ [SocketServiceImpl] Disconnected from socket server!");
    });

    _socket.onConnectError((err) {
      print("⛔ [SocketServiceImpl] Connect error: $err");
    });

    _socket.onError((err) {
      print("🔥 [SocketServiceImpl] Socket general error: $err");
    });
  }

  @override
  void sendMessage({required String receiverId, required String content}) {
    final message = {
      "receiverId": receiverId,
      "content": content,
    };
    print("✉️ [SocketServiceImpl] Sending message: $message");
    _socket.emit("message", message);
  }

  @override
  void onMessage(Function(Map<String, dynamic>) callback) {
    print("🟢 [SocketServiceImpl] Registering onMessage listener...");
    _socket.on("message", (data) {
      print("📩 [SocketServiceImpl] New message received: $data");
      callback(Map<String, dynamic>.from(data));
    });
  }

  @override
  void dispose() {
    print("🚫 [SocketServiceImpl] Disposing socket...");
    _socket.dispose();
  }
}
