part of 'phone_number_bloc.dart';

@immutable
abstract class PhoneNumberEvent {}

class PhoneNumberConfirmButtonEvent extends PhoneNumberEvent {
  final String? mobileNumber;

  PhoneNumberConfirmButtonEvent({this.mobileNumber});
}
/*class SenOtpNewClientEvent extends PhoneNumberEvent {
  final String? mobileNumber;

  SenOtpNewClientEvent({this.mobileNumber});
}*/

class NavigateToVerifyOTPEvent extends PhoneNumberEvent {
  final BuildContext? context;
  final String? phoneNumber;
  final OtpModel? otpModel;
  final String? fullName;
  final String? corporateName;
  final bool? fromCorporate;

  NavigateToVerifyOTPEvent(
      {required this.context,
      required this.phoneNumber,
      required this.otpModel,
      this.fullName,
      this.corporateName,
      this.fromCorporate});
}
