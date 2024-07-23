part of 'packages_screen_bloc.dart';

@immutable
abstract class PackagesScreenState {}

class PackagesScreenInitial extends PackagesScreenState {}

class GetAllPackagesLoadingState extends PackagesScreenState {}

class GetAllPackagesSuccessState extends PackagesScreenState {}

class UsePromoOnPackageLoadingState extends PackagesScreenState {}

class PromoCodeVisibilityState extends PackagesScreenState {}

class UsePromoOnPackageSuccessState extends PackagesScreenState {
  final double? amount;
  final String? percentageShell;
  final String? shellLogo;

  UsePromoOnPackageSuccessState(
      {required this.amount, this.percentageShell, this.shellLogo});
}

class UsePromoOnPackageErrorState extends PackagesScreenState {
  final String error;

  UsePromoOnPackageErrorState({
    required this.error,
  });
}

class GetAllPackagesErrorState extends PackagesScreenState {
  final String error;

  GetAllPackagesErrorState({
    required this.error,
  });
}

class GetMyPackagesLoadingState extends PackagesScreenState {}

class GetMyPackagesSuccessState extends PackagesScreenState {}

class GetMyPackagesErrorState extends PackagesScreenState {
  final String error;

  GetMyPackagesErrorState({
    required this.error,
  });
}

class ValidatePromoPackageLoading extends PackagesScreenState {}

class ValidatePromoPackageSuccess extends PackagesScreenState {}

class ValidatePromoPackageError extends PackagesScreenState {
  final String error;

  ValidatePromoPackageError({
    required this.error,
  });
}

class GetIFrameUrlLoadingPackagesState extends PackagesScreenState {}

class GetIFrameUrlSuccessPackagesState extends PackagesScreenState {
  final String? url;
  final bool fromCorporate;

  GetIFrameUrlSuccessPackagesState({required this.url,this.fromCorporate = false});
}

class GetIFrameUrlErrorPackagesState extends PackagesScreenState {
  final String error;

  GetIFrameUrlErrorPackagesState({
    required this.error,
  });
}
