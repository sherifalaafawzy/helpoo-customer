import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import 'package:helpooappclient/Configurations/extensions/unit_converter_extension.dart';
import 'package:share_extend/share_extend.dart';

import '../../../../Configurations/Constants/assets_images.dart';
import '../../../../Models/service_request/service_request.dart';
import '../../../../Services/deep_link_service.dart';
import '../../../../Style/theme/colors.dart';
import '../../../../Style/theme/text_styles.dart';
import '../../../../Widgets/GradientButton.dart';
import '../../../../Widgets/helpoo_in_app_notifications.dart';
import '../../../../Widgets/load_svg.dart';
import '../../../../Widgets/spacing.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../pages/WenchService/wench_service_bloc.dart';
import '../bottom_sheets_wrapper.dart';
import '../vehicle_order_widget.dart';
import '../../../../Configurations/di/injection.dart';

class TripStatusBottomSheet extends StatefulWidget {
  final bool isDriverArrived;
  final bool isServiceDone;
  WenchServiceBloc? wenchServiceBloc;

  TripStatusBottomSheet(
      {super.key,
      this.isDriverArrived = false,
      this.isServiceDone = false,
      required this.wenchServiceBloc});

  @override
  State<TripStatusBottomSheet> createState() => _TripStatusBottomSheetState();
}

class _TripStatusBottomSheetState extends State<TripStatusBottomSheet> {
  WenchServiceBloc? wenchServiceBloc;

