// ignore: file_names
abstract class UserModel {
  String? email;
  String? passWord;
  List<String>? eventsIDs = [];
}

class UserSignUp extends UserModel {
  final String? email, userName, passWord;
  List<String>? eventsIDs;

  UserSignUp(
      {required this.userName,
      required this.email,
      required this.passWord,
      this.eventsIDs});
}

class UserLogIn extends UserModel {
  final String? email, passWord;
  List<String>? eventsIDs = [];

  UserLogIn({required this.email, required this.passWord, this.eventsIDs});
}
