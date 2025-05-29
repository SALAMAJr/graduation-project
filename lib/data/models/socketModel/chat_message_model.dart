class ChatMessageModel {
  final String sender;
  final String receiverId; // 🆕 ده اللي ضفناه
  final String message;
  final String time;

  ChatMessageModel({
    required this.sender,
    required this.receiverId, // 🆕
    required this.message,
    required this.time,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      sender: json['sender'] ?? '',
      receiverId: json['receiverId'] ?? '', // 🆕
      message: json['message'] ?? '',
      time: json['time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'receiverId': receiverId, // 🆕
      'message': message,
      'time': time,
    };
  }
}
