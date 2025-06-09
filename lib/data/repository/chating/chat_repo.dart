import 'package:dartz/dartz.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/models/socketModel/ChatModel.dart';
import 'package:furniswap/data/models/socketModel/chat_message_model.dart';
import 'package:furniswap/data/models/socketModel/createChatModel.dart';

abstract class ChatRepo {
  Future<Either<Failure, Unit>> connect();
  Future<Either<Failure, Unit>> sendMessage(ChatMessageModel message);
  Stream<ChatMessageModel> onMessage();
  void disconnect();
  Future<Either<Failure, List<ChatModel>>> getMyChats();
  Future<CreateChatModel> createChat(String recipientId);
}
