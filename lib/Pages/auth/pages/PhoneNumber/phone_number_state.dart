part of 'phone_number_bloc.dart';

@immutable
abstract class PhoneNumberState {}

class PhoneNumberInitial extends PhoneNumberState {}
class PhoneNumberSendOtpLoadingState extends PhoneNumberState {}

class PhoneNumberSendOtpSuccessState extends PhoneNumberState {
  final OtpModel? otpModel;
  PhoneNumberSendOtpSuccessState({required this.otpModel});
}

class PhoneNumberSendOtpErrorState extends PhoneNumberState {
  final String error;

  PhoneNumberSendOtpErrorState({
    required this.error,
  });
}