  @override
  void initState() {
    wenchServiceBloc = widget.wenchServiceBloc;
    wenchServiceBloc?.add(GetRequestByIdEvent(
        activeReqId: wenchServiceBloc?.activeReq?.id.toString()));
    wenchServiceBloc?.add(HandleRequestRoutesEvent());

    ///  wenchServiceBloc?.add(CheckIfGetTimeAndDistanceOrNotEvent());
    wenchServiceBloc?.panelController.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WenchServiceBloc, WenchServiceState>(
      listener: (context, state) async {
        if (state is GetRequestByIdSuccessState) {
          wenchServiceBloc?.add(HandleRequestRoutesEvent());
          await wenchServiceBloc?.handleRouteZoom();

          ///          wenchServiceBloc?.add(CheckIfGetTimeAndDistanceOrNotEvent());
        }
        if (state is GetConfigSuccessState) {
          wenchServiceBloc?.add(HandlingWaitingTimeEvent());
        }
      },
      builder: (context, state) {
        return BlocBuilder<WenchServiceBloc, WenchServiceState>(
          builder: (context, state) {
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20.rh),
                  child: BottomSheetsWrapper(
                    sheetBody: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(3.rSp),
                            decoration: BoxDecoration(
                              color: widget.isServiceDone
                                  ? ColorsManager.primaryGreen
                                  : ColorsManager.white,
                              borderRadius: 9.rSp.br,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 4,
                                    offset: const Offset(0, 4)),
                              ],
                            ),
                            child: Text(
                              _mapTripStateToText(),
                              style: TextStyles.bold10.copyWith(
                                color: widget.isServiceDone
                                    ? ColorsManager.white
                                    : ColorsManager.mainColor,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // width: 64.rw,
                                    // height: 27.rh,
                                    padding: EdgeInsets.all(6.rSp),
                                    decoration: BoxDecoration(
                                      color: ColorsManager.darkGreyColor,
                                      borderRadius: 9.rSp.br,
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            blurRadius: 4,
                                            offset: const Offset(0, 4)),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          LocaleKeys.fees.tr(),
                                          style: TextStyles.bold10.copyWith(
                                            color: ColorsManager.black,
                                          ),
                                        ),
                                        horizontalSpace6,
                                        Column(
                                          children: [
                                            Container(
                                              // height: 14.rh,
                                              decoration: BoxDecoration(
                                                color: ColorsManager.white,
                                                borderRadius: 9.rSp.br,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.5),
                                                      blurRadius: 4,
                                                      offset:
                                                          const Offset(0, 4)),
                                                ],
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                // vertical: 2.rh,
                                                horizontal: 5.rw,
                                              ),
                                              child: Text(
                                                ' ${wenchServiceBloc?.getRequestFees()} ',
                                                style: TextStyles.bold10
                                                    .copyWith(
                                                        color: const Color(
                                                            0xff8F8E90),
                                                        fontSize: 11),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            verticalSpace6,
                                            if (wenchServiceBloc
                                                        ?.getRequestOriginalFees() !=
                                                    null &&
                                                wenchServiceBloc
                                                        ?.getRequestOriginalFees() !=
                                                    "")
                                              Container(
                                                // height: 14.rh,
                                                decoration: BoxDecoration(
                                                  color: ColorsManager.white,
                                                  borderRadius: 9.rSp.br,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        blurRadius: 4,
                                                        offset:
                                                            const Offset(0, 4)),
                                                  ],
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  // vertical: 2.rh,
                                                  horizontal: 5.rw,
                                                ),
                                                child: Text(
                                                  ' ${wenchServiceBloc?.getRequestOriginalFees()} ',
                                                  style: TextStyles
                                                      .bold10
                                                      .copyWith(
                                                          color: const Color(
                                                                  0xff8F8E90)
                                                              .withOpacity(0.5),
                                                          fontSize: 11,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                          ],
                                        ),
                                        horizontalSpace6,
                                      ],
                                    ),
                                  ),
                                  verticalSpace6,
                                  Text(
                                    '${LocaleKeys.request.tr()} # ${wenchServiceBloc?.activeReq?.id ?? ''}',
                                    style: TextStyles.bold10
                                        .copyWith(color: ColorsManager.black),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        wenchServiceBloc
                                                ?.activeReq?.driver?.name ??
                                            '',
                                        style: TextStyles.regular12.copyWith(
                                            color: ColorsManager.black),
                                      ),
                                      verticalSpace4,
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            wenchServiceBloc?.activeReq?.driver
                                                    ?.averageRating ??
                                                '',
                                            style: TextStyles.bold12.copyWith(
                                              color: const Color(0xff8F8E90),
                                            ),
                                          ),
                                          horizontalSpace6,
                                          const LoadSvg(
                                            image: AssetsImages.star,
                                            isIcon: true,
                                            color: Color(0xffFFC200),
                                          ),
                                        ],
                                      ),
                                      verticalSpace20,
                                    ],
                                  ),
                                  horizontalSpace6,
                                  // make driver image
                                  Container(
                                    width: 40.rw,
                                    height: 40.rw,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: Image.network(wenchServiceBloc
                                                    ?.activeReq
                                                    ?.driver
                                                    ?.photo ??
                                                '')
                                            .image,
                                      ),
                                      color: ColorsManager.white,
                                      borderRadius: 9.rSp.br,
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            blurRadius: 4,
                                            offset: const Offset(0, 4)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          verticalSpace8,
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (wenchServiceBloc?.activeReq != null &&
                                  !wenchServiceBloc!.isFromTracking)
                                Visibility(
                                  visible: wenchServiceBloc!
                                          .activeReq!.confirmed ||
                                      wenchServiceBloc!.activeReq!.accepted ||
                                      wenchServiceBloc!.activeReq!.arrived,
                                  child: GradientButton(
                                    onPressed: () {
                                      wenchServiceBloc?.add(
                                          CancelServiceRequest(
                                              request: wenchServiceBloc
                                                  ?.activeReq!));
                                      //   wenchServiceBloc?.cancelServiceRequest(req: wenchServiceBloc?.activeReq!);
                                    },
                                    isWithIcon: true,
                                    title: LocaleKeys.cancel.tr(),
                                    colors: [
                                      ColorsManager.red,
                                      ColorsManager.red.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                              horizontalSpace4,
                              if (wenchServiceBloc?.activeReq != null &&
                                  !wenchServiceBloc!.isFromTracking)
                                GradientButton(
                                  onPressed: () async {
                                    //share
                                    final link = await sl<DynamicLinkService>()
                                        .createLink('tracking',
                                            queryParameters: {
                                          "trackId": wenchServiceBloc
                                              ?.activeReq!.id
                                              .toString()
                                        });
                                    if (link.isNotEmpty) {
                                      final String downloadAppLink =
                                          'https://open.helpooapp.net';
                                      final String finalTextToBeShared =
                                          LocaleKeys.downloadAppMessage.tr() +
                                              '\n' +
                                              downloadAppLink +
                                              '\n' +
                                              LocaleKeys.nextLinkMessage.tr() +
                                              '\n' +
                                              link +
                                              '\n' +
                                              LocaleKeys.endMessage.tr() +
                                              '\n';

                                      await ShareExtend.share(
                                          finalTextToBeShared, "text",
                                          sharePanelTitle: 'Helpoo',
                                          subject: finalTextToBeShared);
                                    }
                                  },
                                  isWithIcon: false,
                                  title: LocaleKeys.shareRequest.tr(),
                                  // icon: AssetsImages.call,
                                  colors: const [
                                    Color(0xff39B54A),
                                    Color(0xff00A651),
                                  ],
                                ),
                              horizontalSpace4,
                              GradientButton(
                                onPressed: () {
                                  wenchServiceBloc
                                      ?.launchDialPadWithPhoneNumber(
                                          wenchServiceBloc?.activeReq!.driver
                                                  ?.phoneNumber ??
                                              '17000');
                                },
                                isWithIcon: true,
                                title: LocaleKeys.callDriver.tr(),
                                icon: AssetsImages.call,
                                colors: const [
                                  Color(0xff39B54A),
                                  Color(0xff00A651),
                                ],
                              ),
                              verticalSpace8,
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!widget.isDriverArrived)
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.rh),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_canShowTimeAndDistance())
                            Container(
                              // width: 57.rw,
                              // height: 38.rh,
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.rh, horizontal: 12.rw),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: 9.rSp.br,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 4,
                                      offset: const Offset(0, 4)),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    LocaleKeys.time.tr(),
                                    style: TextStyles.regular11.copyWith(
                                        color: ColorsManager.white,
                                        fontSize: 8),
                                  ),
                                  Text(
                                    ((wenchServiceBloc!.activeReq?.accepted ??
                                                false) ||
                                            (wenchServiceBloc!
                                                    .activeReq?.started ??
                                                false))
                                        ? wenchServiceBloc
                                                ?.getDistanceAndDurationResponse
                                                ?.driverDistanceMatrix
                                                ?.duration
                                                ?.value
                                                ?.toTimeMin() ??
                                            wenchServiceBloc
                                                ?.activeReq
                                                ?.requestLocationModel
                                                .lastUpdatedDistanceAndDuration
                                                ?.driverDistanceMatrix
                                                ?.duration
                                                ?.value
                                                ?.toTimeMin() ??
                                            ''
                                        : wenchServiceBloc?.activeReq?.arrived ??
                                                false
                                            ? wenchServiceBloc
                                                    ?.activeReq
                                                    ?.requestLocationModel
                                                    .timeToDest
                                                    ?.toTimeMin() ??
                                                ''
                                            : wenchServiceBloc!
                                                .returnStringAsHoursOrMinutes(),
                                    // '${appBloc.myGoogleMapsHitResponse.duration}',
                                    style: TextStyles.bold10.copyWith(
                                        color: ColorsManager.white,
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          horizontalSpace6,
                          if (_canShowTimeAndDistance())
                            Container(
                              // width: 57.rw,
                              // height: 38.rh,
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.rh, horizontal: 12.rw),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: 9.rSp.br,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 4,
                                      offset: const Offset(0, 4)),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    LocaleKeys.distance.tr(),
                                    style: TextStyles.regular11.copyWith(
                                        color: ColorsManager.white,
                                        fontSize: 8),
                                  ),
                                  Text(
                                    ((wenchServiceBloc!.activeReq?.accepted ??
                                                false) ||
                                            (wenchServiceBloc!
                                                    .activeReq?.started ??
                                                false))
                                        ? wenchServiceBloc
                                                ?.getDistanceAndDurationResponse
                                                ?.driverDistanceMatrix
                                                ?.distance
                                                ?.value
                                                ?.toDistanceKM() ??
                                            wenchServiceBloc
                                                ?.activeReq
                                                ?.requestLocationModel
                                                .lastUpdatedDistanceAndDuration
                                                ?.driverDistanceMatrix
                                                ?.distance
                                                ?.value
                                                ?.toDistanceKM() ??
                                            ''
                                        : wenchServiceBloc?.activeReq?.arrived ??
                                                false
                                            ? wenchServiceBloc
                                                    ?.activeReq
                                                    ?.requestLocationModel
                                                    .distanceToDest
                                                    ?.toDistanceKM() ??
                                                ''
                                            : wenchServiceBloc!
                                                .returnStringAsKmOrMeters(),
                                    // '${appBloc.myGoogleMapsHitResponse.distance}',
                                    style: TextStyles.bold10.copyWith(
                                        color: ColorsManager.white,
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          Visibility(
                            visible: (wenchServiceBloc?.activeReq?.arrived ??
                                    false) ||
                                (wenchServiceBloc?.activeReq?.destArrived ??
                                    false),
                            child: Row(
                              children: [
                                horizontalSpace24,
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4.rh, horizontal: 12.rw),
                                  decoration: BoxDecoration(
                                    color: wenchServiceBloc!.waitingMinutes >
                                            (wenchServiceBloc!
                                                    .config?.waitingTimeFree ??
                                                0)
                                        ? ColorsManager.red
                                        : Colors.black,
                                    borderRadius: 9.rSp.br,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          blurRadius: 4,
                                          offset: const Offset(0, 4)),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        LocaleKeys.waitingTime.tr(),
                                        style: TextStyles.regular11.copyWith(
                                            color: ColorsManager.white,
                                            fontSize: 8),
                                      ),
                                      Text(
                                        '${wenchServiceBloc?.waitingMinutes} ${wenchServiceBloc!.waitingMinutes > 10 ? LocaleKeys.min.tr() : LocaleKeys.mins.tr()}',
                                        // '${appBloc.waitingMinutes}:${appBloc.waitingSeconds.toString().padLeft(2, '0')}',
                                        style: TextStyles.bold10.copyWith(
                                            color: ColorsManager.white),
                                      ),
                                    ],
                                  ),
                                ),
                                horizontalSpace2,
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4.rh, horizontal: 12.rw),
                                  decoration: BoxDecoration(
                                    color: wenchServiceBloc!.waitingMinutes >
                                            (wenchServiceBloc!
                                                    .config?.waitingTimeFree ??
                                                0)
                                        ? ColorsManager.red
                                        : Colors.black,
                                    borderRadius: 9.rSp.br,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          blurRadius: 4,
                                          offset: const Offset(0, 4)),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        LocaleKeys.waitingTimeFees.tr(),
                                        style: TextStyles.regular11.copyWith(
                                            color: ColorsManager.white,
                                            fontSize: 8),
                                      ),
                                      Text(
                                        wenchServiceBloc?.waitingFees
                                                .toString() ??
                                            '',
                                        style: TextStyles.bold10.copyWith(
                                            color: ColorsManager.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  )
              ],
            );
          },
        );
      },
    );
  }

  _mapTripStateToText() {
    if (wenchServiceBloc?.activeReq?.status == ServiceRequestStatus.accepted) {
      return LocaleKeys.driverOnWay.tr();
    } else if (wenchServiceBloc?.activeReq?.status ==
        ServiceRequestStatus.arrived) {
      return LocaleKeys.driverArrived.tr();
    } else if (wenchServiceBloc?.activeReq?.status ==
        ServiceRequestStatus.destArrived) {
      return LocaleKeys.destArrived.tr();
    } else if (wenchServiceBloc?.activeReq?.status ==
        ServiceRequestStatus.done) {
      return LocaleKeys.done.tr();
    } else if (wenchServiceBloc?.activeReq?.status ==
        ServiceRequestStatus.started) {
      return LocaleKeys.started.tr();
    } else if (wenchServiceBloc?.activeReq?.status ==
        ServiceRequestStatus.started) {
      return LocaleKeys.started.tr();
    } else {
      return LocaleKeys.somethingWentWrong.tr();
    }
  }

  _canShowTimeAndDistance() {
    if (wenchServiceBloc!.otherServiceIds.isEmpty) return true;

    return (wenchServiceBloc!.otherServiceIds.isNotEmpty &&
        (wenchServiceBloc!.activeReq?.accepted ?? false));
  }
}
