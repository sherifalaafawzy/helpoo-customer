import '../user/user_model.dart';

class LoginModel {
  String? status;
  User? user;
  String? token;

  LoginModel({
    this.status,
    this.user,
    this.token,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? '';
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    token = json['token'] ?? '';
  }

}
