class ChatMessageModel {
  final String sender;
  final String message;
  final String time;

  ChatMessageModel({
    required this.sender,
    required this.message,
    required this.time,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      sender: json['sender'] ?? '',
      message: json['message'] ?? '',
      time: json['time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'message': message,
      'time': time,
    };
  }
}
