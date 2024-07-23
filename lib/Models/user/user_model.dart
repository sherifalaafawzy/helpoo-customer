import '../companies/corporate_company_model.dart';
import '../promoCode.dart';

class User {
  int? id;
  int? userId;
  String? phoneNumber;
  String? username;
  String? name;
  int? corporateCompanyId;
  CorporateCompany? corporateCompany;
  int? roleId;
  String? roleName;
  bool? blocked;
  String? photo;
  String? email;
  PromoCode? promo;

  User({
    this.id,
    this.userId,
    this.phoneNumber,
    this.username,
    this.name,
    this.roleId,
    this.roleName,
    this.blocked,
    this.photo,
    this.corporateCompanyId,
    this.corporateCompany,
    this.email,
    this.promo,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    userId = json['UserId'] ?? 0;
    phoneNumber = json['PhoneNumber'] ?? '';
    username = json['username'] ?? '';
    name = json['name'] ?? '';
    corporateCompanyId = json['CorporateCompanyId'] ?? 0;
    corporateCompany = json['CorporateCompany'] != null ? CorporateCompany.fromJson(json['CorporateCompany']) : null;
    roleId = json['RoleId'] ?? 0;
    promo = json['activePromoCode'] != null ? PromoCode.fromJson(json['activePromoCode']) : null;
    roleName = json['RoleName'] ?? '';
    blocked = json['blocked'] ?? false;
    photo = json['photo'] ?? '';
    email = json['email'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'UserId': userId,
      'PhoneNumber': phoneNumber,
      'username': username,
      'name': name,
      'CorporateCompanyId': corporateCompanyId,
      'CorporateCompany': corporateCompany!.toJson(),
      'RoleId': roleId,
      'RoleName': roleName,
      'blocked': blocked,
      'email': email,
    };
  }
}
