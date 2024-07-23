import '../cars/my_cars.dart';
import '../locationModel.dart';

class LatestFnolModel {
  int? id;
  int? requiredImagesNo;
  int? uploadedImagesCounter;
  String? ref;
  String? comment;
  String? phoneNumber;
  String? client;
  String? repairCost;
  String? commentUser;
  String? status;
  List<String>? statusList;
  String? aiRef;
  LocationModel? location;
  List<String>? billDeliveryDate;
  List<String>? billDeliveryTimeRange;
  List<String>? billDeliveryNotes;
  List<LocationModel>? billDeliveryLocation;
  List<LocationModel>? beforeRepairLocation;
  List<LocationModel>? afterRepairLocation;
  List<LocationModel>? rightSaveLocation;
  String? video;
  List<LocationModel>? supplementLocation;
  List<LocationModel>? resurveyLocation;
  bool? read;
  bool? sentToSolera;
  String? createdAt;
  String? updatedAt;
  int? carId;
  String? createdByUser;
  int? clientId;
  int? inspectorId;
  int? inspectionCompanyId;
  int? insuranceCompanyId;
  MyCarModel? car;
  List<Images>? images;
  List<CarAccidentReports>? carAccidentReports;
  List<AccidentTypes>? accidentTypes;

  LatestFnolModel(
      {this.id,
      this.requiredImagesNo,
      this.uploadedImagesCounter,
      this.ref,
      this.comment,
      this.phoneNumber,
      this.client,
      this.repairCost,
      this.commentUser,
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
      // this.bRepairName,
      this.rightSaveLocation,
      this.supplementLocation,
      this.resurveyLocation,
      this.read,
      this.sentToSolera,
      this.createdAt,
      this.updatedAt,
      this.carId,
      this.createdByUser,
      this.clientId,
      this.inspectorId,
      this.inspectionCompanyId,
      this.insuranceCompanyId,
      this.car,
      this.images,
      this.carAccidentReports,
      this.accidentTypes});

  LatestFnolModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    requiredImagesNo = json['requiredImagesNo'] ?? 0;
    uploadedImagesCounter = json['uploadedImagesCounter'] ?? 0;
    ref = json['ref'] ?? '';
    comment = json['comment'] ?? '';
    phoneNumber = json['phoneNumber'] ?? "";
    client = json['client'] ?? "";
    repairCost = json['repairCost'] ?? "";
    commentUser = json['commentUser'] ?? "";
    status = json['status'] ?? "";
    statusList = json['statusList'].cast<String>();
    aiRef = json['aiRef'] ?? '';
    location = json['location'] != null ? new LocationModel.fromJson(json['location']) : null;
        if (json['billDeliveryDate'] != null) {
      billDeliveryDate = <String>[];
      json['billDeliveryDate'].forEach((v) {
        billDeliveryDate!.add(v);
      });
    }
        if (json['billDeliveryTimeRange'] != null) {
      billDeliveryTimeRange = <String>[];
      json['billDeliveryTimeRange'].forEach((v) {
        billDeliveryTimeRange!.add(v);
      });
    }
        if (json['billDeliveryNotes'] != null) {
      billDeliveryNotes = <String>[];
      json['billDeliveryNotes'].forEach((v) {
        billDeliveryNotes!.add(v);
      });
    }
    if (json['billDeliveryLocation'] != null) {
      billDeliveryLocation = <LocationModel>[];
      json['billDeliveryLocation'].forEach((v) {
        billDeliveryLocation!.add(new LocationModel.fromJson(v));
      });
    }
    if (json['beforeRepairLocation'] != null) {
      beforeRepairLocation = <LocationModel>[];
      json['beforeRepairLocation'].forEach((v) {
        beforeRepairLocation!.add(new LocationModel.fromJson(v));
      });
    }
    if (json['supplementLocation'] != null) {
      supplementLocation = <LocationModel>[];
      json['supplementLocation'].forEach((v) {
        supplementLocation!.add(new LocationModel.fromJson(v));
      });
    }

    if (json['resurveyLocation'] != null) {
      resurveyLocation = <LocationModel>[];
      json['resurveyLocation'].forEach((v) {
        resurveyLocation!.add(new LocationModel.fromJson(v));
      });
    }
    if (json['afterRepairLocation'] != null) {
      afterRepairLocation = <LocationModel>[];
      json['afterRepairLocation'].forEach((v) {
        afterRepairLocation!.add(new LocationModel.fromJson(v));
      });
    }
    if (json['rightSaveLocation'] != null) {
      rightSaveLocation = <LocationModel>[];
      json['rightSaveLocation'].forEach((v) {
        rightSaveLocation!.add(new LocationModel.fromJson(v));
      });
    }
    video = json['video'] ?? "";

