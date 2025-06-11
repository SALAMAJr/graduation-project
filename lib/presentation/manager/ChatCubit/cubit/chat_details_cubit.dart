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
}
