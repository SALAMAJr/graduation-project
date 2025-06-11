import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:furniswap/data/repository/socket/socket_service.dart';

part 'chat_send_message_state.dart';

class ChatSendMessageCubit extends Cubit<ChatSendMessageState> {
  final SocketService socketService;

  ChatSendMessageCubit(this.socketService) : super(ChatSendMessageInitial());

  Future<void> sendMessage({
    required String receiverId,
    required String content,
    String? imageUrl,
  }) async {
    print('[Cubit] Starting to send message...');
    emit(ChatSendMessageLoading());
    try {
      print('[Cubit] Sending message to: $receiverId');
      print('[Cubit] Content: $content');
      socketService.sendMessage(receiverId: receiverId, content: content);
      print('[Cubit] Message sent successfully!');
      emit(ChatSendMessageSuccess());
    } catch (e) {
      print('[Cubit] Error while sending message: $e');
      emit(ChatSendMessageError(e.toString()));
    }
  }
}
