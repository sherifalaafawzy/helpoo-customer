class OtpModel {
  Message? message;
  String? createdAt;
  int? checkExist;

  OtpModel({this.message, this.createdAt,this.checkExist});

  OtpModel.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
    createdAt = json['created_at'];
    checkExist=json['checkExist'];
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message!.toJson(),
      'created_at': createdAt,
      'checkExist':checkExist,
    };
  }
}

class Message {
  String? iv;
  String? encryptedData;

  Message({this.iv, this.encryptedData});

  Message.fromJson(Map<String, dynamic> json) {
    iv = json['iv'];
    encryptedData = json['encryptedData'];
  }

  Map<String, dynamic> toJson() {
    return {
      'iv': iv,
      'encryptedData': encryptedData,
    };
  }
}
