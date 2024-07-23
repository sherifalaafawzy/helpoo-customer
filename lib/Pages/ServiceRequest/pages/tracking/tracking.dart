import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Pages/ServiceRequest/pages/WenchService/wench_service_bloc.dart';
import 'package:map_picker/map_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../Configurations/Constants/assets_images.dart';
import '../../../../Models/service_request/service_request.dart';
import '../../../../Services/navigation_service.dart';
import '../../../../Style/theme/colors.dart';
import '../../../../Widgets/helpoo_in_app_notifications.dart';
import '../../../../Widgets/load_asset_image.dart';
import '../../../../Widgets/scaffold_bk.dart';
import '../../../../Widgets/spacing.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../widgets/bottom_sheets/choose_wench_bottom_sheet.dart';
import '../../widgets/bottom_sheets/driver_waiting_bottom_sheet.dart';
import '../../widgets/bottom_sheets/history_request_details_sheet.dart';
import '../../widgets/bottom_sheets/passengers_car_bottom_sheet.dart';
import '../../widgets/bottom_sheets/payment_methods_bottom_sheet.dart';
import '../../widgets/bottom_sheets/request_pending_bottom_sheet.dart';
import '../../widgets/bottom_sheets/trip_info_bottom_sheet.dart';
import '../../widgets/bottom_sheets/trip_pricing_bottom_sheet.dart';
import '../../widgets/bottom_sheets/trip_status_bottom_sheet.dart';
import '../../widgets/current_loc_search.dart';
import '../../widgets/dest_loc_search.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage(this.id, {super.key});

  final String id;

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  WenchServiceBloc? wenchServiceBloc;

  @override
  void initState() {
    wenchServiceBloc = context.read<WenchServiceBloc>();
    wenchServiceBloc?.add(InitTrackingEvent(requestId: widget.id));
    //  wenchServiceBloc?.add(GetRequestByIdEvent(activeReqId: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackground(
        horizontalPadding: 0,
        alignment: AlignmentDirectional.topStart,
        extendBodyBehindAppBar: false,
        appBarTitle: LocaleKeys.roadServices.tr(),
        body: BlocConsumer<WenchServiceBloc, WenchServiceState>(
          listener: (context, state) async {
            if (state is UserRequestProcessChangedState ||
                state is CameraIdleDone) {
              setState(() {});

              ///  await wenchServiceBloc?.handleRouteZoom();
            }
            if (state is GetRequestByIdSuccessState) {
              wenchServiceBloc?.add(HandleServiceRequestSheetEvent());
              if (wenchServiceBloc?.activeReq?.arrived ?? false) {
                await wenchServiceBloc?.handleRequestRoutes(
                  from: LatLng(wenchServiceBloc!.activeReq!.driver!.lat!,
                      wenchServiceBloc!.activeReq!.driver!.lng!),
                  to: wenchServiceBloc!
                      .activeReq!.requestLocationModel.clientPoint!,
                );
              } else {
                wenchServiceBloc?.add(HandleRequestRoutesEvent());
              }
            }
            if (state is GetRequestTimeAndDistanceByIdErrorState) {
              HelpooInAppNotification.showErrorMessage(message: state.error);
            }
          },
          builder: (context, state) {
            return wenchServiceBloc!.isTrackingLoading
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: ColorsManager.mainColor,
                    ),
                  )
                : Stack(
                    children: [
                      MapPicker(
                        mapPickerController:
                            wenchServiceBloc!.mapPickerController,
                        showDot: true,
                        iconWidget: wenchServiceBloc?.userRequestProcess ==
                                UserRequestProcesses.none
                            ? LoadAssetImage(
                                image: AssetsImages.pin,
                                height: 25,
                                color: ColorsManager.mainColor,
                              )
                            : Container(),
                        child: GoogleMap(
                          mapType: MapType.normal,
                          myLocationEnabled: false,
                          zoomControlsEnabled: false,
                          myLocationButtonEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target: wenchServiceBloc?.cameraPosition?.target ??
                                LatLng(30.0595581, 31.223445),
                            zoom: 13.5,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            print('Map Created');
                            if (wenchServiceBloc!
                                .mapControllerCompleter.isCompleted) {
                              wenchServiceBloc!.mapControllerCompleter
                                  .complete(controller);
                            }
                            wenchServiceBloc?.setMapController(
                                controller: controller);
                          },
                          onCameraMoveStarted: () async {
                            wenchServiceBloc?.onCameraMoveStarted();
                          },
                          onCameraMove: (cameraPosition) async {
                            wenchServiceBloc?.isCameraIdle = false;
                            wenchServiceBloc?.cameraMovementPosition =
                                cameraPosition.target;
                            wenchServiceBloc?.onCameraMove(
                                cameraPositionValue: cameraPosition);
                          },
                          onCameraIdle: () {
                            /// print('camera idle ${state}');
                            if (wenchServiceBloc!.userRequestProcess ==
                                UserRequestProcesses.none) {
                              wenchServiceBloc
                                  ?.add(GetPlaceDetailsByCoordinatesEvent(
                                longitude: wenchServiceBloc
                                    ?.cameraMovementPosition?.longitude,
                                latitude: wenchServiceBloc
                                    ?.cameraMovementPosition?.latitude,
                                isMyLocation: false,
                              ));
                            }
                            if (wenchServiceBloc!.userRequestProcess !=
                                UserRequestProcesses.rating) {
                              FocusScope.of(NavigationService
                                      .navigatorKey.currentContext!)
                                  .requestFocus(FocusNode());
                            }
                            Future.delayed(
                              Duration(seconds: 10),
                              () {
                                if (wenchServiceBloc?.userRequestProcess !=
                                    UserRequestProcesses.none) {
                                  //  wenchServiceBloc?.onCameraIdle();
                                  if (wenchServiceBloc
                                              ?.activeReq
                                              ?.requestLocationModel
                                              .clientPoint !=
                                          null &&
                                      wenchServiceBloc
                                              ?.activeReq
                                              ?.requestLocationModel
                                              .destPoint !=
                                          null) {
                                    if (wenchServiceBloc?.activeReq?.accepted !=
                                            null &&
                                        wenchServiceBloc
                                                ?.activeReq
                                                ?.requestLocationModel
                                                .lastUpdatedDistanceAndDuration
                                                ?.points !=
                                            null) {
                                      if (wenchServiceBloc!
                                              .activeReq!.accepted ||
                                          wenchServiceBloc!
                                              .activeReq!.started) {
                                        wenchServiceBloc?.handleRouteZoom(
                                            mapPointsToShowPoints: wenchServiceBloc!
                                                .activeReq!
                                                .requestLocationModel
                                                .lastUpdatedDistanceAndDuration!
                                                .points!);
                                      } else {
                                        wenchServiceBloc
                                            ?.animateCameraToShowAnyMapPath(
                                          from: wenchServiceBloc!
                                              .activeReq!
                                              .requestLocationModel
                                              .clientPoint!,
                                          to: wenchServiceBloc!.activeReq!
                                              .requestLocationModel.destPoint!,
                                        );
                                      }
                                    }
                                  } else if (wenchServiceBloc
                                              ?.request
                                              ?.requestLocationModel
                                              .clientPoint !=
                                          null &&
                                      wenchServiceBloc
                                              ?.request
                                              ?.requestLocationModel
                                              .destPoint !=
                                          null) {
                                    wenchServiceBloc
                                        ?.animateCameraToShowAnyMapPath(
                                            from: wenchServiceBloc!
                                                .request!
                                                .requestLocationModel
                                                .clientPoint!,
                                            to: wenchServiceBloc!
                                                .request!
                                                .requestLocationModel
                                                .destPoint!);
                                  }
                                }
                              },
                            );
                            wenchServiceBloc?.isCameraIdle = true;
                          },
                          polylines:
                              wenchServiceBloc!.googleMapsModel.polylines,
                          markers: wenchServiceBloc!.googleMapsModel.markers,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          child: Column(
                            children: [
                              CurrentLocSearch(
                                  currentLocationController:
                                      wenchServiceBloc?.originController),
                              verticalSpace10,
                              if (wenchServiceBloc?.otherServiceIds.isEmpty ==
                                  true)
                                DestLocSearch(
                                    destinationLocationController:
                                        wenchServiceBloc
                                            ?.destinationController),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SlidingUpPanel(
                          minHeight: wenchServiceBloc?.userRequestProcess ==
                                  UserRequestProcesses.none
                              ? 0
                              : 60.rh,
                          maxHeight: 220.rh,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.0.rSp),
                            topRight: Radius.circular(40.0.rSp),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 20.rw),
                          color: Colors.transparent,
                          boxShadow: const [],
                          defaultPanelState: PanelState.CLOSED,
                          controller: wenchServiceBloc?.panelController,
                          onPanelOpened: () {},
                          onPanelSlide: (double position) {},
                          panel: _mapReqProcessToProperSheet(),
                        ),
                      ),
                    ],
                  );
          },
        ));
  }

  Widget _mapReqProcessToProperSheet() {
    switch (wenchServiceBloc?.userRequestProcess) {
      case UserRequestProcesses.whichWench:
        return BlocProvider.value(
            value: wenchServiceBloc!,
            child: ChooseWenchBottomSheet(
              wenchServiceBloc: wenchServiceBloc!,
            ));
      case UserRequestProcesses.selectedWenchDetails:
        return BlocProvider.value(
            value: wenchServiceBloc!,
            child: const TripInformationBottomSheet());
      case UserRequestProcesses.passengersSheet:
        return BlocProvider.value(
            value: wenchServiceBloc!, child: const PassengersCarBottomSheet());
      case UserRequestProcesses.pricingSheet:
        return BlocProvider.value(
            value: wenchServiceBloc!,
            child: TripPricingBottomSheet(
              serviceRequestBloc: wenchServiceBloc,
            ));
      case UserRequestProcesses.paymentMethod:
        return BlocProvider.value(
          value: wenchServiceBloc!,
          child: PaymentMethodsBottomSheet(),
        );
      case UserRequestProcesses.driverWaiting:
        return BlocProvider.value(
            value: wenchServiceBloc!,
            child: DriverWaitingBottomSheet(
              wenchServiceBloc: wenchServiceBloc,
            ));
      case UserRequestProcesses.pending:
        return BlocProvider.value(
            value: wenchServiceBloc!,
            child: const RequestPendingORNotAvaliableBottomSheet());
      case UserRequestProcesses.notAvaliable:
        return BlocProvider.value(
            value: wenchServiceBloc!,
            child: const RequestPendingORNotAvaliableBottomSheet());
      case UserRequestProcesses.driverStates:
        return BlocProvider.value(
            value: wenchServiceBloc!,
            child: TripStatusBottomSheet(
              wenchServiceBloc: wenchServiceBloc!,
            ));
      case UserRequestProcesses.history:
        return BlocProvider.value(
            value: wenchServiceBloc!,
            child: const HistoryRequestDetailsSheet());
      case UserRequestProcesses.none:
        return const SizedBox();
      default:
        return BlocProvider.value(
            value: wenchServiceBloc!,
            child: const HistoryRequestDetailsSheet());
    }
  }
}
