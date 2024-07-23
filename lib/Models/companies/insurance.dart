class InsuranceModel {
  int? id;
  String? enName;
  String? arName;
  int? packageRequestCount;
  int? packageDiscountPercentage;
  int? maxTotalDiscount;
  int? discountPercentAfterPolicyExpires;
  String? startDate;
  String? endDate;
  String? photo;
  List<String>? emails;
  String? createdAt;
  String? updatedAt;
  Map<String, dynamic>? additionalFields;
  InsuranceModel({
    this.id,
    this.enName,
    this.arName,
    this.packageRequestCount,
    this.packageDiscountPercentage,
    this.maxTotalDiscount,
    this.discountPercentAfterPolicyExpires,
    this.startDate,
    this.endDate,
    this.photo,
    this.emails,
    this.createdAt,
    this.updatedAt,
    this.additionalFields,
  });

  InsuranceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    enName = json['en_name'] ?? "";
    arName = json['ar_name'] ?? "";
    packageRequestCount = json['package_request_count'] ?? 0;
    packageDiscountPercentage = json['package_discount_percentage'] ?? 0;
    maxTotalDiscount = json['max_total_discount'] ?? 0;
    discountPercentAfterPolicyExpires =
        json['discount_percent_after_policy_expires'] ?? 0;
    startDate = json['startDate'] ?? "";
    endDate = json['endDate'] ?? "";
    photo = json['photo'] ?? "";
    if (json['emails'] != null) {
      emails = <String>[];
      json['emails'].forEach((v) {
        emails!.add(v);
      });
    }
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    additionalFields =
        json['additionalFields'] != null ? json['additionalFields'] : null;
    ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['en_name'] = this.enName;
    data['ar_name'] = this.arName;
    data['package_request_count'] = this.packageRequestCount;
    data['package_discount_percentage'] = this.packageDiscountPercentage;
    data['max_total_discount'] = this.maxTotalDiscount;
    data['discount_percent_after_policy_expires'] =
        this.discountPercentAfterPolicyExpires;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['photo'] = this.photo;
    data['emails'] = this.emails;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['additionalFields'] = this.additionalFields;
    return data;
  }
}
