// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpooappclient/Models/service_request/service_request_model.dart';
import 'package:helpooappclient/Models/service_request/vehicle.dart';

import '../../Configurations/Constants/constants.dart';
import '../cars/add_corporate_car_response.dart';
import '../cars/my_cars.dart';
import '../maps/direction_details.dart';
import 'driver.dart';
import 'getDistanceAndDurationResponse.dart';
import 'getRequestDuratonAndDistance.dart';
import 'my_google_maps_hit_response.dart';

class ServiceRequest {
  ServiceRequest({this.id});

  MapPickerStatus fieldPin = MapPickerStatus.pickup;
  bool ableToUsePicker = true;
  bool isWorking = false;
  bool isClickAble = true;
  int? id;
  String? createdByUserId;
  String? carId;
  String? clientUserId;
  int? clientId;
  String? clientFcmToken;
  String? clientName;
  String? clientPhone;
  RequestLocationsDataModel requestLocationModel = RequestLocationsDataModel();
  MyGoogleMapsHitResponse myGoogleMapsHitResponse = MyGoogleMapsHitResponse();
  num localDistance = -1;
  num localDuration = -1;
  num actualDuration = -1;
  num actualDistance = -1;
  int timerForHit = -1;
  int countForHit = 0;
  int countForGetOne = 0;
  num diffLastHitAndCurrentLocal = 0;
  double? currentGradientPercentage = 100;
  int? statusStatrtedDuration;
  int? intervalInSeconds;
  int? statusAcceptedDuration;
  DateTime? TimeOfLastUpdate;
  DateTime? currentTimeUtc;
  int? secondsFromLastUpdate;
  double? initialRemainingMetres;
  num? initialRemainingSeconds;
  GetRequestDurationAndDistanceDTO? getRequestDurationAndDistanceDto;
  ServiceRequestModel? activeReqModel;
  DateTime? v1;
  DateTime? v2;
  DateTime? v3;
  DateTime? v4;
  LatLng? fromForDTO;
  LatLng? toForDTO;
  late LatLng? from;
  late LatLng? to;
  DistanceAndDuration? getDistanceAndDurationResponse;
  DateTime? lastHitDate;
  DateTime? currentTime;
  Duration? timeElapsed;
  num? timeElapsedInSeconds;
  int? timeElapsedInMinutes;
  num? remainingTimeInSeconds;
  num? speedInMetersPerSecond;
  num? remainingDistanceInMeters;
  ServiceRequestStatus status = ServiceRequestStatus.created;
  int? fees;
  DateTime? createdAt;
  PaymentMethod paymentMethod = PaymentMethod.cash;
  PaymentStatus? paymentStatus = PaymentStatus.pending;
  String? comment;
  double rate = 0; // 0 = not rated yet
  int? originalFees;
  int? discountPercentage;
  int? discount;
  DateTime? arriveTime;
  DateTime? destArriveTime;
  DateTime? startServiceTime;
  String? vehiclePhoneNumber;
  int? waitingTimeAllowed;
  String? camUrl;
  bool rated = false;
  var corporateCompanyId;
  int? carServiceTypeId;
  String? corporateName;
  Vehicle? clientCar;
  Vehicle? helpooCar;
  Driver? driver;
  DirectionDetails? driverDirectionDetails;
  Map<String, int>? services;
  // from api caculation call
  String euroOriginalFees = "";
  String euroFees = "";
  String normOriginalFees = "";
  String normFees = "";
  String euroPercent = "";
  String normPercent = "";
  String otherServiceFees = "";
  int? parentRequest;
  bool promoCode = false;
  List<int>? selectedTowingService;
  double tripDistancePercentageRepresentation = 100;

  String get link => "https://dev.helpooapp.net/tracking/?id=$id";

  bool get created => status == ServiceRequestStatus.created;

  bool get opened => status == ServiceRequestStatus.opened;

  bool get confirmed => status == ServiceRequestStatus.confirmed;

  bool get accepted => status == ServiceRequestStatus.accepted;

  bool get arrived => status == ServiceRequestStatus.arrived;

  bool get destArrived => status == ServiceRequestStatus.destArrived;

  bool get started => status == ServiceRequestStatus.started;

  bool get done => status == ServiceRequestStatus.done;

  bool get pending => status == ServiceRequestStatus.pending;

  bool get canceled => status == ServiceRequestStatus.canceled;

