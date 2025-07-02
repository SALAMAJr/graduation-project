import 'package:equatable/equatable.dart';

class AddressModel extends Equatable {
  final String? id;
  final String fullName;
  final String streetAddress;
  final String city;
  final String state;
  final String country;
  final String phoneNumber;
  final String? postalCode;

  const AddressModel({
    this.id,
    required this.fullName,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.country,
    required this.phoneNumber,
    this.postalCode,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    print("📥 parsing address from json: $json");
    return AddressModel(
      id: json['id'],
      fullName: json['fullName'],
      streetAddress: json['streetAddress'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      phoneNumber: json['phoneNumber'],
      postalCode: json['postalCode'],
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'fullName': fullName,
      'streetAddress': streetAddress,
      'city': city,
      'state': state,
      'country': country,
      'phoneNumber': phoneNumber,
      'postalCode': postalCode,
    };
    print("📤 converting address to json: $json");
    return json;
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        streetAddress,
        city,
        state,
        country,
        phoneNumber,
        postalCode,
      ];
}
