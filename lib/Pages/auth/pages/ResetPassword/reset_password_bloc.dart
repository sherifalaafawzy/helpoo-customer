import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:helpooappclient/Pages/Packages/Widgets/utils.dart';
import 'package:meta/meta.dart';

import '../../../../Configurations/Constants/page_route_name.dart';
import '../../../../Configurations/di/injection.dart';
import 'reset_password_repository.dart';

part 'reset_password_event.dart';

part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc? resetPasswordBloc;
  bool? showNameField;
  ResetPasswordRepository resetPasswordRepository =
      sl<ResetPasswordRepository>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  ResetPasswordBloc() : super(ResetPasswordInitial()) {
    on<ResetPasswordEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<InitialResetPasswordEvent>((event, emit) {
      // TODO: implement event handler
      showNameField = (ModalRoute.of(event.context!)!.settings.arguments as Map)['showInputName'];
    });
    on<ResetPasswordButtonEvent>((event, emit) async {
      // TODO: implement event handler
      emit(ResetPasswordLoadingState());
      final result = await resetPasswordRepository.resetPassword(
          phoneNumber: Utils.handlePhoneNumber(phoneNum: event.mobileNumber!),
          password: passwordController.text,
          name: (showNameField != null)
              ? (showNameField!)
                  ? nameController.text
                  : null
              : null);

      result.fold(
        (failure) {
          debugPrint(failure);
          // isResetPasswordLoading = false;
          emit(ResetPasswordErrorState(error: failure));
        },
        (data) {
          // identifierController.text = phoneController.text;
          // userLogin();
          //  isResetPasswordLoading = false;
          //  otpController.clear();
          emit(ResetPasswordSuccessState());
        },
      );
    });
    on<ResetPasswordNavigateToHomeEvent>((event, emit) {
      // TODO: implement event handler
      Navigator.of(event.context!).pushNamedAndRemoveUntil(
        PageRouteName.mainScreen,
        (route) => false,
      );
    });
  }
}
