part of 'otp_bloc.dart';

@immutable
abstract class OtpState {}

class OtpInitial extends OtpState {}
class CheckIfUserExistLoadingState extends OtpState {}


class CheckIfUserExistSuccessState extends OtpState {
  final UserExistStatus? userExistStatus;

  CheckIfUserExistSuccessState({
    required this.userExistStatus,
  });
}

class CheckIfUserExistErrorState extends OtpState {
  final String error;

  CheckIfUserExistErrorState({
    required this.error,
  });
}
class VerifyOtpLoadingState extends OtpState {}

class VerifyOtpSuccessState extends OtpState {}

class VerifyOtpErrorState extends OtpState {
  final String error;

  VerifyOtpErrorState({
    required this.error,
  });
}
class SendOtpLoadingState extends OtpState {}

class SendOtpSuccessState extends OtpState {}

class SendOtpErrorState extends OtpState {
  final String error;

  SendOtpErrorState({
    required this.error,
  });
}
class ForgotPasswordLoadingState extends OtpState {}

class ForgotPasswordSuccessState extends OtpState {}

class ForgotPasswordErrorState extends OtpState {
  final String error;

  ForgotPasswordErrorState({
    required this.error,
  });
}