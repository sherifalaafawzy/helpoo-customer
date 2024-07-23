class PromoCode {
  PromoCode();
  int? id;
  String value="";
  DateTime? startDate;
  DateTime? expiryDate;
  int? percentage;

  PromoCode.fromJson(Map json) {
    id = json['id'];
    value = json['value'];
    startDate = DateTime.parse(json['startDate']);
    expiryDate = DateTime.parse(json['expiryDate']);
    percentage = json['percentage'];
  }
}
