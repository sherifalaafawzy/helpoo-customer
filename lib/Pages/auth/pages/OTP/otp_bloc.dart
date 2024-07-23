import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:helpooappclient/Models/auth/otp_model.dart';
import 'package:helpooappclient/Pages/Profile/profile_repository.dart';
import 'package:helpooappclient/Services/navigation_service.dart';
import 'package:meta/meta.dart';

import '../../../../Configurations/Constants/constants.dart';
import '../../../../Configurations/Constants/enums.dart';
import '../../../../Configurations/Constants/keys.dart';
import '../../../../Configurations/Constants/page_route_name.dart';
import '../../../../Configurations/di/injection.dart';
import '../../../../Services/cache_helper.dart';
import '../../../Packages/Widgets/utils.dart';
import 'otp_repository.dart';
import '../../../../Configurations/di/injection.dart' as di;

part 'otp_event.dart';

part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final OTPRepository otpRepository = sl<OTPRepository>();
  final ProfileRepository profileRepository = sl<ProfileRepository>();
  TextEditingController otpController = TextEditingController();
  OtpModel? otpModel;
  final CacheHelper cacheHelper = di.sl<CacheHelper>();

  OtpBloc() : super(OtpInitial()) {
    on<OtpEvent>((event, emit) {});
    on<InitialOtpScreenEvent>((event, emit) {
      otpModel = (ModalRoute.of(event.context!)!.settings.arguments
          as Map)['otpModel'];
      emit(OtpInitial());
    });

    on<OTPCheckUserExistsEvent>((event, emit) async {
      emit(
        CheckIfUserExistSuccessState(
          userExistStatus: UserExistStatus.values[otpModel!.checkExist! - 1],
        ),
      );
      // TODO: implement event handler
      //    emit(CheckIfUserExistLoadingState());

/*      final String phoneNumber = (ModalRoute.of(event.context!)!
          .settings
          .arguments! as Map)['phoneNumber'];
      final result = await otpRepository.checkIfUserExist(
        phoneNumber: Utils.handlePhoneNumber(phoneNum: phoneNumber),
      );

      result.fold(
        (failure) {
          debugPrint(failure);
          emit(CheckIfUserExistErrorState(error: failure));
        },
        (data) {
          emit(
            CheckIfUserExistSuccessState(
              userExistStatus: data,
            ),
          );
        },
      );*/
    });
    on<VerifyOTPEvent>((event, emit) async {
      print('dears');
      print(event.otpModel?.checkExist);
      String fcmToken = "";
      try {
        fcmToken = await FirebaseMessaging.instance.getToken() ?? "";
      } on Exception catch (_) {}
      emit(VerifyOtpLoadingState());
      final result = await otpRepository.verifyOtp(
        phone: Utils.handlePhoneNumber(phoneNum: event.phoneNumber!),
        signUpOrLogin: event.otpModel?.checkExist == 1,
        otp: otpController.text,
        fcmToken: fcmToken,
        message: json.encode(event.otpModel!.message!.toJson()),
      );

      result.fold((failure) {
        debugPrint(failure);
        // isVerifyOtpLoading = false;
        emit(VerifyOtpErrorState(error: failure));
      }, (data) {
        // isVerifyOtpLoading = false;
        // otpController.clear();
        cacheHelper.put(Keys.token, data.token!);
        cacheHelper.put(Keys.userRoleName, data.user!.roleName!);
        cacheHelper.put(Keys.currentUserId, data.user!.userId.toString());
        cacheHelper.put(Keys.generalID, data.user!.id.toString());
        cacheHelper.put(Keys.userEmail, data.user!.email!);
        cacheHelper.put(Keys.userPhone, data.user!.phoneNumber!);
        cacheHelper.put(Keys.userName, data.user!.name!);
        userRoleName = data.user!.roleName!;
        emit(VerifyOtpSuccessState());
      });
    });

    on<OTPForgotPasswordCallAPIEvent>((event, emit) async {
      emit(ForgotPasswordLoadingState());
      final result = await otpRepository.forgetPassword(
        phoneNumber: Utils.handlePhoneNumber(phoneNum: event.mobileNumber!),
      );

      result.fold(
        (failure) {
          debugPrint(failure);
          //  isForgotPasswordLoading = false;
          emit(ForgotPasswordErrorState(error: failure));
        },
        (data) {
          //otpModel = data;
          // isForgotPasswordLoading = false;
          emit(ForgotPasswordSuccessState());
        },
      );
    });
    on<NavigateToRegisterScreenEvent>((event, emit) async {
      bool fromCorporate = event.fullName == null ? false : true;
      if (fromCorporate) {
        _handleRegisterIfCorporate(event, emit);
      } else {
        Navigator.of(event.context!).pushNamedAndRemoveUntil(
          PageRouteName.registerFillDataScreen,
          (route) => false,
          arguments: {"phoneNumber": event.phoneNumber!},
        );
      }
    });
    on<NavigateToResetPasswordScreenEvent>((event, emit) async {
      Navigator.of(event.context!).pushNamedAndRemoveUntil(
        PageRouteName.resetPasswordScreen,
        (route) => false,
        arguments: {
          "showInputName": event.showInputName!,
          "phoneNumber": event.phoneNumber!
        },
      );
    });
    on<ResendOTPButtonEvent>((event, emit) async {
      print('otpModel?.message1');
      print(otpModel?.message?.iv);
      // TODO: implement event handler
      emit(SendOtpLoadingState());
      final result = await otpRepository.sendOtp(
        phone: Utils.handlePhoneNumber(phoneNum: event.mobileNumber!),
      );

      result.fold((failure) {
        debugPrint(failure);
        //  isSendOtpLoading = false;
        emit(SendOtpErrorState(error: failure));
      }, (data) {
        // isSendOtpLoading = false;
        otpModel = data;
        print('otpModel?.message2');
        print(otpModel?.message?.iv);
        emit(SendOtpSuccessState());
      });
    });
  }

  void _handleRegisterIfCorporate(
      NavigateToRegisterScreenEvent event, Emitter<OtpState> emit) async {
    bool fromCorporate = event.fullName == null ? false : true;
    if (!fromCorporate) return;
    final result = await profileRepository.updateProfile(name: event.fullName!);

    result.fold(
      (failure) {
        emit(CheckIfUserExistErrorState(error: failure));
      },
      (data) async {
        await cacheHelper.put(Keys.userName, event.fullName).then((value) {});
        NavigationService.navigatorKey.currentState!
            .pushReplacementNamed(PageRouteName.authPackagesScreen, arguments: {
          'corporateName': event.corporateName,
          'fromCorporate': true,
        });
        // NavigationService.navigatorKey.currentState!.pushAndRemoveUntil(
        //     MaterialPageRoute(
        //       builder: (context) => CorporatePackagesPage(),
        //     ),
        //     (route) => false);
      },
    );
  }
}
