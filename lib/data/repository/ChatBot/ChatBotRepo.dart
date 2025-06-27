import 'package:dartz/dartz.dart';
import 'package:furniswap/data/models/cahtBot/ChatBotMessage.dart';
import '../../../core/errors/failures.dart';

abstract class ChatBotRepo {
  Future<Either<Failure, ChatBotMessage>> sendMessage(String message);
}