  bool get canceledWithPayment =>
      status == ServiceRequestStatus.canceledWithPayment;

  bool get notAvailable => status == ServiceRequestStatus.notAvailable;

  bool get notPaid => paymentStatus == PaymentStatus.notPaid;

  bool get paid => paymentStatus == PaymentStatus.paid;

  bool get pendingPayment => paymentStatus == PaymentStatus.pending;

  bool get needRefund => paymentStatus == PaymentStatus.needRefund;

  bool get refundDone => paymentStatus == PaymentStatus.refundDone;

  double get percentage => tripDistancePercentageRepresentation;

  set percentage(double val) => tripDistancePercentageRepresentation = val;

  ServiceRequest.fromJson(Map json) {
    id = json['id'];
    camUrl = json['Vehicle']?['url'] ?? '';
    clientName = json['name'];
    fees = json['fees'] ?? 0;
    discount = json['discount'] ?? 0;
    arriveTime =
        json['arriveTime'] != null ? DateTime.parse(json['arriveTime']) : null;
    destArriveTime = json['destArriveTime'] != null
        ? DateTime.parse(json['destArriveTime'])
        : null;
    startServiceTime = json['startServiceTime'] != null
        ? DateFormat('yyyy-MM-ddTHH:mm:ssZ').parseUTC(json['startServiceTime']).toLocal():null;
    waitingTimeAllowed = json["location"]['waitingTimeAllowed'] ?? 0;
    paymentStatus = _parsePaymentStatus(json['paymentStatus']);
    status = _parseServiceRequestStatus(json['status']);
    discountPercentage = json['discountPercentage'] ?? 0;
    createdAt =
        json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    clientPhone = json['PhoneNumber'];
    paymentMethod = _parsePaymentMethod(json['paymentMethod'] ?? "cash");
    comment = json['comment'] ?? "";
    clientCar = json['Car'] != null ? Vehicle.fromJson(json['Car']) : null;
    originalFees = json['originalFees'];
    rated = json['rated'] ?? false;
    selectedTowingService = json['CarServiceTypes'] == null
        ? null
        : (json['CarServiceTypes'] as List).map((e) => e['id'] as int).toList();
    corporateCompanyId = json['CorporateCompanyId'];
    clientFcmToken = json['Client']?['fcmtoken'];
    clientUserId = json['Client']?['UserId'] != null
        ? json['Client']['UserId'].toString()
        : "";
    createdByUserId =
        json['createdByUser'] != null ? json['createdByUser'].toString() : "";

    driver = json['Driver'] != null
        ? (json['Driver'] as Map).containsKey('lat')
            ? Driver.fromJson(json['Driver'])
            : Driver.fromJson(json['Driver'], isFromCurrentReqResponse: true)
        : null;
    requestLocationModel = json['location'] != null
        ? RequestLocationsDataModel.fromJson(json['location'])
        : RequestLocationsDataModel();
    from = requestLocationModel.clientPoint;
    to = requestLocationModel.destPoint;
  }

  Map<String, dynamic> toJson(
    MyCarModel? selectedCarToRequest,
    CorporateUser? corporateUser, {
    bool isOtherService = false,
  }) {
    print('selectedCarToRequest?.id');
    print(selectedCarToRequest?.id);
    print(corporateUser?.id);
    print(corporateCompanyId);
    final jsonData = {
      "paymentMethod": paymentMethod.dbVal,
      "paymentStatus":
          paymentMethod == PaymentMethod.online ? "not-paid" : "pending",
      "carId": carId,
      // "clientId": userId,
      "clientId":
          corporateUser?.id != null ? corporateUser!.id : clientId.toString(),
      // "clientId": CurrentUser.isCorporate ? cubit.request.clientId.toString() : CurrentUser.id.toString(),
      "corporateId": corporateUser?.id != null ? clientId : corporateUser!.id,
      "createdByUser": createdByUserId,
      if (services != null && services!.isNotEmpty) "services": services,
      'driverId': driver?.id.toString(),
      "distance": driver?.distance?.toJson(),
      "clientAddress": requestLocationModel.clientAddress,
      "clientLatitude": requestLocationModel.clientPoint!.latitude.toString(),
      "clientLongitude": requestLocationModel.clientPoint!.longitude.toString(),
      if (parentRequest != null) "parentRequest": parentRequest,
    };
    if (isOtherService)
      return jsonData..removeWhere((key, value) => value == null);
    else
      return {
        ...jsonData,
        "distance": json.encode({
          "distance": {
            "value": requestLocationModel.distanceToClient,
            "text": requestLocationModel.distanceToClientText,
          }
        }),
        "carServiceTypeId": json.encode([carServiceTypeId]),
        "destinationDistance": json.encode({
          "distance": {"value": requestLocationModel.distanceToDest},
          "duration": {"value": requestLocationModel.timeToDest},
          "points": requestLocationModel.pointsClientToDest,
        }),
        "destinationAddress": requestLocationModel.destAddress,
        if (requestLocationModel.destPoint != null)
          "destinationLat": requestLocationModel.destPoint!.latitude.toString(),
        if (requestLocationModel.destPoint != null)
          "destinationLng":
              requestLocationModel.destPoint!.longitude.toString(),
      }..removeWhere((key, value) => value == null);
  }
}

