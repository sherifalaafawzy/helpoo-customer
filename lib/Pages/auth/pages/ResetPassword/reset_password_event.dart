part of 'reset_password_bloc.dart';

@immutable
abstract class ResetPasswordEvent {}

class InitialResetPasswordEvent extends ResetPasswordEvent {
  final BuildContext? context;

  InitialResetPasswordEvent({required this.context});
}

class ResetPasswordButtonEvent extends ResetPasswordEvent {
  final BuildContext? context;
  final String? mobileNumber;

  ResetPasswordButtonEvent({required this.context, required this.mobileNumber});
}

class ResetPasswordNavigateToHomeEvent extends ResetPasswordEvent {
  final BuildContext? context;

  ResetPasswordNavigateToHomeEvent({required this.context});
}
