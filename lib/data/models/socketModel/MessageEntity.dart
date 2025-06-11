class MessageEntity {
  final String id;
  final String message;
  final String? imageUrl; // أضف ده
  final String senderId;
  final DateTime createdAt;

  MessageEntity({
    required this.id,
    required this.message,
    this.imageUrl,
    required this.senderId,
    required this.createdAt,
  });

  factory MessageEntity.fromJson(Map<String, dynamic> json) {
    return MessageEntity(
      id: json['id'] as String,
      message: json['message'] as String,
      imageUrl: json['imageUrl'], // أضف ده
      senderId: json['sender']['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
