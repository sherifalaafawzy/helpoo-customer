import 'dart:convert';

import 'package:helpooappclient/Models/packages/package_model.dart';

class Deal {
  int? id;
  String? dealName;
  int? discountPercent;
  int? discountFees;
  int? packageId;
  int? corporateCompanyId;
  String? expiryDate;
  String? createdAt;
  String? updatedAt;
  Package package;
  Deal({
    this.id,
    this.dealName,
    this.discountPercent,
    this.discountFees,
    this.packageId,
    this.corporateCompanyId,
    this.expiryDate,
    this.createdAt,
    this.updatedAt,
    required this.package,
  });

  factory Deal.fromMap(Map<String, dynamic> map) {
    return Deal(
      id: map['id']?.toInt(),
      dealName: map['name'],
      discountPercent: map['discountPercent']?.toInt(),
      discountFees: map['discountFees']?.toInt(),
      packageId: map['packageId']?.toInt(),
      corporateCompanyId: map['CorporateCompanyId']?.toInt(),
      expiryDate: map['expiryDate'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      package: Package.fromJson(
        map['Package']
          ..addAll({
            'dealId': map['id'],
            "dealName": map['name'],
          }),
      ),
    );
  }

  factory Deal.fromJson(String source) => Deal.fromMap(json.decode(source));
}