class LastUpdatedDistanceAndDuration {
  ServiceRequestStatus? lastUpdatedStatus;
  String? createdAt;
  DriverDistanceMatrix? driverDistanceMatrix;
  List<LatLng>? points;

  LastUpdatedDistanceAndDuration(
      {this.lastUpdatedStatus, this.createdAt, this.driverDistanceMatrix});

  LastUpdatedDistanceAndDuration.fromJson(Map<String, dynamic> json) {
    lastUpdatedStatus = _parseServiceRequestStatus(json['status']);
    createdAt = json['createdAt'];
    points = json['points'] != null ? convertToLatLng(json['points']) : [];

    driverDistanceMatrix = json['driverDistanceMatrix'] != null
        ? new DriverDistanceMatrix.fromJson(json['driverDistanceMatrix'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.lastUpdatedStatus;
    data['createdAt'] = this.createdAt;
    if (this.driverDistanceMatrix != null) {
      data['driverDistanceMatrix'] = this.driverDistanceMatrix!.toJson();
    }
    return data;
  }
}

List<LatLng> convertToLatLng(List points) {
  List<LatLng> latLngList = [];

  for (var coordinates in points) {
    double lat = coordinates[0];
    double lng = coordinates[1];
    latLngList.add(LatLng(lat, lng));
  }
  return latLngList;
}

class RequestLocationsDataModel {
  RequestLocationsDataModel();

  num? distanceToClient;
  String? distanceToClientText;
  int? distanceToDest;
  List<LatLng>? pointsClientToDest;
  int? timeToDest;
  int? intervalsForNextHit;
  int? acceptedDuration;
  int? startedDuration;
  String? distanceToDestText;
  String? timeToDestText;
  String? clientAddress;
  String? destAddress;
  LatLng? clientPoint;
  LatLng? destPoint;
  LastUpdatedDistanceAndDuration? lastUpdatedDistanceAndDuration;
  LastUpdatedDistanceAndDuration? firstUpdatedDistanceAndDuration;

  RequestLocationsDataModel.fromJson(Map<String, dynamic> json) {
    intervalsForNextHit = json['acceptedWithTraffic']?['thisInterval'] ?? -1;
    acceptedDuration = json['acceptedWithTraffic']?['driverDistanceMatrix']
            ['duration']['value'] ??
        -1;
    startedDuration = json['startedWithTraffic']?['driverDistanceMatrix']
            ['duration']['value'] ??
        -1;
    distanceToClient = json['distance']['distance']['value'];
    distanceToClientText = json['distance']['distance']['text'];
    if (json['destinationDistance'] != null)
      distanceToDest = json['destinationDistance']['distance']['value'];
    if (json['destinationDistance'] != null)
      timeToDest = json['destinationDistance']['duration'] != null
          ? json['destinationDistance']['duration']['value']
          : 0;
    if (json['destinationDistance'] != null)
      distanceToDestText = json['destinationDistance']['distance']['text'];
    if (json['destinationDistance'] != null)
      pointsClientToDest = json['destinationDistance']['points'] != null
          ? _convertToLatLng(json['destinationDistance']['points'])
          : [];
    clientAddress = json['clientAddress'];
    destAddress = json['destinationAddress'];
    clientPoint = LatLng(
        double.parse(json['clientLatitude'].toString() ?? '0.0'),
        double.parse(json['clientLongitude'].toString() ?? '0.0'));
    if (json['destinationLat'] != null && json['destinationLng'] != null)
      destPoint = LatLng(
          double.parse(json['destinationLat'].toString() ?? '0.0'),
          double.parse(json['destinationLng'].toString() ?? '0.0'));
    lastUpdatedDistanceAndDuration =
        json['lastUpdatedDistanceAndDuration'] != null
            ? LastUpdatedDistanceAndDuration.fromJson(
                json['lastUpdatedDistanceAndDuration'])
            : null;
    firstUpdatedDistanceAndDuration =
        json['firstUpdatedDistanceAndDuration'] != null
            ? LastUpdatedDistanceAndDuration.fromJson(
                json['firstUpdatedDistanceAndDuration'])
            : null;
  }

  static List<LatLng> _convertToLatLng(List points) {
    List<LatLng> latLngList = [];

    for (var coordinates in points) {
      double lat = coordinates[0];
      double lng = coordinates[1];
      latLngList.add(LatLng(lat, lng));
    }
    return latLngList;
  }
}

class AllServiceRequests {
  List<ServiceRequest>? requests;

  AllServiceRequests({this.requests});

  AllServiceRequests.fromJson(Map json) {
    requests = (json['requests'] as List)
        .map((i) => ServiceRequest.fromJson(i))
        .toList();
  }
}

class AssignDriverToRequestResponse {
  String? status;
  String? vehicleNumber;
  String? msg;
  Driver? driver;
  Map? distance;

  AssignDriverToRequestResponse.fromJson(Map json) {
    status = json['status'];
    vehicleNumber = json['vehiclePhoneNumber'];
    msg = json['msg'];
    driver = json['driver'] != null ? Driver.fromJson(json['driver']) : null;
    distance = json['distance'];
  }
}

/// ****************************** needed enums ***************************

enum MapPickerStatus { pickup, destination }

enum PaymentMethod {
  cash('cash', 'Cash', 'كاش للسائق'),
  visa('card-to-driver', 'Visa', 'فيزا للسائق'),
  online('online-card', 'Online', 'دفع اونلاين'),
  wallet('wallet', 'Wallet', 'محفظة الكترونية');

  final String dbVal;
  final String enName;
  final String arName;

  const PaymentMethod(this.dbVal, this.enName, this.arName);
}

_parsePaymentMethod(String dbVal) {
  switch (dbVal) {
    case "cash":
      return PaymentMethod.cash;
    case "visa":
      return PaymentMethod.visa;
    case "online":
      return PaymentMethod.online;
    case "wallet":
      return PaymentMethod.wallet;
    default:
      return PaymentMethod.cash;
  }
}

enum ServiceRequestStatus {
  created('create', 'Created', 'تم الانشاء'),
  opened('open', 'Opened', 'تم الفتح'),
  confirmed('confirmed', 'Confirmed', 'تمت الموافقة'),
  pending('pending', 'Pending', 'قيد الانتظار'),
  canceled('canceled', 'Canceled', 'ملغي'),
  canceledWithPayment('cancel_with_payment', 'Canceled', 'ملغي'),
  notAvailable('not_available', 'NotAvailable', 'غير متاح'),
  accepted('accepted', 'Accepted', 'مقبول'),
  arrived('arrived', 'Arrived', 'تم الوصول'),
  destArrived('dest_arrived', 'Arrived', 'تم الوصول'),
  started('started', 'Started', 'تم البدا'),
  done('done', 'Done', 'انتهي'),
  paid('paid', 'Paid', 'تم الدفع');

  final String dbVal;
  final String enName;
  final String arName;

  const ServiceRequestStatus(this.dbVal, this.enName, this.arName);
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
      return ServiceRequestStatus.done;
  }
}

enum PaymentStatus {
  notPaid('not_paid', 'Not Paid', 'غير مدفوع'),
  pending('pending', 'Pending', 'غير مدفوع'),
  paid('paid', 'Paid', 'غير مدفوع'),
  needRefund('need_refund', 'Need Refund', 'غير مدفوع'),
  refundDone('refund_done', 'Refund Done', 'غير مدفوع');

