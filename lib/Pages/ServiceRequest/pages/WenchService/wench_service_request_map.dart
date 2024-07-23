import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';
import 'package:helpooappclient/Services/navigation_service.dart';

import '../../../../Configurations/Constants/assets_images.dart';
import '../../../../Configurations/Constants/page_route_name.dart';
import '../../../../Models/service_request/service_request.dart';
import '../../../../Style/theme/colors.dart';
import '../../../../Widgets/helpoo_in_app_notifications.dart';
import '../../../../Widgets/load_asset_image.dart';
import '../../../../Widgets/primary_button.dart';
import '../../../../Widgets/scaffold_bk.dart';
import '../../../../Widgets/spacing.dart';
import '../../../../generated/locale_keys.g.dart';
import 'package:map_picker/map_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../widgets/bottom_sheets/choose_wench_bottom_sheet.dart';
import '../../widgets/bottom_sheets/driver_waiting_bottom_sheet.dart';
import '../../widgets/bottom_sheets/history_request_details_sheet.dart';
import '../../widgets/bottom_sheets/passengers_car_bottom_sheet.dart';
import '../../widgets/bottom_sheets/payment_methods_bottom_sheet.dart';
import '../../widgets/bottom_sheets/rating_bottom_sheet.dart';
import '../../widgets/bottom_sheets/request_pending_bottom_sheet.dart';
import '../../widgets/bottom_sheets/trip_info_bottom_sheet.dart';
import '../../widgets/bottom_sheets/trip_pricing_bottom_sheet.dart';
import '../../widgets/bottom_sheets/trip_status_bottom_sheet.dart';
import '../../widgets/current_loc_search.dart';
import '../../widgets/dest_loc_search.dart';
import 'wench_service_bloc.dart';

class ServiceRequestWenchMapsPage extends StatefulWidget {
  final bool isNewReq;
  final bool isCurrentReq;
  final bool isHistoryReq;
  final bool isCarService;
  final ServiceRequest? serviceRequest;
  final int? parentServiceId;
  ServiceRequestWenchMapsPage({
    super.key,
    this.isNewReq = false,
    this.isCurrentReq = false,
    this.isHistoryReq = false,
    this.isCarService = false,
    this.parentServiceId,
    this.serviceRequest,
  });

  @override
  State<ServiceRequestWenchMapsPage> createState() =>
      _ServiceRequestWenchMapsPageState();
}

