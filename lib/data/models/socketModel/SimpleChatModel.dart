class SimpleChatModel {
  final String chatId;
  final String receiverId;

  SimpleChatModel({
    required this.chatId,
    required this.receiverId,
  });

  factory SimpleChatModel.fromJson(Map<String, dynamic> json) {
    return SimpleChatModel(
      chatId: json['chatId'] ?? "",
      receiverId: json['receiverId'] ?? "",
    );
  }
}
