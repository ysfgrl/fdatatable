
class UserModel{
  String id;
  String firstName;
  String lastName;
  String email;
  int age;
  int userType;
  DateTime birthDate;
  String gender;
  String detail;
  bool isActive;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.age,
    required this.birthDate,
    required this.gender,
    required this.detail,
    required this.isActive,
    required this.userType
  });
}