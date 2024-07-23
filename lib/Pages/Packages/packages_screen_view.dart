import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpooappclient/Configurations/Constants/page_route_name.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import 'package:helpooappclient/Models/packages/package_model.dart';
import 'package:helpooappclient/Pages/Packages/Widgets/info_dialog.dart';
import 'package:helpooappclient/Services/navigation_service.dart';
import 'package:helpooappclient/Widgets/custom_network_image.dart';
import 'package:intl/intl.dart' as intl;

import '../../../generated/locale_keys.g.dart';
import '../../Configurations/Constants/assets_images.dart';
import '../../Configurations/Constants/constants.dart';
import '../../Style/theme/colors.dart';
import '../../Style/theme/text_styles.dart';
import '../../Widgets/animations/fade_animation.dart';
import '../../Widgets/helpoo_in_app_notifications.dart';
import '../../Widgets/load_svg.dart';
import '../../Widgets/network_image_card.dart';
import '../../Widgets/primary_button.dart';
import '../../Widgets/primary_form_field.dart';
import '../../Widgets/primary_loading.dart';
import '../../Widgets/spacing.dart';
import '../PaymentWebView/payment_web_view_page.dart';
import 'Widgets/active_package_item.dart';
import 'Widgets/auth_package_item.dart';
import 'Widgets/utils.dart';
import 'packages_screen_bloc.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({this.isFromRegister = false, Key? key})
      : super(key: key);
  final bool isFromRegister;

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  PackagesScreenBloc? packagesScreenBloc;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    if (widget.isFromRegister) tabController.animateTo(1);
    packagesScreenBloc = context.read<PackagesScreenBloc>();
    packagesScreenBloc?.add(GetMyPackagesEvent());
    packagesScreenBloc?.add(GetAllPackagesEvent());
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        //  appBloc.renderUI();
      }
    });

    /*  appBloc.getAllPackages();
    appBloc.getMyPackages();*/
  }
  bool accepted = false;
     void showTermsAndConditions(
    BuildContext context,{required bool accepted ,required Function buttonAction,required Function(bool s) onChanged, required Package selectedPackage, required PackagesScreenBloc packagesScreenBloc}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return InfoDialog(accepted: accepted, buttonAction: buttonAction, onChanged: onChanged, package: selectedPackage,packagesScreenBloc: packagesScreenBloc);
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PackagesScreenBloc, PackagesScreenState>(
      listener: (context, state) async {
        if (state is GetIFrameUrlSuccessPackagesState) {
          context.pushTo(
            PaymentWebViewPage(
              url: state.url!,
              logoShell: packagesScreenBloc?.logoShell,
              amountPercentageShell: packagesScreenBloc?.amountPercentageShell,
              callBack: () {
                packagesScreenBloc?.add(GetMyPackagesEvent());
                Navigator.of(context).pop();
                tabController.animateTo(0);
              },
              successCallBack: () {
                final selectedPackage = packagesScreenBloc?.selectedPackage;
                if (selectedPackage != null) {
                  packagesScreenBloc?.add(GetMyPackagesEvent());
                  Navigator.of(context).pop();
                  tabController.animateTo(0);
                  _showSuccessDialog(context, packagesScreenBloc!.helpooPackages[selectedPackage]);
                }
              },
            ),
          );
        } else if (state is ValidatePromoPackageError) {
          HelpooInAppNotification.showErrorMessage(message: state.error);
        } else if (state is UsePromoOnPackageErrorState) {
          HelpooInAppNotification.showErrorMessage(message: state.error);
        } else if (state is UsePromoOnPackageSuccessState) {
          if (packagesScreenBloc?.usePromoOnPackageRes?.promo?.fees != 0 &&
              state.amount != 0) {
            packagesScreenBloc?.add(GetIframePackagesEvent(
                amount: state.amount ?? 0.0,
                requestId: packagesScreenBloc
                    ?.helpooPackages[packagesScreenBloc!.selectedPackage].id,
                selectedPackage: packagesScreenBloc!
                    .helpooPackages[packagesScreenBloc!.selectedPackage].id));
          } else {
            /// HelpooInAppNotification.showErrorMessage(message: '');
          }
        } else if (state is PromoCodeVisibilityState) {
          setState(() {
            packagesScreenBloc?.promoCodeController.clear();
          });
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TabBar(
              indicatorColor: ColorsManager.mainColor,
              labelColor: ColorsManager.mainColor,
              unselectedLabelColor: ColorsManager.mainColor.withOpacity(0.4),
              dividerColor: ColorsManager.greyColor,
              unselectedLabelStyle: TextStyles.bold14,
              labelStyle: TextStyles.bold16,
              indicatorPadding: EdgeInsets.symmetric(horizontal: 12.rw),
              controller: tabController,
              tabs: [ Tab(
                  text: LocaleKeys.subscription.tr(),
                ),
                Tab(
                  text: LocaleKeys.myPackages.tr(),
                ),
               
              ],
            ),
            Divider(
              color: ColorsManager.greyColor,
              height: 1.3.rSp,
              indent: 12.rw,
              endIndent: 12.rw,
            ),
            verticalSpace12,
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  ///*** My packages
                 

                  ///*** Helpoo Packages
                  SingleChildScrollView(
                    child: PrimaryLoading(
                      isLoading: state is GetAllPackagesLoadingState,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              // height: 25.rh,
                              // width: 40.rw,
                              padding: EdgeInsets.only(bottom: 10.rh),
                              alignment: Alignment.center,
                              child: Text(
                                '${LocaleKeys.yearlyPackage.tr()}',
                                style: TextStyles.bold16,
                              )),
                          ...List.generate(
                            packagesScreenBloc!.helpooPackages.length,
                            (index) => Padding(
                              padding: EdgeInsetsDirectional.only(
                                start: 12.rw,
                                bottom: (index !=
                                        packagesScreenBloc!
                                                .helpooPackages.length -
                                            1)
                                    ? 14.rSp
                                    : 0,
                              ),
                              child: InkWell(
                                onTap: () {
                                  print(index);

                                  packagesScreenBloc?.selectedPackage = index;
                                  setState(() {});
                                },
                                child: BlocProvider(
                                  create: (context) => PackagesScreenBloc(),
                                  child: AuthPackageItem(
                                    packagesScreenBloc: packagesScreenBloc,
                                    isHelpooPackage: true,
                                    index: index,
                                    isEndMargin: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
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
                              ? _buildActivePromo(context)
                              : Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: PrimaryFormField(
                                    controller:
                                        packagesScreenBloc?.promoCodeController,
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

                          ///* promo code row
                          /* Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: PrimaryFormField(
                                    controller:
                                        packagesScreenBloc?.promoCodeController,
                                    validationError: '',
                                    isValidate: false,
                                    //   enabled: !appBloc.isPromoPackageActive,
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
                                    hint: LocaleKeys.enterThePromoCodeIfExist
                                        .tr(),
                                  ),
                                ),
                                horizontalSpace4,
                                PrimaryButton(
                                  width: 80.rw,
                                  isLoading:
                                      state is ValidatePromoPackageLoading,
                                  text: packagesScreenBloc!.isPromoPackageActive
                                      ? LocaleKeys.change.tr()
                                      : LocaleKeys.activate.tr(),
                                  textStyle: TextStyles.bold14.copyWith(
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    if (packagesScreenBloc?.selectedPackage ==
                                        -1) {
                                      HelpooInAppNotification.showErrorMessage(
                                          message: LocaleKeys
                                              .pleaseChoosePackage
                                              .tr());
                                    } else {
                                      if (packagesScreenBloc!
                                          .promoCodeController
                                          .text
                                          .isNotEmpty) {
                                        if (packagesScreenBloc!
                                            .isPromoPackageActive) {
                                          //-- change promo code
                                          packagesScreenBloc
                                              ?.isPromoPackageActive = false;
                                          packagesScreenBloc
                                              ?.promoCodeController
                                              .clear();
                                        } else {
                                          //-- apply promo code
                                          packagesScreenBloc
                                              ?.add(GetPromoEvent());
                                        }
                                      } else {
                                        HelpooInAppNotification
                                            .showErrorMessage(
                                          message: LocaleKeys.insertPromo.tr(),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),*/
                          verticalSpace8,
                          PrimaryButton(
                            text: LocaleKeys.subscribe.tr(),
                            horizontalPadding: 12,
                            isLoading:
                                state is GetIFrameUrlLoadingPackagesState ||
                                    state is UsePromoOnPackageLoadingState,
                            onPressed: () async {
                              print("subscription to one of ${packagesScreenBloc!.helpooPackages.length}");
                              
                               showTermsAndConditions(packagesScreenBloc: packagesScreenBloc!,selectedPackage: packagesScreenBloc!.helpooPackages.elementAt(packagesScreenBloc!.selectedPackage),context,accepted: accepted,onChanged: (value){
                                log("called");
                                print("called");
                                setState(() {
                                  value = !value;
                                  accepted = value;
                                 
                                  log("the value is $value");
                                });
                               },buttonAction: ()async{
                                log("NEXT WILL BE CALLED");
                                if(accepted){
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
                                }
                               });
                            

                            },
                          ),
                          verticalSpace8,
                        ],
                      ),
                    ),
                  ),
                   SingleChildScrollView(
                    child: PrimaryLoading(
                      isLoading: state is GetAllPackagesLoadingState ||
                          state is GetMyPackagesLoadingState,
                      //appBloc.isGetAllPackagesLoading || appBloc.isGetMyPackagesLoading,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /*  ...List.generate(
                            packagesScreenBloc!.myPackages.length,
                            (index) => Padding(
                              padding: EdgeInsetsDirectional.only(
                                start: 12.rw,
                                bottom: (index !=
                                        packagesScreenBloc!.myPackages.length -
                                            1)
                                    ? 14.rSp
                                    : 0,
                              ),
                              child: BlocProvider(
                                create: (context) => PackagesScreenBloc(),
                                child: AuthPackageItem(
                                  packagesScreenBloc: packagesScreenBloc,
                                  isHelpooPackage: false,
                                  index: index,
                                  isEndMargin: true,
                                ),
                              ),
                            ),
                          ),*/

                          verticalSpace10,

                          // باقات مفعلة علي حسابك
                          if (packagesScreenBloc?.myPackages.isNotEmpty ??
                              false)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.rw,
                                vertical: 12.rh,
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal: 12.rw,
                              ),
                              decoration: BoxDecoration(
                                color: ColorsManager.transparent,
                                border:
                                    Border.all(color: ColorsManager.mainColor),
                                borderRadius: 8.rSp.br,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    LocaleKeys.activePackages.tr(),
                                    style: TextStyles.bold14,
                                  ),
                                  verticalSpace8,
                                  ...List.generate(
                                    packagesScreenBloc!.myPackages.length,
                                    (index) => Padding(
                                        padding: EdgeInsetsDirectional.only(
                                          // bottom: index == 1 ? 10 : 12.0,
                                          bottom: (index !=
                                                  packagesScreenBloc!
                                                          .myPackages.length -
                                                      1)
                                              ? 14.rSp
                                              : 0,
                                        ),
                                        child: ActivePackageItem(
                                            package: packagesScreenBloc!
                                                .myPackages[index])),
                                  ),
                                ],
                              ),
                            ),
                          verticalSpace10,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: PrimaryButton(
                              text: LocaleKeys.haveInsurancePackage.tr(),
                              textStyle: TextStyles.bold14.copyWith(
                                color: Colors.white,
                              ),
                              backgroundColor: ColorsManager.textColor,
                              onPressed: () {
                                NavigationService.navigatorKey.currentContext!
                                    .pushNamed(
                                        PageRouteName.chooseInsuranceCompany);
                                /*   appBloc.activateCarFromPackage = true;
                                appBloc.selectedCar = MyCarModel();
                                navigatorKey.currentContext!.pushNamed(Routes.chooseInsuranceCompany);*/
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActivePromo(BuildContext context) {
    final photoPath =
        packagesScreenBloc?.fetchedPromos.first.corporateCompany?.photo;
    final leadingWidget = photoPath == null
        ? null
        : CustomNetworkImage(
            path: photoPath,
            height: 100.rh,
            width: 70.rh,
            boxFit: BoxFit.contain,
          );
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: 14.rSp.br,
        border: Border.all(
          color: ColorsManager.mainColor.withOpacity(0.7),
          width: 1.5.rw,
        ),
        boxShadow: primaryShadow,
      ),
      child: ListTile(
        leading: leadingWidget,
        title: Text(
          '${packagesScreenBloc!.fetchedPromos.first.value.toString()}',
          style: TextStyles.bold14,
        ),
        subtitle: Text(
          '${LocaleKeys.validUntil.tr()} ${intl.DateFormat("dd/MM/yyyy").format(DateTime.parse(packagesScreenBloc!.fetchedPromos.first.expiryDate.toString()))}',
          style: TextStyles.bold12,
        ),
        trailing: SizedBox(
            width: 100.rw,
            height: 40.rh,
            child: PrimaryButton(
                textStyle: TextStyles.bold14.copyWith(color: Colors.white),
                text: LocaleKeys.replace.tr(),
                onPressed: () {
                  packagesScreenBloc?.add(ChangePromoCodeVisibilityEvent());
                })),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.rw, vertical: 0.rh),
      ),
    );
    // return Center(
    //   child: Padding(
    //     padding: const EdgeInsets.all(10.0),
    //     child: Container(
    //       decoration: BoxDecoration(
    //         border: Border.all(color: ColorsManager.mainColor, width: 2),
    //         borderRadius: BorderRadius.circular(10),
    //       ),
    //       width: MediaQuery.of(context).size.width,
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
    //         children: [
    //           Column(
    //             children: [
    //               Text(
    //                 packagesScreenBloc!.fetchedPromos.first.value.toString(),
    //                 style: TextStyles.bold16,
    //               ),
    //               Text(
    //                 LocaleKeys.validUntil.tr(),
    //                 style: TextStyles.bold16,
    //               ),
    //               Text(
    //                 intl.DateFormat("dd/MM/yyyy").format(DateTime.parse(
    //                     packagesScreenBloc!.fetchedPromos.first.expiryDate
    //                         .toString())),
    //                 style: TextStyles.bold16,
    //               ),
    //             ],
    //           ),
    //           if (packagesScreenBloc
    //                   ?.fetchedPromos.first.corporateCompany?.photo !=
    //               null)
    //             CustomNetworkImage(
    //               path: packagesScreenBloc!
    //                   .fetchedPromos.first.corporateCompany!.photo!,
    //               height: 100.rh,
    //               width: 100.rw,
    //             ),
    //           // NetworkImageCard(
    //           //     imageUrl: packagesScreenBloc!
    //           //         .fetchedPromos.first.corporateCompany!.photo!),
    //           SizedBox(
    //               width: 100,
    //               height: 40,
    //               child: PrimaryButton(
    //                   text: LocaleKeys.replace.tr(),
    //                   onPressed: () {
    //                     packagesScreenBloc
    //                         ?.add(ChangePromoCodeVisibilityEvent());
    //                   })),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  void _showSuccessDialog(BuildContext context, Package helpooPackage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            context: context,
            helpooPackage: helpooPackage,
          );
        });
  }
}

