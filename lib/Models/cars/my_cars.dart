import 'car_model.dart';
import 'manufacturer_model.dart';
import '../companies/insurance.dart';
import '../packages/package_model.dart';

class GetMyCarsResponse {
  List<MyCarModel>? myCars;

  GetMyCarsResponse({this.myCars});

  GetMyCarsResponse.fromJson(Map<String, dynamic> json) {
    myCars = json['cars'] != null ? (json['cars'] as List).map((i) => MyCarModel.fromJson(i)).toList() : null;
  }
}

//***********************************************************************************************
class MyCarModel {
  int? id;
  String? plateNumber;
  int? year;
  String? policyNumber;
  String? policyStarts;
  String? policyEnds;
  String? appendixNumber;
  String? vinNumber;
  bool? policyCanceled;
  String? color;
  String? frontLicense;
  String? backLicense;
  int? createdBy;
  int? manufacturerId;
  int? carModelId;
  int? clientId;
  bool? active;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? insuranceCompanyId;
  Manufacturer? manufacturer;
  CarModel? carModel;
  InsuranceModel? insuranceCompany;
  List<CarPackageModel>? carPackages;

  MyCarModel({
    this.id,
    this.plateNumber,
    this.year,
    this.policyNumber,
    this.policyStarts,
    this.policyEnds,
    this.appendixNumber,
    this.vinNumber,
    this.policyCanceled,
    this.color,
    this.frontLicense,
    this.backLicense,
    this.createdBy,
    this.manufacturerId,
    this.carModelId,
    this.clientId,
    this.active,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.insuranceCompanyId,
    this.manufacturer,
    this.carModel,
    this.insuranceCompany,
    this.carPackages,
  });

  bool get isCarAddedToPackage => carPackages != null && carPackages!.length > 0;

  MyCarModel.fromJson(Map<String, dynamic> json) {
    print(json['id']);
    print(json['vin_number']);
    print(json['policyNumber']);
    id = json['id'];
    plateNumber = json['plateNumber'];
    year = json['year'];
    policyNumber = json['policyNumber'];
    policyStarts = json['policyStarts'];
    policyEnds = json['policyEnds'];
    appendixNumber = json['appendix_number'];
    vinNumber = json['vin_number'];
    policyCanceled = json['policyCanceled'] ?? false;
    color = json['color'];
    frontLicense = json['frontLicense'];
    backLicense = json['backLicense'];
    createdBy = json['CreatedBy'];
    manufacturerId = json['ManufacturerId'];
    carModelId = json['CarModelId'];
    clientId = json['ClientId'];
    active = json['active'] ?? false;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    insuranceCompanyId = json['insuranceCompanyId'];
    manufacturer = json['Manufacturer'] != null ? Manufacturer.fromJson(json['Manufacturer']) : null;
    carModel = json['CarModel'] != null ? CarModel.fromJson(json['CarModel']) : null;
    insuranceCompany = json['insuranceCompany'] != null ? InsuranceModel.fromJson(json['insuranceCompany']) : null;
    carPackages = json['CarPackages'] != null ? (json['CarPackages'] as List).map((i) => CarPackageModel.fromJson(i)).toList() : null;
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['plateNumber'] = this.plateNumber;
    data['year'] = this.year;
    data['policyNumber'] = this.policyNumber;
    data['policyStarts'] = this.policyStarts;
    data['policyEnds'] = this.policyEnds;
    data['appendix_number'] = this.appendixNumber;
    data['vin_number'] = this.vinNumber;
    data['policyCanceled'] = this.policyCanceled;
    data['color'] = this.color;
    data['frontLicense'] = this.frontLicense;
    data['backLicense'] = this.backLicense;
    data['CreatedBy'] = this.createdBy;
    data['ManufacturerId'] = this.manufacturerId;
    data['CarModelId'] = this.carModelId;
    data['ClientId'] = this.clientId;
    // data['BrokerId'] = this.brokerId;
    data['active'] = this.active;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    data['insuranceCompanyId'] = this.insuranceCompanyId;
    if (this.manufacturer != null) {
      data['Manufacturer'] = this.manufacturer!.toJson();
    }
    data['insuranceCompany'] = this.insuranceCompany;
    if (this.carModel != null) {
      data['CarModel'] = this.carModel!.toJson();
    }
    return data;
  }
}

//****************************************************************************************************************
///* car Package Model
class CarPackageModel {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? carId;
  String? clientPackageId;
  String? packageId;
  String? clientId;
  Package? package;
  ClientPackage? clientPackage;

  CarPackageModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.carId,
    this.clientPackageId,
    this.packageId,
    this.clientId,
    this.package,
    this.clientPackage,
  });

  CarPackageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    carId = json['carId'];
    clientPackageId = json['clientPackageId'];
    packageId = json['packageId'];
    clientId = json['clientId'];
    package = json['Package'] != null ? Package.fromJson(json['Package']) : null;
    clientPackage = json['ClientPackage'] != null ? ClientPackage.fromJson(json['ClientPackage']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'carId': carId,
      'clientPackageId': clientPackageId,
      'packageId': packageId,
      'clientId': clientId,
      'Package': package,
      'ClientPackage': clientPackage,
    };
  }
}

//****************************************************************************************************************
///* Client Package Model
class ClientPackage {
  int? id;
  bool? active;
  String? startDate;
  String? endDate;
  String? orderId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? packageId;
  String? clientId;

  ClientPackage({
    this.id,
    this.active,
    this.startDate,
    this.endDate,
    this.orderId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.packageId,
    this.clientId,
  });

  ClientPackage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    active = json['active'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    orderId = json['orderId'].toString() ;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    packageId = json['packageId'];
    clientId = json['clientId'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'active': active,
      'startDate': startDate,
      'endDate': endDate,
      'orderId': orderId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'packageId': packageId,
      'clientId': clientId,
    };
  }
}