class _ServiceRequestWenchMapsPageState
    extends State<ServiceRequestWenchMapsPage> {
  WenchServiceBloc? wenchServiceBloc;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    wenchServiceBloc = context.read<WenchServiceBloc>();
    wenchServiceBloc?.isCarService = widget.isCarService;
    wenchServiceBloc?.parentServiceId = widget.parentServiceId;
    if (widget.isNewReq)
      wenchServiceBloc?.add(InitialWenchServiceEvent(context: context));

    if (widget.isHistoryReq) {
      wenchServiceBloc?.activeReq = widget.serviceRequest;
      final from = widget.serviceRequest?.from;
      final to = widget.serviceRequest?.to;
      if (from != null && to != null) {
        wenchServiceBloc?.animateCameraToShowAnyMapPath(
            from: widget.serviceRequest!.from!, to: widget.serviceRequest!.to!);
      }
    }

    if (widget.isCurrentReq) {
      setState(() {
        wenchServiceBloc?.request = widget.serviceRequest;
        wenchServiceBloc?.activeReq = widget.serviceRequest;
        wenchServiceBloc?.add(GetRequestByIdEvent(
            activeReqId: widget.serviceRequest?.id.toString()));
        wenchServiceBloc?.add(HandleServiceRequestSheetEvent());

        ///  wenchServiceBloc?.add(CheckIfGetTimeAndDistanceOrNotEvent());
        wenchServiceBloc?.handleMapReqUiUpdates(
            isCurrentReq: widget.isCurrentReq);
      });
      wenchServiceBloc?.checkIfGetTimeAndDistanceOrNot(hit: true);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackPress,
      child: ScaffoldWithBackground(
        horizontalPadding: 0,
        alignment: AlignmentDirectional.topStart,
        onBackTab: _handleBackPress,
        extendBodyBehindAppBar: false,
        appBarTitle: LocaleKeys.roadServices.tr(),
        body: BlocConsumer<WenchServiceBloc, WenchServiceState>(
          listener: _handleBlockState,
          builder: _buildBlocBuilder,
        ),
      ),
    );
  }

  Widget _buildBlocBuilder(BuildContext context, WenchServiceState state) {
    if (wenchServiceBloc!.gettingLocation)
      return Center(child: CircularProgressIndicator());
    else
      return Stack(
        children: [
          _buildMapPicker(),
          _buildTopCenterWidgets(),
          _buildNextButtonVisibility(state),
          _buildSlidingUpPanel(),
        ],
      );
  }

  Widget _buildMapPicker() {
    return MapPicker(
      mapPickerController: wenchServiceBloc!.mapPickerController,
      showDot: false,
      iconWidget: _buildMapIcon(),
      child: GoogleMap(
        mapType: MapType.normal,
        myLocationEnabled: false,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        initialCameraPosition: CameraPosition(
          target: wenchServiceBloc?.cameraPosition?.target ?? LatLng(0, 0),
          zoom: 13.5,
        ),
        onMapCreated: _onMapCreated,
        onCameraMoveStarted: () async {
          wenchServiceBloc?.onCameraMoveStarted();
        },
        onCameraMove: _onCameraMove,
        onCameraIdle: _onCameraIdle,
        polylines: wenchServiceBloc!.googleMapsModel.polylines,
        markers: wenchServiceBloc!.googleMapsModel.markers,
      ),
    );
  }

  Widget _buildMapIcon() {
    return wenchServiceBloc?.userRequestProcess == UserRequestProcesses.none
        ? LoadAssetImage(
            image: AssetsImages.pin,
            height: 35,
            color: ColorsManager.mainColor,
          )
        : SizedBox();
  }

  void _onMapCreated(GoogleMapController controller) {
    print('Map Created');
    if (wenchServiceBloc!.mapControllerCompleter.isCompleted) {
      wenchServiceBloc!.mapControllerCompleter.complete(controller);
    }
    wenchServiceBloc?.setMapController(controller: controller);
  }

  void _onCameraMove(CameraPosition cameraPosition) async {
    wenchServiceBloc?.isCameraIdle = false;
    wenchServiceBloc?.cameraMovementPosition = cameraPosition.target;
    wenchServiceBloc?.onCameraMove(cameraPositionValue: cameraPosition);
  }

  void _onCameraIdle() {
    if (wenchServiceBloc!.userRequestProcess == UserRequestProcesses.none) {
      _getPlaceDetailsByCoordinates();
    }
    if (wenchServiceBloc!.userRequestProcess != UserRequestProcesses.rating) {
      FocusScope.of(NavigationService.navigatorKey.currentContext!)
          .requestFocus(FocusNode());
    }
    _handleCameraIdleLogic();
  }

  void _getPlaceDetailsByCoordinates() {
    wenchServiceBloc?.add(GetPlaceDetailsByCoordinatesEvent(
      longitude: wenchServiceBloc?.cameraMovementPosition?.longitude,
      latitude: wenchServiceBloc?.cameraMovementPosition?.latitude,
      isMyLocation: false,
    ));
  }

  void _handleCameraIdleLogic() {
    Future.delayed(
      Duration(seconds: 10),
      () {
        if (wenchServiceBloc?.userRequestProcess != UserRequestProcesses.none) {
          if (_hasValidRequestLocationModel()) {
            if (_hasValidDistanceAndDurationPoints()) {
              if (_isRequestAcceptedOrStarted()) {
                wenchServiceBloc?.handleRouteZoom(
                  mapPointsToShowPoints: wenchServiceBloc!
                      .activeReq!
                      .requestLocationModel
                      .lastUpdatedDistanceAndDuration!
                      .points!,
                );
              } else {
                _animateCameraToShowAnyMapPath();
              }
            }
          } else if (_hasValidClientAndDestPoints()) {
            _animateCameraToShowAnyMapPath();
          }
        }
      },
    );
    wenchServiceBloc?.isCameraIdle = true;
    _handleDriverStatesLogic();
  }

  bool _hasValidRequestLocationModel() {
    return wenchServiceBloc?.activeReq?.requestLocationModel.clientPoint !=
            null &&
        wenchServiceBloc?.activeReq?.requestLocationModel.destPoint != null;
  }

  bool _hasValidDistanceAndDurationPoints() {
    return wenchServiceBloc?.activeReq?.accepted != null &&
        wenchServiceBloc?.activeReq?.requestLocationModel
                .lastUpdatedDistanceAndDuration?.points !=
            null;
  }

  bool _isRequestAcceptedOrStarted() {
    return wenchServiceBloc!.activeReq!.accepted ||
        wenchServiceBloc!.activeReq!.started;
  }

  bool _hasValidClientAndDestPoints() {
    return wenchServiceBloc?.request?.requestLocationModel.clientPoint !=
            null &&
        wenchServiceBloc?.request?.requestLocationModel.destPoint != null;
  }

  void _animateCameraToShowAnyMapPath() {
    wenchServiceBloc?.animateCameraToShowAnyMapPath(
      from: wenchServiceBloc!.request!.requestLocationModel.clientPoint!,
      to: wenchServiceBloc!.request!.requestLocationModel.destPoint!,
    );
  }

  void _handleDriverStatesLogic() {
    if (wenchServiceBloc!.userRequestProcess ==
            UserRequestProcesses.driverStates ||
        wenchServiceBloc!.userRequestProcess ==
            UserRequestProcesses.driverWaiting) {
      // Additional logic for driver states
    }
  }

  Widget _buildTopCenterWidgets() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Column(
          children: [
            CurrentLocSearch(
              currentLocationController: wenchServiceBloc?.originController,
            ),
            verticalSpace10,
            DestLocSearch(
              destinationLocationController:
                  wenchServiceBloc?.destinationController,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButtonVisibility(WenchServiceState state) {
    return Visibility(
      visible:
          wenchServiceBloc?.userRequestProcess == UserRequestProcesses.none,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: PrimaryButton(
          isLoading: state is GetRequestFeesLoadingState ||
                  state is DrawRequestPathLoadingState ||
                  state is GetNearestDriverLoadingState
              ? true
              : false,
          text: LocaleKeys.next.tr(),
          width: 200.rw,
          height: 40,
          verticalPadding: 20.rh,
          onPressed: _handleNextButtonPress,
        ),
      ),
    );
  }

  void _handleNextButtonPress() async {
    if (wenchServiceBloc?.validateRequestMapPickAndDestPoints() ?? false) {
      await wenchServiceBloc?.drawLinesFromClientToDestination();
    } else {
      HelpooInAppNotification.showErrorMessage(
        message: LocaleKeys.sureOfPoints.tr(),
      );
    }
  }

  Widget _buildSlidingUpPanel() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: SlidingUpPanel(
          minHeight:
              wenchServiceBloc?.userRequestProcess == UserRequestProcesses.none
                  ? 0
                  : 60.rh,
          maxHeight: wenchServiceBloc?.userRequestProcess ==
                      UserRequestProcesses.whichWench ||
                  wenchServiceBloc?.userRequestProcess ==
                      ServiceRequestStatus.done
              ? 270.rh
              : 280.rh,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0.rSp),
              topRight: Radius.circular(40.0.rSp)),
          margin: EdgeInsets.symmetric(horizontal: 10.rw),
          color: Colors.transparent,
          boxShadow: const [],
          defaultPanelState: PanelState.CLOSED,
          controller: wenchServiceBloc?.panelController,
          onPanelOpened: () {},
          onPanelSlide: (double position) {},
          panel: _mapReqProcessToProperSheet(),
        ));
  }

  Future<bool> _handleBackPress() async {
    bool x = _mapBackPressToProperSheet(context);
    if (x) {
      if (wenchServiceBloc?.userRequestProcess == UserRequestProcesses.none ||
          wenchServiceBloc?.userRequestProcess ==
              UserRequestProcesses.history ||
          wenchServiceBloc?.userRequestProcess ==
              UserRequestProcesses.whichWench) {
        Navigator.of(context).pop();
      } else {
        if (wenchServiceBloc?.userRequestProcess ==
            UserRequestProcesses.paymentMethod) {
          wenchServiceBloc?.add(
              CancelServiceRequest(request: wenchServiceBloc?.activeReq!));
        }
        context.pushNamedAndRemoveUntil(PageRouteName.mainScreen);
        wenchServiceBloc?.clearMapRequestData();
        if (wenchServiceBloc?.timerMapUiUpdates != null) {
          wenchServiceBloc?.timerMapUiUpdates!.cancel();
        }
      }
      //  wenchServiceBloc?.isHomeScreenRoute = true;
    }
    return x;
  }

  void _handleBlockState(context, state) async {
    if (state is UserRequestProcessChangedState || state is CameraIdleDone)
      setState(() {});

    if (state is GetRequestByIdSuccessState) {
      wenchServiceBloc?.add(GetConfigEvent());
      wenchServiceBloc?.add(HandleServiceRequestSheetEvent());
      if (wenchServiceBloc?.activeReq?.arrived ?? false) {
        await wenchServiceBloc?.handleRequestRoutes(
          from: LatLng(wenchServiceBloc!.activeReq!.driver!.lat!,
              wenchServiceBloc!.activeReq!.driver!.lng!),
          to: wenchServiceBloc!.activeReq!.requestLocationModel.clientPoint!,
        );
      } else {
        wenchServiceBloc?.add(HandleRequestRoutesEvent());
      }
    }
    if (state is GetMapPlaceCoordinatesDetailsSuccess) {
      wenchServiceBloc?.isFromSearch = false;
    }
    if (state is GetLocationDone)
      wenchServiceBloc?.add(SetServiceRequestMapDataEvent());

    if (state is GetNearestDriverErrorState ||
        state is GetRequestFeesErrorState)
      HelpooInAppNotification.showErrorMessage(message: state.error);

    if (state is GetRequestTimeAndDistanceByIdErrorState)
      HelpooInAppNotification.showErrorMessage(message: state.error);

    if (state is CreateRequestErrorState)
      HelpooInAppNotification.showErrorMessage(message: state.error);

    if (state is RateRequestDriverSuccessState) {
      wenchServiceBloc?.cancelUpdateMapUiTimer();
      context.pushNamedAndRemoveUntil(PageRouteName.mainScreen);
    }
    if (state is CreateRequestSuccessState) {
      setState(() {});
      wenchServiceBloc?.add(GetRequestByIdEvent(
          activeReqId: wenchServiceBloc?.activeReq!.id!.toString()));
      await wenchServiceBloc?.handleMapReqUiUpdates(isCurrentReq: true);
    } else if (state is SetMapControllerSuccess) {
      if (widget.isHistoryReq) {
        wenchServiceBloc?.add(UpdateUserRequestSheetEvent(
            userReqProcess: UserRequestProcesses.history));
        wenchServiceBloc?.showHistoryRequestData(
            ModalRoute.of(context)!.settings.arguments as ServiceRequest);
        // await wenchServiceBloc?.drawLinesFromClientToDestination();
      }
    }
  }

  @override
  void dispose() {
    wenchServiceBloc?.cancelUpdateMapUiTimer();
    wenchServiceBloc?.mapControllerCompleter = Completer();
    wenchServiceBloc?.mapController?.dispose();
    super.dispose();
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
      if(wenchServiceBloc!.selectedWenchType == WenchType.norm&&wenchServiceBloc?.calculateFeesModel?.normFees =="0"||
      wenchServiceBloc!.selectedWenchType == WenchType.norm&&wenchServiceBloc?.calculateFeesModel?.normFees ==null||
      wenchServiceBloc!.selectedWenchType == WenchType.norm&&wenchServiceBloc?.calculateFeesModel?.normFees ==""||
      wenchServiceBloc!.selectedWenchType == WenchType.norm&&wenchServiceBloc?.activeReq?.normFees =="0"||
      wenchServiceBloc!.selectedWenchType == WenchType.norm&&wenchServiceBloc?.activeReq?.normFees ==null||
      wenchServiceBloc!.selectedWenchType == WenchType.norm&&wenchServiceBloc?.activeReq?.normFees ==""||
      wenchServiceBloc!.selectedWenchType == WenchType.euro&&wenchServiceBloc?.calculateFeesModel?.euroFees =="0"||
      wenchServiceBloc!.selectedWenchType == WenchType.euro&&wenchServiceBloc?.calculateFeesModel?.euroFees ==null||
      wenchServiceBloc!.selectedWenchType == WenchType.euro&&wenchServiceBloc?.calculateFeesModel?.euroFees ==""||
      wenchServiceBloc!.selectedWenchType == WenchType.euro&&wenchServiceBloc?.activeReq?.euroFees =="0"||
      wenchServiceBloc!.selectedWenchType == WenchType.euro&&wenchServiceBloc?.activeReq?.euroFees ==null||
      wenchServiceBloc!.selectedWenchType == WenchType.euro&&wenchServiceBloc?.activeReq?.euroFees ==""){
        log("should NOT pay ${wenchServiceBloc!.selectedWenchType }, CalcNormal ${wenchServiceBloc!.calculateFeesModel?.normFees},  activeNor ${wenchServiceBloc!.activeReq?.normFees}");
        log("should NOT pay ${wenchServiceBloc!.selectedWenchType }, CalcNormal ${wenchServiceBloc!.calculateFeesModel?.euroFees},  activeNor ${wenchServiceBloc!.activeReq?.euroFees}");
      
        return BlocProvider.value(
            value: wenchServiceBloc!,
            child: DriverWaitingBottomSheet(
              wenchServiceBloc: wenchServiceBloc,
            ));
      }else{
                log("should pay ${wenchServiceBloc!.selectedWenchType }, CalcNormal ${wenchServiceBloc!.calculateFeesModel?.normFees},  activeNor ${wenchServiceBloc!.activeReq?.normFees}");
        log("should pay ${wenchServiceBloc!.selectedWenchType }, CalcNormal ${wenchServiceBloc!.calculateFeesModel?.euroFees},  activeNor ${wenchServiceBloc!.activeReq?.euroFees}");

        return BlocProvider.value(
          value: wenchServiceBloc!,
          child: PaymentMethodsBottomSheet(),
        );
      }
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
      case UserRequestProcesses.rating:
        return BlocProvider.value(
            value: wenchServiceBloc!, child: const RatingBottomSheet());
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

  bool _mapBackPressToProperSheet(BuildContext context) {
    switch (wenchServiceBloc?.userRequestProcess) {
      case UserRequestProcesses.whichWench:
        wenchServiceBloc?.add(UpdateUserRequestSheetEvent(
            userReqProcess: UserRequestProcesses.none));
        return true;
      case UserRequestProcesses.selectedWenchDetails:
        wenchServiceBloc?.add(UpdateUserRequestSheetEvent(
            userReqProcess: wenchServiceBloc!.isCarService
                ? UserRequestProcesses.none
                : UserRequestProcesses.whichWench));
        if (wenchServiceBloc!.isCarService) return true;
        return false;
      case UserRequestProcesses.passengersSheet:
        wenchServiceBloc?.add(UpdateUserRequestSheetEvent(
            userReqProcess: UserRequestProcesses.selectedWenchDetails));
        return false;
      case UserRequestProcesses.pricingSheet:
        wenchServiceBloc?.add(UpdateUserRequestSheetEvent(
            userReqProcess: UserRequestProcesses.selectedWenchDetails
            //   passengersSheet
            ));

        return false;
      case UserRequestProcesses.paymentMethod:
        /*   wenchServiceBloc
            ?.add(CancelServiceRequest(request: wenchServiceBloc?.activeReq!));*/
        //are you sure you want cancel request?
        return true;
      default:
        return true;
    }
  }
}
