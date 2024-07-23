import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/Constants/constants.dart';
import 'package:helpooappclient/Configurations/Constants/page_route_name.dart';
import 'package:helpooappclient/Configurations/Constants/pages_exports.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import 'package:intl/intl.dart' as intl;
import 'package:supercharged/supercharged.dart';

import '../../../Configurations/Constants/assets_images.dart';
import '../../../Services/navigation_service.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/animations/fade_animation.dart';
import '../../../Widgets/helpoo_in_app_notifications.dart';
import '../../../Widgets/load_svg.dart';
import '../../../Widgets/network_image_card.dart';
import '../../../Widgets/primary_button.dart';
import '../../../Widgets/primary_form_field.dart';
import '../../../Widgets/primary_loading.dart';
import '../../../Widgets/scaffold_bk.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';
import '../../PaymentWebView/payment_web_view_page.dart';
import '../Widgets/auth_package_item.dart';
import '../packages_screen_bloc.dart';

class AuthPackagesScreen extends StatefulWidget {
  const AuthPackagesScreen({Key? key, this.fromCorporate, this.corporateName})
      : super(key: key);
  final bool? fromCorporate;
  final String? corporateName;

  @override
  State<AuthPackagesScreen> createState() => _AuthPackagesScreenState();
}

class _AuthPackagesScreenState extends State<AuthPackagesScreen> {
  PackagesScreenBloc? packagesScreenBloc;

