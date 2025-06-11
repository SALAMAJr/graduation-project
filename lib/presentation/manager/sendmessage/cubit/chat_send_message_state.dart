part of 'chat_send_message_cubit.dart';

abstract class ChatSendMessageState extends Equatable {
  const ChatSendMessageState();

  @override
  List<Object?> get props => [];
}

class ChatSendMessageInitial extends ChatSendMessageState {
  ChatSendMessageInitial() : super() {
    print('[State] Initial State');
  }
}

class ChatSendMessageLoading extends ChatSendMessageState {
  ChatSendMessageLoading() : super() {
    print('[State] Loading...');
  }
}

class ChatSendMessageSuccess extends ChatSendMessageState {
  ChatSendMessageSuccess() : super() {
    print('[State] Success!');
  }
}

class ChatSendMessageError extends ChatSendMessageState {
  final String error;
  ChatSendMessageError(this.error) : super() {
    print('[State] Error: $error');
  }

  @override
  List<Object?> get props => [error];
}
