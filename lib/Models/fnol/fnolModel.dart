// class FnolModel {
//   int? id;
//   int? createdByUser;
//   DateTime? createdAt;
//   String? status;

//   FnolModel({this.id, this.createdByUser, this.createdAt, this.status});

//   FnolModel.fromJson(Map<String, dynamic> json) {
//     id = json['id']??0;
//     createdByUser = json['createdByUser']??0;
//     createdAt =DateTime.parse(json['createdAt']);
//     status = json['status']??"";
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['createdByUser'] = this.createdByUser;
//     data['createdAt'] = this.createdAt;
//     data['status'] = this.status;
//     return data;
//   }
// }
