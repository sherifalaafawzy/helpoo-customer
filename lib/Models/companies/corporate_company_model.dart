
import '../../Configurations/Constants/constants.dart';

class CorporateCompany {
  int? id;
  String? enName;
  String? arName;
  num? discountRatio;
  bool? deferredPayment;
  String? startDate;
  String? endDate;
  bool? cash;
  bool? cardToDriver;
  bool? online;
  String? photo;
  num? numOfRequestsThisMonth;
  String? createdAt;
  String? updatedAt;

  CorporateCompany({
    this.id,
    this.enName,
    this.arName,
    this.discountRatio,
    this.deferredPayment,
    this.startDate,
    this.endDate,
    this.cash,
    this.cardToDriver,
    this.online,
    this.photo,
    this.numOfRequestsThisMonth,
    this.createdAt,
    this.updatedAt,
  });

  String get name => isArabic ? arName ?? '' : enName ?? '';

  CorporateCompany.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    enName = json['en_name'] ?? '';
    arName = json['ar_name'] ?? '';
    discountRatio = json['discount_ratio'] ?? 0;
    deferredPayment = json['deferredPayment'] ?? false;
    startDate = json['startDate'] ?? '';
    endDate = json['endDate'] ?? '';
    cash = json['cash'] ?? false;
    cardToDriver = json['cardToDriver'] ?? false;
    online = json['online'] ?? false;
    photo = json['photo'] ?? '';
    numOfRequestsThisMonth = json['numofrequeststhismonth'] ?? 0;
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'enName': enName,
      'arName': arName,
      'discountRatio': discountRatio,
      'deferredPayment': deferredPayment,
      'startDate': startDate,
      'endDate': endDate,
      'cash': cash,
      'cardToDriver': cardToDriver,
      'online': online,
      'photo': photo,
      'numofrequeststhismonth': numOfRequestsThisMonth,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
