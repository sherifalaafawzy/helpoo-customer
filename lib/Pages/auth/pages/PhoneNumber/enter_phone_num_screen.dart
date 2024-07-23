import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import '../../../../Configurations/Constants/assets_images.dart';
import '../../../../Configurations/Constants/page_route_name.dart';
import '../../../../Style/theme/colors.dart';
import '../../../../Style/theme/text_styles.dart';
import '../../../../Widgets/animations/fade_animation.dart';
import '../../../../Widgets/helpoo_in_app_notifications.dart';
import '../../../../Widgets/load_svg.dart';
import '../../../../Widgets/primary_button.dart';
import '../../../../Widgets/primary_form_field.dart';
import '../../../../Widgets/scaffold_bk.dart';
import '../../../../Widgets/spacing.dart';
import '../../../../generated/locale_keys.g.dart';
import 'phone_number_bloc.dart';

class EnterPhoneNumScreen extends StatefulWidget {
  const EnterPhoneNumScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<EnterPhoneNumScreen> createState() => _EnterPhoneNumScreenState();
}

class _EnterPhoneNumScreenState extends State<EnterPhoneNumScreen> {
  final _formKey = GlobalKey<FormState>();
  PhoneNumberBloc? phoneNumberBloc;

  @override
  void initState() {
    super.initState();
    phoneNumberBloc = context.read<PhoneNumberBloc>();
    phoneNumberBloc?.phoneNumberBloc = phoneNumberBloc;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PhoneNumberBloc, PhoneNumberState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is PhoneNumberSendOtpSuccessState) {
          phoneNumberBloc?.add(NavigateToVerifyOTPEvent(
            context: context,
            otpModel: state.otpModel,
            phoneNumber: phoneNumberBloc?.phoneController.text,
          ));
        }
        if (state is PhoneNumberSendOtpErrorState) {
          HelpooInAppNotification.showErrorMessage(message: state.error);
        }
      },
      child: ScaffoldWithBackground(
        withBack: false,
        body: BlocBuilder<PhoneNumberBloc, PhoneNumberState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ///* logo
                  FadeAnimation(
                    delay: 0.5,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.rw),
                      child: LoadSvg(
                        width: double.infinity,
                        image: AssetsImages.logo,
                        height: 106.rh,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  verticalSpace140,
                  FadeAnimation(
                    delay: 1,
                    child: Text(
                      LocaleKeys.pleaseEnterPhonenumber.tr(),
                      style: TextStyles.bold20,
                    ),
                  ),
                  verticalSpace12,
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ///* phone Number
                        FadeAnimation(
                          delay: 1.5,
                          child: PrimaryFormField(
                            validationError:
                                LocaleKeys.phoneNumberIsRequired.tr(),
                            controller: phoneNumberBloc?.phoneController,
                            keyboardType: TextInputType.phone,
                            label: LocaleKeys.phoneNumber.tr(),
                          ),
                        ),
                        verticalSpace16,
                        FadeAnimation(
                          delay: 2,
                          child: PrimaryButton(
                            isLoading: state is PhoneNumberSendOtpLoadingState,
                            text: LocaleKeys.confirm.tr(),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // appBloc.checkIfUserExist();
                                phoneNumberBloc?.add(
                                    PhoneNumberConfirmButtonEvent(
                                        mobileNumber: phoneNumberBloc
                                            ?.phoneController.text));
                              }
                            },
                          ),
                        ),
                        verticalSpace20,
                        FadeAnimation(
                          delay: 0.8,
                          child: Align(
                            alignment: AlignmentDirectional.center,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(PageRouteName.loginScreen);
                              },
                              child: Text(
                                LocaleKeys.loginAsCorporate.tr(),
                                style: TextStyles.semiBold16.copyWith(
                                  color: ColorsManager.mainColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
