import '../../Configurations/Constants/constants.dart';
import '../companies/broker_model.dart';
import '../companies/corporate_company_model.dart';

class CarPackage {
    DateTime createdAt;
    DateTime updatedAt;
    dynamic deletedAt;
    int carId;
    int clientPackageId;
    int packageId;
    Car car;

    CarPackage({
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
        required this.carId,
        required this.clientPackageId,
        required this.packageId,
        required this.car,
    });

    factory CarPackage.fromJson(Map<String, dynamic> json) => CarPackage(
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
        carId: json["CarId"],
        clientPackageId: json["ClientPackageId"],
        packageId: json["PackageId"],
        car: Car.fromJson(json["Car"]),
    );

    Map<String, dynamic> toJson() => {
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "deletedAt": deletedAt,
        "CarId": carId,
        "ClientPackageId": clientPackageId,
        "PackageId": packageId,
        "Car": car.toJson(),
    };
}

class Car {
    int id;
    String plateNumber;
    int year;
    String? policyNumber;
    DateTime? policyStarts;
    DateTime? policyEnds;
    dynamic appendixNumber;
    String vinNumber;
    dynamic policyCanceled;
    String color;
    dynamic frontLicense;
    dynamic backLicense;
    int createdBy;
    int manufacturerId;
    int carModelId;
    int clientId;
    dynamic brokerId;
    bool active;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic deletedAt;
    int? insuranceCompanyId;

    Car({
        required this.id,
        required this.plateNumber,
        required this.year,
        required this.policyNumber,
        required this.policyStarts,
        required this.policyEnds,
        required this.appendixNumber,
        required this.vinNumber,
        required this.policyCanceled,
        required this.color,
        required this.frontLicense,
        required this.backLicense,
        required this.createdBy,
        required this.manufacturerId,
        required this.carModelId,
        required this.clientId,
        required this.brokerId,
        required this.active,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
        required this.insuranceCompanyId,
    });

