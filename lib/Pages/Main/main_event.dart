part of 'main_bloc.dart';

@immutable
abstract class MainEvent {}

class UpdateBottomNavBarEvent extends MainEvent {
  final int? index;
  final BuildContext? context;

  UpdateBottomNavBarEvent({required this.index, required this.context});
}

class MainGetUserRoleEvent extends MainEvent {}

class SetThemeEvent extends MainEvent {
  final bool? isDark;

  SetThemeEvent({required this.isDark});
}

// make language event
class SetLanguageEvent extends MainEvent {
  final Locale locale;

  SetLanguageEvent({required this.locale});
}
