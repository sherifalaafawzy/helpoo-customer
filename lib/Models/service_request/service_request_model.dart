import '../cars/add_corporate_car_response.dart';
import '../cars/my_cars.dart';
import 'service_request.dart';

class ServiceRequestModel {
   String? status;
   ServiceRequest? activeReq;
   LocationPrevRequestModel? firstClientDestination;
   LocationPrevRequestModel? firstClientLocation;
   ServiceRequestStatus? oldRequestStatus;

  ServiceRequestModel({
    required this.status,
    required this.activeReq,
    this.firstClientDestination,
    this.firstClientLocation,
    this.oldRequestStatus,
  });

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) {
    return ServiceRequestModel(
      status: json['status'] ?? '',
      activeReq:
          json['request'].runtimeType == List ? ServiceRequest.fromJson(json['request'][0]) : ServiceRequest.fromJson(json['request']),
      firstClientDestination: json['location'] != null ? LocationPrevRequestModel.fromJson(json['location']) : null,
      firstClientLocation: json['firstClientLocation'] != null ? LocationPrevRequestModel.fromJson(json['firstClientLocation']) : null,
     oldRequestStatus: _parseServiceRequestStatus(json['oldRequestStatus'])
    );
  }

  Map<String, dynamic> toJson(MyCarModel? selectedCarToRequest,CorporateUser? corporateUser) {
    return {
      'status': status,
      'request': activeReq!.toJson(selectedCarToRequest,corporateUser),
    };
  }
}

class LocationPrevRequestModel {
  final num latitude;
  final num longitude;

  LocationPrevRequestModel({
    required this.latitude,
    required this.longitude,
  });

  factory LocationPrevRequestModel.fromJson(Map<String, dynamic> json) {
    return LocationPrevRequestModel(
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
    );
  }
}

class SRVehicleModel {
  final String VecPlate;
  final String VecName;
  final int VecNum;
  // final int Active_Driver;
  // final int Vec_type;
  // final bool available;

  SRVehicleModel({
    required this.VecPlate,
    required this.VecName,
    required this.VecNum,
    // required this.Active_Driver,
    // required this.Vec_type,
    // required this.available,
  });

  factory SRVehicleModel.fromJson(Map<String, dynamic> json) {
    return SRVehicleModel(
      VecPlate: json['Vec_plate'] ?? '',
      VecName: json['Vec_name'] ?? '',
      VecNum: json['Vec_num'] ?? 0,
      // Active_Driver: json['Active_Driver'] ?? '',
      // Vec_type: json['Vec_type'] ?? '',
      // available: json['available'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Vec_plate': VecPlate,
      'Vec_name': VecName,
      'Vec_num': VecNum,
      // 'Active_Driver': Active_Driver,
      // 'Vec_type': Vec_type,
      // 'available': available,
    };
  }
}

class ServiceRequestDetails {
  final int id;
  final String status;
  final num fees;
  final num originalFees;
  final String paymentMethod;
  final String paymentStatus;
  int? discount;
  int? discountPercentage;
  int? adminDiscount;
  String? adminDiscountApprovedBy;
  String? adminDiscountReason;
  bool? isAdminDiscountApplied;
  int? waitingFees;
  int? waitingTime;
  bool? isWaitingTimeApplied;
  PolicyAndPackage? policyAndPackage;
  final int driverId;
  final DriverRequestDetailsModel? driverRequestDetailsModel;
  final LocationRequestDetailsModel? locationRequestDetailsModel;
  SRVehicleModel? vehicle;

  ServiceRequestDetails({
    required this.id,
    required this.status,
    required this.fees,
    required this.originalFees,
    required this.paymentMethod,
    required this.paymentStatus,
    this.discount,
    this.discountPercentage,
    this.adminDiscount,
    this.adminDiscountApprovedBy,
    this.adminDiscountReason,
    this.isAdminDiscountApplied,
    this.waitingFees,
    this.waitingTime,
    this.isWaitingTimeApplied,
    this.policyAndPackage,
    required this.driverId,
    required this.driverRequestDetailsModel,
    required this.locationRequestDetailsModel,
    this.vehicle,
  });

