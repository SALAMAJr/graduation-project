// lib/data/models/socketModel/MessageEntity.dart
class MessageEntity {
  final String id;
  final String message;
  final String senderId; // ده الـ ID بتاع اللي باعت الرسالة
  final DateTime createdAt;

  MessageEntity({
    required this.id,
    required this.message,
    required this.senderId,
    required this.createdAt,
  });

  factory MessageEntity.fromJson(Map<String, dynamic> json) {
    return MessageEntity(
      id: json['id'] as String,
      message: json['message'] as String,
      senderId: json['sender']['id']
          as String, // <--- التعديل هنا: بناخد الـ ID من جوه 'sender'
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