  final String dbVal;
  final String enName;
  final String arName;

  const PaymentStatus(this.dbVal, this.enName, this.arName);
}

_parsePaymentStatus(String? dbVal) {
  if (dbVal != null) {
    switch (dbVal) {
      case "not_paid":
        return PaymentStatus.notPaid;
      case "pending":
        return PaymentStatus.pending;
      case "paid":
        return PaymentStatus.paid;
      case "need_refund":
        return PaymentStatus.needRefund;
      case "refund_done":
        return PaymentStatus.refundDone;
      default:
        return PaymentStatus.notPaid;
    }
  }
}

enum WenchType {
  norm('norm', 'Normal', 'عادي'),
  euro('euro', 'European', 'أوروبي (منخفض)');

  final String dbVal;
  final String enName;
  final String arName;

  String get name => isArabic ? arName : enName;

  const WenchType(this.dbVal, this.enName, this.arName);
}

_parseWenchType(String dbVal) {
  switch (dbVal) {
    case "norm":
      return WenchType.norm;
    case "euro":
      return WenchType.euro;
    default:
      return WenchType.norm;
  }
}

enum UserRequestProcesses {
  none,
  otherService,
  whichWench,
  selectedWenchDetails,
  passengersSheet,
  pricingSheet,
  paymentMethod,
  onlinePayment,
  driverWaiting,
  driverStates,
  history,
  rating,
  pending,
  notAvaliable
}

extension UserRequestProcessesX on UserRequestProcesses {
  get isNone => this == UserRequestProcesses.none;
  get isOtherService => this == UserRequestProcesses.otherService;
  get isWhichWench => this == UserRequestProcesses.whichWench;
  get isSelectedWenchDetails =>
      this == UserRequestProcesses.selectedWenchDetails;
  get isPassengersSheet => this == UserRequestProcesses.passengersSheet;
  get isPricingSheet => this == UserRequestProcesses.pricingSheet;
  get isPaymentMethod => this == UserRequestProcesses.paymentMethod;
  get isOnlinePayment => this == UserRequestProcesses.onlinePayment;
  get isDriverWaiting => this == UserRequestProcesses.driverWaiting;
  get isDriverStates => this == UserRequestProcesses.driverStates;
  get isHistory => this == UserRequestProcesses.history;
  get isRating => this == UserRequestProcesses.rating;
  get isPending => this == UserRequestProcesses.pending;
  get isNotAvaliable => this == UserRequestProcesses.notAvaliable;
}

//
// TODO: dev note for me (Belal) about enums
// enum CarServiceType1 {
//   fuel(1, 'نقل بنزين', 'Fuel'),
//   tiresFix(2, 'اصلاح كاوتش', 'Tires Fix'),
//   batteries(3, 'بطارية', 'Batteries'),
//   carTowing(4, 'ونش عادي', 'normal'),
//   premiumCarTowing(5, 'ونش اوروبي', 'European');
//
//   final int id;
//   final String nameAr;
//   final String nameEn;
//
//   const CarServiceType1(this.id, this.nameAr, this.nameEn);
// }
//
// enum CarServiceType {
//   fuel,
//   tiresFix,
//   batteries,
//   carTowing,
//   premiumCarTowing,
// }
// extension CarServiceTypeExtension on CarServiceType {
//   String get arName {
//     switch(this) {
//       case CarServiceType.fuel:
//         return 'نقل بنزين';
//       case CarServiceType.tiresFix:
//         return 'اصلاح كاوتش';
//       case CarServiceType.batteries:
//         return 'بطارية';
//       case CarServiceType.carTowing:
//         return 'ونش عادي';
//       case CarServiceType.premiumCarTowing:
//         return 'ونش اوروبي';
//       default:
//         return 'ونش عادي';
//     }
//   }
//
//   String get enName {
//     switch(this) {
//       case CarServiceType.fuel:
//         return 'Fuel';
//       case CarServiceType.tiresFix:
//         return 'Tires Fix';
//       case CarServiceType.batteries:
//         return 'Batteries';
//       case CarServiceType.carTowing:
//         return 'Car Towing';
//       case CarServiceType.premiumCarTowing:
//         return 'Premium Car Towing';
//     }
//   }
//
//   String get dbName {
//     switch(this) {
//       case CarServiceType.fuel:
//         return 'fuel';
//       case CarServiceType.tiresFix:
//         return 'tiresFix';
//       case CarServiceType.batteries:
//         return 'batteries';
//       case CarServiceType.carTowing:
//         return 'carTowing';
//       case CarServiceType.premiumCarTowing:
//         return 'premiumCarTowing';
//     }
//   }
// }
//
