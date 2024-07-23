// import 'currentUser.dart';

class InsuranceCompany {
  int? id;
  String? enName;
  String? arName;
  int? packageRequestCount;
  int? packageDiscountPercentage;
  int? maxTotalDiscount;

  // String get name => (CurrentUser.language == "ar" ? arName : enName) ?? "";

  InsuranceCompany.fromJson(Map json) {
    id = json['id'];
    enName = json['en_name'];
    arName = json['ar_name'];
    packageRequestCount = json['package_request_count'];
    packageDiscountPercentage = json['package_discount_percentage'];
    maxTotalDiscount = json['max_total_discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    id = data['id'];
    enName = data['en_name'];
    arName = data['ar_name'];
    packageRequestCount = data['package_request_count'];
    data['package_discount_percentage'] = this.packageDiscountPercentage;
    data['max_total_discount'] = this.maxTotalDiscount;
    data['id'] = this.id;
    data['en_name'] = this.enName;
    data['ar_name'] = this.arName;
    data['package_request_count'] = this.packageRequestCount;
    return data;
  }
}
