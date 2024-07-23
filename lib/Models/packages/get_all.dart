import 'package_model.dart';

class GetAllPackagesDTO {
  List<Package>? packages;

  GetAllPackagesDTO({
    this.packages,
  });

  GetAllPackagesDTO.fromJson(Map<String, dynamic> json) {
    packages = json['packages'] != null
        ? (json['packages'] as List).map((i) => Package.fromJson(i)).toList()
        : null;
  }
}

class GetAllMyPackagesDTO {
  List<Package>? packages;

  GetAllMyPackagesDTO({
    this.packages,
  });

  GetAllMyPackagesDTO.fromJson(Map<String, dynamic> json) {
    packages = json['clientPackages'] != null
        ? (json['clientPackages'] as List).map((i) => Package.fromJson(i)).toList()
        : null;
  }
}