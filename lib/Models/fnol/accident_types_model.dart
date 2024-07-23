

import '../../Configurations/Constants/constants.dart';
import '../../Configurations/Constants/enums.dart';

class AccidentTypesModel {
  String? status;
  List<AccidentTypeModel>? types;

  AccidentTypesModel({this.status, this.types});

  AccidentTypesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['types'] != null) {
      types = <AccidentTypeModel>[];
      json['types'].forEach((v) {
        types!.add(AccidentTypeModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    if (this.types != null) {
      data['types'] = this.types!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AccidentTypeModel {
  int? id;
  String? enName;
  String? arName;
  String? requiredImages;
  String? createdAt;
  String? updatedAt;
  AccidentType? type;
  String get name => isArabic ? enName ?? '' : arName ?? '';

  AccidentTypeModel({this.id, this.enName, this.arName, this.requiredImages, this.createdAt, this.updatedAt, this.type});

  AccidentTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    enName = json['en_name'];
    arName = json['ar_name'];
    requiredImages = json['requiredImages'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['en_name'] = this.enName;
    data['ar_name'] = this.arName;
    data['requiredImages'] = this.requiredImages;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
