import 'package:flutter/material.dart';



@immutable
abstract class SplashEvent {}

class SetSplash extends SplashEvent {}

class GetTokenEvent extends SplashEvent {}
class GetUserFirstTimeStatusEvent extends SplashEvent {}
class SetUserFirstTimeStatusEvent extends SplashEvent {}
class GetConfigEvent extends SplashEvent {}

class GetLanguageEvent extends SplashEvent {
  final BuildContext? context;

  GetLanguageEvent({required this.context});
}

class GetRemoteConfigDataEvent extends SplashEvent {
}

class CheckVersionEvent extends SplashEvent {
  final BuildContext? context;
  //final AppConfigurationsModel? appConfigurationsModel;

  CheckVersionEvent(
      {
      required this.context,
      //required this.appConfigurationsModel
      });
}

class NavigateToForceUpdateEvent extends SplashEvent {
  final BuildContext? context;

  NavigateToForceUpdateEvent({required this.context});
}
class NavigateToWelcomeEvent extends SplashEvent {
  final BuildContext? context;

  NavigateToWelcomeEvent({required this.context});
}

class NavigateToHomeEvent extends SplashEvent {
  final BuildContext? context;

  NavigateToHomeEvent({required this.context});
}

class NavigateToLanguageEvent extends SplashEvent {
  final BuildContext? context;

  NavigateToLanguageEvent({required this.context});
}
