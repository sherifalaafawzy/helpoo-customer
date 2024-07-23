
class Model {
  int? id;
  String? enName;
  String? arName;

  Model.fromJson(Map json) {
    id = json['id'];
    enName = json['en_name'];
    arName = json['ar_name'];
  }
  // String get name => (CurrentUser.isArabic ? arName : enName) ?? "";
}