import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import 'package:helpooappclient/Configurations/extensions/unit_converter_extension.dart';
import 'package:helpooappclient/Pages/ServiceRequest/pages/WenchService/wench_service_bloc.dart';
import 'package:helpooappclient/Pages/vid_streaming/cam_stream_screen.dart';
import 'package:helpooappclient/Widgets/primary_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Configurations/Constants/assets_images.dart';
import '../../../Configurations/Constants/constants.dart';
import '../../../Models/service_request/my_google_maps_hit_response.dart';
import '../../../Models/service_request/service_request.dart';
import '../../../Style/theme/colors.dart';
import '../../../Style/theme/text_styles.dart';
import '../../../Widgets/load_asset_image.dart';
import '../../../Widgets/online_image_viewer.dart';
import '../../../Widgets/spacing.dart';
import '../../../Widgets/started_stepper_other_service.dart';
import '../../../generated/locale_keys.g.dart';

import 'dart:math' as math;

import '../../ServiceRequest/pages/WenchService/wench_service_request_map.dart';
import '../../ServiceRequest/pages/other_service/other_service_view.dart';
import '../home_bloc.dart';
import 'gradient_stepper.dart';

class HomeServiceRequestItem extends StatefulWidget {
  final ServiceRequest serviceRequest;
  final MyGoogleMapsHitResponse myGoogleMapsHitResponse;
  final HomeBloc? homeBloc;
  final int? index;
  final bool? stepperOpenSpeed;

  const HomeServiceRequestItem(
      {Key? key,
      required this.serviceRequest,
      required this.myGoogleMapsHitResponse,
      required this.homeBloc,
      required this.index,
      required this.stepperOpenSpeed})
      : super(key: key);

  @override
  State<HomeServiceRequestItem> createState() => _HomeServiceRequestItemState();
}

