import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import '../../../../Configurations/Constants/keys.dart';
import '../../../../Configurations/di/injection.dart';
import '../../../../Services/cache_helper.dart';
import '../../../../Services/device_info_service.dart';
import '../../../Packages/Widgets/utils.dart';
import 'sign_up_repository.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  TextEditingController nameController = TextEditingController();
  TextEditingController promoCodeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final SignUpRepository signUpRepository = sl<SignUpRepository>();

  final CacheHelper cacheHelper = sl<CacheHelper>();

  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpEvent>((event, emit) async {
      Uuid uuid = Uuid();
      passwordController.text = await uuid.v4();
      confirmPasswordController.text = await uuid.v4();
      // TODO: implement event handler
    });
    on<RegisterButtonEvent>((event, emit) async {
      // TODO: implement event handler
      emit(RegisterLoadingState());
      final result = await signUpRepository.register(
        identifier: Utils.handlePhoneNumber(
            phoneNum: (ModalRoute.of(event.context!)!.settings.arguments
                as Map)['phoneNumber']),
        name: nameController.text,
        password: passwordController.text,
        promoCode: promoCodeController.text.isNotEmpty
            ? promoCodeController.text
            : null,
        email: emailController.text.isNotEmpty ? emailController.text : null,
        loginData: DeviceInfoService().deviceData,
      );

      result.fold((failure) {
        debugPrint(failure);
        //isRegisterLoading = false;
        emit(RegisterErrorState(error: failure));
      }, (data) {
        // isRegisterLoading = false;
        nameController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        //phoneController.clear();
        // identifierController.clear();
        // loginModel = data;

        ///* save data in local
        cacheHelper.put(Keys.token, data.token!);
        cacheHelper.put(Keys.userRoleName, data.user!.roleName!);
        cacheHelper.put(Keys.userName, data.user!.name!);
        cacheHelper.put(Keys.currentUserId, data.user!.userId.toString());
        cacheHelper.put(Keys.generalID, data.user!.id.toString());
        cacheHelper.put(Keys.userEmail, data.user!.email!);
        cacheHelper.put(Keys.userPhone, data.user!.phoneNumber!);

        emit(RegisterSuccessState());
      });
    });
    on<UpdateProfileRegisterEvent>((event, emit) async {
      // TODO: implement event handler
      emit(UpdateProfileRegisterLoadingState());

      final result = await signUpRepository.updateProfile(
          email: emailController.text, name: nameController.text);

      result.fold(
        (failure) {
          debugPrint(failure);
          emit(UpdateProfileRegisterErrorState(error: failure));
        },
        (data) async {
          emit(
            UpdateProfileRegisterSuccessState(),
          );
          await cacheHelper
              .put(Keys.userName, nameController.text)
              .then((value) {});
        },
      );
    });
  }
}
