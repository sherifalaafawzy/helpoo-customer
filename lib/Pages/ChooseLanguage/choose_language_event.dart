part of 'choose_language_bloc.dart';

@immutable
abstract class ChooseLanguageEvent {}
class NavigateToOnBoardingEvent extends ChooseLanguageEvent {
  final BuildContext? context;

  NavigateToOnBoardingEvent({required this.context});
}


class GetLanguageEvent extends ChooseLanguageEvent {

  GetLanguageEvent();
}

class ChangeLanguageEvent extends ChooseLanguageEvent {
  final String? language;
  final BuildContext? context;

  ChangeLanguageEvent({required this.language,this.context});
}