class _HomeServiceRequestItemState extends State<HomeServiceRequestItem> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.homeBloc?.timerHomeUiUpdates?.cancel();
    widget.homeBloc?.timerHomeServiceRequestItemUpdates?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        /*  appBloc.isMapScreenRoute = true;
        appBloc.isHomeScreenRoute = false;
        appBloc.activeReq = widget.serviceRequest;
        appBloc.request = widget.serviceRequest;
        appBloc.handleMapReqUiUpdates(isCurrentReq: true);
        context.pushTo(ServiceRequestMapsPage(isCurrentReq: true));
      */

        widget.homeBloc?.timerHomeUiUpdates?.cancel();
        widget.homeBloc?.timerHomeServiceRequestItemUpdates?.cancel();

        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => WenchServiceBloc(),
                        ),
                        BlocProvider(
                          create: (context) => HomeBloc(),
                        ),
                      ],
                      child: [4, 5, 6].contains(widget.serviceRequest
                                  .selectedTowingService?.firstOrNull) ==
                              true
                          ? ServiceRequestWenchMapsPage(
                              isCurrentReq: true,
                              serviceRequest: widget.serviceRequest,
                              isCarService: widget.serviceRequest
                                      .selectedTowingService?.firstOrNull ==
                                  6,
                            )
                          : OtherRequestsPage(
                              otherServices: {
                                "fuel": widget
                                        .serviceRequest.selectedTowingService
                                        ?.contains(1) ==
                                    true,
                                "tire": widget
                                        .serviceRequest.selectedTowingService
                                        ?.contains(2) ==
                                    true,
                                "battery": widget
                                        .serviceRequest.selectedTowingService
                                        ?.contains(3) ==
                                    true,
                              },
                              isCurrentReq: true,
                              serviceRequest: widget.serviceRequest,
                            )),
              settings: RouteSettings(arguments: widget.serviceRequest)),
        );
      },
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is GetRequestByIdSuccessHomeState) {
            ///  widget.homeBloc?.add(CheckIfGetTimeAndDistanceOrNotHomeEvent());
          }
          // TODO: implement listener
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final isOtherService = [4, 5, 6].contains(
                    widget.serviceRequest.selectedTowingService?.firstOrNull) ==
                false;
            final isCarService =
                widget.serviceRequest.selectedTowingService?.firstOrNull == 6;
            final DateTime? startTime = widget.serviceRequest.startServiceTime;
            final isStarted =
                widget.serviceRequest.status == ServiceRequestStatus.started;
            final isDone =
                widget.serviceRequest.status == ServiceRequestStatus.done;
            if (isOtherService && (isStarted || isDone)) {
              return StartedSheetOtherService(
                startTime: startTime ?? DateTime.now(),
                allowanceTime: widget.serviceRequest.waitingTimeAllowed!,
                isDone: isDone,
              );
            }

            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(5.rSp),
              decoration: BoxDecoration(
                borderRadius: 20.rSp.br,
                color: ColorsManager.lightGreyColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  verticalSpace10,
                  Text(
                    _mapTripStateToText(widget.serviceRequest.status),
                    style: TextStyles.bold16,
                  ),
                  BlocProvider.value(
                    value: widget.homeBloc!,
                    child: GradientStepper(
                      serviceRequest: widget.serviceRequest,
                      homeBloc: widget.homeBloc!,
                      stepperOpenSpeed: widget.stepperOpenSpeed,
                      //increaseByAnimation: ,
                      percentage:
                          widget.serviceRequest.currentGradientPercentage,
                      width: 320.rw,
                      widgetWenchOrPin: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(isArabic ? 0 : math.pi),
                        child: widget.serviceRequest.started ||
                                widget.serviceRequest.destArrived ||
                                widget.serviceRequest.arrived ||
                                widget.serviceRequest.done
                            ? LoadAssetImage(
                                image: AssetsImages.pin,
                                width: 20.rw,
                                height: 45.rh,
                                fit: BoxFit.contain,
                              )
                            : LoadAssetImage(
                                image: AssetsImages.clientCarStepper2,
                                width: 45.rw,
                                height: 45.rh,
                                fit: BoxFit.contain,
                              ),
                      ),
                      widgetSecondWenchOrPin: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(isArabic ? 0 : math.pi),
                        child: LoadAssetImage(
                          image: isOtherService || isCarService
                              ? AssetsImages.n300Stepper
                              : widget.serviceRequest.opened ||
                                      widget.serviceRequest.confirmed ||
                                      widget.serviceRequest.accepted ||
                                      widget.serviceRequest.arrived
                                  ? AssetsImages.wenchStepper
                                  : AssetsImages.wenchWithCarStepper,
                          width: isOtherService ? null : 40.rw,
                          height: isOtherService ? null : 28.rh,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  verticalSpace10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.homeBloc!.activeReq!.isNotEmpty &&
                          !((widget.homeBloc!.activeReq![widget.index!]
                                      .confirmed ||
                                  widget.homeBloc!.activeReq![widget.index!]
                                      .done) &&
                              isOtherService)) ...[
                       widget.serviceRequest.status.enName.toLowerCase() == "confirmed" ? Container():
                       _infoContainerText(
                          title: LocaleKeys.distance.tr(),
                          content: widget.serviceRequest.accepted ||
                                  widget.serviceRequest.started
                              ? widget.homeBloc?.activeReq![widget.index!]
                                      .actualDistance
                                      .toDistanceKM() ??
                                  ''
                              : widget.homeBloc?.activeReq![widget.index!]
                                      .requestLocationModel.distanceToDest
                                      ?.toDistanceKM() ??
                                  widget.myGoogleMapsHitResponse.distance,
                        ),
                       widget.serviceRequest.status.enName.toLowerCase() == "confirmed" ? Container():
                        _infoContainerText(
                          title: LocaleKeys.time.tr(),
                          content: widget.serviceRequest.accepted ||
                                  widget.serviceRequest.started
                              ? widget.homeBloc?.activeReq![widget.index!]
                                      .actualDuration
                                      .toTimeMin() ??
                                  ''
                              : widget.homeBloc?.activeReq![widget.index!]
                                      ?.requestLocationModel.timeToDest
                                      ?.ceil()
                                      .toTimeMin() ??
                                  widget.myGoogleMapsHitResponse.duration,
                        ),
                      ],
                      // ...List.generate(
                      //   2,
                      //   (index) => _infoContainerItem(
                      //     index: index,
                      //     content: index == 0
                      //         ? widget.serviceRequest.accepted ||
                      //                 widget.serviceRequest.started
                      //             ? widget.homeBloc?.activeReq![widget.index!]
                      //                     .actualDistance
                      //                     .toDistanceKM() ??
                      //                 ''
                      //             : widget.homeBloc?.activeReq![widget.index!]
                      //                     .requestLocationModel.distanceToDest
                      //                     ?.toDistanceKM() ??
                      //                 widget.myGoogleMapsHitResponse.distance
                      //         : widget.serviceRequest.accepted ||
                      //                 widget.serviceRequest.started
                      //             ? widget.homeBloc?.activeReq![widget.index!]
                      //                     .actualDuration
                      //                     .toTimeMin() ??
                      //                 ''
                      //             : widget.homeBloc?.activeReq![widget.index!]
                      //                     ?.requestLocationModel.timeToDest
                      //                     ?.ceil()
                      //                     .toTimeMin() ??
                      //                 widget.myGoogleMapsHitResponse.duration,
                      //     // driverImage: widget.serviceRequest.driver?.photo,
                      //     // isDriver: index == 0,
                      //     // driverName: widget.serviceRequest.driver?.name,
                      //     // driverPhone:
                      //     //     widget.serviceRequest.driver?.phoneNumber,
                      //   ),
                      // )
                    ],
                  ),
                  verticalSpace10,
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child:widget.serviceRequest.status.enName.toLowerCase() == "confirmed" ? Container():  Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 10.rSp,
                              horizontal: 5.rSp,
                            ),
                            decoration: BoxDecoration(
                              color: ColorsManager.mainColor,
                              borderRadius: 15.rSp.br,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: ColorsManager.white,
                                  size: 20.rSp,
                                ),
                                horizontalSpace4,
                                Text(
                                  LocaleKeys.watchMap.tr(),
                                  style: TextStyles.bold10.copyWith(
                                    color: ColorsManager.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        horizontalSpace8,
                          Expanded(
                          child:
                           widget.serviceRequest.status.enName.toLowerCase() == "confirmed" ? Container(): 
                          GestureDetector(
                            onTap: () {
                              launchDialPadWithPhoneNumber(
                                  widget.serviceRequest.driver?.phoneNumber ??
                                      '17000');
                            },
                            behavior: HitTestBehavior.translucent,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 10.rSp,
                                horizontal: 5.rSp,
                              ),
                              decoration: BoxDecoration(
                                color: ColorsManager.mainColor,
                                borderRadius: 15.rSp.br,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.phone,
                                    color: ColorsManager.white,
                                    size: 20.rSp,
                                  ),
                                  horizontalSpace6,
                                  Text(
                                    LocaleKeys.callDriver.tr(),
                                    style: TextStyles.bold10.copyWith(
                                      color: ColorsManager.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (widget.serviceRequest.camUrl != null && widget.serviceRequest.camUrl!.isNotEmpty
                            && (widget.serviceRequest.status == ServiceRequestStatus.arrived
                                || widget.serviceRequest.status == ServiceRequestStatus.started
                                || widget.serviceRequest.status == ServiceRequestStatus.destArrived)) ...[
                          horizontalSpace8,
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                context.pushTo(CamStreamScreen(
                                    videoUrl:
                                        widget.serviceRequest?.camUrl ?? ''));
                              },
                              behavior: HitTestBehavior.translucent,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.rSp,
                                  horizontal: 5.rSp,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorsManager.mainColor,
                                  borderRadius: 15.rSp.br,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.video_call_rounded,
                                      color: ColorsManager.white,
                                      size: 20.rSp,
                                    ),
                                    horizontalSpace6,
                                    Text(
                                      LocaleKeys.liveCam.tr(),
                                      style: TextStyles.bold10.copyWith(
                                        color: ColorsManager.white,
                                      ),
                                    ),
                                    horizontalSpace6,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
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

  _mapTripStateToText(ServiceRequestStatus status) {
    if (status == ServiceRequestStatus.accepted) {
      return LocaleKeys.driverOnWay.tr();
    } else if (status == ServiceRequestStatus.confirmed) {
      return LocaleKeys.waitingDriverAccept.tr();
    } else if (status == ServiceRequestStatus.arrived) {
      return LocaleKeys.driverArrived.tr();
    } else if (status == ServiceRequestStatus.destArrived) {
      return LocaleKeys.destArrived.tr();
    } else if (status == ServiceRequestStatus.done) {
      return LocaleKeys.done.tr();
    } else if (status == ServiceRequestStatus.started) {
      return LocaleKeys.started.tr();
    } else {
      return ''; //LocaleKeys.somethingWentWrong.tr();
    }
  }

  Expanded _infoContainerItem({
    required int index,
    required String content,
    bool isDriver = false,
    String? driverName,
    String? driverPhone,
    String? driverImage,
  }) {
    List<String> titles = [
      // LocaleKeys.driverInfo.tr(),
      LocaleKeys.distance.tr(),
      LocaleKeys.time.tr(),
    ];

    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            titles[index],
            style: TextStyles.medium14.copyWith(
              color: ColorsManager.mainColor,
            ),
          ),
          horizontalSpace8,
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.rSp,
              vertical: 5.rSp,
            ),
            decoration: BoxDecoration(
              color: ColorsManager.white,
              borderRadius: 8.rSp.br,
            ),
            child: Text(
              content,
              style: TextStyles.medium12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoContainerText({required String title, required String content}) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyles.medium14.copyWith(
              color: ColorsManager.mainColor,
            ),
          ),
          horizontalSpace8,
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.rSp,
              vertical: 5.rSp,
            ),
            decoration: BoxDecoration(
              color: ColorsManager.white,
              borderRadius: 8.rSp.br,
            ),
            child: Text(
              content,
              style: TextStyles.medium12,
            ),
          ),
        ],
      ),
    );
  }

  void launchDialPadWithPhoneNumber(String? phoneNumber) async {
    Uri phoneno = Uri.parse('tel:$phoneNumber');
    await launchUrl(phoneno);
  }
}
