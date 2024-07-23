import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/Constants/page_route_name.dart';
import 'package:helpooappclient/Configurations/Constants/pages_exports.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';

import '../../../../Configurations/Constants/assets_images.dart';
import '../../../../Configurations/app_router.dart';
import '../../../../Style/theme/text_styles.dart';
import '../../../../Widgets/animations/fade_animation.dart';
import '../../../../Widgets/helpoo_in_app_notifications.dart';
import '../../../../Widgets/load_svg.dart';
import '../../../../Widgets/primary_button.dart';
import '../../../../Widgets/primary_form_field.dart';
import '../../../../Widgets/scaffold_bk.dart';
import '../../../../Widgets/show_success_dialog.dart';
import '../../../../Widgets/spacing.dart';
import '../../../../generated/locale_keys.g.dart';
import 'sign_up_bloc.dart';

class RegisterFillDataScreen extends StatefulWidget {
  const RegisterFillDataScreen({Key? key}) : super(key: key);

  @override
  State<RegisterFillDataScreen> createState() => _RegisterFillDataScreenState();
}

class _RegisterFillDataScreenState extends State<RegisterFillDataScreen> {
  final _formKey = GlobalKey<FormState>();
  SignUpBloc? signUpBloc;

  @override
  void initState() {
    super.initState();
    signUpBloc = context.read<SignUpBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is UpdateProfileRegisterSuccessState) {
          showSuccessDialog(
            context,
            title: LocaleKeys.accountCreatedSuccessfully.tr(),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => MainScreen(isFromRegister: true)),
                (route) => false,
              );
            },
          );
        }
        if (state is RegisterErrorState) {
          HelpooInAppNotification.showErrorMessage(message: state.error);
        }
      },
      builder: (context, state) {
        return ScaffoldWithBackground(
          withBack: false,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //verticalSpace2,

                ///* logo
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.rw),
                  child: FadeAnimation(
                    delay: 0.2,
                    child: LoadSvg(
                      width: double.infinity,
                      image: AssetsImages.logo,
                      height: 60.rh,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                verticalSpace10,
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///* Full Name ---------------------------------------------
                      FadeAnimation(
                        delay: 0.4,
                        child: Text(
                          LocaleKeys.fullName.tr(),
                          style: TextStyles.bold16,
                        ),
                      ),
                      verticalSpace12,
                      FadeAnimation(
                        delay: 0.6,
                        child: PrimaryFormField(
                          validationError: LocaleKeys.nameRequired.tr(),
                          label: LocaleKeys.fullName.tr(),
                          controller: signUpBloc?.nameController,
                        ),
                      ),
                      verticalSpace20,

                      ///* Email ---------------------------------------------
                      FadeAnimation(
                        delay: 0.8,
                        child: Text(
                          LocaleKeys.email.tr(),
                          style: TextStyles.bold16,
                        ),
                      ),
                      verticalSpace12,
                      FadeAnimation(
                        delay: 1,
                        child: PrimaryFormField(
                          validationError: LocaleKeys.required.tr(),
                          label: LocaleKeys.email.tr(),
                          controller: signUpBloc?.emailController,
                        ),
                      ),
                      verticalSpace10,

                      ///* Password ----------------------------------------------
                      /*   FadeAnimation(
                        delay: 1.2,
                        child: Text(
                          LocaleKeys.password.tr(),
                          style: TextStyles.bold16,
                        ),
                      ),
                      verticalSpace12,
                      FadeAnimation(
                        delay: 1.4,
                        child: PrimaryFormField(
                          validationError: LocaleKeys.passwordRequired.tr(),
                          label: LocaleKeys.password.tr(),
                          controller: signUpBloc?.passwordController,
                        ),
                      ),
                      verticalSpace10,*/

                      ///* Confirm Password --------------------------------------
                      /* FadeAnimation(
                        delay: 1.6,
                        child: Text(
                          LocaleKeys.confirmPassword.tr(),
                          style: TextStyles.bold16,
                        ),
                      ),
                      verticalSpace12,
                      FadeAnimation(
                        delay: 1.8,
                        child: PrimaryFormField(
                          validationError: LocaleKeys.passwordDoesntMatch.tr(),
                          label: LocaleKeys.confirmPassword.tr(),
                          controller: signUpBloc?.confirmPasswordController,
                        ),
                      ),
                      verticalSpace10,*/

                      ///* promo code --------------------------------------------
                      FadeAnimation(
                        delay: 2,
                        child: Text(
                          LocaleKeys.enterThePromoCodeIfExist.tr(),
                          style: TextStyles.bold16,
                        ),
                      ),
                      verticalSpace12,
                      FadeAnimation(
                        delay: 2.2,
                        child: PrimaryFormField(
                          controller: signUpBloc?.promoCodeController,
                          validationError: '',
                          isValidate: false,
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: SizedBox(
                              width: 12,
                              height: 12,
                              child: LoadSvg(
                                image: AssetsImages.promoIcon,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          label: LocaleKeys.enterThePromoCodeIfExist.tr(),
                        ),
                      ),
                      verticalSpace10,
                      FadeAnimation(
                        delay: 2.4,
                        child: PrimaryButton(
                          text: LocaleKeys.confirm.tr(),
                          isLoading: state
                              is UpdateProfileRegisterLoadingState, // state is RegisterLoadingState,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // appBloc.register();
                              /*signUpBloc
                                  ?.add(RegisterButtonEvent(context: context));*/
                              signUpBloc?.add(UpdateProfileRegisterEvent());
                            }
                          },
                        ),
                      ),
                      verticalSpace10,
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
