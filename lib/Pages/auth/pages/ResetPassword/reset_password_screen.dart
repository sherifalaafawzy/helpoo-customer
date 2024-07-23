import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';

import '../../../../Configurations/Constants/assets_images.dart';
import '../../../../Widgets/animations/fade_animation.dart';
import '../../../../Widgets/helpoo_in_app_notifications.dart';
import '../../../../Widgets/load_svg.dart';
import '../../../../Widgets/primary_button.dart';
import '../../../../Widgets/primary_form_field.dart';
import '../../../../Widgets/scaffold_bk.dart';
import '../../../../Widgets/spacing.dart';
import '../../../../generated/locale_keys.g.dart';
import '../Login/login_bloc.dart';
import 'reset_password_bloc.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool showPassword = false;
  bool showConfirmPassword = false;
  ResetPasswordBloc? resetPasswordBloc;
  LoginBloc? loginBloc;

  @override
  void initState() {
    super.initState();
    resetPasswordBloc = context.read<ResetPasswordBloc>();
    loginBloc = context.read<LoginBloc>();
    resetPasswordBloc?.resetPasswordBloc = resetPasswordBloc;
    resetPasswordBloc?.add(InitialResetPasswordEvent(context: context));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
      listener: (context, state) {
        loginBloc?.stream.listen((stateLogin) {
          if(stateLogin is UserLoginSuccessState){
            resetPasswordBloc
                ?.add(ResetPasswordNavigateToHomeEvent(context: context));
            loginBloc?.close();
          }
        });
        // TODO: implement listener
        if (state is ResetPasswordErrorState) {
          HelpooInAppNotification.showErrorMessage(
            message: LocaleKeys.somethingWentWrong.tr(),
          );
        }
        if (state is ResetPasswordSuccessState) {
          HelpooInAppNotification.showSuccessMessage(
            message: LocaleKeys.doneSuccessfully.tr(),
          );
          loginBloc?.add(LoginButtonEvent(
              phone: (ModalRoute.of(context)!.settings.arguments
                  as Map)['phoneNumber'],
              password: resetPasswordBloc?.passwordController.text));

        }
      },
      builder: (context, state) {
        return ScaffoldWithBackground(
          withBack: false,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///* logo
                FadeAnimation(
                  delay: 0.2,
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
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ///* Name
                      Visibility(
                        visible: resetPasswordBloc?.showNameField ?? false,
                        child: FadeAnimation(
                          delay: 0.4,
                          child: PrimaryFormField(
                            validationError: LocaleKeys.nameRequired.tr(),
                            controller: resetPasswordBloc?.nameController,
                            label: LocaleKeys.fullName.tr(),
                          ),
                        ),
                      ),
                      // if (appBloc.userExistStatus.isExistNotActive) verticalSpace20,
                      if (resetPasswordBloc?.showNameField ?? false)
                        verticalSpace20,

                      ///* password
                      FadeAnimation(
                        delay: 0.6,
                        child: PrimaryFormField(
                            validationError: LocaleKeys.passwordRequired.tr(),
                            controller: resetPasswordBloc?.passwordController,
                            label: LocaleKeys.password.tr(),
                            isPassword: !showPassword,
                            suffixIcon: showPassword == true
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showPassword = false;
                                      });
                                    },
                                    icon: const Icon(Icons.visibility_off),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showPassword = true;
                                      });
                                    },
                                    icon: const Icon(Icons.visibility),
                                  )),
                      ),
                      verticalSpace20,

                      ///* confirm password
                      FadeAnimation(
                        delay: 0.8,
                        child: PrimaryFormField(
                            validationError: LocaleKeys.passwordRequired.tr(),
                            controller:
                                resetPasswordBloc?.confirmPasswordController,
                            label: LocaleKeys.confirmPassword.tr(),
                            isPassword: !showConfirmPassword,
                            suffixIcon: showConfirmPassword == true
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showConfirmPassword = false;
                                      });
                                    },
                                    icon: const Icon(Icons.visibility_off),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showConfirmPassword = true;
                                      });
                                    },
                                    icon: const Icon(Icons.visibility),
                                  )),
                      ),
                      verticalSpace20,

                      ///* Confirm button
                      FadeAnimation(
                        delay: 1,
                        child: PrimaryButton(
                          text: LocaleKeys.confirm.tr(),
                          //isLoading: appBloc.isLoginLoading || appBloc.isResetPasswordLoading,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // appBloc.resetPassword();
                              resetPasswordBloc?.add(ResetPasswordButtonEvent(
                                  context: context,
                                  mobileNumber: (ModalRoute.of(context)!
                                      .settings
                                      .arguments as Map)['phoneNumber']));
                            }
                          },
                        ),
                      ),
                      verticalSpace20,
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
