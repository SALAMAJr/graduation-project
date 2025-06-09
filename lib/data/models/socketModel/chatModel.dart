class ChatModel {
  final String chatId;
  final String receiverId;

  ChatModel({
    required this.chatId,
    required this.receiverId,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chatId: json['chatId'] ?? '',
      receiverId: json['receiverId'] ?? '',
    );
  }
}
