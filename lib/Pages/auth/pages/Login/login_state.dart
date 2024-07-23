part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class UserLoginLoadingState extends LoginState {}

class UserLoginSuccessState extends LoginState {}

class UserLoginErrorState extends LoginState {
  final String error;

  UserLoginErrorState({
    required this.error,
  });
}
class AuthAdminLoadingState extends LoginState {}

class AuthAdminSuccessState extends LoginState {
  final String adminRole;

  AuthAdminSuccessState({
    required this.adminRole,
  });
}

class AuthAdminErrorState extends LoginState {
  final String error;

  AuthAdminErrorState({
    required this.error,
  });
}