  @override
  void initState() {
    super.initState();
    // appBloc.getAllPackages();
    // appBloc.getMyPackages();
    packagesScreenBloc = context.read<PackagesScreenBloc>();
    if (widget.fromCorporate ?? false) {
      if (widget.corporateName != null)
        packagesScreenBloc
            ?.add(GetPackagesByCorporate(corporateName: widget.corporateName!));
    } else {
      packagesScreenBloc?.add(GetAllPackagesEvent());
      packagesScreenBloc?.add(GetMyPackagesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PackagesScreenBloc, PackagesScreenState>(
      listener: (context, state) async {
        if (state is GetIFrameUrlSuccessPackagesState) {
          context.pushTo(
            PaymentWebViewPage(
                url: state.url!,
                callBack: () async {
                  final mainBloc = context.read<MainBloc>();
                  NavigationService.navigatorKey.currentContext!
                      .pushNamedAndRemoveUntil(PageRouteName.mainScreen);
                  if (state.fromCorporate) {
                    await Future.delayed(const Duration(milliseconds: 500));
                    mainBloc.add(
                        UpdateBottomNavBarEvent(index: 0, context: context));
                  }
                }),
          );
        }
        if (state is ValidatePromoPackageError) {
          HelpooInAppNotification.showErrorMessage(message: state.error);
        }
        /*   if (state is ValidatePromoPackageError) {
          HelpooInAppNotification.showErrorMessage(message: state.error);
        }
        if (state is UsePromoOnPackageErrorState) {
          HelpooInAppNotification.showErrorMessage(message: state.error);
        } else if (state is UsePromoOnPackageSuccessState) {
          if (appBloc.usePromoOnPackageRes?.promo?.fees != 0) {
            await appBloc.getIFrameUrl(
              isServiceReq: false,
              amount: appBloc.usePromoOnPackageRes?.promo?.fees?.toDouble() ?? 0.0,
            );
            appBloc.isFromPackageOnline = true;
            appBloc.isFromServiceRequestOnline = false;
            context.pushTo(
              PaymentWebViewPage(),
            );
          } else {
            // TODO : fees after promo = 0
          }
        }*/
      },
      builder: (context, state) {
        return ScaffoldWithBackground(
          withBack: false,
          alignment: AlignmentDirectional.center,
          extendBodyBehindAppBar: false,
          appBarTitle: LocaleKeys.packages.tr(),
          body: PrimaryLoading(
            isLoading: state is GetAllPackagesLoadingState ||
                state is GetMyPackagesLoadingState,
            // appBloc.isGetAllPackagesLoading || appBloc.isGetMyPackagesLoading,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ///*** Corporate Packages [ My Packages ] ======================
                  if (packagesScreenBloc?.myPackages.isNotEmpty ?? false) ...[
                    Container(
                      padding: EdgeInsets.all(10.rSp),
                      decoration: BoxDecoration(
                        borderRadius: 24.rSp.br,
                        border: Border.all(
                          color: ColorsManager.mainColor,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                              start: 12.rw,
                            ),
                            child: Text(
                              LocaleKeys.alreadySubscribed.tr(),
                              style: TextStyles.bold16,
                            ),
                          ),
                          verticalSpace12,
                          ...List.generate(
                            packagesScreenBloc?.myPackages.length ?? 0,
                            (index) => Padding(
                              padding: EdgeInsets.only(
                                bottom: (index !=
                                        packagesScreenBloc!.myPackages.length -
                                            1)
                                    ? 14.rSp
                                    : 0,
                              ),
                              child: AuthPackageItem(
                                index: index,
                                packagesScreenBloc: null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpace12,
                  ],

                  ///*** Helpoo Packages ========================================
                  if (packagesScreenBloc?.helpooPackages.isNotEmpty ??
                      false) ...[
                    Container(
                      padding: EdgeInsets.all(10.rSp),
                      decoration: BoxDecoration(
                        borderRadius: 24.rSp.br,
                        border: Border.all(
                          color: ColorsManager.mainColor,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_isNotFromCorporate)
                            Padding(
                              padding: EdgeInsetsDirectional.only(
                                start: 12.rw,
                              ),
                              child: Text(
                                LocaleKeys.addPackageAsk.tr(),
                                style: TextStyles.bold16,
                              ),
                            ),
                          verticalSpace12,
                          ...List.generate(
                            packagesScreenBloc?.helpooPackages.length ?? 0,
                            (index) => Padding(
                              padding: EdgeInsets.only(
                                bottom: 14.rSp,
                              ),
                              child: InkWell(
                                onTap: () {
                                  //    printMeLog('-------------------------- 11');
                                  setState(() {
                                    packagesScreenBloc?.selectedPackage = index;
                                  });
                                },
                                child: AuthPackageItem(
                                  isHelpooPackage: true,
                                  isFromCorporate:
                                      widget.fromCorporate ?? false,
                                  index: index,
                                  packagesScreenBloc: packagesScreenBloc,
                                  discount:
                                      packagesScreenBloc?.discount?[index],
                                ),
                              ),
                            ),
                          ),

                          ///* promo package Field
                          if (_isNotFromCorporate) ...[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  FadeAnimation(
                                    delay: 2,
                                    child: packagesScreenBloc!
                                            .isPromoPackageActive
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
                                ],
                              ),
                            ),
                            packagesScreenBloc!.isPromoPackageActive
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
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
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    packagesScreenBloc!
                                                        .fetchedPromos
                                                        .first
                                                        .value
                                                        .toString(),
                                                    style: TextStyles.bold14,
                                                  ),
                                                  Text(
                                                    LocaleKeys.validUntil.tr(),
                                                    style: TextStyles.bold14,
                                                  ),
                                                  Text(
                                                    intl.DateFormat(
                                                            "dd/MM/yyyy")
                                                        .format(DateTime.parse(
                                                            packagesScreenBloc!
                                                                .fetchedPromos
                                                                .first
                                                                .expiryDate
                                                                .toString())),
                                                    style: TextStyles.bold12,
                                                  ),
                                                ],
                                              ),
                                              if (packagesScreenBloc
                                                      ?.fetchedPromos
                                                      .first
                                                      .corporateCompany
                                                      ?.photo !=
                                                  null)
                                                NetworkImageCard(
                                                    imageUrl:
                                                        packagesScreenBloc!
                                                            .fetchedPromos
                                                            .first
                                                            .corporateCompany!
                                                            .photo!),
                                              SizedBox(
                                                  width: 70,
                                                  height: 40,
                                                  child: PrimaryButton(
                                                      text: LocaleKeys.replace
                                                          .tr(),
                                                      onPressed: () {
                                                        packagesScreenBloc?.add(
                                                            ChangePromoCodeVisibilityEvent());
                                                      })),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: PrimaryFormField(
                                      controller: packagesScreenBloc
                                          ?.promoCodeController,
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
                                                        is ValidatePromoPackageLoading ||
                                                    state
                                                        is UsePromoOnPackageLoadingState,
                                                //appBloc.isUseNormalPromoLoading,
                                                text: LocaleKeys.activate.tr(),
                                                onPressed: () {
                                                  if (packagesScreenBloc
                                                          ?.selectedPackage ==
                                                      -1) {
                                                    HelpooInAppNotification
                                                        .showErrorMessage(
                                                            message: LocaleKeys
                                                                .pleaseChoosePackage
                                                                .tr());
                                                  } else {
                                                    if (packagesScreenBloc
                                                            ?.promoCodeController
                                                            .text
                                                            .isNotEmpty ??
                                                        false) {
                                                      if (packagesScreenBloc!
                                                          .promoCodeController
                                                          .text
                                                          .toLowerCase()
                                                          .startsWith('sh')) {
                                                        packagesScreenBloc
                                                            ?.usePromoOnPackageShell();
                                                      } else {
                                                        packagesScreenBloc?.add(
                                                            GetPromoEvent());
                                                      }
                                                    } else {
                                                      HelpooInAppNotification
                                                          .showErrorMessage(
                                                        message: LocaleKeys
                                                            .enterThePromoCodeIfExist
                                                            .tr(),
                                                      );
                                                    }
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
                                      // label: LocaleKeys.enterThePromoCodeIfExist.tr(),
                                    ),
                                  ),
                          ],
                          verticalSpace8,
                          PrimaryButton(
                            text: LocaleKeys.subscribe.tr(),

                            isLoading:
                                state is GetIFrameUrlLoadingPackagesState,
                            //appBloc.isGetIFrameUrlLoading || appBloc.isUsePromoOnPackageLoading,
                            onPressed: () async {
                              ///* 1- there is no package selected
                              if (packagesScreenBloc?.selectedPackage == -1) {
                                HelpooInAppNotification.showErrorMessage(
                                    message:
                                        LocaleKeys.pleaseChoosePackage.tr());
                              } else {
                                if (packagesScreenBloc?.isPromoPackageActive ??
                                    false) {
                                  if (packagesScreenBloc!
                                      .promoCodeController.text
                                      .toLowerCase()
                                      .startsWith('sh')) {
                                    await packagesScreenBloc
                                        ?.usePromoOnPackageShell();
                                  } else {
                                    await packagesScreenBloc
                                        ?.usePromoOnPackage();
                                  }
                                  // after the response => look at the listener
                                } else {
                                  if (widget.fromCorporate ?? false) {
                                    final selectedPackage = packagesScreenBloc
                                            ?.helpooPackages[
                                        packagesScreenBloc!.selectedPackage];
                                    if (selectedPackage != null)
                                      packagesScreenBloc?.add(
                                          UseByCorporateEvent(
                                              dealId: selectedPackage.dealId,
                                              packageId: selectedPackage.id!,
                                              corporateName:
                                                  widget.corporateName!));
                                    return;
                                  }
                                  packagesScreenBloc?.add(
                                      GetIframePackagesEvent(
                                          amount: packagesScreenBloc
                                                  ?.helpooPackages[
                                                      packagesScreenBloc!
                                                          .selectedPackage]
                                                  .fees
                                                  ?.toDouble() ??
                                              0,
                                          requestId: packagesScreenBloc
                                              ?.helpooPackages[
                                                  packagesScreenBloc!
                                                      .selectedPackage]
                                              .id,
                                          selectedPackage: packagesScreenBloc!
                                              .helpooPackages[
                                                  packagesScreenBloc!
                                                      .selectedPackage]
                                              .id));
                                  /* await packagesScreenBloc?.getIFrameUrl(
                                    isServiceReq: false,
                                    amount: packagesScreenBloc?.helpooPackages[packagesScreenBloc!.selectedPackage].fees?.toDouble() ?? 0,
                                  );*/
                                  // appBloc.isFromPackageOnline = true;
                                  // appBloc.isFromServiceRequestOnline = false;
                                }
                              }

                              ///* 1- there is no package selected
                              /*if (appBloc.selectedPackage == -1) {
                                HelpooInAppNotification.showErrorMessage(
                                  message: LocaleKeys.pleaseChoosePackage.tr(),
                                );
                              } else {
                                if (appBloc.isPromoPackageActive) {
                                  await appBloc.usePromoOnPackage();

                                  //after the response => look at the listener
                                } else {
                                  await appBloc.getIFrameUrl(
                                    isServiceReq: false,
                                    amount: appBloc.helpooPackages[appBloc.selectedPackage].fees?.toDouble() ?? 0,
                                  );
                                  appBloc.isFromPackageOnline = true;
                                  appBloc.isFromServiceRequestOnline = false;
                                  context.pushTo(
                                    PaymentWebViewPage(),
                                  );
                                }
                              }*/
                            },
                          ),
                        ],
                      ),
                    ),
                    verticalSpace14,
                  ],
                  if (_isNotFromCorporate)
                    PrimaryButton(
                      text: LocaleKeys.haveInsurancePackage.tr(),
                      textStyle: TextStyles.bold14.copyWith(
                        color: Colors.white,
                      ),
                      backgroundColor: ColorsManager.textColor,
                      onPressed: () {
                        NavigationService.navigatorKey.currentContext!
                            .pushNamed(PageRouteName.chooseInsuranceCompany);
                        /*    appBloc.activateCarFromPackage = true;
                      appBloc.selectedCar = MyCarModel();
                      navigatorKey.currentContext!.pushNamed(Routes.chooseInsuranceCompany);*/
                      },
                    ),
                  verticalSpace18,
                  PrimaryButton(
                    text: LocaleKeys.continueWithoutPackage.tr(),
                    textStyle: TextStyles.bold16.copyWith(
                      color: ColorsManager.mainColor,
                    ),
                    backgroundColor: ColorsManager.darkGreyColor,
                    onPressed: () {
                      //  appBloc.selectedBottomNavBarIndex = 2;
                      NavigationService.navigatorKey.currentContext!
                          .pushNamedAndRemoveUntil(PageRouteName.mainScreen);
                    },
                  ),
                  verticalSpace28,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool get _isNotFromCorporate =>
      widget.fromCorporate == false || widget.fromCorporate == null;
}
