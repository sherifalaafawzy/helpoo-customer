import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../Configurations/Constants/constants.dart';
import '../../Configurations/Constants/keys.dart';
import '../../Configurations/Constants/page_route_name.dart';
import '../../Configurations/di/injection.dart';
import '../../Services/cache_helper.dart';
import '../../Services/navigation_service.dart';
import '../../Services/storage_service.dart';
import 'choose_language_repository.dart';

part 'choose_language_event.dart';

part 'choose_language_state.dart';

class ChooseLanguageBloc
    extends Bloc<ChooseLanguageEvent, ChooseLanguageState> {
  ChooseLanguageRepository? languageRepository = ChooseLanguageRepository();
  ChooseLanguageBloc? chooseLanguageBloc;
  String? selectedLanguage = '';
  final CacheHelper cacheHelper = sl<CacheHelper>();

  ChooseLanguageBloc() : super(ChooseLanguageInitial()) {
    on<ChooseLanguageEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetLanguageEvent>((event, emit) async {
      await cacheHelper.get(Keys.languageCode).then((value) {
        (value?.compareTo('ar') == 0)
            ? selectedLanguage = 'arabic'
            : selectedLanguage = 'english';
      });
    });
    on<NavigateToOnBoardingEvent>((event, emit) async {
      Navigator.of(event.context!).pushNamedAndRemoveUntil(
          PageRouteName.onBoardingScreen, (route) => false);
    });
    on<ChangeLanguageEvent>((event, emit) async {
      await NavigationService.navigatorKey.currentContext!.setLocale(
          event.language!.compareTo('english') == 0
              ? localizeLanguages.last
              : localizeLanguages.first);
      await languageRepository
          ?.changeLang(event.language!.compareTo('english') == 0 ? "en" : "ar");
      emit(LanguageChangedState());
    });
  }
}
