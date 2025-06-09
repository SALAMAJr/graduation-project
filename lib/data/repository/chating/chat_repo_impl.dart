import 'package:furniswap/data/api_services/api_service.dart';
import 'package:furniswap/data/models/socketModel/ChatModel.dart';
import 'package:furniswap/data/models/socketModel/createChatModel.dart';
import 'package:furniswap/data/repository/socket/socket_service.dart';
import 'package:furniswap/data/models/socketModel/chat_message_model.dart';
import 'package:dartz/dartz.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'dart:async';
import 'package:hive/hive.dart';

import 'chat_repo.dart';

class ChatRepoImpl implements ChatRepo {
  final ApiService apiService;
  final SocketService socketService;

  final _messageController = StreamController<ChatMessageModel>.broadcast();

  ChatRepoImpl(this.apiService, this.socketService);

  @override
  Future<Either<Failure, List<ChatModel>>> getMyChats() async {
    try {
      print("🟢 Starting getMyChats()");
      final token = await Hive.box('authBox').get('auth_token');
      print("🔐 Auth token: $token");

      final response = await apiService.get(
        endPoint: '/chat/my-chats',
        headers: {'Authorization': 'Bearer $token'},
      );
      print("🌐 API response: $response");

      final data = response['data'];
      if (data == null) {
        print("⚠️ Data is null");
        return right([]);
      }
      final chatsList = (data as Map<String, dynamic>).values.toList();
      print("🗂️ chatsList: $chatsList");
      final chats = chatsList.map((e) => ChatModel.fromJson(e)).toList();
      print("✅ Fetched ${chats.length} chats.");

      return right(chats);
    } catch (e) {
      print("❌ ERROR IN getMyChats: $e");
      return left(ServerFailure(message: "فشل تحميل المحادثات"));
    }
  }

  @override
  Future<CreateChatModel> createChat(String recipientId) async {
    try {
      print('🚀 [ChatRepoImpl] هعمل شات مع $recipientId');
      final response = await apiService.post(
        endPoint: '/chat/create',
        data: {'recipientId': recipientId},
      );
      print('✅ [ChatRepoImpl] Response جالي: $response');
      final chatJson = response['data'];
      return CreateChatModel.fromJson(chatJson);
    } catch (e, st) {
      print('❌ [ChatRepoImpl] حصل خطأ: $e');
      print(st);
      rethrow;
    }
  }

  // باقي دوال الـ socket
  @override
  Future<Either<Failure, Unit>> connect() async {
    try {
      socketService.connect();
      socketService.onMessage((data) {
        final msg = ChatMessageModel.fromJson(data);
        _messageController.add(msg);
      });
      return right(unit);
    } catch (e) {
      return left(ServerFailure(message: "Failed to connect to socket"));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendMessage(ChatMessageModel message) async {
    try {
      socketService.sendMessage(
        receiverId: message.receiverId,
        content: message.message,
      );
      return right(unit);
    } catch (e) {
      return left(ServerFailure(message: "Failed to send message"));
    }
  }

  @override
  Stream<ChatMessageModel> onMessage() => _messageController.stream;

  @override
  void disconnect() {
    socketService.dispose();
    _messageController.close();
  }
}
