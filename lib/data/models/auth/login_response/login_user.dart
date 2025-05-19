import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? id;
  final String? email;
  final String? name;
  final bool? status;

  const User({this.id, this.email, this.name, this.status});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String?,
        email: json['email'] as String?,
        name: json['name'] as String?,
        status: json['status'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'status': status,
      };

  @override
  List<Object?> get props => [id, email, name, status];
}