    read = json['read'] ?? false;
    sentToSolera = json['sentToSolera'] ?? false;
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    carId = json['carId'] ?? 0;
    createdByUser = json['createdByUser'].toString() ?? "";
    clientId = json['clientId'] ?? "";
    inspectorId = json['InspectorId'] ?? 0;
    inspectionCompanyId = json['inspectionCompanyId'] ?? 0;
    insuranceCompanyId = json['insuranceCompanyId'] ?? 0;
    car = json['Car'] != null ? new MyCarModel.fromJson(json['Car']) : null;
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    if (json['CarAccidentReports'] != null) {
      carAccidentReports = <CarAccidentReports>[];
      json['CarAccidentReports'].forEach((v) {
        carAccidentReports!.add(new CarAccidentReports.fromJson(v));
      });
    }
    if (json['accidentTypes'] != null) {
      accidentTypes = <AccidentTypes>[];
      json['accidentTypes'].forEach((v) {
        accidentTypes!.add(new AccidentTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['requiredImagesNo'] = this.requiredImagesNo;
    data['uploadedImagesCounter'] = this.uploadedImagesCounter;
    data['ref'] = this.ref;
    data['comment'] = this.comment;
    data['phoneNumber'] = this.phoneNumber;
    data['client'] = this.client;
    data['repairCost'] = this.repairCost;
    data['commentUser'] = this.commentUser;
    data['status'] = this.status;
    data['statusList'] = this.statusList;
    data['aiRef'] = this.aiRef;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['billDeliveryDate'] = this.billDeliveryDate;
    data['billDeliveryTimeRange'] = this.billDeliveryTimeRange;
    data['billDeliveryNotes'] = this.billDeliveryNotes;
    data['billDeliveryLocation'] = this.billDeliveryLocation;
    if (this.beforeRepairLocation != null) {
      data['beforeRepairLocation'] = this.beforeRepairLocation!.map((v) => v.toJson()).toList();
    }
    data['afterRepairLocation'] = this.afterRepairLocation;
    data['video'] = this.video;
    // data['bRepairName'] = this.bRepairName;
    data['rightSaveLocation'] = this.rightSaveLocation;
    data['supplementLocation'] = this.supplementLocation;
    data['resurveyLocation'] = this.resurveyLocation;
    data['read'] = this.read;
    data['sentToSolera'] = this.sentToSolera;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['carId'] = this.carId;
    data['createdByUser'] = this.createdByUser;
    data['clientId'] = this.clientId;
    data['InspectorId'] = this.inspectorId;
    data['inspectionCompanyId'] = this.inspectionCompanyId;
    data['insuranceCompanyId'] = this.insuranceCompanyId;
    // if (this.car != null) {
    //   data['Car'] = this.car!.toJson();
    // }
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.carAccidentReports != null) {
      data['CarAccidentReports'] = this.carAccidentReports!.map((v) => v.toJson()).toList();
    }
    if (this.accidentTypes != null) {
      data['accidentTypes'] = this.accidentTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  int? id;
  String? imageName;
  String? imagePath;
  bool? additional;
  int? count;
  String? createdAt;
  String? updatedAt;
  int? accidentReportId;

  Images({this.id, this.imageName, this.imagePath, this.additional, this.count, this.createdAt, this.updatedAt, this.accidentReportId});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageName = json['imageName'];
    imagePath = json['imagePath'];
    additional = json['additional'];
    count = json['count'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    accidentReportId = json['accidentReportId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imageName'] = this.imageName;
    data['imagePath'] = this.imagePath;
    data['additional'] = this.additional;
    data['count'] = this.count;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['accidentReportId'] = this.accidentReportId;
    return data;
  }
}

class CarAccidentReports {
  int? id;
  String? report;
  bool? active;
  String? createdAt;
  String? updatedAt;
  int? accidentReportId;
  int? pdfReportId;

  CarAccidentReports({this.id, this.report, this.active, this.createdAt, this.updatedAt, this.accidentReportId, this.pdfReportId});

  CarAccidentReports.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    report = json['report'];
    active = json['active'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    accidentReportId = json['AccidentReportId'];
    pdfReportId = json['pdfReportId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['report'] = this.report;
    data['active'] = this.active;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['AccidentReportId'] = this.accidentReportId;
    data['pdfReportId'] = this.pdfReportId;
    return data;
  }
}

class AccidentTypes {
  int? id;
  String? enName;
  String? arName;
  String? requiredImages;
  String? createdAt;
  String? updatedAt;
  AccidentTypesAndReports? accidentTypesAndReports;

  AccidentTypes({this.id, this.enName, this.arName, this.requiredImages, this.createdAt, this.updatedAt, this.accidentTypesAndReports});

  AccidentTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    enName = json['en_name'];
    arName = json['ar_name'];
    requiredImages = json['requiredImages'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    accidentTypesAndReports = json['AccidentTypesAndReports'] != null ? new AccidentTypesAndReports.fromJson(json['AccidentTypesAndReports']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['en_name'] = this.enName;
    data['ar_name'] = this.arName;
    data['requiredImages'] = this.requiredImages;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.accidentTypesAndReports != null) {
      data['AccidentTypesAndReports'] = this.accidentTypesAndReports!.toJson();
    }
    return data;
  }
}

class AccidentTypesAndReports {
  int? id;
  int? accidentTypeId;
  int? accidentReportId;
  String? createdAt;
  String? updatedAt;

  AccidentTypesAndReports({this.id, this.accidentReportId, this.createdAt, this.updatedAt, this.accidentTypeId});

  AccidentTypesAndReports.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accidentTypeId = json['AccidentTypeId'];
    accidentReportId = json['AccidentReportId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    accidentTypeId = json['accidentTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['AccidentTypeId'] = this.accidentTypeId;
    data['AccidentReportId'] = this.accidentReportId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['accidentTypeId'] = this.accidentTypeId;
    return data;
  }
}
