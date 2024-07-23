part of 'main_bloc.dart';

@immutable
abstract class MainState {}

class MainInitial extends MainState {}

class SelectBottomNavBarState extends MainState {}

class OnlinePaymentSuccessState extends MainState {}

class GetUserRoleSuccess extends MainState {}

class ChangeLanguageState extends MainState {
  final Locale locale;

  ChangeLanguageState(this.locale);
}