    factory Car.fromJson(Map<String, dynamic> json) => Car(
        id: json["id"],
        plateNumber: json["plateNumber"],
        year: json["year"],
        policyNumber: json["policyNumber"],
        policyStarts: json["policyStarts"] == null ? null : DateTime.parse(json["policyStarts"]),
        policyEnds: json["policyEnds"] == null ? null : DateTime.parse(json["policyEnds"]),
        appendixNumber: json["appendix_number"],
        vinNumber: json["vin_number"],
        policyCanceled: json["policyCanceled"],
        color: json["color"],
        frontLicense: json["frontLicense"],
        backLicense: json["backLicense"],
        createdBy: json["CreatedBy"],
        manufacturerId: json["ManufacturerId"],
        carModelId: json["CarModelId"],
        clientId: json["ClientId"],
        brokerId: json["BrokerId"],
        active: json["active"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
        insuranceCompanyId: json["insuranceCompanyId"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "plateNumber": plateNumber,
        "year": year,
        "policyNumber": policyNumber,
        "policyStarts": policyStarts?.toIso8601String(),
        "policyEnds": policyEnds?.toIso8601String(),
        "appendix_number": appendixNumber,
        "vin_number": vinNumber,
        "policyCanceled": policyCanceled,
        "color": color,
        "frontLicense": frontLicense,
        "backLicense": backLicense,
        "CreatedBy": createdBy,
        "ManufacturerId": manufacturerId,
        "CarModelId": carModelId,
        "ClientId": clientId,
        "BrokerId": brokerId,
        "active": active,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "deletedAt": deletedAt,
        "insuranceCompanyId": insuranceCompanyId,
    };
}
class Package {
  int? id;
  int? dealId;
  String? dealName;
  String? enName;
  String? arName;
  String? photo;
  num? originalFees;
  num? price;
  num? fees;
  int? numberOfCars;
  num? maxDiscountPerTime;
  num? numberOfDiscountTimes;
  num?numberOfDiscountTimesOther;
  num? discountPercentage;
  num? discountAfterMaxTimes;
  num? numberOfDays;
  String? arDescription;
  String? enDescription;
  List<CarPackage>? carPackages;
  int? activateDaysPerCar;
  bool? active;
  bool? private;
  String? createdAt;
  String? updatedAt;
  String? startDate;
  String? endDate;
  int? orderId;
  String? deletedAt;
  int? packageId;
  int? clientId;
  int? assignedCars;
  int? insuranceCompanyId;
  int? corporateCompanyId;
  int? activateAfterDays;
  CorporateCompany? corporateCompany;
  PackageInsuranceCompany? insuranceCompany;
  List<UsedPromoPackageModel>? usedPromosPackages;
  int? brokerId;
  Broker? broker;
  List<PackageBenefit>? packageBenefits;
      int? requestsInThisPackage;
    int? requestsInThisPackageOtherServices;

  Package({
    this.id,
    this.dealId,
    this.dealName,
    this.enName,
    this.arName,
    this.photo,
    this.originalFees,
    this.price,
    this.fees,
    this.numberOfCars,
    this.maxDiscountPerTime,
    this.numberOfDiscountTimes,
    this.numberOfDiscountTimesOther,
    this.discountPercentage,
    this.discountAfterMaxTimes,
    this.numberOfDays,
    this.arDescription,
    this.activateDaysPerCar,
    this.enDescription,
    this.active,
    this.carPackages,
    this.private,
    this.createdAt,
    this.updatedAt,
    this.insuranceCompanyId,
    this.startDate,
    this.endDate,
    this.orderId,
    this.deletedAt,
    this.packageId,
    this.clientId,
    this.assignedCars,
    this.corporateCompanyId,
    this.activateAfterDays,
    this.corporateCompany,
    this.insuranceCompany,
    this.usedPromosPackages,
    this.brokerId,
    this.broker,
    this.packageBenefits,
         this.requestsInThisPackage,
       this.requestsInThisPackageOtherServices,
  });

  String get name => isArabic ? arName ?? '' : enName ?? '';

  Package.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        dealId = json['dealId'] ?? 0,
        dealName = json['dealName'] ?? '',
        enName = json['enName'] ?? '',
        arName = json['arName'] ?? '',
        photo = json['photo'] ?? '',
        activateDaysPerCar = json['activateDaysPerCar']??0,
        originalFees = json['originalFees'] ?? 0,
        price = json['price'] ?? 0,
        fees = json['fees'] ?? 0,
        numberOfCars = json['numberOfCars'] ?? 0,
        maxDiscountPerTime = json['maxDiscountPerTime'] ?? 0,
        numberOfDiscountTimes = json['numberOfDiscountTimes'] ?? 0,
        numberOfDiscountTimesOther = json['numberOfDiscountTimesOther'] ?? 0,
        discountPercentage = json['discountPercentage'] ?? 0,
        discountAfterMaxTimes = json['discountAfterMaxTimes'] ?? 0,
        numberOfDays = json['numberOfDays'] ?? 0,
        arDescription = json['arDescription'] ?? '',
        enDescription = json['enDescription'] ?? '',
        active = json['active'] ?? false,
        private = json['private'] ?? false,
        createdAt = json['createdAt'] ?? '',
        updatedAt = json['updatedAt'] ?? '',
        startDate = json['startDate'] ?? '',
        endDate = json['endDate'] ?? '',
        
        orderId = json['OrderId'] ?? 0,
        deletedAt = json['deletedAt'] ?? '',
        packageId = json['PackageId'],
        clientId = json['ClientId'] ?? 0,
        assignedCars = json['assignedCars'] ?? 0,
        insuranceCompanyId = json['InsuranceCompanyId'],
        corporateCompanyId = json['CorporateCompanyId'] ?? 0,
        activateAfterDays = json['activateAfterDays'] ?? 0,
        corporateCompany = json['CorporateCompany'] != null
            ? CorporateCompany.fromJson(json['CorporateCompany'])
            : null,
        insuranceCompany = json['insuranceCompany'] != null
            ? PackageInsuranceCompany.fromJson(json['insuranceCompany'])
            : null,
        usedPromosPackages = json['UsedPromosPackages'] != null
            ? (json['UsedPromosPackages'] as List)
                .map((i) => UsedPromoPackageModel.fromJson(i))
                .toList()
            : null,

          carPackages=json['CarPackages'] != null
            ? (json['CarPackages'] as List)
                .map((i) => CarPackage.fromJson(i))
                .toList()
            : null,

        brokerId = json['BrokerId'] ?? 0,
        broker =
            json['Broker'] != null ? Broker.fromJson(json['Broker']) : null,
        packageBenefits = json['PackageBenefits'] != null
            ? (json['PackageBenefits'] as List)
                .map((i) => PackageBenefit.fromJson(i))
                .toList()
            : [],
        requestsInThisPackage =json["requestsInThisPackage"],
        requestsInThisPackageOtherServices= json["requestsInThisPackageOtherServices"];
}

//******************************************************************************
class PackageInsuranceCompany {
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
  String? createdAt;
  String? updatedAt;

  PackageInsuranceCompany({
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
    this.createdAt,
    this.updatedAt,
  });

  String get name => isArabic ? arName ?? '' : enName ?? '';

  PackageInsuranceCompany.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        enName = json['en_name'] ?? '',
        arName = json['ar_name'] ?? '',
        packageRequestCount = json['package_request_count'] ?? 0,
        packageDiscountPercentage = json['package_discount_percentage'] ?? 0,
        maxTotalDiscount = json['max_total_discount'] ?? 0,
        discountPercentAfterPolicyExpires =
            json['discount_percent_after_policy_expires'] ?? 0,
        startDate = json['startDate'] ?? '',
        endDate = json['endDate'] ?? '',
        photo = json['photo'] ?? '',
        createdAt = json['createdAt'] ?? '',
        updatedAt = json['updatedAt'] ?? '';
}

//******************************************************************************
class UsedPromoPackageModel {
  int? id;
  int? fees;
  String? createdAt;
  String? updatedAt;
  int? packageId;
  int? packagePromoCodeId;
  int? userId;
  int? clientPackageId;
  PackagePromoCode? packagePromoCode;

  UsedPromoPackageModel({
    this.id,
    this.fees,
    this.createdAt,
    this.updatedAt,
    this.packageId,
    this.packagePromoCodeId,
    this.userId,
    this.clientPackageId,
    this.packagePromoCode,
  });

  UsedPromoPackageModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        fees = json['fees'] ?? 0,
        createdAt = json['createdAt'] ?? '',
        updatedAt = json['updatedAt'] ?? '',
        packageId = json['PackageId'] ?? 0,
        packagePromoCodeId = json['PackagePromoCodeId'] ?? 0,
        userId = json['UserId'] ?? 0,
        clientPackageId = json['ClientPackageId'] ?? 0,
        packagePromoCode = json['PackagePromoCode'] != null
            ? PackagePromoCode.fromJson(json['PackagePromoCode'])
            : null;
}

//******************************************************************************
class PackagePromoCode {
  int? id;
  String? name;
  String? value;
  String? startDate;
  String? expiryDate;
  String? usageExpiryDate;
  int? percentage;
  int? count;
  int? maxCount;
  int? maxUse;
  int? feesDiscount;
  bool? private;
  bool? active;
  String? SMS;
  String? ENSMS;
  String? ActivateSMS;
  String? ActivateENSMS;
  String? createdAt;
  String? updatedAt;
  int? corporateCompanyId;
  CorporateCompany? corporateCompany;

  PackagePromoCode({
    this.id,
    this.name,
    this.value,
    this.startDate,
    this.expiryDate,
    this.usageExpiryDate,
    this.percentage,
    this.count,
    this.maxCount,
    this.maxUse,
    this.feesDiscount,
    this.private,
    this.active,
    this.SMS,
    this.ENSMS,
    this.ActivateSMS,
    this.ActivateENSMS,
    this.createdAt,
    this.updatedAt,
    this.corporateCompanyId,
    this.corporateCompany,
  });

  PackagePromoCode.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        name = json['name'] ?? '',
        value = json['value'] ?? '',
        startDate = json['startDate'] ?? '',
        expiryDate = json['expiryDate'] ?? '',
        usageExpiryDate = json['usageExpiryDate'] ?? '',
        percentage = json['percentage'] ?? 0,
        count = json['count'] ?? 0,
        maxCount = json['maxCount'] ?? 0,
        maxUse = json['maxUse'] ?? 0,
        feesDiscount = json['feesDiscount'] ?? 0,
        private = json['private'] ?? false,
        active = json['active'] ?? false,
        SMS = json['SMS'] ?? '',
        ENSMS = json['ENSMS'] ?? '',
        ActivateSMS = json['ActivateSMS'] ?? '',
        ActivateENSMS = json['ActivateENSMS'] ?? '',
        createdAt = json['createdAt'] ?? '',
        updatedAt = json['updatedAt'] ?? '',
        corporateCompanyId = json['CorporateCompanyId'] ?? 0,
        corporateCompany = json['CorporateCompany'] != null
            ? CorporateCompany.fromJson(json['CorporateCompany'])
            : null;
}
//******************************************************************************

class PackageBenefit {
  int? id;
  String? enName;
  String? arName;
  String? createdAt;
  String? updatedAt;
  int? packageId;

  PackageBenefit({
    this.id,
    this.enName,
    this.arName,
    this.createdAt,
    this.updatedAt,
    this.packageId,
  });

  PackageBenefit.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        enName = json['enName'] ?? '',
        arName = json['arName'] ?? '',
        createdAt = json['createdAt'] ?? '',
        updatedAt = json['updatedAt'] ?? '',
        packageId = json['packageId'] ?? 0;

  String get name => isArabic ? arName ?? '' : enName ?? '';
}
