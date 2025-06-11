// chat_details_state.dart
part of 'chat_details_cubit.dart';

abstract class ChatDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatDetailsInitial extends ChatDetailsState {}

class ChatDetailsLoading extends ChatDetailsState {}

class ChatDetailsLoaded extends ChatDetailsState {
  final ChatData chatData;
  ChatDetailsLoaded(this.chatData);

  @override
  List<Object?> get props => [chatData];
}

class ChatDetailsError extends ChatDetailsState {
  final String message;
  ChatDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
