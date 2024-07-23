part of 'settings_screen_bloc.dart';

@immutable
abstract class SettingsScreenState {}

class SettingsScreenInitial extends SettingsScreenState {}
class LogoutSuccessState extends SettingsScreenState {}
class LogoutLoadingState extends SettingsScreenState {}
