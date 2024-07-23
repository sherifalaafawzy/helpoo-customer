class CheckPromoPackageOrNormalResponse {
  String? status;
  bool? isPromoPackage;

  CheckPromoPackageOrNormalResponse({
    this.status,
    this.isPromoPackage,
  });

  CheckPromoPackageOrNormalResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    isPromoPackage = json['isPromoPackage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['isPromoPackage'] = isPromoPackage;
    return data;
  }
}
