import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../Configurations/Constants/keys.dart';
import '../../Configurations/di/injection.dart';
import '../../Services/cache_helper.dart';

part 'settings_screen_event.dart';
part 'settings_screen_state.dart';

class SettingsScreenBloc extends Bloc<SettingsScreenEvent, SettingsScreenState> {
  SettingsScreenBloc() : super(SettingsScreenInitial()) {
    on<SettingsScreenEvent>((event, emit) {
      // TODO: implement event handler

    });
    on<NavigateToHomeTab>((event, emit) {
      // TODO: implement event handler

    });
    on<LogoutSettingsScreenButton>((event, emit) {
      // TODO: implement event handler
      emit(LogoutLoadingState());
      Future.wait([
        sl<CacheHelper>().clear(Keys.userName),
        sl<CacheHelper>().clear(Keys.userEmail),
        sl<CacheHelper>().clear(Keys.userPhone),
        sl<CacheHelper>().clear(Keys.generalID),
        sl<CacheHelper>().clear(Keys.token),
        sl<CacheHelper>().clear(Keys.userRoleName),
        sl<CacheHelper>().clear(Keys.currentUserId),
        sl<CacheHelper>().clear(Keys.isDark),
        sl<CacheHelper>().clear(Keys.token),
        sl<CacheHelper>().clear(Keys.isEnglish),
      ]);
      emit(LogoutSuccessState());
    });

  }
}
