import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:furniswap/data/models/cahtBot/ChatBotMessage.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/repository/ChatBot/ChatBotRepo.dart';
import 'chat_bot_state.dart';

class ChatBotCubit extends Cubit<ChatBotState> {
  final ChatBotRepo chatRepo;
  final List<ChatBotMessage> _messages = [];

  ChatBotCubit(this.chatRepo) : super(ChatBotInitial());

  void send(String msg) async {
    // 1. أضف الرسالة المؤقتة
    _messages.add(ChatBotMessage(query: msg, answer: '...'));
    emit(ChatBotLoaded(List.from(_messages)));

    // 2. أرسل الرسالة للبوت
    final Either<Failure, ChatBotMessage> result =
        await chatRepo.sendMessage(msg);

    result.fold(
      (failure) {
        // 3. لو فيه فشل، احذف الرسالة المؤقتة وأضف رسالة خطأ
        _messages.removeLast();
        _messages.add(ChatBotMessage(
            query: msg, answer: '❌ ${_mapFailureToMessage(failure)}'));
        emit(ChatBotError(_mapFailureToMessage(failure)));
        emit(ChatBotLoaded(List.from(_messages)));
      },
      (chatMessage) {
        // 4. لو تم بنجاح، استبدل المؤقتة بالرد الحقيقي
        _messages.removeLast();
        _messages.add(chatMessage);
        emit(ChatBotLoaded(List.from(_messages)));
      },
    );
  }

  void clearMessages() {
    _messages.clear();
    emit(ChatBotInitial());
  }

  List<ChatBotMessage> get messages => List.unmodifiable(_messages);

  // ✅ طريقة لتحويل Failure إلى نص
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return failure.message;
    } else if (failure is UnknownFailure) {
      return failure.message;
    } else {
      return 'حدث خطأ غير متوقع';
    }
  }
}
