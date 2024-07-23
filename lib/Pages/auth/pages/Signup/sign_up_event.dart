part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpEvent {}

class RegisterButtonEvent extends SignUpEvent {
  final BuildContext? context;

  RegisterButtonEvent({required this.context});
}
class UpdateProfileRegisterEvent extends SignUpEvent{}

