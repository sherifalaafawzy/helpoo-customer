import '../companies/insurance.dart';

class GetInsuranceCompanyModel {
  String? status;
  List<InsuranceModel>? insuranceCompanies;

  GetInsuranceCompanyModel({this.status, this.insuranceCompanies});

  GetInsuranceCompanyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['insuranceCompanies'] != null) {
      insuranceCompanies = <InsuranceModel>[];
      json['insuranceCompanies'].forEach((v) {
        insuranceCompanies!.add(new InsuranceModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.insuranceCompanies != null) {
      data['insuranceCompanies'] =
          this.insuranceCompanies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}