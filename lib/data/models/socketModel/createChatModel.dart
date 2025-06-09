class CreateChatModel {
  final String id;
  final String chatName;
  final List<String> participants;
  final DateTime createdAt;

  CreateChatModel({
    required this.id,
    required this.chatName,
    required this.participants,
    required this.createdAt,
  });

  factory CreateChatModel.fromJson(Map<String, dynamic> json) {
    print('📦 [CreateChatModel] جالي JSON: $json');
    return CreateChatModel(
      id: json['id'],
      chatName: json['chatName'],
      participants: List<String>.from(
        (json['participants'] as List).map((e) => e['id']),
      ),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
