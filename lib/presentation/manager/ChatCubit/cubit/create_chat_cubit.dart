import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniswap/data/models/socketModel/createChatModel.dart';
import 'package:furniswap/data/repository/chating/chat_repo.dart';

part 'create_chat_state.dart';

class CreateChatCubit extends Cubit<CreateChatState> {
  final ChatRepo chatRepo;

  CreateChatCubit(this.chatRepo) : super(CreateChatInitial());

  Future<void> createChat(String recipientId) async {
    emit(CreateChatLoading());
    try {
      print('⏳ [CreateChatCubit] جاري إنشاء شات ...');
      final chat = await chatRepo.createChat(recipientId);
      print('✅ [CreateChatCubit] تم إنشاء الشات بنجاح: ${chat.id}');
      emit(CreateChatSuccess(chat));
    } catch (e, st) {
      print('❌ [CreateChatCubit] حصل Error: $e');
      print(st);
      emit(CreateChatError(e.toString()));
    }
  }
}
