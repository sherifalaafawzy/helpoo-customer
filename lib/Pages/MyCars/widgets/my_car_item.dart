import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/Constants/page_route_name.dart';
import 'package:helpooappclient/Configurations/Constants/pages_exports.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import 'package:helpooappclient/Models/service_request/service_request.dart';
import 'package:helpooappclient/Services/navigation_service.dart';
import 'package:helpooappclient/Widgets/helpoo_in_app_notifications.dart';
import 'package:supercharged/supercharged.dart';

import '../../../Configurations/Constants/assets_images.dart';
import '../../../Configurations/Constants/constants.dart';
import '../../../Models/cars/my_cars.dart';
import '../../../Models/packages/package_model.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/load_asset_image.dart';
import '../../../Widgets/primary_button.dart';
import '../../../Widgets/spacing.dart';
import '../../../generated/locale_keys.g.dart';
import '../../Home/home_bloc.dart';
import '../../Home/widgets/text_container_item.dart';
import '../../ServiceRequest/pages/WenchService/wench_service_bloc.dart';
import '../../ServiceRequest/pages/WenchService/wench_service_request_map.dart';
import '../../ServiceRequest/pages/other_service/other_service_view.dart';

class MyCarItem extends StatefulWidget {
  final MyCarModel myCarModel;
  final bool isSelection;
  final bool activateButton;
  final bool addToPackageButton;
  final bool editButton;
  final bool isFromPayment;
  final int? selectedIndex;
  final List<ServiceRequest>? activeReq;
  final MyCarsBloc? myCarsBloc;
  final Package? selectedPackage;
  final Map<String, bool>? selectedServices;
  const MyCarItem(
      {super.key,
      this.selectedServices,
      required this.myCarModel,
      required this.activateButton,
      required this.addToPackageButton,
      required this.editButton,
      this.selectedIndex,
      this.isSelection = false,
      this.isFromPayment = false,
      required this.myCarsBloc,
      this.selectedPackage,
      required this.activeReq});

  @override
  State<MyCarItem> createState() => _MyCarItemState();
}

