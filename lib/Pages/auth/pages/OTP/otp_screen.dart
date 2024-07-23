import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:pinput/pinput.dart';

import '../../../../Configurations/Constants/assets_images.dart';
import '../../../../Configurations/Constants/page_route_name.dart';
import '../../../../Style/theme/colors.dart';
import '../../../../Style/theme/text_styles.dart';
import '../../../../Widgets/helpoo_in_app_notifications.dart';
import '../../../../Widgets/load_svg.dart';
import '../../../../Widgets/scaffold_bk.dart';
import '../../../../Widgets/spacing.dart';
import '../../../../generated/locale_keys.g.dart';
//import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../Packages/Widgets/utils.dart';
import 'otp_bloc.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key, this.fromCorporate, this.fullName, this.corporateName})
      : super(key: key);
  final bool? fromCorporate;
  final String? fullName;
  final String? corporateName;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _formKey = GlobalKey<FormState>();
  OtpBloc? otpBloc;

  @override
  void initState() {
    // appBloc.otpController = TextEditingController();
    super.initState();
    otpBloc = context.read<OtpBloc>();
    otpBloc?.add(InitialOtpScreenEvent(context: context));
  }

  @override
  Widget build(BuildContext context) {
    final otpBloc = context.read<OtpBloc>();
    return BlocListener<OtpBloc, OtpState>(
      listener: (context, state) {
        bool fromCorporate = widget.fromCorporate ?? false;
        if (state is VerifyOtpErrorState) {
          HelpooInAppNotification.showErrorMessage(message: state.error);
        }
        if (state is CheckIfUserExistErrorState) {
          HelpooInAppNotification.showErrorMessage(message: state.error);
        }
        // TODO: implement listener
        if (state is VerifyOtpSuccessState) {
          otpBloc.add(OTPCheckUserExistsEvent(context: context));
        } else if (state is CheckIfUserExistSuccessState) {
          if (state.userExistStatus?.isExistActive ?? false) {
            // TODO : (forgot password) => (reset password)
            /* otpBloc?.add(NavigateToResetPasswordScreenEvent(
                context: context,
                showInputName: false,
                phoneNumber: (ModalRoute.of(context)!.settings.arguments
                    as Map)['phoneNumber']));*/
            HelpooInAppNotification.showSuccessMessage(
              message: LocaleKeys.loginSuccess.tr(),
            );
            if (fromCorporate) {
              //TODO : navigate to corporate main screen

              Navigator.pushReplacementNamed(
                  context, PageRouteName.authPackagesScreen, arguments: {
                'fromCorporate': true,
                'corporateName': widget.corporateName
              });
            } else
              context.pushNamedAndRemoveUntil(PageRouteName.mainScreen);
          } else if (state.userExistStatus?.isExistNotActive ?? false) {
            // TODO : (forgot password) => (reset password with name field)
            //here we need to navigate to profile to user cont add data
            if (fromCorporate) {
              //TODO : update name then navigate
              otpBloc.add(NavigateToRegisterScreenEvent(
                  fullName: widget.fullName,
                  corporateName: widget.corporateName,
                  context: context,
                  phoneNumber: (ModalRoute.of(context)!.settings.arguments
                      as Map)['phoneNumber']));
            } else
              context.pushNamedAndRemoveUntil(
                PageRouteName.profileScreenNotActiveUser,
                
              );
            /* otpBloc?.add(NavigateToResetPasswordScreenEvent(
                context: context,
                showInputName: true,
                phoneNumber: (ModalRoute.of(context)!.settings.arguments
                    as Map)['phoneNumber']));*/
          } else if (state.userExistStatus?.isNotExist ?? false) {
            // TODO : (send otp) => (register)
            otpBloc?.add(NavigateToRegisterScreenEvent(
                context: context,
                fullName: widget.fullName,
                corporateName: widget.corporateName,
                phoneNumber: (ModalRoute.of(context)!.settings.arguments
                    as Map)['phoneNumber']));
          }
        }
      },
      child: ScaffoldWithBackground(
          body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            verticalSpace120,

            ///* logo
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.rw),
              child: LoadSvg(
                width: double.infinity,
                image: AssetsImages.logo,
                height: 106.rh,
                fit: BoxFit.fill,
              ),
            ),
            verticalSpace80,
            Text(
              LocaleKeys.pleaseEnterOTP.tr(),
              style: TextStyles.bold20,
            ),
            verticalSpace16,

            ///* OTP Field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.rw),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ///* OTP Field
                    /*   Directionality(
                      textDirection: ui.TextDirection.ltr,
                      child: PinCodeTextField(
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        controller: otpBloc?.otpController,
                        length: 4,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        validator: (value) {
                          if (value!.isNotEmpty &&
                              !Utils.otpValidation.hasMatch(value)) {
                            return LocaleKeys.invalidOtp.tr();
                          }
                          return value;
                        },
                        onCompleted: (v) {
                          //   appBloc.verifyOtp();
                          otpBloc?.add(VerifyOTPEvent(
                              phoneNumber: (ModalRoute.of(context)!
                                  .settings
                                  .arguments as Map)['phoneNumber'],
                              otpModel: otpBloc?.otpModel ??
                                  (ModalRoute.of(context)!.settings.arguments
                                      as Map)['otpModel']));
                        },
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: 12.br,
                          fieldHeight: 56.rh,
                          fieldWidth: 56.rw,
                          borderWidth: 3,
                          activeFillColor: Colors.white,
                          activeColor: ColorsManager.darkGreyColor,
                          selectedColor: ColorsManager.mainColor,
                          inactiveColor: ColorsManager.darkGreyColor,
                          fieldOuterPadding:
                              const EdgeInsets.symmetric(horizontal: 5),
                        ),
                        cursorColor: ColorsManager.mainColor,
                        enablePinAutofill: true,
                        animationDuration: duration300,
                        appContext: context,
                        onChanged: (v) {},
                      ),
                    ),*/
                    Center(
                      child: Directionality(
                        // Specify direction if desired
                        textDirection: ui.TextDirection.ltr,
                        child: Pinput(
                          length: 4,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          keyboardType: TextInputType.number,

                          controller: otpBloc?.otpController,
                          // focusNode: focusNode,
                          androidSmsAutofillMethod:
                              AndroidSmsAutofillMethod.smsUserConsentApi,
                          listenForMultipleSmsOnAndroid: true,
                          // defaultPinTheme: defaultPinTheme,
                          separatorBuilder: (index) => const SizedBox(width: 8),
                          validator: (value) {
                            if (value!.isNotEmpty &&
                                !Utils.otpValidation.hasMatch(value)) {
                              return LocaleKeys.invalidOtp.tr();
                            }
                            return value;
                          },
                          // onClipboardFound: (value) {
                          //   debugPrint('onClipboardFound: $value');
                          //   pinController.setText(value);
                          // },
                          hapticFeedbackType: HapticFeedbackType.lightImpact,
                          onCompleted: (pin) {
                            debugPrint('onCompleted: $pin');
                            otpBloc?.add(VerifyOTPEvent(
                                phoneNumber: (ModalRoute.of(context)!
                                    .settings
                                    .arguments as Map)['phoneNumber'],
                                otpModel: otpBloc?.otpModel ??
                                    (ModalRoute.of(context)!.settings.arguments
                                        as Map)['otpModel']));
                          },
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          errorText: '',
                          pinputAutovalidateMode:
                              PinputAutovalidateMode.onSubmit,
                          onChanged: (value) {
                            debugPrint('onChanged: $value');
                            otpBloc?.otpController.text = value;
                          },
                          cursor: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 9),
                                width: 22,
                                height: 1,
                                color: ColorsManager.primaryGreen,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    verticalSpace12,

                    ///* Resend OTP
                    TextButton(
                      onPressed: () {
                        // appBloc.sendOtp();
                        otpBloc?.add(ResendOTPButtonEvent(
                          mobileNumber: (ModalRoute.of(context)!
                              .settings
                              .arguments as Map)['phoneNumber'],
                        ));
                      },
                      child: Text(
                        LocaleKeys.resendCode.tr(),
                        textAlign: TextAlign.start,
                        style: TextStyles.bold16.copyWith(
                          color: ColorsManager.mainColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
