import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:helpooappclient/Configurations/Constants/constants.dart';
import 'package:meta/meta.dart';

import '../../../../Configurations/Constants/api_endpoints.dart';
import '../../../../Configurations/Constants/keys.dart';
import '../../../../Services/cache_helper.dart';
import '../../../../Services/device_info_service.dart';
import '../../../Packages/Widgets/utils.dart';
import 'login_repository.dart';
import '../../../../Configurations/di/injection.dart' as di;

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final LoginRepository loginRepository = di.sl<LoginRepository>();
  final CacheHelper cacheHelper = di.sl<CacheHelper>();
  TextEditingController adminAuthNameCtrl = TextEditingController();
  TextEditingController adminAuthPassCtrl = TextEditingController();
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonEvent>((event, emit) async {
      emit(UserLoginLoadingState());
      final deviceData = DeviceInfoService().deviceData;
      final result = await loginRepository.login(
        identifier: Utils.handlePhoneNumber(phoneNum: event.phone!),
        password: event.password!,
        fcmToken: await FirebaseMessaging.instance
            .getToken()
            .then((value) => value ?? ""),
        loginData: {
          "loggedAt": deviceData["loggedAt"],
          "device": deviceData["device"],
          "model": deviceData["model"],
          "brand": deviceData["brand"],
        },
      );
      result.fold(
        (failure) {
          debugPrint(failure);
          emit(UserLoginErrorState(error: failure));
        },
        (data) {
          phoneNumberController.clear();
          passwordController.clear();
          cacheHelper.put(Keys.token, data.token!);
          cacheHelper.put(Keys.userRoleName, data.user!.roleName!);
          cacheHelper.put(Keys.currentUserId, data.user!.userId.toString());
          cacheHelper.put(Keys.generalID, data.user!.id.toString());
          cacheHelper.put(Keys.userEmail, data.user!.email!);
          cacheHelper.put(Keys.userPhone, data.user!.phoneNumber!);
          cacheHelper.put(Keys.userName, data.user!.name!);
          userRoleName = data.user!.roleName!;
          emit(UserLoginSuccessState());
        },
      );
    });
    on<AuthAdminEvent>((event, emit) async {
      emit(AuthAdminLoadingState());

      final result = await loginRepository.login(
        identifier: adminAuthNameCtrl.text,
        password: adminAuthPassCtrl.text.replaceFirst('\\', ''),
        fcmToken: '',
        loginData: DeviceInfoService().deviceData,
      );

      result.fold(
        (l) {
          emit(AuthAdminErrorState(error: l));
        },
        (r) async {
          if (r.user!.roleName!.toLowerCase() == 'super') {
            apiRoute = ENV_CONFIG_SELECTED;
            baseUrl = 'https://$apiRoute.helpooapp.net/api/';
            imagesBaseUrl = 'https://$apiRoute.helpooapp.net';
          }
          emit(AuthAdminSuccessState(
              adminRole: r.user!.roleName!.toLowerCase()));
        },
      );
    });
  }
}
