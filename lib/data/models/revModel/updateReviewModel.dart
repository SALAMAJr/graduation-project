class UserModel {
  final String? id;
  final String? email;
  final String? image;
  final int? points;
  final String? firstName;
  final String? lastName;
  final bool? status;
  final String? phone;
  final String? fcmToken;
  final String? dateOfBirth;
  final String? role;
  final bool? isOAuthUser;

  UserModel({
    required this.id,
    this.email,
    this.image,
    this.points,
    this.firstName,
    this.lastName,
    this.status,
    this.phone,
    this.fcmToken,
    this.dateOfBirth,
    this.role,
    this.isOAuthUser,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'],
      image: json['image'],
      points: json['points'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      status: json['status'],
      phone: json['phone'],
      fcmToken: json['fcmToken'],
      dateOfBirth: json['dateOfBirth'],
      role: json['role'],
      isOAuthUser: json['isOAuthUser'],
    );
  }
}

class ReviewModel {
  final String id;
  final int rating;
  final String comment;
  final String? createdAt;
  final UserModel? user;

  ReviewModel({
    required this.id,
    required this.rating,
    required this.comment,
    this.createdAt,
    this.user,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      createdAt: json['createdAt'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }
}
