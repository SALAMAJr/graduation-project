import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:furniswap/data/models/socketModel/ChatModel.dart';
import 'package:furniswap/data/repository/chating/chat_repo.dart';

part 'chats_list_state.dart';

class ChatsListCubit extends Cubit<ChatsListState> {
  final ChatRepo chatRepo;

  ChatsListCubit(this.chatRepo) : super(ChatsListInitial()) {
    print("🔵 ChatsListCubit Created! (Initial State)");
  }

  Future<void> loadChats() async {
    print("⏳ loadChats() called, emitting ChatsListLoading...");
    emit(ChatsListLoading());
    final result = await chatRepo.getMyChats();
    print("📡 getMyChats() finished! Result: $result");

    result.fold(
      (failure) {
        print("❌ Failure in loadChats: ${failure.toString()}");
        emit(ChatsListError("حدث خطأ غير متوقع"));
      },
      (chats) {
        print("✅ Success! Loaded chats: ${chats.length}");
        emit(ChatsListLoaded(chats));
      },
    );
  }
}
