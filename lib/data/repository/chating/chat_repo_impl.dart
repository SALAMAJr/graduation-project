import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/core/network/socket_service.dart';
import 'package:furniswap/data/models/socketModel/chat_message_model.dart';
import 'chat_repo.dart';

class ChatRepoImpl implements ChatRepo {
  final SocketService socketService;

  final _messageController = StreamController<ChatMessageModel>.broadcast();

  ChatRepoImpl(this.socketService);

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
