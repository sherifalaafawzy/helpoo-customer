part of 'choose_language_bloc.dart';

@immutable
abstract class ChooseLanguageState {}

class ChooseLanguageInitial extends ChooseLanguageState {}
class LanguageInitial extends ChooseLanguageState {}
class InitialState extends ChooseLanguageState {}
class ArabicState extends ChooseLanguageState {}
class EnglishState extends ChooseLanguageState {}
class LanguageLoadingState extends ChooseLanguageState {}
class LanguageChangedState extends ChooseLanguageState {}