// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'my_cars_bloc.dart';

@immutable
abstract class MyCarsState {}

class CarsWithoutPackageInitialState extends MyCarsState {}

class GetMyCarsLoadingState extends MyCarsState {}

class GetMyCarsSuccessState extends MyCarsState {}

class GetMyCarsErrorState extends MyCarsState {
  final String error;

  GetMyCarsErrorState({
    required this.error,
  });
}

class GetMyPackagesFromMyCarsLoadingState extends MyCarsState {}

class GetMyPackagesFromMyCarsSuccessState extends MyCarsState {}

class GetMyPackageFromMyCarsErrorState extends MyCarsState {
  final String error;

  GetMyPackageFromMyCarsErrorState({
    required this.error,
  });
}

class SelectCarYearState extends MyCarsState {}

class SelectCarColorState extends MyCarsState {}

class SelectCarVinNumberState extends MyCarsState {}

class TakeLicenseImagesState extends MyCarsState {}

class UpdateCarLoadingState extends MyCarsState {}

class UpdateCarSuccessState extends MyCarsState {}

class UpdateCarErrorState extends MyCarsState {
  final String error;

  UpdateCarErrorState({
    required this.error,
  });
}

class GetAllManufacturesLoadingState extends MyCarsState {}

class GetAllManufacturesSuccessState extends MyCarsState {}

class GetAllManufacturesErrorState extends MyCarsState {
  final String error;

  GetAllManufacturesErrorState({
    required this.error,
  });
}

class GetModelsForManufacturerLoadingState extends MyCarsState {}

class GetModelsForManufacturerSuccessState extends MyCarsState {}

class GetModelsForManufacturerErrorState extends MyCarsState {
  final String error;

  GetModelsForManufacturerErrorState({
    required this.error,
  });
}

class AddCarLoadingState extends MyCarsState {}

class AddCarSuccessState extends MyCarsState {
  final MyCarModel? selectedCar;
  AddCarSuccessState({required this.selectedCar});
}

class AddCarErrorState extends MyCarsState {
  final String error;

  AddCarErrorState({
    required this.error,
  });
}

class ActivateCarLoadingState extends MyCarsState {}

class ActivateCarSuccessState extends MyCarsState {}

class ActivateCarErrorState extends MyCarsState {
  final String error;

  ActivateCarErrorState({
    required this.error,
  });
}

class SubscribeCarToPackageLoadingState extends MyCarsState {}

class SubscribeCarToPackageSuccessState extends MyCarsState {
  final bool isInsurancePackage;
  SubscribeCarToPackageSuccessState({required this.isInsurancePackage});
}

class SubscribeCarToPackageErrorState extends MyCarsState {
  final String error;

  SubscribeCarToPackageErrorState({
    required this.error,
  });
}

class ImagePickedState extends MyCarsState {}

class TakeImageRenderState extends MyCarsState {}

class TakePictureLoadingState extends MyCarsState {}

class TakePictureSuccessState extends MyCarsState {}

class TakePictureErrorState extends MyCarsState {
  final String error;

  TakePictureErrorState({
    required this.error,
  });
}

class CameraInitializedState extends MyCarsState {}

class CameraErrorState extends MyCarsState {
  final String error;

  CameraErrorState({
    required this.error,
  });
}
