import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:furniswap/core/globals.dart';
import 'package:furniswap/data/repository/socket/socket_service.dart';
import 'package:hive/hive.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:provider/provider.dart';
import 'package:furniswap/core/notification/in_app_notification_provider.dart';
import 'package:furniswap/presentation/screens/messagesDetailsScreen.dart';

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

      // لازم تتأكد الأول إن الداتا Map أصلاً
      if (data is! Map) {
        print('🚨 [SocketServiceImpl] Data is not a Map!');
        return;
      }

      Map<String, dynamic> messageData;
      try {
        messageData = Map<String, dynamic>.from(data);
      } catch (e) {
        print("🚨 [SocketServiceImpl] Error casting data to Map: $e");
        return;
      }

      callback(messageData);

      // Banner notification logic
      try {
        final chatId = messageData['chatId'];
        // ⬅️⬅️⬅️ هنا السطر اللي بتعدل فيه اسم المرسل
        // لو اسم المفتاح مختلف غيره هنا زي ما شرحنا
        final senderName = messageData['senderName'] ?? "User";
        // final senderName = messageData['fromName'] ?? "User"; // لو السيرفر بيرجع من هنا
        final senderId = messageData['senderId'] ?? "";
        final senderImage = messageData['senderImage'] ?? "";
        final messageContent = messageData['content'] ?? "";

        // لو مش فاتح نفس الشات
        if (currentlyOpenedChatId == null || currentlyOpenedChatId != chatId) {
          final context = navigatorKey.currentContext;
          if (context == null) {
            print("🚨 [SocketServiceImpl] context is null, can't show banner.");
            return;
          }

          try {
            Provider.of<InAppNotificationProvider>(context, listen: false)
                .showNotification(
              senderName: senderName,
              message: messageContent,
              imageUrl: senderImage,
              onTap: () {
                try {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MessagesDetailsScreen(
                        receiverId: senderId,
                        chatId: chatId,
                        receiverName: senderName,
                        receiverImage: senderImage,
                      ),
                    ),
                  );
                  Provider.of<InAppNotificationProvider>(context, listen: false)
                      .clear();
                } catch (e) {
                  print('🚨 [SocketServiceImpl] Error navigating to chat: $e');
                }
              },
            );
          } catch (e) {
            print("🚨 [SocketServiceImpl] Provider error: $e");
          }
        }
      } catch (e) {
        print('🚨 [SocketServiceImpl] Banner notification error: $e');
      }
    });
  }

  @override
  void dispose() {
    print("🚫 [SocketServiceImpl] Disposing socket...");
    _socket.dispose();
  }
}
