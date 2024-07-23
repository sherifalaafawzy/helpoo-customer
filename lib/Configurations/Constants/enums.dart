enum InspectionType { preInception, beforeRepair, supplement, afterRepair, rightSave }

extension InspectionTypeExtension on InspectionType {
  String get apiName {
    switch (this) {
      case InspectionType.preInception:
        return 'preInception';
      case InspectionType.beforeRepair:
        return 'beforeRepair';
      case InspectionType.supplement:
        return 'supplement';
      case InspectionType.afterRepair:
        return 'afterRepair';
      case InspectionType.rightSave:
        return 'rightSave';
    }
  }

  String get name {
    switch (this) {
      case InspectionType.preInception:
        return 'Pre-Inception';
      case InspectionType.beforeRepair:
        return 'Before Repair';
      case InspectionType.supplement:
        return 'Supplement';
      case InspectionType.afterRepair:
        return 'After Repair';
      case InspectionType.rightSave:
        return 'Right Save';
    }
  }
}

enum FNOLSteps {
  created(
    'FNOL',
    'FNOL',
    'created',
  ),
  policeReport(
    'Police Images',
    'Police Report',
    'policeReport',
  ),
  bRepair(
    'Before Repair Images',
    'Before Repair',
    'bRepair',
  ),
  supplement(
    'Supplement Images',
    'Supplement',
    'supplement',
  ),
  resurvey(
    'Resurvey Images',
    'Resurvey',
    'resurvey',
  ),
  aRepair(
    'After Repair',
    'After Repair',
    'aRepair',
  ),
  rightSave(
    'Right Save',
    'Right Save',
    'rightSave',
  ),
  billing(
    'Billing',
    'Billing',
    'billing',
  ),
  additional(
    '',
    '',
    '',
  );

  get isCreated => this == FNOLSteps.created;

  get isPoliceReport => this == FNOLSteps.policeReport;
  get isAdditional => this == FNOLSteps.additional;

  get isBeforeRepair => this == FNOLSteps.bRepair;

  get isSupplement => this == FNOLSteps.supplement;

  get isResurvey => this == FNOLSteps.resurvey;

  get isAfterRepair => this == FNOLSteps.aRepair;

  get isRightSave => this == FNOLSteps.rightSave;

  get isBilling => this == FNOLSteps.billing;

  final String title;
  final String status;
  final String apiName;

  const FNOLSteps(
    this.title,
    this.status,
    this.apiName,
  );
}

enum LocationFNOLSteps {
  bRepair(
    'requestBeforeRepair',
    'beforeRepairLocation',
    'bRepair',
  ),
  supplement(
    'requestSupplement',
    'supplementLocation',
    'supplement',
  ),
  resurvey(
    'requestResurvey',
    'resurveyLocation',
    'resurvey',
  ),
  aRepair(
    'requestAfterRepair',
    'afterRepairLocation',
    'aRepair',
  ),
  rightSave(
    'requestRightSave',
    'rightSaveLocation',
    'rightSave',
  );

  get isBeforeRepair => this == LocationFNOLSteps.bRepair;

  get isSupplement => this == LocationFNOLSteps.supplement;

  get isResurvey => this == LocationFNOLSteps.resurvey;

  get isAfterRepair => this == LocationFNOLSteps.aRepair;

  get isRightSave => this == LocationFNOLSteps.rightSave;

  final String apiUrl;
  final String key;
  final String status;

  const LocationFNOLSteps(
    this.apiUrl,
    this.key,
    this.status,
  );
}

enum InspectionsStatus {
  all,
  pending,
  finished,
}

enum BillDeliveryTime { first, second }

enum Rules {
  Admin,
  Insurance,
  Corporate,
  Broker,
  Manager,
  Super,
  SuperVisor,
  Inspector,
  CallCenter,
  InspectionManager,
  client,
  none,
}

extension RulesExtension on Rules {
  String get name {
    switch (this) {
      case Rules.Insurance:
        return 'Insurance';
      case Rules.InspectionManager:
        return 'Inspection Manager';
      case Rules.Inspector:
        return 'Inspector';
      case Rules.Corporate:
        return 'Corporate';
      case Rules.Admin:
        return 'Admin';
      case Rules.Broker:
        return 'Broker';
      case Rules.Manager:
        return 'Manager';
      case Rules.Super:
        return 'Super';
      case Rules.SuperVisor:
        return 'SuperVisor';
      case Rules.CallCenter:
        return 'CallCenter';
      case Rules.client:
        return 'Client';
      case Rules.none:
        return 'none';
    }
  }

  int get id {
    switch (this) {
      case Rules.Insurance:
        return 8;
      case Rules.InspectionManager:
        return -1;
      case Rules.Inspector:
        return 9;
      case Rules.Corporate:
        return 12;
      case Rules.Admin:
        return 3;
      case Rules.Broker:
        return 11;
      case Rules.Manager:
        return 1;
      case Rules.Super:
        return 2;
      case Rules.SuperVisor:
        return 7;
      case Rules.CallCenter:
        return 10;
      case Rules.client:
        return 5;
      case Rules.none:
        return 0;
    }
  }
}

enum InspectionStatus {
  pending,
  accepted,
  done,
  // separated
  finished,

  //
  cancelled,
}

enum InspectorTypes {
  company,
  individual,
}

extension InspectorTypesExtension on InspectorTypes {
  String get name {
    switch (this) {
      case InspectorTypes.company:
        return 'company';
      case InspectorTypes.individual:
        return 'individual';
    }
  }
}

enum UserExistStatus {
  notExist,
  existActive,
  existNotActive;

  bool get isNotExist => this == UserExistStatus.notExist;

  bool get isExistActive => this == UserExistStatus.existActive;

  bool get isExistNotActive => this == UserExistStatus.existNotActive;
}

enum AccidentType {
  frontAccident,
  backAccident,
  leftSideAccident,
  rightSideAccident,
  carRoofAccident,
  frontClassAccident,
  backClassAccident,
  allCarAccident,
  general,
  checkOut,
  checkIn
}

enum ServiceType {
  fuel(1, '', '', ''),
  tires(2, '', '', ''),
  battery(3, '', '', ''),
  wenchNorm(4, '', '', ''),
  wenchEuro(5, '', '', ''),
  passengers(6, '', '', '');

  final int id;
  final String dbVal;
  final String enName;
  final String arName;

  bool get isFuel => this == ServiceType.fuel;
  bool get isTires => this == ServiceType.tires;
  bool get isBattery => this == ServiceType.battery;
  bool get isWenchNorm => this == ServiceType.wenchNorm;
  bool get isWenchEuro => this == ServiceType.wenchEuro;
  bool get isPassengers => this == ServiceType.passengers;

  const ServiceType(this.id, this.dbVal, this.enName, this.arName);
}