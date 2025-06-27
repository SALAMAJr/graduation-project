import 'package:equatable/equatable.dart';
import 'package:furniswap/data/models/cahtBot/ChatBotMessage.dart';

abstract class ChatBotState extends Equatable {
  const ChatBotState();

  @override
  List<Object> get props => [];
}

class ChatBotInitial extends ChatBotState {}

class ChatBotLoading extends ChatBotState {}

class ChatBotLoaded extends ChatBotState {
  final List<ChatBotMessage> messages;

  const ChatBotLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class ChatBotError extends ChatBotState {
  final String message;

  const ChatBotError(this.message);

  @override
  List<Object> get props => [message];
}
