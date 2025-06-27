import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/models/cahtBot/ChatBotMessage.dart';
import 'package:furniswap/data/models/socketModel/chatData.dart';
import 'package:furniswap/data/repository/ChatBot/ChatBotRepo.dart';

class ChatBotRepoImpl implements ChatBotRepo {
  final Dio dio;

  ChatBotRepoImpl(this.dio);

  @override
  Future<Either<Failure, ChatBotMessage>> sendMessage(String message) async {
    print('💬 ببدأ إرسال الرسالة للبوت...');
    try {
      final response = await dio.post(
        'https://mahm0uda21-chatbot.hf.space/chat',
        data: {"query": message},
        options: Options(
          headers: {'Accept': 'application/json'},
          contentType: Headers.jsonContentType,
        ),
      );

      print('✅ استجابة ناجحة من البوت');
      final chatBotMessage = ChatBotMessage.fromJson(response.data);
      return Right(chatBotMessage);
    } catch (e) {
      print('🚨 خطأ أثناء الاتصال بالشات بوت: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
