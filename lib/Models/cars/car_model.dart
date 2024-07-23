
import '../../Configurations/Constants/constants.dart';

class CarModel {
  int? id;
  String? enName;
  String? arName;
  String? createdAt;
  String? updatedAt;
  int? manufacturerId;

  CarModel({this.id, this.enName, this.arName, this.createdAt, this.updatedAt, this.manufacturerId});

  CarModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    enName = json['en_name'] ?? '';
    arName = json['ar_name'] ?? '';
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
    manufacturerId = json['ManufacturerId'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'en_name': enName,
      'ar_name': arName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'ManufacturerId': manufacturerId,
    };
  }

  String get name => (isArabic ? arName : enName) ?? "";
}

class GetAllModels {
  List<CarModel>? models;

  GetAllModels({
    this.models,
  });

  GetAllModels.fromJson(Map<String, dynamic> json) {
    models = json['models'] != null ? (json['models'] as List).map((i) => CarModel.fromJson(i)).toList() : null;
  }
}
