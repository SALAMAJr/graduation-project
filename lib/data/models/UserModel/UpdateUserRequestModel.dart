class UpdateUserRequestModel {
  final String firstName;
  final String lastName;
  final String dateOfBirth;

  UpdateUserRequestModel({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
    };
  }
}
