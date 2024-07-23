import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Configurations/extensions/ui_extention.dart';
import 'package:helpooappclient/Configurations/extensions/unit_converter_extension.dart';

import '../../../../Configurations/Constants/assets_images.dart';
import '../../../../Style/theme/colors.dart';
import '../../../../Style/theme/text_styles.dart';
import '../../../../Widgets/GradientButton.dart';
import '../../../../Widgets/helpoo_in_app_notifications.dart';
import '../../../../Widgets/primary_button.dart';
import '../../../../Widgets/spacing.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../Home/home_bloc.dart';
import '../../pages/WenchService/wench_service_bloc.dart';
import '../../service_request_bloc.dart';
import '../bottom_sheets_wrapper.dart';
import '../vehicle_order_widget.dart';

class DriverWaitingBottomSheet extends StatefulWidget {
  DriverWaitingBottomSheet({Key? key, required this.wenchServiceBloc})
      : super(key: key);
  WenchServiceBloc? wenchServiceBloc;

  @override
  State<DriverWaitingBottomSheet> createState() =>
      _DriverWaitingBottomSheetState();
}

class _DriverWaitingBottomSheetState extends State<DriverWaitingBottomSheet> {
  WenchServiceBloc? wenchServiceBloc;

//  HomeBloc? homeBloc;

