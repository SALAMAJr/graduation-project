class ReceiverModel {
  final String id;
  final String firstName;
  final String lastName;
  final String image;

  ReceiverModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.image,
  });

  factory ReceiverModel.fromJson(Map<String, dynamic> json) {
    return ReceiverModel(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