class _MyCarItemState extends State<MyCarItem> {
  @override
  void initState() {
    if (widget.myCarModel.plateNumber?.startsWith(RegExp(r'[0-9]')) == true ||
        widget.myCarModel.plateNumber?.startsWith("-") == true) {
      widget.myCarModel.plateNumber = widget.myCarModel.plateNumber!.reverse;
    }
    if (widget.selectedPackage != null) {
      widget.myCarsBloc?.selectedAddedPackage = widget.selectedPackage!;
      print(widget.selectedPackage?.id);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: double.infinity,
        margin: EdgeInsetsDirectional.only(bottom: 10),
        padding: EdgeInsetsDirectional.only(
          top: 10.rSp,
          bottom: 14.rSp,
          end: 10.rSp,
          start: 10.rSp,
        ),
        decoration: BoxDecoration(
          borderRadius: 20.rSp.br,
          color: ColorsManager.white,
          boxShadow: [
            BoxShadow(
              color: ColorsManager.gray90.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.myCarModel.plateNumber.toString(),
                  //LocaleKeys.registeredCarInformation.tr(),
                  style: TextStyles.bold16
                      .copyWith(color: ColorsManager.mainColor),
                ),
                horizontalSpace8,
                Text(
                  widget.myCarModel.color.toString(),
                  //LocaleKeys.registeredCarInformation.tr(),
                  style: TextStyles.bold16
                      .copyWith(color: ColorsManager.mainColor),
                ),
                const Spacer(),
                TextContainerItem(
                  text: widget.myCarModel.manufacturer?.name ?? '',
                  containerColor: ColorsManager.gray90,
                  textColor: ColorsManager.white,
                ),
                horizontalSpace8,
                TextContainerItem(
                  text: widget.myCarModel.carModel?.name ?? '',
                  containerColor: ColorsManager.gray90,
                  textColor: ColorsManager.white,
                ),
              ],
            ),
            verticalSpace2,
            Row(
              children: [
                Container(
                  //width: 40.rw,
                  height: 35.rh,
                  decoration: BoxDecoration(
                    color: ColorsManager.lightGreyColor,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.green, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: LoadAssetImage(
                      image: AssetsImages.carVector,
                      width: 30.rw,
                      height: 30.rh,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
                horizontalSpace4,
                (widget.myCarModel.carPackages!.isNotEmpty)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.myCarModel.carPackages![0].package!
                                      .corporateCompany !=
                                  null
                              ? Text(
                                  context.locale.languageCode == 'ar'
                                      ? "${LocaleKeys.thisCarAddedBy.tr()} ${tr(LocaleKeys.package.tr())}  ${widget.myCarModel.carPackages![0].package!.corporateCompany!.name}"
                                      : "${LocaleKeys.thisCarAddedBy.tr()}  ${widget.myCarModel.carPackages![0].package!.corporateCompany!.name} ${tr(LocaleKeys.package.tr())}",

                                  // LocaleKeys.thisCarAddedBy.tr() + "   " + myCarModel.carPackages![0].package!.corporateCompany!.name,
                                  style: TextStyles.bold12
                                      .copyWith(color: ColorsManager.mainColor),
                                )
                              : (widget.myCarModel.carPackages![0].package!
                                          .name !=
                                      "")
                                  ? _buildPackageAddedTo(context)
                                  : Container(),
                          if (widget.myCarModel.insuranceCompany?.arName !=
                              null)
                            Text(
                              "${LocaleKeys.carIsActivatedUntil.tr()}  ${DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.myCarModel.carPackages![0].clientPackage!.endDate ?? ""))}",
                              style: TextStyles.bold12
                                  .copyWith(color: ColorsManager.red),
                            ),
                        ],
                      )
                    : (widget.myCarModel.insuranceCompany?.arName != null &&
                            widget.myCarModel.policyEnds?.isNotEmpty == true)
                        ? Text(
                            "${LocaleKeys.carIsActivatedUntil.tr()}  ${DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.myCarModel.policyEnds!))}",
                            style: TextStyles.bold12
                                .copyWith(color: ColorsManager.red),
                          )
                        : Container(),
              ],
            ),
            verticalSpace10,
          ],
        ),
      ),
      Positioned(
        bottom: 0,
        right: isArabic ? 0 : 10,
        left: isArabic ? 10 : 0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.rh),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                visible: widget.isSelection,
                child: PrimaryButton(
                  backgroundColor: ColorsManager.mainColor,
                  textStyle: TextStyles.medium12
                      .copyWith(color: ColorsManager.whiteColor),
                  height: 28.rSp,
                  width: 110.rSp,
                  text: LocaleKeys.choose.tr(),
                  onPressed: () async {
                    final hasAnotherRequestForTheSameCar = widget.activeReq
                            ?.where((element) =>
                                element.clientCar?.id == widget.myCarModel.id)
                            .toList()
                            .isNotEmpty ==
                        true;
                    final isCarService = widget.selectedServices?['passenger'];
                    final isWenchServiceActive = widget.activeReq
                            ?.where((element) =>
                                element.clientCar?.id == widget.myCarModel.id)
                            .toList()
                            .where((element) =>
                                element.selectedTowingService?.contains(5) ==
                                    true ||
                                element.selectedTowingService?.contains(4) ==
                                    true)
                            .isNotEmpty ==
                        true;
                    final requestId = widget.activeReq
                        ?.where((element) =>
                            element.clientCar?.id == widget.myCarModel.id)
                        .toList()
                        .where((element) =>
                            element.selectedTowingService?.contains(5) ==
                                true ||
                            element.selectedTowingService?.contains(4) == true)
                        .firstOrNull
                        ?.id;
                    if (widget.selectedIndex != null) {
                      if (widget.selectedIndex == 0) {
                        if (isCarService == true &&
                            isWenchServiceActive == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) {
                                  return MultiBlocProvider(
                                    providers: [
                                      BlocProvider(
                                        create: (context) => WenchServiceBloc(),
                                      ),
                                      BlocProvider(
                                        create: (context) => HomeBloc(),
                                      ),
                                    ],
                                    child: ServiceRequestWenchMapsPage(
                                      isNewReq: true,
                                      isCarService: true,
                                      parentServiceId: requestId,
                                    ),
                                  );
                                },
                                settings: RouteSettings(
                                    arguments: widget.myCarModel)),
                          );
                          return;
                        } else if (isCarService == true &&
                            isWenchServiceActive == false) {
                          HelpooInAppNotification.showErrorMessage(
                              message: LocaleKeys.passengerErrorMessage.tr());
                          return;
                        }
                        if (hasAnotherRequestForTheSameCar) {
                          HelpooInAppNotification.showErrorMessage(
                              message: LocaleKeys.canNotMakeRequest.tr());
                        } else {
                          // check if is wench service
                          if (widget.selectedServices?['wench'] == true)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) {
                                    return MultiBlocProvider(
                                      providers: [
                                        BlocProvider(
                                          create: (context) =>
                                              WenchServiceBloc(),
                                        ),
                                        BlocProvider(
                                          create: (context) => HomeBloc(),
                                        ),
                                      ],
                                      child: ServiceRequestWenchMapsPage(
                                          isNewReq: true),
                                    );
                                  },
                                  settings: RouteSettings(
                                      arguments: widget.myCarModel)),
                            );
                          else {
                            if (widget.selectedServices == null)
                              return Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) {
                                    return MultiBlocProvider(
                                      providers: [
                                        BlocProvider(
                                          create: (context) =>
                                              WenchServiceBloc(),
                                        ),
                                        BlocProvider(
                                          create: (context) => HomeBloc(),
                                        ),
                                      ],
                                      child: OtherRequestsPage(
                                        isNewReq: true,
                                        otherServices: widget.selectedServices!,
                                      ),
                                    );
                                  },
                                  settings: RouteSettings(
                                      arguments: widget.myCarModel)),
                            );
                          }
                        }
                      } else {
                        if (widget.myCarModel.insuranceCompany == null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) {
                                  return BlocProvider(
                                    create: (context) =>
                                        ChooseInsuranceCompanyBloc(),
                                    child: const ChooseInsuranceCompany(),
                                  );
                                },
                                settings: RouteSettings(
                                  arguments: widget.myCarModel,
                                )),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) {
                                  return MultiBlocProvider(
                                    providers: [
                                      BlocProvider(
                                        create: (context) => FnolBloc(),
                                      ),
                                      BlocProvider(
                                        create: (context) => MyCarsBloc(),
                                      ),
                                    ],
                                    child: const ChooseAccidentType(),
                                  );
                                },
                                settings: RouteSettings(
                                    arguments: widget.myCarModel)),
                          );
                        }
                      }
                    }
                  },
                ),
              ),
              horizontalSpace10,
              Visibility(
                visible: widget.activateButton,
                child: PrimaryButton(
                  backgroundColor: ColorsManager.mainColor,
                  textStyle: TextStyles.medium12
                      .copyWith(color: ColorsManager.whiteColor),
                  height: 28.rSp,
                  width: 110.rSp,
                  text: LocaleKeys.activate.tr(),
                  onPressed: () {
                    widget.myCarsBloc?.selectedCar = widget.myCarModel;
                    widget.myCarsBloc?.handleAddCarIntro(
                        activateCarValue: true,
                        addCarToPackageValue: false,
                        isAddCorporateCarValue: false,
                        isAddNewCarToPackageValue: false,
                        editCarValue: false);
                    widget.myCarsBloc?.licensesBase64 = [];
                    widget.myCarsBloc?.licensesImages = [];
                    widget.myCarsBloc?.licensesPathes = [];
                    NavigationService.navigatorKey.currentContext!
                        .pushNamed(PageRouteName.addCarScreen, arguments: {
                      "myCarModel": widget.myCarModel,
                      "activateCarValue": true,
                      "addCarToPackageValue": false,
                      "isAddCorporateCarValue": false,
                      "isAddNewCarToPackageValue": false,
                      "editCarValue": false
                    });
                  },
                ),
              ),
              horizontalSpace10,
              Visibility(
                visible: widget.addToPackageButton,
                //&& appBloc.isFromPackageScreen,
                child: PrimaryButton(
                  backgroundColor: ColorsManager.mainColor,
                  textStyle: TextStyles.medium12
                      .copyWith(color: ColorsManager.whiteColor),
                  height: 28.rSp,
                  width: 110.rSp,
                  text: LocaleKeys.addToPackage.tr(),
                  onPressed: () {
                    if (widget.myCarsBloc?.myPackages.isEmpty ?? true) {
                      //     myCarsBloc?.selectedBottomNavBarIndex = 1;
                      HelpooInAppNotification.showErrorMessage(
                          message: LocaleKeys.youDoNotHavePackage.tr());
                      //  NavigationService.navigatorKey.currentContext!.pushNamedAndRemoveUntil(PageRouteName.mainScreen);
                    } else {
                      widget.myCarsBloc?.selectedCar = widget.myCarModel;
                      widget.myCarsBloc?.handleAddCarIntro(
                          activateCarValue: false,
                          addCarToPackageValue: true,
                          isAddCorporateCarValue: false,
                          isAddNewCarToPackageValue: false,
                          editCarValue: false);
                      /*   NavigationService.navigatorKey.currentContext!.pushNamed(
                          PageRouteName.addCarScreen,
                          arguments: widget.myCarModel);*/
                      NavigationService.navigatorKey.currentContext!
                          .pushNamed(PageRouteName.addCarScreen, arguments: {
                        "myCarModel": widget.myCarModel,
                        "activateCarValue": false,
                        "addCarToPackageValue": true,
                        "isAddCorporateCarValue": false,
                        "isAddNewCarToPackageValue": false,
                        "editCarValue": false,
                        "selectedAddedPackage": widget.selectedPackage,
                        "isFromPayment": widget.isFromPayment,
                      });
                      // navigatorKey.currentContext!.pushNamed(Routes.addCarScreen);
                    }
                  },
                ),
              ),
              horizontalSpace10,
              Visibility(
                visible: widget.editButton &&
                    widget.myCarModel.insuranceCompany?.arName == null,
                child: PrimaryButton(
                  backgroundColor: ColorsManager.mainColor,
                  textStyle: TextStyles.medium12
                      .copyWith(color: ColorsManager.whiteColor),
                  height: 28.rSp,
                  width: 110.rSp,
                  text: LocaleKeys.edit.tr(),
                  onPressed: () {
                    widget.myCarsBloc?.selectedCar = widget.myCarModel;

                    widget.myCarsBloc?.handleAddCarIntro(
                        activateCarValue: false,
                        addCarToPackageValue: false,
                        isAddCorporateCarValue: false,
                        isAddNewCarToPackageValue: false,
                        editCarValue: true);
                    NavigationService.navigatorKey.currentContext!
                        .pushNamed(PageRouteName.addCarScreen, arguments: {
                      "myCarModel": widget.myCarModel,
                      "activateCarValue": false,
                      "addCarToPackageValue": false,
                      "isAddCorporateCarValue": false,
                      "isAddNewCarToPackageValue": false,
                      "editCarValue": true
                    });
                    /* NavigationService.navigatorKey.currentContext!.pushNamed(
                        PageRouteName.addCarScreen,
                        arguments: widget.myCarModel);*/
                  },
                ),
              ),
            ],
          ),
        ),
      )
    ]);
  }

  Widget _buildPackageAddedTo(BuildContext context) {
    final text = Text(
      context.locale.languageCode == 'ar'
          ? "${LocaleKeys.thisCarAddedBy.tr()} ${tr(LocaleKeys.package.tr())} ${widget.myCarModel.carPackages![0].package!.name}"
          : "${LocaleKeys.thisCarAddedBy.tr()}  ${widget.myCarModel.carPackages![0].package!.name} ${tr(LocaleKeys.package.tr())}",
      style: TextStyles.bold12.copyWith(color: ColorsManager.mainColor),
    );
    final myCarModel = widget.myCarModel;
    final myCarPackage = myCarModel.carPackages?[0];
    if (myCarPackage == null) return text;
    final createdDate = DateTime.parse(myCarPackage.createdAt!);
    final activatedDate = createdDate.add(Duration(days: 5));
    final now = DateTime.now();
    final children = [
      Text(
        "subscription_activates_in".tr(),
        style: TextStyles.bold12,
      ),
      horizontalSpace8,
      _buildCountDownTimer(activatedDate),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text,
        verticalSpace4,
        if (widget.myCarModel.insuranceCompany == null)
          if (now.isAfter(activatedDate))
            Text(
              "subscription_activated".tr(),
              style:
                  TextStyles.bold12.copyWith(color: ColorsManager.primaryGreen),
            )
          else
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
      ],
    );
  }

  Widget _buildCountDownTimer(DateTime activatedDate) =>
      CountDownTimer(activatedDate: activatedDate);
}

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({
    required this.activatedDate,
    super.key,
  });
  final DateTime? activatedDate;
  @override
  State<CountDownTimer> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  late final Timer? _timer;
  late String days;
  late String hours;
  late String minutes;
  late String seconds;
  @override
  initState() {
    _initTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted)
        setState(() {
          _initTimer();
        });
    });
    super.initState();
  }

  void _initTimer() {
    final now = DateTime.now();
    final difference = widget.activatedDate!.difference(now);
    days = difference.inDays.toString().padLeft(2, '0');
    hours = difference.inHours.remainder(24).toString().padLeft(2, '0');
    minutes = difference.inMinutes.remainder(60).toString().padLeft(2, '0');
    seconds = difference.inSeconds.remainder(60).toString().padLeft(2, '0');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildCountDownContainer(days, "days".tr()),
        horizontalSpace4,
        _buildCountDownContainer(hours, "hours".tr()),
        horizontalSpace4,
        _buildCountDownContainer(minutes, "minutes".tr()),
        horizontalSpace4,
        _buildCountDownContainer(seconds, "seconds".tr()),
      ],
    );
  }

  Widget _buildCountDownContainer(String value, String text) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF700000),
                Color(0xFF8B0404),
                Color(0xFFB50A0A),
                Color(0xFFD20E0E),
                Color(0xFFE51111),
                Color(0xFFEB1212),
              ],
            ),
          ),
          child: Text(
            value.toString(),
            style: TextStyles.bold12.copyWith(color: ColorsManager.white),
          ),
        ),
        Text(
          text,
          style: TextStyles.medium10,
        ),
      ],
    );
  }
}