  @override
  void initState() {
    super.initState();
    wenchServiceBloc = widget.wenchServiceBloc;
    // wenchServiceBloc = context.read<WenchServiceBloc>();
    wenchServiceBloc?.add(GetRequestByIdEvent(
        activeReqId: wenchServiceBloc?.activeReq?.id.toString()));
    if (wenchServiceBloc?.timerMapUiUpdates == null) {
      wenchServiceBloc
          ?.handleMapReqUiUpdates(isCurrentReq: true)
          .then((value) {});
    }
    wenchServiceBloc?.panelController.open();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WenchServiceBloc, WenchServiceState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50.rh),
              child: BottomSheetsWrapper(
                sheetBody: Column(
                  children: [
                    /* verticalSpace70,
                    VehicleOrderWidget(
                      image: AssetsImages.passengersCar,
                      title: LocaleKeys.wantPassengerCar.tr(),
                      onPressed: () {
                        HelpooInAppNotification.showMessage(
                          message: LocaleKeys.comingSoon.tr(),
                        );
                      },
                    ),*/
                    verticalSpace70,
                    if (!wenchServiceBloc!.isFromTracking)
                      Align(
                        alignment: Alignment.center,
                        child: PrimaryButton(
                          text: LocaleKeys.cancel.tr(),
                          isLoading: state is CancelRequestLoadingState,
                          isDisabled: state is CancelRequestLoadingState,
                          backgroundColor: Colors.red,
                          onPressed: () {
                            wenchServiceBloc?.add(CancelServiceRequest(
                                request: wenchServiceBloc!.activeReq!));
                          },
                        ),
                      ),
                    /* Visibility(
                      visible: wenchServiceBloc!.activeReq!.confirmed ||
                          wenchServiceBloc!.activeReq!.accepted ||
                          wenchServiceBloc!.activeReq!.arrived,
                      child: GradientButton(
                        title: LocaleKeys.cancel.tr(),
                        onPressed: () {
                          wenchServiceBloc?.add(CancelServiceRequest(
                              request: wenchServiceBloc!.activeReq!));
                          //cancelServiceRequest(req: serviceRequestBloc!.activeReq!);
                        },
                      ),
                    ),*/
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          if (_canShowDistanceAndDuration())
                          Container(
                              // width: 57.rw,
                              // height: 38.rh,
                              padding: EdgeInsets.symmetric(
                                  vertical: 6.rh, horizontal: 5.rw),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: 9.rSp.br,
                                /*  boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 4,
                                    offset: const Offset(0, 4)),
                              ],*/
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    LocaleKeys.time.tr(),
                                    style: TextStyles.regular11.copyWith(
                                        color: ColorsManager.white,
                                        fontSize: 10),
                                  ),
                                  Text( widget.wenchServiceBloc!.activeReq!.status.enName.toLowerCase() == "confirmed"  ? "- - - -": 
                                    // appBloc.activeReqModel == null || (appBloc.activeReqModel != null && appBloc.activeReqModel!.firstClientDestination == null)
                                    //     ? '${appBloc.request.driverDirectionDetails?.durationText ?? appBloc.myGoogleMapsHitResponse.duration}'
                                    //     : appBloc.returnStringAsHoursOrMinutes(),
                                    wenchServiceBloc
                                                ?.activeReq
                                                ?.requestLocationModel
                                                .lastUpdatedDistanceAndDuration
                                                ?.driverDistanceMatrix
                                                ?.duration
                                                ?.text
                                                ?.isNotEmpty ??
                                            false
                                        ? wenchServiceBloc!
                                            .activeReq!
                                            .requestLocationModel
                                            .lastUpdatedDistanceAndDuration!
                                            .driverDistanceMatrix!
                                            .duration!
                                            .text!
                                        : wenchServiceBloc?.localDuration
                                                .toTimeMin() ??
                                            '',
                                    // '${appBloc.request.driverDirectionDetails?.durationText ?? appBloc.myGoogleMapsHitResponse.duration}',

                                    style: TextStyles.bold10.copyWith(
                                        color: ColorsManager.white,
                                        fontSize: 14),
                                    textDirection: TextDirection.ltr,
                                  ),
                                ],
                              ),
                            )
                          else
                            SizedBox(height: 45.rh),
                          horizontalSpace3,
                          if (_canShowDistanceAndDuration())
                      Container(
                              // width: 57.rw,
                              // height: 38.rh,
                              padding: EdgeInsets.symmetric(
                                  vertical: 6.rh, horizontal: 5.rw),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: 9.rSp.br,
                                /*  boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 4,
                            offset: const Offset(0, 4)),
                      ],*/
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    LocaleKeys.distance.tr(),
                                    style: TextStyles.regular11.copyWith(
                                        color: ColorsManager.white,
                                        fontSize: 10),
                                  ),
                                  Text( widget.wenchServiceBloc!.activeReq!.status.enName.toLowerCase() == "confirmed"  ? " - - - -": 
                                    // appBloc.activeReqModel == null || (appBloc.activeReqModel != null && appBloc.activeReqModel!.firstClientDestination == null)
                                    //     ? '${appBloc.activeReq!.requestLocationModel.distanceToDest?.toDistanceKM()}'
                                    //     : appBloc.returnStringAsKmOrMeters(),
                                    wenchServiceBloc
                                                ?.activeReq
                                                ?.requestLocationModel
                                                .lastUpdatedDistanceAndDuration
                                                ?.driverDistanceMatrix
                                                ?.distance
                                                ?.text
                                                ?.isNotEmpty ??
                                            false
                                        ? wenchServiceBloc!
                                            .activeReq!
                                            .requestLocationModel
                                            .lastUpdatedDistanceAndDuration!
                                            .driverDistanceMatrix!
                                            .distance!
                                            .text!
                                        : wenchServiceBloc?.localDistance
                                                .toDistanceKM() ??
                                            '',
                                    style: TextStyles.bold10.copyWith(
                                        color: ColorsManager.white,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                      verticalSpace6,
                      Container(
                        width: 170.rw,
                        // height: 27.rh,
                        padding: EdgeInsets.all(6.rSp),
                        decoration: BoxDecoration(
                          color: ColorsManager.darkGreyColor,
                          borderRadius: 9.rSp.br,
                          /* boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 4,
                                    offset: const Offset(0, 4)),
                              ],*/
                        ),
                        child: Row(
                          children: [
                            Text(
                              LocaleKeys.fees.tr(),
                              style: TextStyles.bold10.copyWith(
                                  color: ColorsManager.black, fontSize: 15),
                            ),
                            horizontalSpace6,
                            if (wenchServiceBloc?.getRequestOriginalFees() != null && wenchServiceBloc?.getRequestOriginalFees() != "")
                              Container(
                                // height: 14.rh,
                                decoration: BoxDecoration(
                                  color: ColorsManager.white,
                                  borderRadius: 9.rSp.br,
                                  /*  boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            blurRadius: 4,
                                            offset: const Offset(0, 4)),
                                      ],*/
                                ),
                                padding: EdgeInsets.symmetric(
                                  // vertical: 2.rh,
                                  horizontal: 5.rw,
                                ),
                                child: Text(
                                  ' ${wenchServiceBloc?.activeReq?.corporateCompanyId == null ? wenchServiceBloc?.getRequestOriginalFees():"***"} ',
                                  style: TextStyles.bold10.copyWith(
                                      color: const Color(0xff8F8E90)
                                          .withOpacity(0.5),
                                      fontSize: 11,
                                      decoration: TextDecoration.lineThrough),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            horizontalSpace6,
                            Container(
                              // height: 14.rh,
                              decoration: BoxDecoration(
                                color: ColorsManager.white,
                                borderRadius: 9.rSp.br,
                                /*  boxShadow: [
                                      BoxShadow(
                                          color:
                                              Colors.black.withOpacity(0.5),
                                          blurRadius: 4,
                                          offset: const Offset(0, 4)),
                                    ],*/
                              ),
                              padding: EdgeInsets.symmetric(
                                // vertical: 2.rh,
                                horizontal: 5.rw,
                              ),
                              child: Text(
                                ' ${wenchServiceBloc?.activeReq?.corporateCompanyId == null ? wenchServiceBloc?.getRequestFees():"***"} ',
                                style: TextStyles.bold10.copyWith(
                                    color: const Color(0xff8F8E90),
                                    fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  horizontalSpace6,
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.rw,
                        ),
                        decoration: BoxDecoration(
                          color: ColorsManager.white,
                          borderRadius: 9.rSp.br,
                          /* boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 4,
                                    offset: const Offset(0, 4)),
                              ],*/
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            LocaleKeys.waitingDriverAccept.tr(),
                            style: TextStyles.bold10.copyWith(
                              color: ColorsManager.red,
                            ),
                          ),
                        ),
                      ),
                      verticalSpace6,
                      Text(
                        '${LocaleKeys.request.tr()} # ${wenchServiceBloc?.activeReq?.id ?? ''}',
                        // '# رقم الطلب : ${appBloc.activeReq!.id}',
                        style: TextStyles.bold10
                            .copyWith(color: ColorsManager.black),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    // dispose the timer in the service req map page not here
  }

  _canShowDistanceAndDuration() {
    return (wenchServiceBloc!.otherServiceIds.isEmpty);
  }
}
