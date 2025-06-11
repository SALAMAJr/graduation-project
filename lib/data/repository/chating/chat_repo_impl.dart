import 'package:dio/dio.dart';
import 'package:furniswap/data/api_services/api_service.dart';
import 'package:furniswap/data/models/socketModel/ReceiverModel.dart';
import 'package:furniswap/data/models/socketModel/SimpleChatModel.dart';
import 'package:furniswap/data/models/socketModel/chatData.dart';
import 'package:furniswap/data/repository/socket/socket_service.dart';
import 'package:dartz/dartz.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'dart:async';
import 'package:hive/hive.dart';

import 'chat_repo.dart';

class ChatRepoImpl implements ChatRepo {
  final ApiService apiService;
  final SocketService socketService;

  final _messageController = StreamController<ChatMessage>.broadcast();

  ChatRepoImpl(this.apiService, this.socketService);

  @override
  Future<Either<Failure, List<SimpleChatModel>>> getMyChats() async {
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
      final chats = chatsList
          .map((e) => SimpleChatModel.fromJson(e as Map<String, dynamic>))
          .toList();
      print("✅ Fetched ${chats.length} chats.");

      return right(chats);
    } catch (e) {
      print("❌ ERROR IN getMyChats: $e");
      return left(ServerFailure(message: "فشل تحميل المحادثات"));
    }
  }

  @override
  Future<Either<Failure, ChatData>> getOrCreateChat(String recepientId) async {
    try {
      final token = await Hive.box('authBox').get('auth_token');
      print("🔐 Auth token: $token");

      final response = await apiService.post(
        endPoint: '/chat/create',
        data: {'recepientId': recepientId},
        headers: {'Authorization': 'Bearer $token'},
      );

      print("🌐 getOrCreateChat API response: $response");

      if (response['data'] != null) {
        final chatData = ChatData.fromJson(response['data']);
        print("✅ Chat Created/Already Exists: ${chatData.id}");
        return right(chatData);
      } else {
        print("⚠️ مشكلة في الريسبونس");
        return left(ServerFailure(message: response['message'] ?? "حصل مشكلة"));
      }
    } on DioException catch (e) {
      print("❌ ERROR IN getOrCreateChat: $e");
      String msg = e.response?.data['message'] ?? "حصل مشكلة في الشبكة";
      return left(ServerFailure(message: msg));
    } catch (e) {
      print("❌ ERROR IN getOrCreateChat: $e");
      return left(ServerFailure(message: "حصل خطأ غير متوقع"));
    }
  }

  @override
  Future<Either<Failure, Unit>> connect() async {
    try {
      socketService.connect();
      socketService.onMessage((data) {
        final msg = ChatMessage.fromJson(data);
        _messageController.add(msg);
      });
      return right(unit);
    } catch (e) {
      return left(ServerFailure(message: "Failed to connect to socket"));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendMessage(ChatMessage message) async {
    try {
      socketService.sendMessage(
        receiverId: message.message,
        content: message.message,
      );
      return right(unit);
    } catch (e) {
      return left(ServerFailure(message: "Failed to send message"));
    }
  }

  @override
  Stream<ChatMessage> onMessage() => _messageController.stream;

  @override
  void disconnect() {
    socketService.dispose();
    _messageController.close();
  }

  @override
  Future<Either<Failure, ReceiverModel>> getReceiverInfo(
      String receiverId) async {
    try {
      final token = await Hive.box('authBox').get('auth_token');
      final response = await apiService.get(
        endPoint: '/user/getUserDetails/$receiverId',
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response != null) {
        final receiver = ReceiverModel.fromJson(response);
        return right(receiver);
      } else {
        return left(ServerFailure(message: "مفيش بيانات للريسيڤر"));
      }
    } on DioException catch (e) {
      String msg = e.response?.data['message'] ?? "حصل مشكلة في الشبكة";
      return left(ServerFailure(message: msg));
    } catch (e) {
      return left(ServerFailure(message: "حصل خطأ غير متوقع"));
    }
  }
}
