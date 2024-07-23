class GetConfigModel {
  String? status;
  List<Config>? config;

  GetConfigModel({this.status, this.config});

  GetConfigModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['config'] != null) {
      config = <Config>[];
      json['config'].forEach((v) {
        config!.add(new Config.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;

    if (this.config != null) {
      data['config'] = this.config!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Config {
  int? id;
  String? minimumIOSVersion;
  String? minimumAndroidVersion;
  bool? underMaintaining;
  String? distanceLimit;
  String? durationLimit;
  String? createdAt;
  String? updatedAt;

  int? finishTime;
  int? carryingTime;
  int? waitingTimeFree;
  int? waitingTimeLimit;
  int? waitingTimePrice;

  Config({
    this.id,
    this.minimumIOSVersion,
    this.minimumAndroidVersion,
    this.underMaintaining,
    this.distanceLimit,
    this.durationLimit,
    this.createdAt,
    this.updatedAt,
    this.finishTime,
    this.carryingTime,
    this.waitingTimeFree,
    this.waitingTimeLimit,
    this.waitingTimePrice,
  });

  Config.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    minimumIOSVersion = json['minimumIOSVersion'];
    minimumAndroidVersion = json['minimumAndroidVersion'];
    underMaintaining = json['underMaintaining'];
    distanceLimit = json['distanceLimit'];
    durationLimit = json['durationLimit'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];

    finishTime = json['finishTime']??0;
    carryingTime = json['carryingTime']??0;
    waitingTimeFree = json['waitingTimeFree']??0;
    waitingTimeLimit = json['waitingTimeLimit']??0;
    waitingTimePrice = json['waitingTimePrice']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['minimumIOSVersion'] = this.minimumIOSVersion;
    data['minimumAndroidVersion'] = this.minimumAndroidVersion;
    data['underMaintaining'] = this.underMaintaining;
    data['distanceLimit'] = this.distanceLimit;
    data['durationLimit'] = this.durationLimit;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;

    return data;
  }
}