class CustomDialog extends StatelessWidget {
  final BuildContext context;
  final Package helpooPackage;
  CustomDialog({
    required this.context,
    required this.helpooPackage,
  });

  @override
  Widget build(context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 0.0, right: 0.0),
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            margin: const EdgeInsets.only(top: 30.0, right: 8.0),
            decoration: BoxDecoration(
                color: const Color(0xffD9D9D9),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: <BoxShadow>[
                  const BoxShadow(
                    color: Colors.black26,
                    blurRadius: 0.0,
                    offset: Offset(0.0, 0.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    width: 240,
                    child: Text("subscription_success".tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff0B141F))) //
                    ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AlertButton(
                      buttonLabel: "continue".tr(),
                      onTap: () {
                        Navigator.of(context).pop();
                        NavigationService.navigatorKey.currentContext!
                            .pushNamed(PageRouteName.addCarOrSelectCarPackage,
                                arguments: {
                              "isFromPayment": true,
                              "addedCars": helpooPackage.assignedCars ?? 0,
                              "totalCars": helpooPackage.numberOfCars ?? 0,
                            });
                      },
                    ),
                    AlertButton(
                      buttonLabel: "later".tr(),
                      onTap: () {
                        NavigationService.navigatorKey.currentContext!.pop();
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Center(
                    child: Text(
                  "subscription_warning".tr(),
                  style: TextStyle(
                    color: Color(0xffFF0000),
                    fontSize: 15,
                  ),
                ))
              ],
            ),
          ),
          Positioned(
            right: 0.0,
            left: 0.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                    radius: 30.0,
                    backgroundColor: const Color(0xffD9D9D9),
                    child: SvgPicture.asset(
                      "assets/images/check_icon.svg",
                      height: 60,
                      width: 60,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//******************************************************************************
class AlertButton extends StatelessWidget {
  final String buttonLabel;
  final Function() onTap;
  const AlertButton(
      {super.key, required this.buttonLabel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        decoration: const BoxDecoration(
            color: Color(0xff44B649),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Text(
          buttonLabel,
          style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xffFFFFFF),
              fontSize: 13.0),
          textAlign: TextAlign.center,
        ),
      ),
      onTap: onTap,
    );
  }
}
