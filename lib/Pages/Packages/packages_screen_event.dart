part of 'packages_screen_bloc.dart';

@immutable
abstract class PackagesScreenEvent {}

class GetMyPackagesEvent extends PackagesScreenEvent {}

class GetAllPackagesEvent extends PackagesScreenEvent {}

class GetPromoEvent extends PackagesScreenEvent {}

class GetPromoShellEvent extends PackagesScreenEvent {}

class ChangePromoCodeVisibilityEvent extends PackagesScreenEvent {}

class GetIframePackagesEvent extends PackagesScreenEvent {
  final int? requestId;
  final int? selectedPackage;
  final double? amount;
  final bool fromCorporate;

  GetIframePackagesEvent({
    required this.amount,
    required this.requestId,
    required this.selectedPackage,
    this.fromCorporate = false,
  });
}

class GetPackagesByCorporate extends PackagesScreenEvent {
  final String corporateName;
  GetPackagesByCorporate({
    required this.corporateName,
  });
}

class UseByCorporateEvent extends PackagesScreenEvent {
  final int packageId;
  final int? dealId;
  final String corporateName;
  UseByCorporateEvent({
    required this.packageId,
    this.dealId,
    required this.corporateName,
  });
}
