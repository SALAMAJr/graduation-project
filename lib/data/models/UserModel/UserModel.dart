import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String image;
  final int points;
  final String firstName;
  final String lastName;
  final bool status;
  final String phone;
  final String fcmToken;
  final String dateOfBirth;
  final String role;
  final bool isOAuthUser;

  const UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
      points: json['points'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      status: json['status'] ?? false,
      phone: json['phone'] ?? '',
      fcmToken: json['fcmToken'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      role: json['role'] ?? '',
      isOAuthUser: json['isOAuthUser'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'image': image,
      'points': points,
      'firstName': firstName,
      'lastName': lastName,
      'status': status,
      'phone': phone,
      'fcmToken': fcmToken,
      'dateOfBirth': dateOfBirth,
      'role': role,
      'isOAuthUser': isOAuthUser,
    };
  }

  @override
  List<Object?> get props => [
        id,
        email,
        image,
        points,
        firstName,
        lastName,
        status,
        phone,
        fcmToken,
        dateOfBirth,
        role,
        isOAuthUser,
      ];
}
