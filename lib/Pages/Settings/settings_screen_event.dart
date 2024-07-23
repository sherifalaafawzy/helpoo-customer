part of 'settings_screen_bloc.dart';

@immutable
abstract class SettingsScreenEvent {}

class LogoutSettingsScreenButton extends SettingsScreenEvent {}

class NavigateToHomeTab extends SettingsScreenEvent {}
