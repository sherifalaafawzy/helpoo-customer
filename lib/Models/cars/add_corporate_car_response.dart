import 'my_cars.dart';

class AddCorporateCarResponse {
  String? status;
  MyCarModel? car;
  CorporateUser? user;

  AddCorporateCarResponse({this.status, this.car, this.user});

  AddCorporateCarResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    car = json['car'] != null ? new MyCarModel.fromJson(json['car']) : null;
    user = json['user'] != null ? new CorporateUser.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.car != null) {
      data['car'] = this.car!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}



class CorporateUser {
  String? phoneNumber;
  String? name;
  String? email;
  int? roleId;
  int? id;
  int? userId;

  CorporateUser(
      {this.phoneNumber,
      this.name,
      this.email,
      this.roleId,
      this.id,
      this.userId});

  CorporateUser.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['PhoneNumber'];
    name = json['name'];
    email = json['email'];
    roleId = json['RoleId'];
    id = json['id'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PhoneNumber'] = this.phoneNumber;
    data['name'] = this.name;
    data['email'] = this.email;
    data['RoleId'] = this.roleId;
    data['id'] = this.id;
    data['userId'] = this.userId;
    return data;
  }
}
