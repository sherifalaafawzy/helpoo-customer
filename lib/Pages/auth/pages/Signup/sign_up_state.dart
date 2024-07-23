part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}
class RegisterLoadingState extends SignUpState {}

class RegisterSuccessState extends SignUpState {}

class RegisterErrorState extends SignUpState {
  final String error;

  RegisterErrorState({
    required this.error,
  });
}
class UpdateProfileRegisterLoadingState extends SignUpState {}

class UpdateProfileRegisterSuccessState extends SignUpState {}

class UpdateProfileRegisterErrorState extends SignUpState {
  final String error;

  UpdateProfileRegisterErrorState({
    required this.error,
  });
}