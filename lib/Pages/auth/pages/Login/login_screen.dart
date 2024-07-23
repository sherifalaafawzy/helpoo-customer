import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import '../../../../Configurations/Constants/api_endpoints.dart';
import '../../../../Configurations/Constants/assets_images.dart';
import '../../../../Configurations/Constants/page_route_name.dart';
import '../../../../Widgets/animations/fade_animation.dart';
import '../../../../Widgets/helpoo_in_app_notifications.dart';
import '../../../../Widgets/load_svg.dart';
import '../../../../Widgets/primary_button.dart';
import '../../../../Widgets/primary_form_field.dart';
import '../../../../Widgets/scaffold_bk.dart';
import '../../../../Widgets/spacing.dart';
import '../../../../generated/locale_keys.g.dart';
import 'login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool showPassword = false;
  LoginBloc? loginBloc;

  @override
  void initState() {
    super.initState();
    loginBloc = context.read<LoginBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is AuthAdminSuccessState) {
          if (state.adminRole.toLowerCase() == 'super') {
            Navigator.of(context).pop();
            HelpooInAppNotification.showSuccessMessage(
                message: 'ENVIRONMENT: (${apiRoute})');
          } else {
            HelpooInAppNotification.showErrorMessage(
                message: 'Not AUTHORIZED!');
          }
        }
        if (state is AuthAdminErrorState) {
          HelpooInAppNotification.showErrorMessage(
              message: 'Not AUTHORIZED!');
        }
        // TODO: implement listener
        if (state is UserLoginErrorState) {
          HelpooInAppNotification.showErrorMessage(
            message: LocaleKeys.errorInUserNameOrPassword.tr(),
          );
        }
        if (state is UserLoginSuccessState) {
          HelpooInAppNotification.showSuccessMessage(
            message: LocaleKeys.loginSuccess.tr(),
          );
          context.pushNamedAndRemoveUntil(PageRouteName.mainScreen);
        }
      },
      builder: (context, state) {
        return ScaffoldWithBackground(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///* logo
                GestureDetector(
                  onTap: () {
                    ENV_CONFIG_CLICKS++;
                    if (ENV_CONFIG_CLICKS == 10) {
                      ENV_CONFIG_CLICKS = 0;
                      showModalBottomSheet(
                          isDismissible: false,
                          context: context,
                          builder: (_) {
                            return ListView(
                              children: [
                                ListTile(
                                  title: Text('PRODUCTION'),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    ENV_CONFIG_SELECTED = productionRoute;
                                    showAdminPassDialog(
                                        context, loginBloc, state);
                                  },
                                ),
                                ListTile(
                                  title: Text('STAGING'),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    ENV_CONFIG_SELECTED = stagingRoute;
                                    showAdminPassDialog(
                                        context, loginBloc, state);
                                  },
                                ),
                                ListTile(
                                  title: Text('DEV'),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    ENV_CONFIG_SELECTED = devRoute;
                                    showAdminPassDialog(
                                        context, loginBloc, state);
                                  },
                                ),
                              ],
                            );
                          });
                    }
                  },
                  child: FadeAnimation(
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
                ),
                verticalSpace140,
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ///* phone Number
                      FadeAnimation(
                        delay: 0.4,
                        child: PrimaryFormField(
                          validationError:
                              LocaleKeys.phoneNumberIsRequired.tr(),
                          controller: loginBloc?.phoneNumberController,
                          /* keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],*/
                          label: LocaleKeys.phoneNumber.tr(),
                          suffixIcon: const Icon(Icons.phone),
                        ),
                      ),
                      verticalSpace16,

                      ///* password
                      FadeAnimation(
                        delay: 0.6,
                        child: PrimaryFormField(
                            validationError: LocaleKeys.passwordRequired.tr(),
                            controller: loginBloc?.passwordController,
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
                      verticalSpace10,

                      ///* forgot Password
                      /* FadeAnimation(
                    delay: 0.8,
                    child: Align(
                      alignment: AlignmentDirectional.bottomEnd,
                      child: TextButton(
                        onPressed: () {
                          context
                              .pushNamed(PageRouteName.enterPhoneNumScreen);
                        },
                        child: Text(
                          LocaleKeys.forgotPassword.tr(),
                          style: TextStyles.semiBold16.copyWith(
                            color: ColorsManager.mainColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  verticalSpace16,*/

                      ///* login button
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return FadeAnimation(
                            delay: 1,
                            child: PrimaryButton(
                              text: LocaleKeys.login.tr(),
                              isLoading: state is UserLoginLoadingState,
                              isDisabled: state is UserLoginLoadingState,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  //    appBloc.userLogin();
                                  loginBloc?.add(LoginButtonEvent(
                                      password:
                                          loginBloc?.passwordController.text,
                                      phone: loginBloc
                                          ?.phoneNumberController.text));
                                }
                              },
                            ),
                          );
                        },
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

  void showAdminPassDialog(context, LoginBloc? loginBloc, state) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Warning!'),
        content: Column(
          children: [
            const ListTile(
              title: Text('Admin Configuration!'),
              subtitle: Text(
                  'You are about to edit on the app configuration! Please make sure to contact Helpoo Administration Team.'),
            ),
            PrimaryFormField(
              validationError: 'Wrong Username',
              label: 'ADMIN',
              controller: loginBloc?.adminAuthNameCtrl,
              enabled: true,
            ),
            SizedBox(height: 10),
            PrimaryFormField(
              validationError: 'Wrong Password',
              label: 'PASS',
              controller: loginBloc?.adminAuthPassCtrl,
              enabled: true,
            ),
          ],
        ),
        actions: [
          PrimaryButton(
            text: 'PROCEED!',
            backgroundColor: Colors.red,
            isLoading: state is AuthAdminLoadingState,
            onPressed: () {
              loginBloc?.add(AuthAdminEvent(
                  pass: loginBloc?.adminAuthPassCtrl.text,
                  admin: loginBloc?.adminAuthNameCtrl.text));
            },
          ),
        ],
      ),
    );
  }
}
