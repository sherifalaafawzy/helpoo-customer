part of 'otp_bloc.dart';

@immutable
abstract class OtpEvent {}

class InitialOtpScreenEvent extends OtpEvent {
  final BuildContext? context;

  InitialOtpScreenEvent({required this.context});
}

class OTPCheckUserExistsEvent extends OtpEvent {
  final BuildContext? context;

  OTPCheckUserExistsEvent({required this.context});
}

class VerifyOTPEvent extends OtpEvent {
  final OtpModel? otpModel;
  final String? phoneNumber;

  VerifyOTPEvent({required this.otpModel, required this.phoneNumber});
}

class ResendOTPButtonEvent extends OtpEvent {
  final String? mobileNumber;

  ResendOTPButtonEvent({required this.mobileNumber});
}

class OTPForgotPasswordCallAPIEvent extends OtpEvent {
  final String? mobileNumber;

  OTPForgotPasswordCallAPIEvent({required this.mobileNumber});
}

class NavigateToResetPasswordScreenEvent extends OtpEvent {
  final BuildContext? context;
  final bool? showInputName;
  final String? phoneNumber;

  NavigateToResetPasswordScreenEvent(
      {required this.context,
      required this.showInputName,
      required this.phoneNumber});
}

class NavigateToRegisterScreenEvent extends OtpEvent {
  final BuildContext? context;
  final String? phoneNumber;
  final String? fullName;
  final String? corporateName;

  NavigateToRegisterScreenEvent(
      {required this.context, required this.phoneNumber, this.fullName,this.corporateName});
}
