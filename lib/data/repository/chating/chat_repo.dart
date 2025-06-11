import 'package:dartz/dartz.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/models/socketModel/ReceiverModel.dart';
import 'package:furniswap/data/models/socketModel/SimpleChatModel.dart';
import 'package:furniswap/data/models/socketModel/chatData.dart';

abstract class ChatRepo {
  Future<Either<Failure, Unit>> connect();
  Future<Either<Failure, Unit>> sendMessage(ChatMessage message);
  Stream<ChatMessage> onMessage();
  void disconnect();
  Future<Either<Failure, List<SimpleChatModel>>> getMyChats();

  Future<Either<Failure, ChatData>> getOrCreateChat(String recepientId);
  Future<Either<Failure, ReceiverModel>> getReceiverInfo(String receiverId);
}
