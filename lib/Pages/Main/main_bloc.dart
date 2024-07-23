import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../Configurations/Constants/constants.dart';
import '../../Configurations/Constants/keys.dart';
import '../../Configurations/di/injection.dart';

import '../../Services/cache_helper.dart';
import 'main_repository.dart';

part 'main_event.dart';

part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final MainRepository _repository;
  String? userName = '';
  int _selectedBottomNavBarIndex = 0;

  int get selectedBottomNavBarIndex => _selectedBottomNavBarIndex;

  set selectedBottomNavBarIndex(int value) {
    _selectedBottomNavBarIndex = value;
    emit(SelectBottomNavBarState());
  }

  MainBloc({
    required MainRepository repository,
  })  : _repository = repository,
        super(MainInitial()) {
    on<MainEvent>((event, emit) async {
      // TODO: implement event handler
      userName = await sl<CacheHelper>().get(Keys.userName);
      userRoleName = await sl<CacheHelper>().get(Keys.userRoleName) ?? "";
    });
    on<MainGetUserRoleEvent>((event, emit) async {
      // TODO: implement event handler
      userName = await sl<CacheHelper>().get(Keys.userName);
      userRoleName = await sl<CacheHelper>().get(Keys.userRoleName);
      emit(GetUserRoleSuccess());
    });
    on<SetThemeEvent>((event, emit) {
      // TODO: implement event handler
      sl<CacheHelper>().put(Keys.isDark, event.isDark);
      emit(MainInitial());
    });

    on<UpdateBottomNavBarEvent>((event, emit) async {
      // TODO: implement event handler
      _selectedBottomNavBarIndex = event.index!;
      userName = await sl<CacheHelper>().get(Keys.userName);
      emit(SelectBottomNavBarState());
    });
    on<SetLanguageEvent>((event, emit) async {
      emit(ChangeLanguageState(event.locale));
    });
  }
  onlinePaymentSuccess() async {
    // isPaymentSuccess = true;
    //  if (isFromServiceRequestOnline) await confirmRequest();
    //  if (isFromPackageOnline) await getMyPackages();

    emit(OnlinePaymentSuccessState());
  }
}
