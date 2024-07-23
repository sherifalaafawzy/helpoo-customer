part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}
class GetProfileEvent extends ProfileEvent{}
class UpdateProfileEvent extends ProfileEvent{}
class CheckPromoCode extends ProfileEvent{
  final String? promoCode;
  CheckPromoCode({required this.promoCode});
}

class UsePromoCode extends ProfileEvent {
  final String? value;

  UsePromoCode({required this.value});
}
