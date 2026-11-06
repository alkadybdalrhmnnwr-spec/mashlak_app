class UserModel {
  final String fullName;
  final String academicId;
  final String email;
  final String password;

  const UserModel({
    required this.fullName,
    required this.academicId,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() => {
    'fullName': fullName,
    'academicId': academicId,
    'email': email,
  };
}
