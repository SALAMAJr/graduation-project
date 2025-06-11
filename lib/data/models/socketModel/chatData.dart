class ChatData {
  final String id;
  final String chatName;
  final DateTime createdAt;
  final List<Participant> participants;
  final List<ChatMessage> messages;

  ChatData({
    required this.id,
    required this.chatName,
    required this.createdAt,
    required this.participants,
    required this.messages,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      id: json['id'] ?? '',
      chatName: json['chatName'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      participants: List<Participant>.from(
          (json['participants'] ?? []).map((x) => Participant.fromJson(x))),
      messages: List<ChatMessage>.from(
          (json['messages'] ?? []).map((x) => ChatMessage.fromJson(x))),
    );
  }
}

class Participant {
  final String id;
  final String email;
  final String image;
  final int points;
  final String firstName;
  final String? lastName;
  final bool status;
  final String? phone;
  final String? fcmToken;
  final String? dateOfBirth;
  final String role;
  final bool isOAuthUser;

  Participant({
    required this.id,
    required this.email,
    required this.image,
    required this.points,
    required this.firstName,
    required this.lastName,
    required this.status,
    required this.phone,
    required this.fcmToken,
    required this.dateOfBirth,
    required this.role,
    required this.isOAuthUser,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
      points: json['points'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName']?.toString(), // بقت String? تقبل null
      status: json['status'] ?? false,
      phone: json['phone']?.toString(),
      fcmToken: json['fcmToken']?.toString(),
      dateOfBirth: json['dateOfBirth']?.toString(),
      role: json['role'] ?? '',
      isOAuthUser: json['isOAuthUser'] ?? false,
    );
  }
}

class ChatMessage {
  final String id;
  final String message;
  final String? imageUrl; // أضف ده
  final DateTime createdAt;
  final String senderId;

  ChatMessage({
    required this.id,
    required this.message,
    this.imageUrl, // أضف ده
    required this.createdAt,
    required this.senderId,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      imageUrl: json['imageUrl'], // أضف ده (ممكن يجي null عادي)
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      senderId: json['sender']?['id'] ?? '',
    );
  }
}
