part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}



class GetProfileLoadingState extends ProfileState {}


class GetProfileErrorState extends ProfileState {
  final String error;

  GetProfileErrorState({
    required this.error,
  });
}

class GetProfileSuccessState extends ProfileState {
  final LoginModel? profileModel;
  final PromoCode? normalPromoCodeRes;
  final bool? value;


  GetProfileSuccessState({required this.profileModel,required this.normalPromoCodeRes,required this.value});
}

class ChangePromoCodeVisibility extends ProfileState {
  final bool? value;

  ChangePromoCodeVisibility({required this.value});
}
class UpdateProfileLoadingState extends ProfileState {}

class UpdateProfileSuccessState extends ProfileState {}

class UpdateProfileErrorState extends ProfileState {
  final String error;

  UpdateProfileErrorState({
    required this.error,
  });
}
class CheckPromoIfPackageOrNormalLoading extends ProfileState {}

class CheckPromoIfPackageOrNormalSuccess extends ProfileState {}

class CheckPromoIfPackageOrNormalError extends ProfileState {
  final String error;

  CheckPromoIfPackageOrNormalError({
    required this.error,
  });
}

class ChangePromoCodeActivityState extends ProfileState {}

class UsePromoOnPackageLoadingState extends ProfileState {}

class UsePromoOnPackageSuccessState extends ProfileState {}

class UsePromoOnPackageErrorState extends ProfileState {
  final String error;

  UsePromoOnPackageErrorState({
    required this.error,
  });
}

class UseNormalPromoLoadingState extends ProfileState {}

class UseNormalPromoSuccessState extends ProfileState {}

class UseNormalPromoErrorState extends ProfileState {
  final String error;

  UseNormalPromoErrorState({
    required this.error,
  });
}

