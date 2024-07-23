import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../Configurations/Constants/constants.dart';
import '../cars/manufacturer_model.dart';
import '../cars/my_cars.dart';
import '../packages/package_model.dart';
import 'carPackages.dart';
import 'insurance_company.dart';
import 'model.dart';

class Vehicle {
  Vehicle();
  int? id;
  bool? active;
  Manufacturer? manufacture;
  Model? model;
  InsuranceCompany? insuranceCompany;
  String? color;
  int? year;
  String? plateNo;
  String? chassisNo;
  Package? package;
  List<CarPackages>? carPackages;
  ClientPackage? clientPackage;
  String policyEnd = "";
  String? frontLicense;
  String? backLicense;

  static Vehicle updatedCar = Vehicle();
  static bool anotherVehicle = false;
  static bool addVehicle = false;
  static List<Model> modelList = [];
  static Manufacturer? selectedManufacturer;
  static Model? selectedModel;
  static bool returnedSelectedModel = false;
  static String? selectedName;
  static String? phone;
  static String? firstCharacter;
  static String? secondCharacter;
  static String? thirdCharacter;
  static String? selectedColor;
  static int? selectedYear;
  static List<DropdownMenuItem<int>> years = [];
  static TextEditingController plateNumberC = TextEditingController();
  static TextEditingController chassisCtrl = TextEditingController();

  static List<DropdownMenuItem<String>> get colors =>
      List.from(CarColors.values.map<DropdownMenuItem<String>>((c) => DropdownMenuItem(
            value: c.name,
            child: Text(c.nameEn.tr as String),
          ),),);

  static String get plateNumber =>
      (firstCharacter ?? "") +
      "-" +
      (secondCharacter ?? "") +
      "-" +
      (thirdCharacter ?? "") +
      "-" +
      plateNumberC.text;

  Vehicle.fromJson(Map json) {
    id = json['id'];
    if (json['Manufacturer'] != null) {
      manufacture = Manufacturer.fromJson(json['Manufacturer']);
    }
    if (json['CarModel'] != null) {
      model = Model.fromJson(json['CarModel']);
    }
    if (json['insuranceCompany'] != null) {
      insuranceCompany = InsuranceCompany.fromJson(json['insuranceCompany']);
      policyEnd = json['policyEnds'] ?? "";
    }
    if (json['CarPackages'] != null) {
      Iterable I = json['CarPackages'];
      carPackages = List<CarPackages>.from(I.map((e) => CarPackages.fromjson(e)));
      // clientPackage =
      //     ClientPackage.fromJson(json['CarPackage']['ClientPackage']);
      // package = Package.fromJson(json['CarPackage']['Package']);
      print('CarPackages');
    }
    active = json['active'];
    color = json['color'];
    year = json['year'];
    chassisNo = json['vin_number'];
    plateNo = json['plateNumber'];
  }
}