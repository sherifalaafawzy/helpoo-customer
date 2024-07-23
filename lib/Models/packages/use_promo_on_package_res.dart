
class UsePromoOnPackageRes {
  String? status;
  PromoOnPackageModel? promo;
  int? amountShell;
  String? packageId;

  UsePromoOnPackageRes({
    this.status,
    this.promo,
    this.packageId,
    this.amountShell
  });

  UsePromoOnPackageRes.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    amountShell=json['amount'];
    packageId=json['packageId'];
    promo = json['promo'] != null
        ? PromoOnPackageModel.fromJson(json['promo'])
        : null;
  }
}

class PromoOnPackageModel {
  int? id;
  int? userId;
  int? packageId;
  int? packagePromoCodeId;
  int? fees;
  String? updatedAt;
  String? createdAt;
  int? clientPackageId;

  PromoOnPackageModel({
    this.id,
    this.userId,
    this.packageId,
    this.packagePromoCodeId,
    this.fees,
    this.updatedAt,
    this.createdAt,
    this.clientPackageId,
  });

  PromoOnPackageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['UserId'];
    packageId = json['PackageId'];
    packagePromoCodeId = json['PackagePromoCodeId'];
    fees = json['fees'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
    clientPackageId = json['ClientPackageId'];
  }
}
