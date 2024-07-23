import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/Constants/constants.dart';
import 'package:intl/intl.dart' as intl;
import '../../../generated/locale_keys.g.dart';
import '../../Configurations/Constants/assets_images.dart';
import '../../Style/theme/colors.dart';
import '../../Style/theme/text_styles.dart';
import '../../Widgets/animations/fade_animation.dart';
import '../../Widgets/helpoo_in_app_notifications.dart';
import '../../Widgets/load_svg.dart';
import '../../Widgets/primary_button.dart';
import '../../Widgets/primary_form_field.dart';
import '../../Widgets/spacing.dart';
import '../ChooseLanguage/choose_language_bloc.dart';
import '../Settings/settings_screen_bloc.dart';
import '../Settings/settings_screen_view.dart';
import 'profile_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _formKey = GlobalKey<FormState>();
  ProfileBloc? profileBloc;

  @override
  void initState() {
    super.initState();
    profileBloc = context.read<ProfileBloc>();
    profileBloc?.add(GetProfileEvent());
    profileBloc?.profileBloc = profileBloc;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
         if (state is UpdateProfileSuccessState) {
          HelpooInAppNotification.showSuccessMessage(
              message: '${LocaleKeys.profileUpdated.tr()}');
        }
        if (state is UseNormalPromoErrorState)
          HelpooInAppNotification.showErrorMessage(
            message: state.error,
          );
        if (state is GetProfileErrorState)
          HelpooInAppNotification.showErrorMessage(
            message: state.error,
          );
        if (state is UpdateProfileErrorState)
          HelpooInAppNotification.showErrorMessage(
            message: state.error,
          );
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: state is GetProfileLoadingState
              ? Column(
                  children: [
                    _buildSettingsButton(context),
                    const Center(
                      child: CircularProgressIndicator(
                          color: ColorsManager.mainColor),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    verticalSpace20,
                    _buildSettingsButton(context),

                    // verticalSpace20,
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
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
                                controller: profileBloc?.nameController,
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
                                validationError: "",
                                label: LocaleKeys.email.tr(),
                                controller: profileBloc?.emailController,
                                isValidate: false,
                              ),
                            ),
                            verticalSpace20,

                            ///* Mobile ---------------------------------------------
                            FadeAnimation(
                              delay: 0.8,
                              child: Text(
                                LocaleKeys.phoneNumber.tr(),
                                style: TextStyles.bold16,
                              ),
                            ),
                            verticalSpace12,
                            FadeAnimation(
                              delay: 1,
                              child: PrimaryFormField(
                                validationError: LocaleKeys.required.tr(),
                                controller: profileBloc?.phoneNumberController,
                                enabled: false,
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                            verticalSpace20,

                            ///* promo code --------------------------------------------
                            if (userRoleName == "Client")
                              FadeAnimation(
                                delay: 2,
                                child: state is GetProfileSuccessState &&
                                        state.value!
                                    ? Text(
                                        LocaleKeys.promoCode.tr(),
                                        style: TextStyles.bold16,
                                      )
                                    : Text(
                                        LocaleKeys.enterThePromoCodeIfExist
                                            .tr(),
                                        style: TextStyles.bold16,
                                      ),
                              ),
                            verticalSpace12,
                            if (userRoleName == "Client")
                              FadeAnimation(
                                delay: 2.2,
                                child: state is GetProfileSuccessState &&
                                            state.value! ||
                                        profileBloc!.isPromoCodeVisable
                                    ? Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: ColorsManager.mainColor,
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    profileBloc!
                                                        .normalPromoCodeRes!
                                                        .value,
                                                    style: TextStyles.bold16,
                                                  ),
                                                  Text(
                                                    LocaleKeys.validUntil.tr(),
                                                    style: TextStyles.bold16,
                                                  ),
                                                  Text(
                                                    intl.DateFormat(
                                                            "dd/MM/yyyy")
                                                        .format(DateTime.parse(
                                                            profileBloc!
                                                                .normalPromoCodeRes!
                                                                .expiryDate
                                                                .toString())),
                                                    style: TextStyles.bold16,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                  width: 100,
                                                  height: 40,
                                                  child: PrimaryButton(
                                                      text: LocaleKeys.replace
                                                          .tr(),
                                                      onPressed: () {
                                                        profileBloc
                                                            ?.changePromoCodeVisibilty(
                                                                false);
                                                      })),
                                            ],
                                          ),
                                        ),
                                      )
                                    : PrimaryFormField(
                                        controller:
                                            profileBloc?.promoCodeController,
                                        validationError: '',
                                        isValidate: false,
                                        suffixIcon: FadeAnimation(
                                          delay: 2.2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: 100,
                                              child: PrimaryButton(
                                                  isLoading: state
                                                      is CheckPromoIfPackageOrNormalLoading,
                                                  //appBloc.isUseNormalPromoLoading,
                                                  text: LocaleKeys.add.tr(),
                                                  onPressed: () {
                                                    if (profileBloc
                                                            ?.promoCodeController
                                                            .text
                                                            .isNotEmpty ??
                                                        false) {
                                                      profileBloc?.add(CheckPromoCode(
                                                          promoCode: profileBloc
                                                              ?.promoCodeController
                                                              .text));
                                                      profileBloc?.add(UsePromoCode(
                                                          value: profileBloc
                                                              ?.promoCodeController
                                                              .text));
                                                    } else {
                                                      HelpooInAppNotification
                                                          .showErrorMessage(
                                                        message: LocaleKeys
                                                            .enterThePromoCodeIfExist
                                                            .tr(),
                                                      );
                                                    }
                                                  }),
                                            ),
                                          ),
                                        ),
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
                                      ),
                              ),
                            verticalSpace20,
                            FadeAnimation(
                              delay: 2.4,
                              child: Center(
                                child: PrimaryButton(
                                  isLoading: state is UpdateProfileLoadingState,
                                  text: LocaleKeys.save.tr(),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      //   appBloc.updateProfile();
                                      profileBloc?.add(UpdateProfileEvent());
                                      profileBloc?.add(UpdateProfileEvent());
                                    }
                                  },
                                ),
                              ),
                            ),
                            verticalSpace20,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Row _buildSettingsButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (_) {
                return MultiBlocProvider(providers: [
                  BlocProvider(create: (context) => SettingsScreenBloc()),
                  BlocProvider(create: (context) => ChooseLanguageBloc()),
                ], child: const SettingsScreen());
              },
            );
          },
        ),
      ],
    );
  }
}
