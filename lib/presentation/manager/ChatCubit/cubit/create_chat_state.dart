part of 'create_chat_cubit.dart';

abstract class CreateChatState {}

class CreateChatInitial extends CreateChatState {}

class CreateChatLoading extends CreateChatState {}

class CreateChatSuccess extends CreateChatState {
  final CreateChatModel chat;
  CreateChatSuccess(this.chat);
}

class CreateChatError extends CreateChatState {
  final String message;
  CreateChatError(this.message);
}
