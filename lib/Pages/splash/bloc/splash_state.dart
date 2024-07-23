import 'package:flutter/material.dart';


@immutable
abstract class SplashState {}

class SplashInitialState extends SplashState {}

class SplashLoadingState extends SplashState {}

class SplashLoadedState extends SplashState {}

class TokenExistsState extends SplashState {
  final String? token;

  TokenExistsState({@required this.token});

  @override
  // TODO: implement props
  List<Object> get props => [token!];
}

class NoTokenState extends SplashState {}
class ForceUpdateState extends SplashState {}
class RemoteConfigDataSuccessState extends SplashState {
 // final AppConfigurationsModel? appConfigurationsModel;
 // RemoteConfigDataSuccessState({required this.appConfigurationsModel});
}

class NoLanguageState extends SplashState {}

class LanguageExistsState extends SplashState {
  final String? language;

  LanguageExistsState({required this.language});

  @override
  // TODO: implement props
  List<Object> get props => [language!];
}
class GetConfigLoadingState extends SplashState {}

class GetConfigSuccessState extends SplashState {}

class GetConfigErrorState extends SplashState {
  final String error;

  GetConfigErrorState({
    required this.error,
  });
}
