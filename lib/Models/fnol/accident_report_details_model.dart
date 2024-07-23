import 'package:helpooappclient/Models/auth/login_model.dart';
import 'package:helpooappclient/Models/cars/car_model.dart';
import 'package:helpooappclient/Models/cars/manufacturer_model.dart';
import 'package:helpooappclient/Models/cars/my_cars.dart';
import 'package:helpooappclient/Models/fnol/latestFnolModel.dart';

import '../service_request/insurance_company.dart';
import '../user/user_model.dart';
import 'imagesModel.dart';
import 'locationAddress.dart';

class GetAccidentDetailsModel {
  String? status;
  Report? report;
  List<ImagesModel>? mainImages;
  List<ImagesModel>? policeImages;
  List<ImagesModel>? supplementImages;
  List<ImagesModel>? bRepairImages;
  List<ImagesModel>? resurveyImages;
  List<ImagesModel>? additional;

  GetAccidentDetailsModel(
      {this.status,
      this.report,
      this.mainImages,
      this.policeImages,
      this.supplementImages,
      this.bRepairImages,
      this.resurveyImages,
      this.additional});

  GetAccidentDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? '';
    report = json['report'] != null ? Report.fromJson(json['report']) : null;
    mainImages = json['mainImages'] != null
        ? (json['mainImages'] as List)
            .map((e) => ImagesModel.fromJson(e))
            .toList()
        : null;
    policeImages = json['policeImages'] != null
        ? (json['policeImages'] as List)
            .map((e) => ImagesModel.fromJson(e))
            .toList()
        : null;
    supplementImages = json['supplementImages'] != null
        ? (json['supplementImages'] as List)
            .map((e) => ImagesModel.fromJson(e))
            .toList()
        : null;
    bRepairImages = json['bRepairImages'] != null
        ? (json['bRepairImages'] as List)
            .map((e) => ImagesModel.fromJson(e))
            .toList()
        : null;
    resurveyImages = json['resurveyImages'] != null
        ? (json['resurveyImages'] as List)
            .map((e) => ImagesModel.fromJson(e))
            .toList()
        : null;
    additional = json['additional'] != null
        ? (json['additional'] as List)
            .map((e) => ImagesModel.fromJson(e))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'report': report!.toJson(),
      'mainImages': mainImages!.map((v) => v.toJson()).toList(),
      'policeImages': policeImages!.map((v) => v.toJson()).toList(),
      'supplementImages': supplementImages!.map((v) => v.toJson()).toList(),
      'bRepairImages': bRepairImages!.map((v) => v.toJson()).toList(),
      'resurveyImages': resurveyImages!.map((v) => v.toJson()).toList(),
      'additional': additional!.map((v) => v.toJson()).toList(),
    };
  }
}

//******************************************************************************
class Report {
  int? id;
  int? requiredImagesNo;
  int? uploadedImagesCounter;
  String? ref;
  String? comment;
  String? phoneNumber;
  String? audioCommentWritten;
  String? client;
  String? repairCost;
  String? commentUser;
  String? status;
  List<String>? statusList;
  String? aiRef;
  LocationAddress? location;
  List<String>? billDeliveryDate;
  List<String>? billDeliveryTimeRange;
  List<String>? billDeliveryNotes;
  List<LocationAddress>? billDeliveryLocation;
  List<LocationAddress>? beforeRepairLocation;
  List<LocationAddress>? afterRepairLocation;
  String? video;
  List<String>? bRepairName;
  List<LocationAddress>? rightSaveLocation;
  List<LocationAddress>? supplementLocation;
  List<LocationAddress>? resurveyLocation;
  String? createdAt;
  String? updatedAt;
  int? carId;
  int? createdByUser;
  int? clientId;
  int? insuranceCompanyId;
  InsuranceCompany? insuranceCompany;
  MyCarModel? car;
  List<AccidentTypes>? accidentTypes;
  User? clientModel;

  Report({
    this.id,
    this.requiredImagesNo,
    this.uploadedImagesCounter,
    this.ref,
    this.comment,
    this.phoneNumber,
    this.client,
    this.repairCost,
    this.commentUser,
    this.audioCommentWritten,
    this.status,
    this.statusList,
    this.aiRef,
    this.location,
    this.billDeliveryDate,
    this.billDeliveryTimeRange,
    this.billDeliveryNotes,
    this.billDeliveryLocation,
    this.beforeRepairLocation,
    this.afterRepairLocation,
    this.video,
    this.bRepairName,
    this.rightSaveLocation,
    this.supplementLocation,
    this.resurveyLocation,
    this.createdAt,
    this.updatedAt,
    this.carId,
    this.createdByUser,
    this.clientId,
    this.insuranceCompanyId,
    this.car,
    this.accidentTypes,
    this.clientModel,
    this.insuranceCompany,
  });

