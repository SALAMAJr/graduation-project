import 'package:furniswap/data/socket/socket_service.dart';
import 'package:hive/hive.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketServiceImpl implements SocketService {
  late IO.Socket _socket;

  @override
  void connect() {
    final userId = Hive.box('authBox').get('user_id');

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

    _socket.onConnect((_) {
      print("✅ Connected to socket server");
    });

    _socket.onDisconnect((_) {
      print("❌ Disconnected from socket server");
    });
  }

  @override
  void getChatList(Function(List<Map<String, dynamic>>) onData) {
    _socket.emit("get_chat_list");
    _socket.on("chat_list", (data) {
      onData(List<Map<String, dynamic>>.from(data));
    });
  }

  @override
  void sendMessage({required String receiverId, required String content}) {
    final message = {
      "receiverId": receiverId,
      "content": content,
    };
    _socket.emit("send_message", message);
  }

  @override
  void onMessage(Function(Map<String, dynamic>) callback) {
    _socket.on("receive_message", (data) {
      callback(Map<String, dynamic>.from(data));
    });
  }

  @override
  void dispose() {
    _socket.dispose();
  }
}
