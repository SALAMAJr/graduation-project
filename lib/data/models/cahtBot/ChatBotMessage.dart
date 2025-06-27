import 'package:equatable/equatable.dart';

class ChatBotMessage extends Equatable {
  final String query;
  final String answer;

  const ChatBotMessage({required this.query, required this.answer});

  factory ChatBotMessage.fromJson(Map<String, dynamic> json) {
    return ChatBotMessage(
      query: json['query'],
      answer: json['answer'],
    );
  }

  @override
  List<Object> get props => [query, answer];
}
