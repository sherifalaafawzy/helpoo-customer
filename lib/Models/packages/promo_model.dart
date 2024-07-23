import '../companies/corporate_company_model.dart';

class Promo {
  int? id;
  String? name;
  String? value;
  String? startDate;
  String? expiryDate;
  String? usageExpiryDate;
  int? percentage;
  int? count;
  int? maxCount;
  int? feesDiscount;
  bool? private;
  bool? active;
  String? createdAt;
  String? updatedAt;
  int? corporateCompanyId;
  CorporateCompany? corporateCompany;

  Promo({
    this.id,
    this.name,
    this.value,
    this.startDate,
    this.expiryDate,
    this.usageExpiryDate,
    this.percentage,
    this.count,
    this.maxCount,
    this.feesDiscount,
    this.private,
    this.active,
    this.createdAt,
    this.updatedAt,
    this.corporateCompanyId,
    this.corporateCompany,
  });

  factory Promo.fromJson(Map<String, dynamic> json) {
    return Promo(
      id: json['id'],
      name: json['name'],
      value: json['value'],
      startDate: json['startDate'],
      expiryDate: json['expiryDate'],
      usageExpiryDate: json['usageExpiryDate'],
      percentage: json['percentage'],
      count: json['count'],
      maxCount: json['maxCount'],
      feesDiscount: json['feesDiscount'],
      private: json['private'],
      active: json['active'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      corporateCompanyId: json['CorporateCompanyId'],
      corporateCompany: json['CorporateCompany'] != null
          ? CorporateCompany.fromJson(json['CorporateCompany'])
          : null,
    );
  }
}
