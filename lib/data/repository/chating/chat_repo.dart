import 'package:dartz/dartz.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/models/socketModel/chat_message_model.dart';

abstract class ChatRepo {
  Future<Either<Failure, Unit>> connect();
  Future<Either<Failure, Unit>> sendMessage(ChatMessageModel message);
  Stream<ChatMessageModel> onMessage();
  void disconnect();
}
