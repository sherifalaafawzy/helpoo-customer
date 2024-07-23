import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../Configurations/Constants/page_route_name.dart';
import '../../../../Configurations/di/injection.dart';
import '../../../../Models/auth/otp_model.dart';
import '../../../../Services/cache_helper.dart';
import '../../../Packages/Widgets/utils.dart';
import 'phone_number_repository.dart';

part 'phone_number_event.dart';

part 'phone_number_state.dart';

class PhoneNumberBloc extends Bloc<PhoneNumberEvent, PhoneNumberState> {
  TextEditingController phoneController = TextEditingController();
  PhoneNumberBloc? phoneNumberBloc;
  OtpModel? otpModel;
  String? fullName;
  final PhoneNumberRepository phoneNumberRepository =
      sl<PhoneNumberRepository>();
  final CacheHelper cacheHelper = sl<CacheHelper>();

  PhoneNumberBloc() : super(PhoneNumberInitial()) {
    on<PhoneNumberEvent>((event, emit) {});

    on<PhoneNumberConfirmButtonEvent>((event, emit) async {
      emit(PhoneNumberSendOtpLoadingState());
      final result = await phoneNumberRepository.sendOtp(
        phone: Utils.handlePhoneNumber(phoneNum: phoneController.text),
      );

      result.fold((failure) {
        debugPrint(failure);

        emit(PhoneNumberSendOtpErrorState(error: failure));
      }, (data) {
        otpModel = data;
        emit(PhoneNumberSendOtpSuccessState(otpModel: data));
      });
    });

    on<NavigateToVerifyOTPEvent>((event, emit) {
      Navigator.of(
        event.context!,
      ).pushNamed(PageRouteName.oTPScreen, arguments: {
        "phoneNumber": event.phoneNumber!,
        "otpModel": event.otpModel,
        'fromCorporate': event.fromCorporate,
        'fullName': event.fullName,
        'corporateName': event.corporateName
      });
    });
  }
}
