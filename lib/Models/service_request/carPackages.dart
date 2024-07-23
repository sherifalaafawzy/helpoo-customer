import '../cars/my_cars.dart';
import '../packages/package_model.dart';

class CarPackages {
  String? createdAt;
  String? updatedAt;
  int? carId;
  int? clientPackageId;
  int? packageId;
  ClientPackage? clientPackage;
  Package? package;

  CarPackages.fromjson(json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    carId = json['CarId'];
    clientPackageId = json['ClientPackageId'];
    clientPackage = ClientPackage.fromJson(json['ClientPackage']);
    package = Package.fromJson(json['Package']);
  }
}