class AddCarDTO {
  String ManufacturerId;
  String CarModelId;
  String year;
  String? plateNumber;
  String color;
  String? vin_number;
  String ClientId;
  String? fl;
  String? bl;
  bool? active;
  String? insuranceCompanyId;

  AddCarDTO({
    required this.ManufacturerId,
    required this.CarModelId,
    required this.year,
    this.plateNumber,
    required this.color,
    this.vin_number,
    this.fl,
    this.bl,
    this.active,
    this.insuranceCompanyId,
    required this.ClientId,
  });

  Map<String, dynamic> toJson({required String clientIdKey}) => {
        "ManufacturerId": ManufacturerId,
        "CarModelId": CarModelId,
        "year": year,
        "plateNumber": plateNumber,
        "color": color,
        "vin_number": vin_number ?? "",
        "fl": fl ?? "",
        "bl": bl ?? "",
        "active": active ?? "",
        "insuranceCompanyId": insuranceCompanyId ?? "",
        clientIdKey: ClientId
      };
  Map<String, dynamic> toJsonCorporate() => {
        "ManufacturerId": ManufacturerId,
        "CarModelId": CarModelId,
        "year": year,
        "plateNumber": plateNumber,
        "color": color,
        "vin_number": vin_number,
      };
}