  factory ServiceRequestDetails.fromJson(Map<String, dynamic> json) {
    return ServiceRequestDetails(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      fees: json['fees'] ?? 0.0,
      originalFees: json['originalFees'] ?? 0.0,
      paymentMethod: json['paymentMethod'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      discount: json['discount'] ?? 0,
      discountPercentage: json['discountPercentage'] ?? 0,
      adminDiscount: json['adminDiscount'] ?? 0,
      adminDiscountApprovedBy: json['adminDiscountApprovedBy'] ?? '',
      adminDiscountReason: json['adminDiscountReason'] ?? '',
      isAdminDiscountApplied: json['isAdminDiscountApplied'] ?? false,
      waitingFees: json['waitingFees'] ?? 0,
      waitingTime: json['waitingTime'] ?? 0,
      isWaitingTimeApplied: json['isWaitingTimeApplied'] ?? false,
      policyAndPackage: json['policyAndPackage'] != null ? PolicyAndPackage.fromJson(json['policyAndPackage']) : null,
      driverId: json['DriverId'] ?? 0,
      driverRequestDetailsModel: json['Driver'] != null ? DriverRequestDetailsModel.fromJson(json['Driver']) : null,
      locationRequestDetailsModel: json['location'] != null ? LocationRequestDetailsModel.fromJson(json['location']) : null,
      vehicle: json['Vehicle'] != null ? SRVehicleModel.fromJson(json['Vehicle']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'fees': fees,
      'originalFees': originalFees,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'DriverId': driverId,
      'Driver': driverRequestDetailsModel?.toJson(),
      'location': locationRequestDetailsModel?.toJson(),
      'Vehicle': vehicle?.toJson(),
    };
  }
}

class DriverRequestDetailsModel {
  final int id;
  final bool offline;
  final bool available;
  final num latitude;
  final num longitude;
  final String heading;
  final String averageRating;
  final String fcmtoken;
  final int ratingCount;
  final DriverUserModel driverUserModel;

  DriverRequestDetailsModel({
    required this.id,
    required this.offline,
    required this.available,
    required this.latitude,
    required this.longitude,
    required this.heading,
    required this.averageRating,
    required this.ratingCount,
    required this.driverUserModel,
    required this.fcmtoken,
  });

  factory DriverRequestDetailsModel.fromJson(Map<String, dynamic> json) {
    return DriverRequestDetailsModel(
      id: json['id'] ?? 0,
      offline: json['offline'] ?? false,
      available: json['available'] ?? false,
      latitude: json['location'] != null ? json['location']['latitude'] ?? 0.0 : 0.0,
      longitude: json['location'] != null ? json['location']['longitude'] ?? 0.0 : 0.0,
      heading: json['location'] != null ? json['location']['heading'] ?? '0.0' : '0.0',
      averageRating: json['average_rating'] ?? '',
      fcmtoken: json['fcmtoken'] ?? '',
      ratingCount: json['rating_count'] ?? 0,
      driverUserModel: DriverUserModel.fromJson(json['User'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'offline': offline,
      'available': available,
      'latitude': latitude,
      'longitude': longitude,
      'heading': heading,
      'average_rating': averageRating,
      'rating_count': ratingCount,
      'User': driverUserModel.toJson(),
    };
  }
}

class DriverUserModel {
  final int id;
  final String PhoneNumber;
  final String name;
  final String photo;

  DriverUserModel({
    required this.id,
    required this.PhoneNumber,
    required this.name,
    required this.photo,
  });

  factory DriverUserModel.fromJson(Map<String, dynamic> json) {
    return DriverUserModel(
      id: json['id'] ?? 0,
      PhoneNumber: json['PhoneNumber'] ?? '',
      name: json['name'] ?? '',
      photo: json['photo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'PhoneNumber': PhoneNumber,
      'name': name,
      'photo': photo,
    };
  }
}

class PolicyAndPackage {
  String? status;
  String? policyEnd;
  int? usedCount;
  String? policyStart;
  String? policyNumber;
  bool? policyCanceled;
  int? maxTotalDiscount;
  int? packageRequestCount;
  int? packageDiscountPercentage;
  int? discountPercentAfterPolicyExpires;

  PolicyAndPackage({
    this.status,
    this.policyEnd,
    this.usedCount,
    this.policyStart,
    this.policyNumber,
    this.policyCanceled,
    this.maxTotalDiscount,
    this.packageRequestCount,
    this.packageDiscountPercentage,
    this.discountPercentAfterPolicyExpires,
  });

  PolicyAndPackage.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    policyEnd = json['policy_end'];
    usedCount = json['used_count'];
    policyStart = json['policy_start'];
    policyNumber = json['policy_number'];
    policyCanceled = json['policy_canceled'];
    maxTotalDiscount = json['max_total_discount'];
    packageRequestCount = json['package_request_count'];
    packageDiscountPercentage = json['package_discount_percentage'];
    discountPercentAfterPolicyExpires = json['discount_percent_after_policy_expires'];
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'policy_end': policyEnd,
      'used_count': usedCount,
      'policy_start': policyStart,
      'policy_number': policyNumber,
      'policy_canceled': policyCanceled,
      'max_total_discount': maxTotalDiscount,
      'package_request_count': packageRequestCount,
      'package_discount_percentage': packageDiscountPercentage,
      'discount_percent_after_policy_expires': discountPercentAfterPolicyExpires,
    };
  }
}

class LocationRequestDetailsModel {
  final String clientAddress;
  final num clientLatitude;
  final num clientLongitude;
  final String destinationAddress;
  final num destinationLatitude;
  final num destinationLongitude;

  LocationRequestDetailsModel({
    required this.clientAddress,
    required this.clientLatitude,
    required this.clientLongitude,
    required this.destinationAddress,
    required this.destinationLatitude,
    required this.destinationLongitude,
  });

  factory LocationRequestDetailsModel.fromJson(Map<String, dynamic> json) {
    return LocationRequestDetailsModel(
      clientAddress: json['clientAddress'] ?? '',
      clientLatitude: num.parse((json['clientLatitude'] as String)),
      clientLongitude: num.parse((json['clientLongitude'] as String)),
      destinationAddress: json['destinationAddress'] ?? '',
      destinationLatitude: num.parse((json['destinationLat'] as String)),
      destinationLongitude: num.parse((json['destinationLng'] as String)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clientAddress': clientAddress,
      'clientLatitude': clientLatitude,
      'clientLongitude': clientLongitude,
      'destinationAddress': destinationAddress,
      'destinationLatitude': destinationLatitude,
      'destinationLongitude': destinationLongitude,
    };
  }
}
_parseServiceRequestStatus(dbVal) {
  switch (dbVal) {
    case 'create':
      return ServiceRequestStatus.created;
    case 'open':
      return ServiceRequestStatus.opened;
    case 'pending':
      return ServiceRequestStatus.pending;
    case 'confirmed':
      return ServiceRequestStatus.confirmed;
    case 'arrived':
      return ServiceRequestStatus.arrived;
    case 'destArrived':
      return ServiceRequestStatus.destArrived;
    case 'canceled':
      return ServiceRequestStatus.canceled;
    case 'not_available':
      return ServiceRequestStatus.notAvailable;
    case 'accepted':
      return ServiceRequestStatus.accepted;
    case 'started':
      return ServiceRequestStatus.started;
    case 'done':
      return ServiceRequestStatus.done;
    case 'paid':
      return ServiceRequestStatus.paid;
    default:
      return null;
  }
}
