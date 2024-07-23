import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../Configurations/Constants/page_route_name.dart';
import '../../../Configurations/di/injection.dart';
import '../../../Models/get_config.dart';
import '../../../Services/cache_helper.dart';
import '../../../Services/deep_link_service.dart';
import '../splash_repository.dart';
import '/Pages/splash/bloc/splash_event.dart';
import '/Pages/splash/bloc/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final SplashRepository splashRepository = sl<SplashRepository>();
  final CacheHelper cacheHelper = sl<CacheHelper>();
  Config? config;

  SplashBloc() : super(SplashInitialState()) {
    on<GetUserFirstTimeStatusEvent>((event, emit) async {
      /* emit(SplashLoadingState());
      await Future.delayed(const Duration(seconds: 3));
      emit(SplashLoadedState());*/
    });
    on<GetTokenEvent>((event, emit) async {
      //TODO
      return splashRepository.getToken().then((value) {
        print('from getToken splash bloc :$value');
        if (value != null) {
          return emit(TokenExistsState(token: value));
        } else {
          return emit(NoTokenState());
        }
      }).onError((error, stackTrace) => emit(NoTokenState()));
    });
    on<GetLanguageEvent>((event, emit) async {
      //TODO
      emit(SplashLoadingState());
      await Future.delayed(const Duration(seconds: 4));
      return splashRepository
          .getLanguage()
          .then((value) {
            if (value != null) {
              EasyLocalization.of(event.context!)?.setLocale(
                Locale(value.compareTo('en') == 0 ? 'en' : 'ar',
                    value.compareTo('en') == 0 ? 'US' : 'EG'),
              );
              //splashRepository?.changeLang(value);
              return emit(LanguageExistsState(language: value));
            } else {
              return emit(NoLanguageState());
            }
          })
          .onError((error, stackTrace) => emit(NoLanguageState()))
          .whenComplete(() => sl<DynamicLinkService>().handleInitialLink());
    });
    on<NavigateToHomeEvent>((event, emit) {
      //TODO
      Navigator.of(event.context!)
          .pushNamedAndRemoveUntil(PageRouteName.mainScreen, (route) => false);
    });
    on<NavigateToForceUpdateEvent>((event, emit) {
      //TODO
      /* Navigator.of(event.context!)
          .pushNamedAndRemoveUntil(PageRouteName.forceUpdate, (route) => false);*/
    });

    on<CheckVersionEvent>((event, emit) async {
      /*  await DeviceService()
          .checkVersionWithServer(event.appConfigurationsModel!).then((value)async {
            print('check version value: $value');
         if(value){
           emit(ForceUpdateState());
         }else {
           Navigator.of(event.context!)
               .pushNamedAndRemoveUntil(PageRouteName.home, (route) => false);
         }
      });*/
    });
    on<NavigateToWelcomeEvent>((event, emit) {
      //TODO
      Navigator.of(event.context!).pushNamedAndRemoveUntil(
          PageRouteName.welcomeScreen, (route) => false);
    });
    on<NavigateToLanguageEvent>((event, emit) {
      //TODO
      Navigator.of(event.context!).pushNamedAndRemoveUntil(
          PageRouteName.chooseLanguageScreen, (route) => false,
          arguments: false);
    });
    on<GetConfigEvent>((event, emit) async {
      emit(GetConfigLoadingState());
      final results = await splashRepository.getConfig();
      results.fold(
        (error) {
          //isGetConfigLoading = false;

          debugPrint('-----error------');
          debugPrint(error.toString());
          emit(
            GetConfigErrorState(
              error: error,
            ),
          );
        },
        (data) {
          debugPrint('----- Config Data ------');
          // debugPrintFullText(data.toJson().toString());
          config = data.config![0];

          emit(GetConfigSuccessState());
        },
      );
    });
  }
}