  Report.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    requiredImagesNo = json['requiredImagesNo'] ?? 0;
    uploadedImagesCounter = json['uploadedImagesCounter'] ?? 0;
    ref = json['ref'] ?? '';
    comment = json['comment'] ?? '';
    phoneNumber = json['phoneNumber'] ?? '';
    client = json['client'] ?? '';
    repairCost = json['repairCost'] ?? '';
    commentUser = json['commentUser'] ?? '';
    audioCommentWritten = json['audioCommentWritten'] ?? '';
    status = json['status'] ?? '';
    statusList = json['statusList'] != null
        ? (json['statusList'] as List).map((e) => e.toString()).toList()
        : null;
    aiRef = json['aiRef'] ?? '';
    location = json['location'] != null
        ? LocationAddress.fromJson(json['location'])
        : null;
    billDeliveryDate = json['billDeliveryDate'] != null
        ? (json['billDeliveryDate'] as List).map((e) => e.toString()).toList()
        : null;
    billDeliveryTimeRange = json['billDeliveryTimeRange'] != null
        ? (json['billDeliveryTimeRange'] as List)
            .map((e) => e.toString())
            .toList()
        : null;
    billDeliveryNotes = json['billDeliveryNotes'] != null
        ? (json['billDeliveryNotes'] as List).map((e) => e.toString()).toList()
        : null;
    billDeliveryLocation = json['billDeliveryLocation'] != null
        ? (json['billDeliveryLocation'] as List)
            .map((e) => LocationAddress.fromJson(e))
            .toList()
        : null;
    beforeRepairLocation = json['beforeRepairLocation'] != null
        ? (json['beforeRepairLocation'] as List)
            .map((e) => LocationAddress.fromJson(e))
            .toList()
        : null;
    afterRepairLocation = json['afterRepairLocation'] != null
        ? (json['afterRepairLocation'] as List)
            .map((e) => LocationAddress.fromJson(e))
            .toList()
        : null;
    video = json['video'] ?? '';
    bRepairName = json['bRepairName'] != null
        ? (json['bRepairName'] as List).map((e) => e.toString()).toList()
        : null;
    rightSaveLocation = json['rightSaveLocation'] != null
        ? (json['rightSaveLocation'] as List)
            .map((e) => LocationAddress.fromJson(e))
            .toList()
        : null;

    supplementLocation = json['supplementLocation'] != null
        ? (json['supplementLocation'] as List)
            .map((e) => LocationAddress.fromJson(e))
            .toList()
        : null;
    resurveyLocation = json['resurveyLocation'] != null
        ? (json['resurveyLocation'] as List)
            .map((e) => LocationAddress.fromJson(e))
            .toList()
        : null;
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
    carId = json['carId'];
    createdByUser = json['createdByUser'];
    clientId = json['clientId'];
    insuranceCompanyId = json['insuranceCompanyId'];
    car = json['Car'] != null ? MyCarModel.fromJson(json['Car']) : null;
    accidentTypes = json['accidentTypes'] != null
        ? (json['accidentTypes'] as List)
            .map((e) => AccidentTypes.fromJson(e))
            .toList()
        : null;
    clientModel = json['Client'] != null ? User.fromJson(json['Client']) : null;
    insuranceCompany = json['insuranceCompany'] != null
        ? InsuranceCompany.fromJson(json['insuranceCompany'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requiredImagesNo': requiredImagesNo,
      'uploadedImagesCounter': uploadedImagesCounter,
      'ref': ref,
      'comment': comment,
      'phoneNumber': phoneNumber,
      'client': client,
      'repairCost': repairCost,
      'commentUser': commentUser,
      'audioCommentWritten': audioCommentWritten,
      'status': status,
      'statusList': statusList,
      'aiRef': aiRef,
      'location': location?.toJson(),
      'billDeliveryDate': billDeliveryDate,
      'billDeliveryTimeRange': billDeliveryTimeRange,
      'billDeliveryNotes': billDeliveryNotes,
      'billDeliveryLocation':
          billDeliveryLocation?.map((v) => v.toJson()).toList(),
      'beforeRepairLocation':
          beforeRepairLocation?.map((v) => v.toJson()).toList(),
      'afterRepairLocation':
          afterRepairLocation?.map((v) => v.toJson()).toList(),
      'video': video,
      'bRepairName': bRepairName,
      'rightSaveLocation': rightSaveLocation?.map((v) => v.toJson()).toList(),
      'supplementLocation': supplementLocation?.map((v) => v.toJson()).toList(),
      'resurveyLocation': resurveyLocation?.map((v) => v.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'carId': carId,
      'createdByUser': createdByUser,
      'clientId': clientId,
      'insuranceCompanyId': insuranceCompanyId,
      'Car': car?.toJson(),
      'accidentTypes': accidentTypes?.map((v) => v.toJson()).toList(),
      'Client': clientModel?.toJson(),
      'InsuranceCompany': insuranceCompany?.toJson(),
    };
  }
}
