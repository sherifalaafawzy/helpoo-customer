class FeesResponseModel {
  String? status;
  String? euroOriginalFees;
  String? euroFees;
  String? euroPercent;
  String? normOriginalFees;
  String? normFees;
  String? normPercent;
  String? errMsg;
  String? originalFees;
  String? fees;
  String? percent;
  FeesResponseModel();
  FeesResponseModel.fromJson(Map json) {
    //debugPrintFullText('zzzzzzzzzzzzzzzzzzzz ${json}');

    status = json['status'];
    euroOriginalFees = json['EuroOriginalFees'].toString();
    euroFees = json['EuroFees'].toString();
    euroPercent = json['EuroPercent'].toString();
    normOriginalFees = json['NormOriginalFees'].toString();
    normFees = json['NormFees'].toString();
    normPercent = json['NormPercent'].toString();
    errMsg = json['msg'].toString();
    originalFees = json['originalFees'].toString();
    fees = json['fees'].toString();
    percent = json['percent'].toString();
  }
}
