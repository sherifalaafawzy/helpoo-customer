
import '../../Configurations/Constants/constants.dart';

class Manufacturer {
  int? id;
  String? enName;
  String? arName;
  String? createdAt;
  String? updatedAt;

  Manufacturer({this.id, this.enName, this.arName, this.createdAt, this.updatedAt});

  Manufacturer.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    enName = json['en_name'] ?? '';
    arName = json['ar_name'] ?? '';
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'en_name': enName,
      'ar_name': arName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  String get name => (isArabic ? arName : enName) ?? "";
}

class GetAllManufacturersRes {
  List<Manufacturer>? manufacturers;

  GetAllManufacturersRes({
    this.manufacturers,
  });

  GetAllManufacturersRes.fromJson(Map<String, dynamic> json) {
    manufacturers = json['manufacturers'] != null ? (json['manufacturers'] as List).map((i) => Manufacturer.fromJson(i)).toList() : null;
  }
}
