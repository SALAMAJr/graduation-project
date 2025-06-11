import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/models/socketModel/chatData.dart';
import 'package:furniswap/data/repository/chating/chat_repo.dart';

part 'chat_details_state.dart';

class ChatDetailsCubit extends Cubit<ChatDetailsState> {
  final ChatRepo repo;

  ChatDetailsCubit(this.repo) : super(ChatDetailsInitial());

  Future<void> loadOrCreateChat(String recepientId) async {
    emit(ChatDetailsLoading());
    final result = await repo.getOrCreateChat(recepientId);
    result.fold(
      (fail) {
        emit(ChatDetailsError(
            fail is ServerFailure ? fail.message : "حصلت مشكلة!"));
      },
      (chatData) {
        emit(ChatDetailsLoaded(chatData));
      },
    );
  }

  // ====== ده اللي بنضيفه عشان تقدر تضيف الرسالة الجديدة في UI ======
  void addMessageLocally(ChatMessage message) {
    // لازم يكون في ستيت لودد أصلا
    if (state is ChatDetailsLoaded) {
      final currentState = state as ChatDetailsLoaded;
      final updatedMessages =
          List<ChatMessage>.from(currentState.chatData.messages)..add(message);

      final updatedChatData = ChatData(
        id: currentState.chatData.id,
        chatName: currentState.chatData.chatName,
        createdAt: currentState.chatData.createdAt,
        participants: currentState.chatData.participants,
        messages: updatedMessages,
      );

      emit(ChatDetailsLoaded(updatedChatData));
    }
  }
}
