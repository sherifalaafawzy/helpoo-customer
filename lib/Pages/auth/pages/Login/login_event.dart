part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginButtonEvent extends LoginEvent {
  final String? phone;
  final String? password;

  LoginButtonEvent({required this.password, required this.phone});
}
class AuthAdminEvent extends LoginEvent {
  final String? admin;
  final String? pass;

  AuthAdminEvent({required this.pass, required this.admin});
}