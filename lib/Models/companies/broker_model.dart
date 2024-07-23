import '../user/user_model.dart';

class Broker {
  int? id;
  String? createdAt;
  String? updatedAt;
  int? userId;
  User? user;

  Broker({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.user,
  });

  Broker.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
    userId = json['UserId'] ?? 0;
    user = json['User'] != null ? User.fromJson(json['User']) : null;
  }
}
