import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:bloc/src/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_maps_webservice/geocoding.dart';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:helpooappclient/generated/locale_keys.g.dart';
import 'package:location/location.dart' as ll;
import 'package:geocoding/geocoding.dart' as GeocodingForCountry;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import 'package:helpooappclient/Configurations/extensions/days_extensions.dart';
import 'package:helpooappclient/Configurations/extensions/unit_converter_extension.dart';
import 'package:map_picker/map_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Configurations/Constants/constants.dart';
import '../../../../Configurations/Constants/enums.dart';
import '../../../../Configurations/Constants/keys.dart';
import '../../../../Configurations/Constants/page_route_name.dart';
import '../../../../Configurations/di/injection.dart';
import '../../../../Models/cars/my_cars.dart';
import '../../../../Models/get_config.dart';
import '../../../../Models/map_place_details_model.dart';
import '../../../../Models/maps/google_map_model.dart';
import '../../../../Models/packages/package_model.dart';
import '../../../../Models/service_request/driver.dart';
import '../../../../Models/service_request/fees_other_service_model.dart';
import '../../../../Models/service_request/fees_response_model.dart';
import '../../../../Models/service_request/getDistanceAndDurationResponse.dart';
import '../../../../Models/service_request/getRequestDuratonAndDistance.dart';
import '../../../../Models/service_request/service_request.dart';
import '../../../../Models/service_request/service_request_model.dart';
import '../../../../Services/cache_helper.dart';
import '../../../../Services/navigation_service.dart';
import '../../../../Style/theme/colors.dart';
import '../../../../Widgets/helpoo_in_app_notifications.dart';
import 'wench_service_repository.dart';
import 'package:google_maps_webservice/geocoding.dart'
    as flutter_polyline_points;

part 'wench_service_event.dart';

part 'wench_service_state.dart';

class WenchServiceBloc extends Bloc<WenchServiceEvent, WenchServiceState> {
  final WenchServiceRepository wenchServiceRepository =
      sl<WenchServiceRepository>();
  final CacheHelper cacheHelper = sl<CacheHelper>();
  bool isCameraIdle = true;
  WenchServiceBloc? wenchServiceBloc;
  PanelController panelController = PanelController();
  List<ServiceRequest> latestRequests = [];
  List<ServiceRequest> activeRequestsList = [];
  ServiceRequestModel? activeReqModel;
  ServiceRequest? activeReq;
  WenchType? selectedWenchType;
  FeesResponseModel? calculateFeesModel;
  ServiceRequest? request = ServiceRequest();
  ServiceRequest historyRequestModel = ServiceRequest();

  UserRequestProcesses userRequestProcess = UserRequestProcesses.none;
  num localDuration = -1;
  num mPerSecRatio = -1;
  Driver? driverModel;
  String rateDriverValue = '';
  TextEditingController rateDriverCommentCtrl = TextEditingController();
  Config? config;
  num localDistance = -1;
  List<Package> helpooPackages = [];
  CameraPosition? cameraPosition;
  LatLng? initialCameraPosition; //= const LatLng(30.0595581, 31.223445);
  num localDistancePerMinute = -1;
  Timer? localDurationTimer;
  bool isFirstTimeHitRequest = true;
  Timer? timerMapUiUpdates;
  LatLng? from;
  LatLng? to;
  GoogleMapController? mapController;
  Completer<GoogleMapController> mapControllerCompleter = Completer();
  List<LatLng>? mapPointsToShow = [];
  bool isFeesEqualZero = false;
  DistanceAndDuration? getDistanceAndDurationResponse;
  LatLng? cameraMovementPosition;
  MapPlaceDetailsCoordinatesModel? mapPlaceDetailsCoordinatesModel;
  bool? serviceEnabled;
  ll.LocationData? locationData;
  ll.Location location = ll.Location();

  //LocationData? locationData;
  //Location location = Location();

  PolylineResult? firstPolylineResult;
  PolylineResult? secondPolylineResult;
  PolylineResult? thirdPolylineResult;
  MapPickerController mapPickerController = MapPickerController();
  GoogleMapsModel googleMapsModel = GoogleMapsModel();
  MyCarModel? selectedCarToRequest;
  bool isFromSearch = false;
  PolylineResult? driverPolylineResult;
  int waitingMinutes = 0;
  int waitingSeconds = 0;
  double waitingFees = 0;
  bool isWaitingTimerRunning = false;
  Position? currentPosition;
  String currentAddress = "";
  LatLng? currentLatLng;
  double southWestLatitude = 0;
  double southWestLongitude = 0;
  double northEastLatitude = 0;
  double northEastLongitude = 0;
  LatLng? fromForDTO;
  LatLng? toForDTO;
  LatLng? destinationLatLng;
  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController mapSearchFnolTextFieldCtrl = TextEditingController();
  int fnolImagesTaken = 0;
  int fnolImagesUploaded = 0;
  FNOLSteps? currentFnolStep;
  String? currentFnolStepAddress;
  LatLng? currentFnolStepLatLng;
  LocationFNOLSteps? currentLocationFnolStep;
  String fnolNamePrefix = "";
  TextEditingController currentLocationTextFieldCtrl = TextEditingController();
  TextEditingController destinationLocationTextFieldCtrl =
      TextEditingController();
  bool isTrackingLoading = false;
  bool isGuest = true;
  bool isCarService = false;
  int? parentServiceId;
  bool _isFromTracking = false;
  bool get isFromTracking => _isFromTracking;
  WenchServiceBloc() : super(WenchServiceInitial()) {
    on<WenchServiceEvent>((event, emit) {});
    on<InitTrackingEvent>((event, emit) async {
      _isFromTracking = true;
      isGuest = await cacheHelper.get(Keys.token) == null;
      isTrackingLoading = true;
      await getOneById(event.requestId);
      await checkIfGetTimeAndDistanceOrNot(hit: true);
      await handleMapReqUiUpdates(isCurrentReq: true);
      isTrackingLoading = false;
    });
    on<InitialWenchServiceEvent>((event, emit) async {
      _isFromTracking = false;
      isGuest = await cacheHelper.get(Keys.token) == null;
      print(isGuest);
      await getForceLocation(true);
   
      if ((ModalRoute.of(event.context!)?.settings.arguments) is MyCarModel) {
        selectedCarToRequest =
            ModalRoute.of(event.context!)!.settings.arguments as MyCarModel;
        emit(UpdateMapState());
      }
    });
    on<SetFnolMapDataEvent>((event, emit) {
      mapSearchFnolTextFieldCtrl.text = currentAddress;
      currentFnolStepAddress = currentAddress;
      currentFnolStepLatLng = currentLatLng;
      if (mapController != null) {
        mapController!
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition!));
      }
      emit(UpdateFnolCurrentLocation());
    });
    on<SetServiceRequestMapDataEvent>((event, emit) {
      if (request?.fieldPin == MapPickerStatus.pickup) {
        currentLocationTextFieldCtrl.text = currentAddress;
        request?.requestLocationModel.clientAddress = currentAddress;
        request?.requestLocationModel.clientPoint = currentLatLng;
      } else if (request?.fieldPin == MapPickerStatus.destination) {
        destinationLocationTextFieldCtrl.text = currentAddress;
        request?.requestLocationModel.destAddress = currentAddress;
        request?.requestLocationModel.destPoint = currentLatLng;
      } else {}

      if (mapController != null)
        mapController!
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition!));

      emit(UpdateSRSearchLocation());
    });
    on<GetPlaceDetailsByCoordinatesEvent>((event, emit) async {
      ///  print('skskskdkdk');
      emit(GetMapPlaceCoordinatesDetailsLoading());
      if (event.longitude != null && event.latitude != null) {
        final result =
            await wenchServiceRepository.getPlaceDetailsByCoordinates(
          latLng: '${event.latitude!},${event.longitude!}',
        );

        result.fold(
          (failure) {
            debugPrint(failure.toString());
            emit(
              GetMapPlaceCoordinatesDetailsError(
                error: failure,
              ),
            );
          },
          (data) {
            print('iiii: $isFromSearch');
            mapPlaceDetailsCoordinatesModel = data;
            switch (request?.fieldPin) {
              case null:
                return;
              case MapPickerStatus.pickup:
                if (!isFromSearch) {
                  request?.requestLocationModel.clientAddress =
                      mapPlaceDetailsCoordinatesModel!.placeName;
                                      }
                request?.requestLocationModel.clientPoint = LatLng(
                  event.latitude!,
                  event.longitude!,
                );
                break;
              case MapPickerStatus.destination:
                if (!isFromSearch) {
                  request?.requestLocationModel.destAddress =
                      mapPlaceDetailsCoordinatesModel!.placeName;
                }
                request?.requestLocationModel.destPoint = LatLng(
                  event.latitude!,
                  event.longitude!,
                );
                break;
            }

            emit(
              GetMapPlaceCoordinatesDetailsSuccess(),
            );
          },
        );
      }
    });
    on<HandlingWaitingTimeEvent>((event, emit) {
      DateTime? specificUtcTime;
      if (activeReq!.arrived) {
        specificUtcTime = activeReq!.arriveTime!;
      } else if (activeReq!.destArrived) {
        specificUtcTime = activeReq!.destArriveTime!;
      } else {
        specificUtcTime = DateTime.now().toUtc();
      }
      // Get the current UTC time.
      DateTime currentUtcTime = DateTime.now().toUtc();
      // Calculate the difference between specificUtcTime and currentUtcTime.
      Duration difference = currentUtcTime.difference(specificUtcTime);
      // Extract minutes and seconds from the duration.
      waitingMinutes = difference.inMinutes;
      waitingSeconds = difference.inSeconds % 60;
      print('waitingMinutes');
      print(waitingMinutes);
      waitingFees = calculateWaitingPrice(waitingMinutes);
      emit(CalculateWaitingTimeState());
    });
    on<HandleServiceRequestSheetEvent>((event, emit) async {
      /// googleMapsModel.markers.clear();
      if (activeReq!.confirmed) {
        userRequestProcess = UserRequestProcesses.driverWaiting;
      } else if (activeReq!.pending) {
        userRequestProcess = UserRequestProcesses.pending;
      } else if (activeReq!.canceled) {
        userRequestProcess = UserRequestProcesses.history;
      } else if (activeReq!.done && !activeReq!.rated) {
        userRequestProcess = UserRequestProcesses.rating;
      } else if (activeReq!.done && activeReq!.rated) {
        userRequestProcess = UserRequestProcesses.history;
      } else if (activeReq!.notAvailable) {
        userRequestProcess = UserRequestProcesses.notAvaliable;
      } else if (activeReq!.created || activeReq!.opened) {
        userRequestProcess = UserRequestProcesses.paymentMethod;
      } else {
        userRequestProcess = UserRequestProcesses.driverStates;
      }

      emit(UserRequestProcessChangedState(
          userRequestProcesses: userRequestProcess));
    });
    on<HandleRequestRoutesEvent>((event, emit) async {
      print('activeReq?.status.name');
      print(activeReq?.status.name);

      ///emit(LoadingMapState());
      try {
        PolylineId id = PolylineId('polylineId');
        final isStarted = activeReq?.started == true;
        final isAccepted = activeReq?.accepted == true;
        final points = (isStarted || isAccepted
                ? activeReq!
                    .requestLocationModel.lastUpdatedDistanceAndDuration?.points
                : activeReq?.requestLocationModel.pointsClientToDest) ??
            [];
        if (points.isEmpty) return;
        final startBearing = Geolocator.bearingBetween(
          points.first.latitude,
          points.first.longitude,
          points[1].latitude,
          points[1].longitude,
        );
        final endBearing = Geolocator.bearingBetween(
          points[points.length - 2].latitude,
          points[points.length - 2].longitude,
          points.last.latitude,
          points.last.longitude,
        );
        Polyline polyline = Polyline(
          polylineId: id,
          color: Theme.of(NavigationService.navigatorKey.currentContext!)
              .primaryColor,
          points: points,
          width: 4,
        );
        if (activeReqModel?.firstClientDestination != null) {
          if (activeReqModel!.oldRequestStatus ==
              ServiceRequestStatus.destArrived) {
            googleMapsModel.polylines.add(polyline);
          } else {
            //  googleMapsModel.polylines = {};
          }
          googleMapsModel.markers = {};

          drawAnyMapPathMarkers(
            startIconPath: Platform.isIOS
                ? "assets/images/pin_ios.png"
                : "assets/images/pin_android.png",
            endIconPath: Platform.isIOS
                ? "assets/images/client_car_ios.png"
                : "assets/images/client_car.png",
            startMarkerCoord: activeReq!.requestLocationModel.clientPoint!,
            endMarkerCoord: activeReq!.requestLocationModel.destPoint!,
            heading: 0.0,
            bearing: endBearing,
          );
        } else {
          googleMapsModel.polylines = {};
          googleMapsModel.polylines.add(polyline);
          if (activeReq!.accepted) {
            from = LatLng(activeReq!.driver!.lat!, activeReq!.driver!.lng!);
            to = activeReq!.requestLocationModel.clientPoint!;
            if (otherServiceIds.isEmpty)
              drawAnyMapPathMarkers(
                startIconPath: isCarService
                    ? Platform.isIOS
                        ? "assets/images/n300_marker_ios.png"
                        : "assets/images/n300_marker.png"
                    : Platform.isIOS
                        ? "assets/images/wench_ios.png"
                        : "assets/images/wench.png",
                endIconPath: Platform.isIOS
                    ? "assets/images/client_car_ios.png"
                    : "assets/images/client_car.png",
                startMarkerCoord: points.first,
                endMarkerCoord: points.last,
                heading: startBearing,
                bearing: endBearing,
              );
            else
              drawAnyMapPathMarkers(
                startIconPath: Platform.isIOS
                    ? "assets/images/n300_marker_ios.png"
                    : "assets/images/n300_marker.png",
                endIconPath: Platform.isIOS
                    ? "assets/images/client_car_ios.png"
                    : "assets/images/client_car.png",
                startMarkerCoord: points.first,
                endMarkerCoord: points.last,
                heading: startBearing,
                bearing: endBearing,
              );
          } else if (activeReq!.arrived ||
              activeReq!.started ||
              activeReq!.destArrived) {
            from = LatLng(activeReq!.driver!.lat!, activeReq!.driver!.lng!);
            if (otherServiceIds.isNotEmpty) {
              to = activeReq!.requestLocationModel.clientPoint!;
              googleMapsModel.polylines = {};
              addServiceMarkerAndAnimate();
              return;
            } else
              to = activeReq!.requestLocationModel.destPoint!;

            await drawAnyMapPathMarkers(
              startIconPath: isCarService
                  ? Platform.isIOS
                      ? "assets/images/n300_marker_ios.png"
                      : "assets/images/n300_marker.png"
                  : Platform.isIOS
                      ? "assets/images/wench_with_car_ios.png"
                      : "assets/images/wench_with_car.png",
              endIconPath: Platform.isIOS
                  ? "assets/images/pin_ios.png"
                  : "assets/images/pin_android.png",
              startMarkerCoord: points.first,
              endMarkerCoord: points.last,
              heading: startBearing,
            );
          } else {
            if (otherServiceIds.isNotEmpty) return;
            from = activeReq!.requestLocationModel.clientPoint!;
            to = activeReq!.requestLocationModel.destPoint!;
            await drawAnyMapPathMarkers(
              startIconPath: Platform.isIOS
                  ? "assets/images/client_car_ios.png"
                  : "assets/images/client_car.png",
              endIconPath: Platform.isIOS
                  ? "assets/images/pin_ios.png"
                  : "assets/images/pin_android.png",
              startMarkerCoord: from!,
              endMarkerCoord: to!,
              heading: startBearing,
            );
          }
          //   animateCameraToShowAnyMapPath(from: from!, to: to!);
        }
        emit(UpdateMapState());
      } catch (e) {
        print(e.toString());
        // emit(GetDriverPathToDrawError(error: e.toString()));
      }
    });
    on<GetRequestByIdEvent>((event, emit) async {
      // emit(GetRequestByIdLoadingState());
      final result = await wenchServiceRepository.getOneServiceRequest(
          serviceRequestId: int.parse(event.activeReqId!));

      result.fold(
        (failure) {
          debugPrint(failure);
          emit(GetRequestByIdErrorState(error: failure));
          return null;
        },
        (data) async {
          // debugPrint('get req by id hi ===============> 1 x ${data.id}');
          activeReq = data.activeReq;
          activeReqModel = data;
          emit(GetRequestByIdSuccessState());

          /// debugPrintFullText('get req by id hi ===============> 2 x ${data.toJson(selectedCarToRequest, null)}');

          //print(activeReqModel?.status);
          if (activeReq!.confirmed || activeReq!.done) {
            from = activeReq!.requestLocationModel.clientPoint!;
            to = activeReq!.requestLocationModel.destPoint!;
            await handleRequestRoutes(from: from, to: to);
          }
          if (activeReq!.accepted) {
            from = LatLng(activeReq!.driver!.lat!, activeReq!.driver!.lng!);
            to = activeReq!.requestLocationModel.clientPoint!;
            await drawAnyMapPath(
                    from: LatLng(
                        activeReq!.driver!.lat!, activeReq!.driver!.lng!),
                    to: activeReq!.requestLocationModel.clientPoint!,
                    pathId: "")
                .then((value) async {
              drawAnyMapPathMarkers(
                  startIconPath: isCarService
                      ? Platform.isIOS
                          ? "assets/images/n300_marker_ios.png"
                          : "assets/images/n300_marker.png"
                      : Platform.isIOS
                          ? "assets/images/wench_ios.png"
                          : "assets/images/wench.png",
                  endIconPath: Platform.isIOS
                      ? "assets/images/client_car_ios.png"
                      : "assets/images/client_car.png",
                  startMarkerCoord: from!,
                  endMarkerCoord: to!,
                  heading: activeReq?.driver?.heading!);
            });
            // trimRoute();
            await handleRequestRoutes(from: from, to: to);
          } else if (activeReq!.started) {
            from = LatLng(activeReq!.driver!.lat!, activeReq!.driver!.lng!);
            to = activeReq!.requestLocationModel.clientPoint!;
            if (otherServiceIds.isNotEmpty) return data;
            await drawAnyMapPath(from: from!, to: to!, pathId: "")
                .then((value) async {
              drawAnyMapPathMarkers(
                  startIconPath: isCarService
                      ? Platform.isIOS
                          ? "assets/images/n300_marker_ios.png"
                          : "assets/images/n300_marker.png"
                      : Platform.isIOS
                          ? "assets/images/wench_with_car_ios.png"
                          : "assets/images/wench_with_car.png",
                  endIconPath: Platform.isIOS
                      ? "assets/images/pin_ios.png"
                      : "assets/images/pin_android.png",
                  startMarkerCoord: from!,
                  endMarkerCoord: to!,
                  heading: activeReq?.driver?.heading);
            });
            // trimRoute();
            await handleRequestRoutes(from: from, to: to);
          }

          // wenchServiceBloc?.add(HandleServiceRequestSheetEvent());

          // wenchServiceBloc?.add(HandleRequestRoutesEvent());

          return data;
        },
      );
    });

    on<GetConfigEvent>((event, emit) async {
      emit(GetConfigLoadingState());
      final results = await wenchServiceRepository.getConfig();
      results.fold(
        (error) {
          //isGetConfigLoading = false;

          debugPrint('-----error------');
          debugPrint(error.toString());
          emit(
            GetConfigErrorState(
              error: error,
            ),
          );
        },
        (data) {
          debugPrint('----- Config Data ------');
          debugPrintFullText(data.toJson().toString());
          config = data.config![0];

          // isGetConfigLoading = false;
          emit(GetConfigSuccessState());
        },
      );
    });
    on<RateRequestDriverEvent>((event, emit) async {
      emit(RateRequestDriverLoadingState());
      final result = await wenchServiceRepository.rateRequestDriver(
          reqID: activeReq!.id.toString(),
          rate: rateDriverValue,
          comment: rateDriverCommentCtrl.text,
          rated: 'true');

      result.fold(
        (failure) {
          debugPrint(failure);
          //  rateRequestDriverIsLoading = false;
          emit(RateRequestDriverErrorState(error: failure));
        },
        (data) {
          // printMeLog("khalillllll");
          //rateRequestDriverIsLoading = false;

          emit(RateRequestDriverSuccessState());
          //clearMapRequestData();
        },
      );
    });
    on<GetIframeEvent>((event, emit) async {
      // TODO: implement event handler

      emit(GetIFrameUrlLoadingState());

      final result = await wenchServiceRepository.getPaymentIframe(
        serviceRequestId: event.requestId,
        /* packageId: event.selectedPackage != null
            ? null
            : helpooPackages[event.selectedPackage!].id,*/
        amount: event.amount!,
      );

      result.fold(
        (failure) {
          debugPrint('-----failure------');
          debugPrint(failure.toString());
          //  isGetIFrameUrlLoading = false;
          emit(GetIFrameUrlErrorState(error: failure));
        },
        (data) {
          // printMeLog('-----data--- ${data.toJson()}');
          // IFrameUrl = data.frameUrl ?? '';
          debugPrint('-----IFrameUrl------');
          debugPrint(data.frameUrl ?? '');
          //   isGetIFrameUrlLoading = false;
          emit(GetIFrameUrlSuccessState(url: data.frameUrl ?? ''));
        },
      );
    });
    on<ChangeRequestPaymentMethod>((event, emit) async {
      // TODO: implement event handler
      request?.paymentMethod = event.pm!;
      if (activeReq != null) activeReq!.paymentMethod = event.pm!;
      event.callBack!();
      emit(PaymentMethodChangedState());
    });
    on<ConfirmRequestEvent>((event, emit) async {
      emit(ConfirmRequestLoadingState());

      final result = await wenchServiceRepository.confirmServiceRequest(
        serviceRequestId: request!.id!,
        status: 'confirmed',
        // status: request.paymentMethod == PaymentMethod.online ? "online-card" : 'confirmed',
        // paymentMethod: isFeesEqualZero ? PaymentMethod.cash.dbVal : paymentMethod.value,
        paymentMethod: request!.paymentMethod.dbVal,
        paymentStatus: isFeesEqualZero
            ? 'paid'
            : request!.paymentMethod == PaymentMethod.online
                ? 'paid'
                : 'pending',
      );

      result.fold(
        (failure) {
          debugPrint('failed to confirm a request ==============> $failure');
          emit(ConfirmRequestErrorState(error: failure));
        },
        (data) async {
          //updateUserRequestSheetState(UserRequestProcesses.driverWaiting);
          request?.status = ServiceRequestStatus.confirmed;
          activeReq?.status = ServiceRequestStatus.confirmed;
          emit(ConfirmRequestSuccessState());

          ///await handleMapReqUiUpdates(isCurrentReq: true);
//
//          await assignDriverToRequest();
        },
      );
    });
    on<CreateServiceRequest>((event, emit) async {
      emit(CreateRequestLoadingState());
      selectedCarToRequest =
          ModalRoute.of(event.context!)!.settings.arguments as MyCarModel;
      if (selectedWenchType == WenchType.norm) {
        // driverModel = normalDriverModel;
        request?.carServiceTypeId = 4;
        request?.driver = driverModel;
        request?.clientId = int.parse(await cacheHelper.get(Keys.generalID));
        request?.createdByUserId =
            (await cacheHelper.get(Keys.currentUserId).toString());
        request?.carId = selectedCarToRequest?.id.toString();
      } else if (selectedWenchType == WenchType.euro) {
        request?.carServiceTypeId = 5;
        request?.driver = driverModel;
        request?.clientId = int.parse(await cacheHelper.get(Keys.generalID));

        request?.createdByUserId = (await cacheHelper.get(Keys.currentUserId));
        request?.carId = selectedCarToRequest?.id.toString();
        // driverModel = euroDriverModel;
      } else if (isCarService) {
        request?.carServiceTypeId = carServiceId;
        request?.parentRequest = parentServiceId;
        request?.driver = driverModel;
        request?.clientId = int.parse(await cacheHelper.get(Keys.generalID));
        request?.createdByUserId =
            (await cacheHelper.get(Keys.currentUserId).toString());
      }

      final result =
          await wenchServiceRepository.createServiceRequest(request!);

      result.fold(
        (failure) {
          debugPrint('failed to create a request ==============> $failure');
          emit(CreateRequestErrorState(error: failure));
        },
        (data) async {
          request?.corporateName = data["corporate"];
          request?.id = data["request"][0]['id'];

          activeReq = request;

          //updateUserRequestSheetState(UserRequestProcesses.paymentMethod);
          wenchServiceBloc?.add(HandleRequestRoutesEvent());
          debugPrint('created request id: =============> ${request?.id}');
          debugPrint('created request json: =============> ${data}');

          emit(CreateRequestSuccessState());
        },
      );
    });
    on<CreateOtherServiceRequest>((event, emit) async {
      emit(CreateRequestLoadingState());
      selectedCarToRequest =
          ModalRoute.of(event.context!)!.settings.arguments as MyCarModel;
      final Map<String, int> services = {};
      for (int i = 0; i < otherServiceIds.length; i++) {
        services.addAll({otherServiceIds[i].toString(): 1});
      }
      request?.services = services;
      request?.clientId = int.parse(await cacheHelper.get(Keys.generalID));
      request?.createdByUserId =
          (await cacheHelper.get(Keys.currentUserId).toString());
      request?.carId = selectedCarToRequest?.id.toString();

      request?.clientId = int.parse(await cacheHelper.get(Keys.generalID));

      request?.createdByUserId = (await cacheHelper.get(Keys.currentUserId));

      final result =
          await wenchServiceRepository.createOtherServiceRequest(request!);

      await result.fold(
        (failure) {
          debugPrint('failed to create a request ==============> $failure');
          emit(CreateRequestErrorState(error: failure));
        },
        (data) async {
          request?.corporateName = data["corporate"];
          request?.id = data["request"][0]['id'];
          await wenchServiceRepository.assignDriverToRequest(request!)
            ..fold((l) {
              debugPrint(
                  'failed to assign driver to request ==============> $l');
              emit(CreateRequestErrorState(error: l));
            }, (r) {
              activeReq = request;
              emit(CreateRequestSuccessState());
            });
          //updateUserRequestSheetState(UserRequestProcesses.paymentMethod);
          debugPrint('created request id: =============> ${request?.id}');
          debugPrint('created request json: =============> ${data}');
        },
      );
    });

    on<GetNearestDriver>((event, emit) async {
      // TODO: implement event handler
      emit(GetNearestDriverLoadingState());
      // if (id == 4) {
      //   normalDriverModel = null;
      // } else if (id == 5) {
      //   euroDriverModel = null;
      // }

      final result = await wenchServiceRepository.getNearestDriver(
        carServiceTypeId: json.encode([event.id ?? request?.carServiceTypeId]),
        location: json.encode({
          "clientLatitude":
              request?.requestLocationModel.clientPoint?.latitude ?? '',
          "clientLongitude":
              request?.requestLocationModel.clientPoint?.longitude ?? ''
        }),
      );

      result.fold(
        (failure) {
          debugPrint(failure);
          emit(GetNearestDriverErrorState(error: failure));
        },
        (data) {
          // if (id != null) {
          //   id == 4 ? normalDriverModel = data : euroDriverModel = data;
          // } else {
          driverModel = data;
          request?.driver = data;
          activeReq?.driver = data;
          // }
          emit(GetNearestDriverSuccessState(driver: data));
        },
      );
    });
    on<UpdateUserRequestSheetEvent>((event, emit) {
      // TODO: implement event handler
      userRequestProcess = event.userReqProcess!;
      debugPrint('============> userRequestProcess: ${event.userReqProcess}');
      emit(UserRequestProcessChangedState(
          userRequestProcesses: event.userReqProcess));
    });
    on<CancelServiceRequest>((event, emit) async {
      // TODO: implement event handler
      emit(CancelRequestLoadingState());

      final result =
          await wenchServiceRepository.cancelServiceRequest(event.request!);

      await result.fold(
        (failure) {
          debugPrint(failure);
          HelpooInAppNotification.showMessage(
              message:
                  'لا يمكنك الغاء الطلب لانه قيد التنفيذ. اتصل بخدمة العملاء في حال وجود مشكله علي رقم 17000');
          emit(CancelRequestErrorState(error: failure));
          return null;
        },
        (data) {
          HelpooInAppNotification.showMessage(message: LocaleKeys.cancel.tr());

          timerMapUiUpdates?.cancel();
          NavigationService.navigatorKey.currentContext!
              .pushNamedAndRemoveUntil(PageRouteName.mainScreen);

          emit(CancelRequestSuccessState());
          return data;
        },
      );
    });
  }

  String? getRequestOriginalFees() {
    String? fees;
    if (selectedWenchType == WenchType.norm) {
      fees =
          calculateFeesModel != null && calculateFeesModel!.normPercent != '0'
              ? calculateFeesModel!.normOriginalFees
              : null;
    } else if (isCarService) {
      fees = calculateFeesModel != null && calculateFeesModel!.percent != '0'
          ? calculateFeesModel!.fees
          : null;
    } else if (otherServiceIds.isNotEmpty) {
      fees = calculateFeesOtherServiceModel != null &&
              calculateFeesOtherServiceModel!.discountPercent != 0
          ? calculateFeesOtherServiceModel!.originalFees.toString()
          : activeReq?.originalFees != null &&
                  activeReq?.discountPercentage != 0
              ? activeReq!.originalFees.toString()
              : null;
    } else {
      fees =
          calculateFeesModel != null && calculateFeesModel!.euroPercent != '0'
              ? calculateFeesModel!.euroOriginalFees
              : null;
    }
    return fees;
  }

  String getRequestFees() {
    if (otherServiceIds.isNotEmpty) {
      return calculateFeesOtherServiceModel != null
          ? calculateFeesOtherServiceModel!.fees.toString()
          : activeReq?.fees != null
              ? activeReq!.fees.toString()
              : '';
    }
    if (isCarService) {
      return calculateFeesModel != null
          ? calculateFeesModel!.originalFees.toString()
          : activeReq?.originalFees != null
              ? activeReq!.originalFees.toString()
              : '';
    }

    ///  print('hela ${activeReq == null} $selectedWenchType');
    if (activeReq == null) {
      // activeReq = request;
      ///calculateFeesModel = FeesResponseModel();
      request!.euroFees = calculateFeesModel!.euroFees!;
      request!.euroOriginalFees = calculateFeesModel!.euroOriginalFees!;
      request!.euroPercent = calculateFeesModel!.euroPercent!;
      request!.normFees = calculateFeesModel!.normFees!;
      request!.normOriginalFees = calculateFeesModel!.normOriginalFees!;
      request!.normPercent = calculateFeesModel!.normPercent!;
    } else {
      calculateFeesModel = FeesResponseModel();
      calculateFeesModel!.euroFees = activeReq!.euroFees;
      calculateFeesModel!.euroOriginalFees = activeReq!.euroOriginalFees;
      calculateFeesModel!.euroPercent = activeReq!.euroPercent;
      calculateFeesModel!.normFees = activeReq!.normFees;
      calculateFeesModel!.normOriginalFees = activeReq!.normOriginalFees;
      calculateFeesModel!.normPercent = activeReq!.normPercent;
    }

    String feesString = request!.fees.toString();
    //  print(selectedWenchType == WenchType.euro);
    if (selectedWenchType == WenchType.euro) {
      if (calculateFeesModel!.euroPercent != "" &&
          calculateFeesModel!.euroPercent != null) {
        feesString = calculateFeesModel != null
            ? calculateFeesModel!.euroFees!
            : activeReq!.euroFees;
      } else {
        feesString = calculateFeesModel != null
            ? calculateFeesModel!.euroOriginalFees!
            : activeReq!.euroOriginalFees;
      }
    } else {
      if (calculateFeesModel?.normPercent != "" &&
          calculateFeesModel?.normPercent != null) {
        feesString = calculateFeesModel != null
            ? calculateFeesModel!.normFees!
            : activeReq!.normFees;
      } else {
        feesString = calculateFeesModel != null
            ? calculateFeesModel!.normOriginalFees!
            : activeReq!.normOriginalFees;
      }
    }
    // print(feesString + ' feees');
    if (feesString.isNotEmpty) {
      if (activeReq == null) {
        request!.fees = int.parse(feesString);
      } else {
        activeReq!.fees = int.parse(feesString);
      }
    }
    return activeReq?.fees.toString() ?? request?.fees.toString() ?? '';
  }

  String returnStringAsHoursOrMinutes() {
    String s = '';

    if (localDistance != -1 && localDuration != -1) {
      if (localDistance.isNaN) {
        localDistancePerMinute = localDistance ~/ localDuration;
      }
    }

    if (localDurationTimer == null && localDuration != -1) {
      debugPrint('--->> init localDurationTimer');

      localDurationTimer = Timer.periodic(
        const Duration(minutes: 2),
        (timer) {
          if (localDuration != -1) {
            localDuration--;

            if (localDistancePerMinute != -1) {
              localDistance -= localDistancePerMinute;
            }

            ///emit(EmptyStateToRebuild());
          }
        },
      );
    }

    s += localDuration.toTimeMin();
    return s;
  }

  String returnStringAsKmOrMeters() {
    String s = '';

    s = localDistance.toDistanceKM();
    // s = '${(localDistance / 1000).toStringAsFixed(2)} ${'km'}';
    //  emit(ReturnStringAsKmOrMetersState());

    return s;
  }

  void launchDialPadWithPhoneNumber(String? phoneNumber) async {
    Uri phoneno = Uri.parse('tel:$phoneNumber');
    await launchUrl(phoneno);
  }

  String getRequestETA() {
    DateTime d = DateTime.now();
    int seconds = activeReq?.driverDirectionDetails != null
        ? activeReq!.driverDirectionDetails!.durationValue
        : int.parse(request!.requestLocationModel.timeToDest.toString());
    debugPrint('time minutes ===============> $seconds');
    d = d.add(Duration(seconds: seconds));
    return d.timeFormat;
  }

  int timer = -1;

  handleMapReqUiUpdates({required bool isCurrentReq}) async {
    if (activeReq != null) {
      if (activeReq!.opened ||
          activeReq!.canceled ||
          activeReq!.canceledWithPayment ||
          activeReq!.done ||
          activeReq!.rated) {
        cancelUpdateMapUiTimer();
      } else {
        await cacheHelper.put(
            '${activeReq!.id!}Duration', activeReq!.actualDuration.toDouble());

        if (await cacheHelper.get(
              '${activeReq!.id!}CounterForHit',
            ) !=
            null) {
          activeReq!.countForHit = await cacheHelper.get(
            '${activeReq!.id!}CounterForHit',
          );
        } else {
          activeReq!.countForHit = 0;
        }
        activeReq!.countForGetOne = 0;
        //int counterForGetOne = 0;
        activeReq!.actualDuration =
            await cacheHelper.get('${activeReq!.id!}Duration') ?? -1;
        activeReq!.actualDistance =
            await cacheHelper.get('${activeReq!.id!}Distance') ?? -1;
        timer =
            activeReq!.requestLocationModel.intervalsForNextHit?.toInt() ?? -1;
        timerMapUiUpdates = Timer.periodic(
          const Duration(seconds: 1),
          (timerUi) async {
            if (activeReq != null) {
              activeReq!.actualDuration =
                  await cacheHelper.get('${activeReq!.id!}Duration') ?? -1;
              activeReq!.actualDistance =
                  await cacheHelper.get('${activeReq!.id!}Distance') ?? -1;
              if (await cacheHelper.get(
                    '${activeReq!.id!}CounterForHit',
                  ) !=
                  null) {
                activeReq!.countForHit = await cacheHelper.get(
                  '${activeReq!.id!}CounterForHit',
                );
              }
              print('counterForHit');
              print(activeReq!.countForHit);
              print('timer for next hit');
              print(timer);
              print('actual duration');
              print(activeReq!.actualDuration);
              print('counterForGetOne');
              print(activeReq!.countForGetOne);
              //if(activeReq!.actualDuration>0)
              {
                timer = activeReq!.requestLocationModel.intervalsForNextHit
                        ?.toInt() ??
                    -1; /*((activeReq!.actualDuration > 3600)
                  ? 900
                  : (activeReq!.actualDuration < 3600 &&
                  activeReq!.actualDuration >= 1800)
                  ? 600
                  : (activeReq!.actualDuration < 1800 &&
                  activeReq!.actualDuration >= 600)
                  ? 300
                  : (activeReq!.actualDuration < 600 &&
                  activeReq!.actualDuration >= 10)
                  ? 120
                  : -1);*/
              }

              if (activeReq!.countForGetOne == 5) {
                activeReq!.countForGetOne = 0;
                if (activeReq != null) {
                  /// for (int i = 0; i < activeReq!.length; i++)
                  {
                    final result = await wenchServiceRepository
                        .getOneServiceRequest(serviceRequestId: activeReq!.id!);
                    await result.fold(
                      (failure) {
                        debugPrint(failure);

                        ///  return null;
                      },
                      (data) async {
                        activeReq = data.activeReq!;
                        timer = activeReq!
                                .requestLocationModel.intervalsForNextHit
                                ?.toInt() ??
                            -1;

                        {
                          if (activeReq != null) {
                            await checkIfGetTimeAndDistanceOrNot();
                          }
                        }
                        if (activeReq != null) {
                          if (activeReq!.arrived) {
                            await cacheHelper.put('${activeReq!.id!}Duration',
                                activeReq!.actualDuration.toDouble());
                            await cacheHelper.put('${activeReq!.id!}Distance',
                                activeReq!.actualDistance);
                            await cacheHelper.put(
                                '${activeReq!.id!}percentage', 100.0);
                            await cacheHelper.clear(
                              '${activeReq!.id!}CounterForHit',
                            );
                            wenchServiceBloc?.add(HandlingWaitingTimeEvent());
                          }
                          if (activeReq!.arrived || activeReq!.destArrived) {
                            print('here we go');
                            wenchServiceBloc?.add(HandlingWaitingTimeEvent());
                            //   wenchServiceBloc?.add(CheckIfGetTimeAndDistanceOrNotEvent());
                            //  wenchServiceBloc?.add(HandleRequestRoutesEvent());
                          }
                          if (activeReq!.done) {
                            await cacheHelper
                                .clear('${activeReq!.id!}Duration');
                            await cacheHelper
                                .clear('${activeReq!.id!}Distance');
                            await cacheHelper
                                .clear('${activeReq!.id!}percentage');
                            await cacheHelper.clear(
                              '${activeReq!.id!}CounterForHit',
                            );
                          }

                          if (activeReq!.started || activeReq!.accepted) {
                            double? lastLocalPercentage =
                                await sl<CacheHelper>()
                                    .get('${activeReq!.id}percentage');
                            if (lastLocalPercentage != null) {
                              activeReq!.currentGradientPercentage =
                                  lastLocalPercentage;
                            }
                            activeReq!.actualDuration = await cacheHelper
                                    .get('${activeReq!.id!}Duration') ??
                                -1;
                            activeReq!.actualDistance = await cacheHelper
                                    .get('${activeReq!.id!}Distance') ??
                                -1;
                          }
                        }
                        emit(GetRequestByIdSuccessState());

                        return data;
                      },
                    );
                  }
                }
              } else {
                activeReq!.countForGetOne++;
                if (activeReq!.accepted || activeReq!.started) {
                  if (activeReq!.countForHit == timer) {
                    activeReq!.countForHit = 0;
                    await cacheHelper.put('${activeReq!.id!}CounterForHit', 0);
                    await checkIfGetTimeAndDistanceOrNot(hit: true);
                    timer = activeReq!.requestLocationModel.intervalsForNextHit
                            ?.toInt() ??
                        -1;
                  } else {
                    activeReq!.countForHit++;
                    await cacheHelper.put('${activeReq!.id!}CounterForHit',
                        activeReq!.countForHit);
                  }
                }
              }
            }
          },
        );
      }
    }
  }

  checkIfGetTimeAndDistanceOrNot({hit = false}) async {
    /// we need to hit getRequestTimeAndDistance API in three cases
    /// 1. with the interval time
    /// 2. with status changed to handle the new route and simulate it
    /// 3. in case the driver go far of the route with 1 KM
    if (hit ||
        activeReq!.requestLocationModel.lastUpdatedDistanceAndDuration ==
            null ||
        (activeReq!.requestLocationModel.lastUpdatedDistanceAndDuration!
                    .lastUpdatedStatus ==
                ServiceRequestStatus.confirmed &&
            activeReq!.status == ServiceRequestStatus.accepted) ||
        (activeReq!.requestLocationModel.lastUpdatedDistanceAndDuration!
                    .lastUpdatedStatus ==
                ServiceRequestStatus.accepted &&
            activeReq!.status == ServiceRequestStatus.arrived) ||
        (activeReq!.requestLocationModel.lastUpdatedDistanceAndDuration!
                    .lastUpdatedStatus ==
                ServiceRequestStatus.arrived &&
            activeReq!.status == ServiceRequestStatus.started)) {
      if (activeReq!.arrived) {
        timerMapUiUpdates?.cancel();
      }
      if (activeReq!.confirmed || activeReq!.done) {
        activeReq!.fromForDTO = activeReq!.requestLocationModel.clientPoint!;
        if (otherServiceIds.isEmpty)
          activeReq!.toForDTO = activeReq!.requestLocationModel.destPoint!;
        else {
          activeReq!.toForDTO = activeReq!.requestLocationModel.clientPoint!;
        }
        if (activeReq!.done) {
          timerMapUiUpdates?.cancel();
        }
      } else if (activeReq!.accepted) {
        activeReq!.fromForDTO =
            LatLng(activeReq!.driver!.lat!, activeReq!.driver!.lng!);
        activeReq!.toForDTO = activeReq!.requestLocationModel.clientPoint!;
      } else {
        activeReq!.fromForDTO =
            LatLng(activeReq!.driver!.lat!, activeReq!.driver!.lng!);
        if (otherServiceIds.isNotEmpty) {
          activeReq!.toForDTO = activeReq!.requestLocationModel.clientPoint!;
        } else
          activeReq!.toForDTO = activeReq!.requestLocationModel.destPoint!;
      }
      if (activeReq?.fromForDTO != null) {
        GetRequestDurationAndDistanceDTO getRequestDurationAndDistanceDto =
            GetRequestDurationAndDistanceDTO(
          serviceRequestId: activeReq!.id!,
          oldStatus: activeReq?.activeReqModel?.oldRequestStatus != null
              ? activeReq!.activeReqModel!.oldRequestStatus!.enName
              : null,
          prevClientLocation: activeReq!.activeReqModel != null &&
                  activeReq!.activeReqModel!.firstClientLocation != null
              ? LatLng(
                  activeReq!.activeReqModel!.firstClientLocation!.latitude
                      .toDouble(),
                  activeReq!.activeReqModel!.firstClientLocation!.longitude
                      .toDouble())
              : null,
          oldDest: activeReq!.activeReqModel != null &&
                  activeReq!.activeReqModel!.firstClientDestination != null
              ? LatLng(
                  activeReq!.activeReqModel!.firstClientDestination!.latitude
                      .toDouble(),
                  activeReq!.activeReqModel!.firstClientDestination!.longitude
                      .toDouble())
              : null,
          driverLatLng: activeReq!.fromForDTO!,
          curClientLocation: activeReq!.toForDTO!,
        );
        await getRequestTimeAndDistance(
          getRequestDurationAndDistanceDto: getRequestDurationAndDistanceDto,
        ).then((value) async {
          final result = await wenchServiceRepository.getOneServiceRequest(
              serviceRequestId: activeReq!.id!);
          await result.fold(
            (failure) {
              debugPrint(failure);
              // emit(GetRequestByIdErrorState(error: failure));
              // wenchServiceBloc?.add(HandlingWaitingTimeEvent());
              return null;
            },
            (data) async {
              activeReq = data.activeReq!;
              activeReq!.activeReqModel = data;
              if (activeReq!.arrived) {
                await cacheHelper.put('${activeReq!.id!}Duration',
                    activeReq!.actualDuration.toDouble());
                await cacheHelper.put(
                    '${activeReq!.id!}Distance', activeReq!.actualDistance);
                await cacheHelper.put('${activeReq!.id!}percentage', 100.0);
                await cacheHelper.clear('${activeReq!.id!}Intervals');
                await cacheHelper.clear(
                  '${activeReq!.id!}V1',
                );
                await cacheHelper.clear(
                  '${activeReq!.id!}V2',
                );
                await cacheHelper.clear(
                  '${activeReq!.id!}V3',
                );
                await cacheHelper.clear(
                  '${activeReq!.id!}V4',
                );
              }
              if (activeReq!.done) {
                await cacheHelper.clear('${activeReq!.id!}Duration');
                await cacheHelper.clear('${activeReq!.id!}Distance');
                await cacheHelper.clear('${activeReq!.id!}percentage');
                await cacheHelper.clear('${activeReq!.id!}Intervals');
                await cacheHelper.clear(
                  '${activeReq!.id!}V1',
                );
                await cacheHelper.clear(
                  '${activeReq!.id!}V2',
                );
                await cacheHelper.clear(
                  '${activeReq!.id!}V3',
                );
                await cacheHelper.clear(
                  '${activeReq!.id!}V4',
                );
              }
              if (activeReq!.started || activeReq!.accepted) {
                /*      if (await cacheHelper.get('${activeReq!.id!}Duration') ==
                        null ||
                    cacheHelper.get('${activeReq!.id!}Duration').toString() ==
                        "" ||
                    await cacheHelper.get('${activeReq!.id!}Duration') == -1)*/
                {
                  await cacheHelper.put('${activeReq!.id!}Duration',
                      activeReq!.actualDuration.toDouble());
                  await cacheHelper.put(
                      '${activeReq!.id!}Distance', activeReq!.actualDistance);

                  ///     handleMapReqUiUpdates(isCurrentReq: true);
                  ///startTimerServiceRequest();
                }
              }
              emit(GetRequestByIdSuccessState());

              return data;
            },
          );
        });
        print('hit 1');
      }

      /* await homeRepository.getOneServiceRequest(
          serviceRequestId: activeReq!.id!);*/
    } else {
      if (activeReq!.accepted) {
        activeReq!.fromForDTO =
            LatLng(activeReq!.driver!.lat!, activeReq!.driver!.lng!);
        activeReq!.toForDTO = activeReq!.requestLocationModel.clientPoint!;
        if (activeReq!.requestLocationModel.firstUpdatedDistanceAndDuration ==
            null) {
          GetRequestDurationAndDistanceDTO getRequestDurationAndDistanceDto =
              GetRequestDurationAndDistanceDTO(
            serviceRequestId: activeReq!.id!,
            oldStatus: activeReq!.activeReqModel != null
                ? activeReq!.activeReqModel!.oldRequestStatus!.enName
                : null,
            prevClientLocation: activeReq!.activeReqModel != null &&
                    activeReq!.activeReqModel!.firstClientLocation != null
                ? LatLng(
                    activeReq!.activeReqModel!.firstClientLocation!.latitude
                        .toDouble(),
                    activeReq!.activeReqModel!.firstClientLocation!.longitude
                        .toDouble())
                : null,
            oldDest: activeReq!.activeReqModel != null &&
                    activeReq!.activeReqModel!.firstClientDestination != null
                ? LatLng(
                    activeReq!.activeReqModel!.firstClientDestination!.latitude
                        .toDouble(),
                    activeReq!.activeReqModel!.firstClientDestination!.longitude
                        .toDouble())
                : null,
            driverLatLng: activeReq!.fromForDTO!,
            curClientLocation: activeReq!.toForDTO!,
          );
          await getRequestTimeAndDistance(
            getRequestDurationAndDistanceDto: getRequestDurationAndDistanceDto,
          );
          print('hit 2');
          wenchServiceBloc?.add(
              GetRequestByIdEvent(activeReqId: activeReq!.id!.toString()));
        }

        /// startAcceptTimer();
      } else if (activeReq!.started) {
        activeReq!.fromForDTO =
            LatLng(activeReq!.driver!.lat!, activeReq!.driver!.lng!);
        if (otherServiceIds.isNotEmpty)
          activeReq!.toForDTO = activeReq!.requestLocationModel.clientPoint!;
        else
          activeReq!.toForDTO = activeReq!.requestLocationModel.destPoint!;
        wenchServiceBloc
            ?.add(GetRequestByIdEvent(activeReqId: activeReq!.id!.toString()));
      }
    }
    if (activeReq!.requestLocationModel.lastUpdatedDistanceAndDuration
                ?.driverDistanceMatrix?.distance!.value !=
            null &&
        activeReq!.requestLocationModel.lastUpdatedDistanceAndDuration
                ?.driverDistanceMatrix?.duration !=
            null) {
      /// handleTimeAndDistanceSimulation(i);
    }

    ///  emit(CheckIfGetNewTimeAndDistanceState());
  }

  startStartTimer() async {
    int statusStatrtedDuration =
        activeReq!.requestLocationModel.timeToDest ?? 0;

    int intervalInSeconds = statusStatrtedDuration ~/ 4;

    DateTime TimeOfLastUpdate = DateTime.parse(activeReq!
            .requestLocationModel.lastUpdatedDistanceAndDuration!.createdAt!)
        .toUtc();
    DateTime currentTimeUtc = DateTime.now().toUtc();
    int secondsFromLastUpdate =
        currentTimeUtc.difference(TimeOfLastUpdate).inSeconds;

    if (secondsFromLastUpdate >= intervalInSeconds) {
      GetRequestDurationAndDistanceDTO getRequestDurationAndDistanceDto =
          GetRequestDurationAndDistanceDTO(
        serviceRequestId: activeReq!.id!,
        oldStatus: activeReqModel != null
            ? activeReqModel!.oldRequestStatus!.enName
            : null,
        prevClientLocation: activeReqModel != null &&
                activeReqModel!.firstClientLocation != null
            ? LatLng(activeReqModel!.firstClientLocation!.latitude.toDouble(),
                activeReqModel!.firstClientLocation!.longitude.toDouble())
            : null,
        oldDest: activeReqModel != null &&
                activeReqModel!.firstClientDestination != null
            ? LatLng(
                activeReqModel!.firstClientDestination!.latitude.toDouble(),
                activeReqModel!.firstClientDestination!.longitude.toDouble())
            : null,
        driverLatLng: fromForDTO!,
        curClientLocation: toForDTO!,
      );
      /*  wenchServiceBloc?.add(GetRequestTimeAndDistanceEvent(
          getRequestDurationAndDistanceDto: getRequestDurationAndDistanceDto));
*/
      await getRequestTimeAndDistance(
          getRequestDurationAndDistanceDto: getRequestDurationAndDistanceDto);
    }
  }

  void cancelUpdateMapUiTimer() {
    if (timerMapUiUpdates != null) {
      timerMapUiUpdates!.cancel();
    }
  }

  void animateCameraToShowAnyMapPath({
    required LatLng from,
    required LatLng to,
  }) async {
    northEastLatitude = 0;
    northEastLongitude = 0;
    southWestLatitude = 0;
    southWestLongitude = 0;

    double miny = (from.latitude <= to.latitude) ? from.latitude : to.latitude;
    double minx =
        (from.longitude <= to.longitude) ? from.longitude : to.longitude;
    double maxy = (from.latitude <= to.latitude) ? to.latitude : from.latitude;
    double maxx =
        (from.longitude <= to.longitude) ? to.longitude : from.longitude;

    southWestLatitude = miny;
    southWestLongitude = minx;
    northEastLatitude = maxy;
    northEastLongitude = maxx;

    // the bounds you want to set
    LatLngBounds bounds = LatLngBounds(
      northeast: LatLng(northEastLatitude, northEastLongitude),
      southwest: LatLng(southWestLatitude, southWestLongitude),
    );

    // calculating centre of the bounds
    LatLng centerBounds = LatLng(
        (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2);
    await handleRequestRoutes(
        from: from, to: to); //_zoomToFit(mapController!, bounds, centerBounds);
  }

  Future<void> handleRouteZoom({mapPointsToShowPoints}) async {
    // Create a LatLngBounds that includes all the points in your route.

    if (otherServiceIds.isNotEmpty &&
        activeReq?.status != ServiceRequestStatus.accepted) {
      return;
    }
    if (mapPointsToShowPoints != null) {
      mapPointsToShow = mapPointsToShowPoints;
    } else if (getDistanceAndDurationResponse?.points != null) {
      /// print('starting fomr here');
      mapPointsToShow = getDistanceAndDurationResponse!.points!;
    }

    if (mapPointsToShow?.isNotEmpty ?? false) {
      ///  print('starting fomr here2');
      ///  print(mapPointsToShowPoints);
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          mapPointsToShow!
              .map((point) => point.latitude)
              .reduce((a, b) => a < b ? a : b),
          mapPointsToShow!
              .map((point) => point.longitude)
              .reduce((a, b) => a < b ? a : b),
        ),
        northeast: LatLng(
          mapPointsToShow!
              .map((point) => point.latitude)
              .reduce((a, b) => a > b ? a : b),
          mapPointsToShow!
              .map((point) => point.longitude)
              .reduce((a, b) => a > b ? a : b),
        ),
      );

      // Calculate padding for the Google Map camera position.
      double padding = 50.0;

      // Move the camera to show the entire route with padding.
      if (mapController != null) {
        try {
          Future.delayed(const Duration(seconds: 1), () async {
            try {
              await mapController?.animateCamera(
                  CameraUpdate.newLatLngBounds(bounds, padding));
            } catch (e) {
              print('error here wench_service_bloc--> ${e}');
            }
          });
        } catch (e) {
          print('error is here omaar');
          print(e);
        }
      }
    }
  }

  void trimRoute() async {
    // Find the closest segment to the driver's location
    double minDistance = double.infinity;
    int closestSegmentIndex = 0;

    for (int i = 0; i < mapPointsToShow!.length - 1; i++) {
      double distanceInMeters = Geolocator.distanceBetween(
        activeReq!.driver?.lat ??
            activeReq!.requestLocationModel.destPoint!.latitude,
        activeReq!.driver?.lng ??
            activeReq!.requestLocationModel.destPoint!.longitude,
        mapPointsToShow![i].latitude,
        mapPointsToShow![i].longitude,
      );
      if (distanceInMeters < minDistance) {
        minDistance = distanceInMeters;
        closestSegmentIndex = i;
      }
    }

    // Trim the route to include only the segments from the closest one onward
    mapPointsToShow = mapPointsToShow!.sublist(closestSegmentIndex);
    PolylineId id = PolylineId('polylineId');

    Polyline polyline = Polyline(
      polylineId: id,
      color:
          Theme.of(NavigationService.navigatorKey.currentContext!).primaryColor,
      points: mapPointsToShow!,
      width: 4,
    );
    googleMapsModel.polylines = {};
    googleMapsModel.polylines.add(polyline);
    await handleRouteZoom(mapPointsToShowPoints: mapPointsToShow);
  }

  handleRequestRoutes({required from, required to}) async {
    if (mapController != null) {
      //  print('mr omar welcom');
      // try {
      // if (activeReq!.arrived || activeReq!.started) {
      // } else {
      activeReq ??= request;
      if (activeReq!.canceled || activeReq!.done) {
        mapPointsToShow = activeReq!.requestLocationModel.pointsClientToDest;
      } else if (getDistanceAndDurationResponse != null) {
        mapPointsToShow = getDistanceAndDurationResponse!.points!;
      } else {
        if (activeReq!.requestLocationModel.lastUpdatedDistanceAndDuration !=
            null) {
          if (!activeReq!.started ||
              !activeReq!.arrived ||
              activeReq!.accepted) {
            mapPointsToShow =
                activeReq!.requestLocationModel.pointsClientToDest;
          } else {
            mapPointsToShow = activeReq!
                .requestLocationModel.lastUpdatedDistanceAndDuration?.points;
          }
        } else {
          mapPointsToShow = activeReq!.requestLocationModel.pointsClientToDest;
        }
      }
      PolylineId id = PolylineId('polylineId');

      final points = !activeReq!.accepted
          ? activeReq!.requestLocationModel.pointsClientToDest ?? []
          : getDistanceAndDurationResponse!.points!;
      Polyline polyline = Polyline(
        polylineId: id,
        color: Theme.of(NavigationService.navigatorKey.currentContext!)
            .primaryColor,
        //points: mapPointsToShow!,
        points: points,
        width: 4,
      );
      final startBearing = Geolocator.bearingBetween(
        points.first.latitude,
        points.first.longitude,
        points[1].latitude,
        points[1].longitude,
      );
      final endBearing = Geolocator.bearingBetween(
        points[points.length - 2].latitude,
        points[points.length - 2].longitude,
        points.last.latitude,
        points.last.longitude,
      );

      if (activeReqModel != null &&
          activeReqModel!.firstClientDestination != null) {
        if (activeReqModel!.oldRequestStatus ==
            ServiceRequestStatus.destArrived) {
          googleMapsModel.polylines.add(polyline);
          trimRoute();
        } else {
          // googleMapsModel.polylines = {};
        }
        googleMapsModel.markers = {};

        /* BitmapDescriptor start = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration.empty,
          "assets/images/wench.png",
        );
        Marker startMarker = Marker(
          markerId: MarkerId('start'),
          position: from,
          visible: true,
          icon: start,
        );
        googleMapsModel.markers.add(startMarker);*/
        drawAnyMapPathMarkers(
          startIconPath: Platform.isIOS
              ? "assets/images/pin_ios.png"
              : "assets/images/pin_android.png",
          endIconPath: Platform.isIOS
              ? "assets/images/client_car_ios.png"
              : "assets/images/client_car.png",
          startMarkerCoord: to!,
          endMarkerCoord: from!,
          heading: 0.0,
          bearing: endBearing,
        );
      } else {
        googleMapsModel.polylines = {};
        googleMapsModel.polylines.add(polyline);
        // trimRoute();
        if (activeReq!.accepted) {
          from = LatLng(activeReq!.driver!.lat!, activeReq!.driver!.lng!);
          to = activeReq!.requestLocationModel.clientPoint!;
          drawAnyMapPathMarkers(
            startIconPath: isCarService
                ? Platform.isIOS
                    ? "assets/images/n300_marker_ios.png"
                    : "assets/images/n300_marker.png"
                : Platform.isIOS
                    ? "assets/images/wench_ios.png"
                    : "assets/images/wench.png",
            endIconPath: Platform.isIOS
                ? "assets/images/client_car_ios.png"
                : "assets/images/client_car.png",
            startMarkerCoord: from,
            endMarkerCoord: to,
            heading: startBearing,
            bearing: endBearing,
          );

          trimRoute();
        } else if (activeReq!.arrived ||
            activeReq!.started ||
            activeReq!.destArrived) {
          from = LatLng(activeReq!.driver!.lat!, activeReq!.driver!.lng!);
          to = activeReq!.requestLocationModel.destPoint!;

          await drawAnyMapPathMarkers(
            startIconPath: isCarService
                ? Platform.isIOS
                    ? "assets/images/n300_marker_ios.png"
                    : "assets/images/n300_marker.png"
                : Platform.isIOS
                    ? "assets/images/wench_with_car_ios.png"
                    : "assets/images/wench_with_car.png",
            endIconPath: Platform.isIOS
                ? "assets/images/pin_ios.png"
                : "assets/images/pin_android.png",
            startMarkerCoord: from,
            endMarkerCoord: to,
            heading: startBearing,
          );
          trimRoute();
        } else {
          from = activeReq!.requestLocationModel.clientPoint!;
          to = activeReq!.requestLocationModel.destPoint!;
          drawAnyMapPathMarkers(
            startIconPath: Platform.isIOS
                ? "assets/images/client_car_ios.png"
                : "assets/images/client_car.png",
            endIconPath: Platform.isIOS
                ? "assets/images/pin_ios.png"
                : "assets/images/pin_android.png",
            startMarkerCoord: from,
            endMarkerCoord: to,
            heading: startBearing,
          );
        }

        await handleRouteZoom(
            mapPointsToShowPoints:
                activeReq?.requestLocationModel.pointsClientToDest);
      }
      // emit(UpdateMapState());
      // } catch (e) {
      //   emit(GetDriverPathToDrawError(error: e.toString()));
      // }
    }
  }

  drawAnyMapPathMarkers({
    required String startIconPath,
    required String endIconPath,
    required LatLng startMarkerCoord,
    required LatLng endMarkerCoord,
    required double? heading,
    double? bearing,
  }) async {
    BitmapDescriptor start = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      startIconPath,
    );
    BitmapDescriptor end = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      endIconPath,
    );

    Marker startMarker = Marker(
      markerId: MarkerId('start'),
      infoWindow: InfoWindow(title: 'start'),
      position: startMarkerCoord,
      visible: true,
      icon: start,
      flat: true,
      rotation: heading ??
          0.0, /*Geolocator.bearingBetween(
          startMarkerCoord.latitude* (pi / 180),
          startMarkerCoord.longitude* (pi / 180),
          endMarkerCoord.latitude* (pi / 180),
          endMarkerCoord.longitude* (pi / 180),
        ).toDouble()*/ //startMarkerCoord.longitude,
    );
    Marker endMarker = Marker(
      markerId: MarkerId('end'),
      position: endMarkerCoord,
      visible: true,
      flat: true,
      infoWindow: InfoWindow(title: 'end'),
      rotation: bearing ?? 0.0,
      /* rotation: Geolocator.bearingBetween(
        startMarkerCoord.latitude,
        startMarkerCoord.longitude,
        endMarkerCoord.latitude,
        endMarkerCoord.longitude,
      ).toDouble(),*/
      //endMarkerCoord.longitude,
      icon: end,
    );
    if (activeReqModel?.oldRequestStatus == null) {
      googleMapsModel.markers.clear();
      googleMapsModel.markers.add(startMarker);
      googleMapsModel.markers.add(endMarker);
    }

    //emit(AddMarkerSuccess());
  }

  startAcceptTimer() async {
    print('accept timer');
    activeReq!.localDuration =
        await cacheHelper.get('${activeReq!.id!}Duration') ?? -1;
    activeReq!.intervalInSeconds =
        await cacheHelper.get('${activeReq!.id!}Intervals');

    print('activeReq!.localDuration wench bloc');
    print(activeReq!.localDuration);
    if (activeReq!.localDuration.toString() != "" &&
        activeReq!.localDuration != -1 &&
        activeReq!.intervalInSeconds == null) {
      activeReq!.intervalInSeconds = activeReq!.localDuration ~/ 4;
      print('intervals from local');
      print(activeReq!.intervalInSeconds);

      await cacheHelper.put(
          '${activeReq!.id!}Intervals', activeReq!.actualDuration ~/ 4);

      await cacheHelper.put(
          '${activeReq!.id!}V1',
          DateTime.now()
              .add(Duration(seconds: activeReq!.intervalInSeconds!))
              .toString()
              .split('.')[0]);
      await cacheHelper.put(
          '${activeReq!.id!}V2',
          DateTime.now()
              .add(Duration(seconds: activeReq!.intervalInSeconds! * 2))
              .toString()
              .split('.')[0]);
      await cacheHelper.put(
          '${activeReq!.id!}V3',
          DateTime.now()
              .add(Duration(seconds: activeReq!.intervalInSeconds! * 3))
              .toString()
              .split('.')[0]);
      await cacheHelper.put(
          '${activeReq!.id!}V4',
          DateTime.now()
              .add(Duration(seconds: activeReq!.intervalInSeconds! * 4))
              .toString()
              .split('.')[0]);
    }
    print('activeReq!.v1');
    print((await cacheHelper.get('${activeReq!.id!}V1')));
    print((await cacheHelper.get('${activeReq!.id!}V2')));
    print((await cacheHelper.get('${activeReq!.id!}V3')));
    print((await cacheHelper.get('${activeReq!.id!}V4')));
    print('current Time:');
    print(DateTime.now().toString().split('.')[0]);
    print(DateTime.now().toString().split('.')[0] ==
        (await cacheHelper.get('${activeReq!.id!}V1')));
    print(DateTime.now().toString().split('.')[0] ==
        (await cacheHelper.get('${activeReq!.id!}V2')));
    print(DateTime.now().toString().split('.')[0] ==
        (await cacheHelper.get('${activeReq!.id!}V3')));
    print(DateTime.now().toString().split('.')[0] ==
        (await cacheHelper.get('${activeReq!.id!}V4')));

    print('xxx 1 ${activeReq!.localDuration}');
    print('xxx 2 ${activeReq!.intervalInSeconds?.toInt()}');

    if (DateTime.now().toString().split('.')[0] ==
                (await cacheHelper.get('${activeReq!.id!}V1')) ||
            DateTime.now().toString().split('.')[0] ==
                (await cacheHelper.get('${activeReq!.id!}V2')) ||
            DateTime.now().toString().split('.')[0] ==
                (await cacheHelper.get('${activeReq!.id!}V3')) ||
            DateTime.now().toString().split('.')[0] ==
                (await cacheHelper.get('${activeReq!.id!}V4'))
        //activeReq!.secondsFromLastUpdate! == activeReq!.intervalInSeconds!
        // activeReq!.localDuration != 0 && activeReq!.localDuration % activeReq!.intervalInSeconds!.toInt() == 0
        //activeReq!.secondsFromLastUpdate! >= activeReq!.intervalInSeconds!
        ) {
      print('hit 4');
    }
  }

  double calculateWaitingPrice(int totalMinutes) {
    print("waitingTimeFree   " + config!.waitingTimeFree.toString());
    print("waitingTimeLimit   " + config!.waitingTimeLimit.toString());
    print("waitingTimePrice   " + config!.waitingTimePrice.toString());
    final int freeMinutes = config!.waitingTimeFree!;
    final double costPerEveryLimitMinutes =
        config!.waitingTimePrice!.toDouble();

    if (totalMinutes <= freeMinutes) {
      return 0.0; // The first 15 minutes are free
    }

    // Calculate the number of additional 15-minute blocks beyond the first 15 minutes
    final int additionalMinutes = totalMinutes - freeMinutes;
    final int additionalBlocks =
        (additionalMinutes / config!.waitingTimeLimit!).ceil();

    // final int additionalBlocks =
    //  ((totalMinutes - freeMinutes + (config!.waitingTimeLimit! - 1)) / config!.waitingTimeLimit!).ceil();

    // Calculate the total price
    final double totalPrice = additionalBlocks * costPerEveryLimitMinutes;

    return totalPrice;
  }

  clearMapRequestData() {
    //clearRequestDateIsLoading = true;
    request = ServiceRequest();
    historyRequestModel = ServiceRequest();
    activeReq = null;
    googleMapsModel = GoogleMapsModel();
    originController.clear();
    destinationController.clear();
    mapSearchFnolTextFieldCtrl.clear();
    currentLocationTextFieldCtrl.clear();
    destinationLocationTextFieldCtrl.clear();
    cancelUpdateMapUiTimer();
    //updateUserRequestSheetState(UserRequestProcesses.none);
    //clearRequestDateIsLoading = false;
  }

  onCameraIdle() async {
    mapPickerController.mapFinishedMoving!();
    emit(CameraIdleDone());
  }

  onCameraMoveStarted() async {
    mapPickerController.mapMoving!();
  }

  onCameraMove({
    required CameraPosition cameraPositionValue,
  }) async {
    cameraPosition = cameraPositionValue;
    cameraMovementPosition = cameraPositionValue.target;
    if (wenchServiceBloc?.isClosed ?? true) {
    } else {
      emit(CameraMoveStartedState());
    }
  }

  void setMapController({
    required GoogleMapController controller,
  }) async {
    mapController = controller;

    if (mapController != null && cameraPosition != null) {
      mapController!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition!));
    }

    emit(SetMapControllerSuccess());
  }

  bool validateRequestMapPick() {
    if (request?.requestLocationModel.clientPoint != null) return true;

    return false;
  }

  bool validateRequestMapPickAndDestPoints() {
    if (request?.requestLocationModel.destPoint != null &&
        request?.requestLocationModel.clientPoint != null) {
      return true;
    }
    return false;
  }

  Future<void> drawLinesFromClientToDestination() async {
    emit(DrawRequestPathLoadingState());
    GetRequestDurationAndDistanceDTO getRequestDurationAndDistanceDto =
        GetRequestDurationAndDistanceDTO(
      driverLatLng: request?.requestLocationModel.clientPoint ??
          activeReq!.requestLocationModel.clientPoint!,
      curClientLocation: request?.requestLocationModel.destPoint ??
          activeReq!.requestLocationModel.destPoint!,
    );
    await getRequestTimeAndDistance(
        getRequestDurationAndDistanceDto: getRequestDurationAndDistanceDto);
    request?.requestLocationModel.timeToDest =
        getDistanceAndDurationResponse!.driverDistanceMatrix!.duration!.value;
    request?.requestLocationModel.distanceToDest =
        getDistanceAndDurationResponse!.driverDistanceMatrix!.distance!.value;
    request?.requestLocationModel.pointsClientToDest =
        getDistanceAndDurationResponse!.points;
    final success = await getServiceRequestFeesImpl();
    if (!success) {
      emit(DrawRequestPathSuccessState());
      return;
    }
    await drawMapPath(getDistanceAndDurationResponse!.points!);
    wenchServiceBloc?.panelController.open();
    emit(DrawRequestPathSuccessState());
  }

  List<int> otherServiceIds = [];
  FeesOtherServiceResponseModel? calculateFeesOtherServiceModel;
  Future<void> GetNearestDriverOtherService() async {
    emit(GetNearestDriverLoadingState());
    final clientPoint = request?.requestLocationModel.clientPoint;
    final location =
        Location(lat: clientPoint!.latitude, lng: clientPoint.longitude);
    final response = await wenchServiceRepository.getDriverDetails(
        otherServiceIds, location);

    response.fold(
      (l) {
        emit(GetNearestDriverErrorState(error: l.toString()));
      },
      (r) async {
        final Map<String, int> services = {};
        for (int i = 0; i < otherServiceIds.length; i++) {
          services.addAll({otherServiceIds[i].toString(): 1});
        }
        String error = "";
        final getFeesResponse =
            await wenchServiceRepository.getOtherServiceRequestFees(
          userId: int.parse(await cacheHelper.get(Keys.currentUserId)),
          carId: selectedCarToRequest!.id!,
          distance: r.distance!.toJson(),
          services: services,
        );
        getFeesResponse.fold(
          (l) {
            debugPrint(l);
            error = l.toString();
          },
          (r) {
            calculateFeesOtherServiceModel = r;
          },
        );
        if (getFeesResponse.isLeft())
          emit(GetNearestDriverErrorState(error: error));
        else {
          userRequestProcess = UserRequestProcesses.otherService;
          driverModel = r;
          request?.driver = r;
          activeReq?.driver = r;
          panelController.open();
          emit(GetNearestDriverSuccessState(driver: r));
        }
      },
    );
  }

  static const carServiceId = 6;
  Future<bool> getServiceRequestFeesImpl({bool updateSheet = true}) async {
    emit(GetRequestFeesLoadingState());

    final result = await wenchServiceRepository.getServiceRequestFees(
      serviceId: isCarService ? carServiceId : null,
      userId: int.parse(await cacheHelper.get(Keys.currentUserId)),
      carId: selectedCarToRequest!.id!,
      destinationDistance: json.encode({
        'distance': {
          'value': request?.requestLocationModel.distanceToDest.toString(),
        }
      }),
      distance: "",
    );
    result.fold((l) {
      debugPrint(l);
      emit(GetRequestFeesErrorState(error: l.toString()));
      return false;
    }, (r) {
      calculateFeesModel = r;
      if (userRequestProcess != UserRequestProcesses.whichWench) {
        getRequestOriginalFees();
        getRequestFees();
      }

      if (updateSheet) {
        if (isCarService) {
          panelController.open();
          userRequestProcess = UserRequestProcesses.selectedWenchDetails;
        } else
          userRequestProcess = UserRequestProcesses.whichWench;
      }
      emit(GetRequestFeesSuccessState());
      return true;
    });
    return true;
  }

  Future<void> drawMapPath(List<LatLng> points) async {
    // inits
    mapPointsToShow = points;
    googleMapsModel.polylineCoordinates.clear();
    googleMapsModel.polylines.clear();
    googleMapsModel.markers.clear();
    PolylinePoints polylinePoints = PolylinePoints();
    // shortcuts for lats and lngs
    double? cLat = request?.requestLocationModel.clientPoint?.latitude;
    double? cLng = request?.requestLocationModel.clientPoint?.longitude;
    double? dLat = request?.requestLocationModel.destPoint?.latitude;
    double? dLng = request?.requestLocationModel.destPoint?.longitude;
    // make two map marker
    BitmapDescriptor pickupMarkerbitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      Platform.isIOS
          ? "assets/images/client_car_ios.png"
          : "assets/images/client_car.png",
    );
    BitmapDescriptor destinationMarkerbitmap =
        await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      Platform.isIOS
          ? "assets/images/pin_ios.png"
          : "assets/images/pin_android.png",
    );
    Marker pickupMarker = Marker(
      markerId: MarkerId('pickup'),
      position: LatLng(cLat!, cLng!),
      visible: true,
      icon: pickupMarkerbitmap,
    );
    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: LatLng(dLat!, dLng!),
      visible: true,
      icon: destinationMarkerbitmap,
    );
    googleMapsModel.markers.add(pickupMarker);
    googleMapsModel.markers.add(destinationMarker);
    Polyline polyLine = Polyline(
      polylineId: PolylineId('polyid'),
      color: ColorsManager.mainColor,
      points: points,
      // points: googleMapsModel.polylineCoordinates,
      jointType: JointType.round,
      width: 4,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );

    googleMapsModel.polylines.add(polyLine);

    if (mapController != null) {
      await handleRouteZoom(mapPointsToShowPoints: points);
      //  mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
    }
  }

  void addServiceMarkerAndAnimate() async {
    final serviceLocation = activeReq?.requestLocationModel.clientPoint;
    BitmapDescriptor serviceMarkerbitmap =
        await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      Platform.isIOS
          ? "assets/images/pin_ios.png"
          : "assets/images/pin_android.png",
    );
    if (serviceLocation != null) {
      Marker pickupMarker = Marker(
        markerId: MarkerId('pickup'),
        position: serviceLocation,
        visible: true,
        icon: serviceMarkerbitmap,
      );
      googleMapsModel.markers = {};
      googleMapsModel.markers.add(pickupMarker);
      cameraPosition = CameraPosition(
        target: serviceLocation,
        zoom: 16,
      );
      if (mapController != null) {
        mapController!
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition!));
      }
    }
  }

  Future getRequestTimeAndDistance({
    required GetRequestDurationAndDistanceDTO getRequestDurationAndDistanceDto,
  }) async {
    if (otherServiceIds.isNotEmpty) {
      return await getRequestTimeAndDistanceOtherService(
          getRequestDurationAndDistanceDto: getRequestDurationAndDistanceDto);
    }
    final result = await wenchServiceRepository.getRequestTimeAndDistance(
        getRequestDurationAndDistanceDto: getRequestDurationAndDistanceDto);

    result.fold(
      (failure) {
        debugPrint(failure);
      },
      (data) async {
        print(
            'driver duration: ${data.distanceAndDuration!.driverDistanceMatrix?.duration?.value}');
        print(
            'driver distance: ${data.distanceAndDuration!.driverDistanceMatrix?.distance?.value}');
        print('move value: ${data.distanceAndDuration?.move}');
        getDistanceAndDurationResponse = data.distanceAndDuration!;
        localDistance = getDistanceAndDurationResponse!
            .driverDistanceMatrix!.distance!.value!;
        localDuration = getDistanceAndDurationResponse!
            .driverDistanceMatrix!.duration!.value!;
        if (activeReq != null) {
          activeReq!.getDistanceAndDurationResponse = data.distanceAndDuration!;
          activeReq!.actualDistance = activeReq!.getDistanceAndDurationResponse!
              .driverDistanceMatrix!.distance!.value!;
          activeReq!.actualDuration = activeReq!.getDistanceAndDurationResponse!
              .driverDistanceMatrix!.duration!.value!;

          print('cacheHelper.get(${activeReq!.id!}Duration)');
          print(await cacheHelper.get('${activeReq!.id!}Duration'));
          if (activeReq!.started || activeReq!.accepted) {
            double? lastLocalPercentage =
                await sl<CacheHelper>().get('${activeReq!.id}percentage');
            if (lastLocalPercentage != null) {
              activeReq!.currentGradientPercentage = lastLocalPercentage;
            }
            {
              {
                activeReq!.diffLastHitAndCurrentLocal = 0;
              }

              await cacheHelper.put('${activeReq!.id!}Duration',
                  activeReq!.actualDuration.toDouble());
              await cacheHelper.put(
                  '${activeReq!.id!}Distance', activeReq!.actualDistance);
              if (data.distanceAndDuration?.move != null) {
                if (data.distanceAndDuration!.move! &&
                    activeReq!.currentGradientPercentage! > 0) {
                  activeReq!.currentGradientPercentage =
                      (activeReq!.currentGradientPercentage!) - 15;

                  await cacheHelper.put('${activeReq!.id!}percentage',
                      activeReq!.currentGradientPercentage);
                } else {
                  if (data.distanceAndDuration?.moveAfter != null &&
                      data.distanceAndDuration?.moveAfter != 0 &&
                      activeReq!.currentGradientPercentage! > 0) {
                    Future.delayed(
                      Duration(seconds: data.distanceAndDuration!.moveAfter!),
                      () {
                        activeReq!.currentGradientPercentage =
                            (activeReq!.currentGradientPercentage!) - 15;
                      },
                    );
                  }
                }
              }
              timer = activeReq!.requestLocationModel.intervalsForNextHit
                      ?.toInt() ??
                  -1;
            }
          }
        }
        emit(GetRequestTimeAndDistanceByIdSuccessState());
      },
    );
  }

  Future getRequestTimeAndDistanceOtherService({
    required GetRequestDurationAndDistanceDTO getRequestDurationAndDistanceDto,
  }) async {
    final result =
        await wenchServiceRepository.getRequestTimeAndDistanceOtherService(
            getRequestDurationAndDistanceDto: getRequestDurationAndDistanceDto);

    result.fold(
      (failure) {
        debugPrint(failure);
      },
      (data) async {
        print(
            'driver duration: ${data.distanceAndDuration!.driverDistanceMatrix?.duration?.value}');
        print(
            'driver distance: ${data.distanceAndDuration!.driverDistanceMatrix?.distance?.value}');
        print('move value: ${data.distanceAndDuration?.move}');
        getDistanceAndDurationResponse = data.distanceAndDuration!;
        localDistance = getDistanceAndDurationResponse!
            .driverDistanceMatrix!.distance!.value!;
        localDuration = getDistanceAndDurationResponse!
            .driverDistanceMatrix!.duration!.value!;
        if (activeReq != null) {
          activeReq!.getDistanceAndDurationResponse = data.distanceAndDuration!;
          activeReq!.actualDistance = activeReq!.getDistanceAndDurationResponse!
              .driverDistanceMatrix!.distance!.value!;
          activeReq!.actualDuration = activeReq!.getDistanceAndDurationResponse!
              .driverDistanceMatrix!.duration!.value!;

          print('cacheHelper.get(${activeReq!.id!}Duration)');
          print(await cacheHelper.get('${activeReq!.id!}Duration'));
          if (activeReq!.started || activeReq!.accepted) {
            double? lastLocalPercentage =
                await sl<CacheHelper>().get('${activeReq!.id}percentage');
            if (lastLocalPercentage != null) {
              activeReq!.currentGradientPercentage = lastLocalPercentage;
            }
            {
              {
                activeReq!.diffLastHitAndCurrentLocal = 0;
              }

              await cacheHelper.put('${activeReq!.id!}Duration',
                  activeReq!.actualDuration.toDouble());
              await cacheHelper.put(
                  '${activeReq!.id!}Distance', activeReq!.actualDistance);
              if (data.distanceAndDuration?.move != null) {
                if (data.distanceAndDuration!.move! &&
                    activeReq!.currentGradientPercentage! > 0) {
                  activeReq!.currentGradientPercentage =
                      (activeReq!.currentGradientPercentage!) - 15;

                  await cacheHelper.put('${activeReq!.id!}percentage',
                      activeReq!.currentGradientPercentage);
                } else {
                  if (data.distanceAndDuration?.moveAfter != null &&
                      data.distanceAndDuration?.moveAfter != 0 &&
                      activeReq!.currentGradientPercentage! > 0) {
                    Future.delayed(
                      Duration(seconds: data.distanceAndDuration!.moveAfter!),
                      () {
                        activeReq!.currentGradientPercentage =
                            (activeReq!.currentGradientPercentage!) - 15;
                      },
                    );
                  }
                }
              }
              timer = activeReq!.requestLocationModel.intervalsForNextHit
                      ?.toInt() ??
                  -1;
            }
          }
        }
        emit(GetRequestTimeAndDistanceByIdSuccessState());
      },
    );
  }

  Future<PlacesAutocompleteResponse> searchPlace(String placeName) async {
    var searchKeyWord;
    var res = await GoogleMapsPlaces(
            apiKey: MapApiKey, apiHeaders: {"Accept-Language": "ar"})
        .autocomplete(placeName,
            radius: 1000,
            components: [Component(Component.country, 'eg')],
            origin: Location(
                lat: currentPosition!.latitude,
                lng: currentPosition!.longitude),
            location: Location(
                lat: currentPosition!.latitude,
                lng: currentPosition!.longitude));
    try {
      res.predictions.sort((a, b) => a.distanceMeters == null
          ? -1
          : b.distanceMeters == null
              ? 1
              : a.distanceMeters!.compareTo(b.distanceMeters!));
      for (var item in res.predictions) {
        print('item.description');
        print(item.description);
        searchKeyWord = res.predictions;
      }
    } catch (e) {
      debugPrint("Error sort predictions by distance in meters");
    }
    return res;
  }

  bool isGetPlacesDetailsLoading = false;

  void getPlaceDetails({required Prediction option}) async {
    emit(GetPlacesDetailsLoading());
    isGetPlacesDetailsLoading = true;

    final result = await wenchServiceRepository.getPlaceDetails(
      placeId: option.placeId!,
    );
    result.fold(
      (failure) {
        debugPrint(failure.toString());
      },
      (data) {
        if (mapController != null) {
          mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(
                  data.result.latitude.toDouble(),
                  data.result.longitude.toDouble(),
                ),
                //msh hya de
                zoom: 15.0,
              ),
            ),
          );
        }

        saveSRLocationAddressLatLng(option: option);

        saveCurrentFnolStepAddressLatLng(option: option);

        isGetPlacesDetailsLoading = false;
      },
    );
  }

  saveSRLocationAddressLatLng({required Prediction option}) async {
    if (request?.fieldPin == MapPickerStatus.pickup) {
      currentLocationTextFieldCtrl.text =
          '${option.structuredFormatting!.mainText}+${option.structuredFormatting!.secondaryText}';
      request?.requestLocationModel.clientAddress =
          currentLocationTextFieldCtrl.text;

      LatLng x = await getLatLang(currentLocationTextFieldCtrl.text);
      request?.requestLocationModel.clientPoint = x;
    } else if (request?.fieldPin == MapPickerStatus.destination) {
      destinationLocationTextFieldCtrl.text =
          '${option.structuredFormatting!.mainText}+${option.structuredFormatting!.secondaryText}';
      request?.requestLocationModel.destAddress =
          destinationLocationTextFieldCtrl.text;

      LatLng x = await getLatLang(destinationLocationTextFieldCtrl.text);
      request?.requestLocationModel.destPoint = x;
    } else {}

    emit(UpdateSRLocationAddress());
  }

  saveCurrentFnolStepAddressLatLng({required Prediction option}) async {
    currentFnolStepAddress =
        '${option.structuredFormatting!.mainText}+${option.structuredFormatting!.secondaryText}';
    mapSearchFnolTextFieldCtrl.text = currentFnolStepAddress!;

    LatLng x = await getLatLang(currentFnolStepAddress!);
    currentFnolStepLatLng = x;
    emit(UpdateFnolLocationAddress());
  }

  var dir;

  Future<LatLng> getLatLang(String address) async {
    try {
      dir =
          await GoogleMapsGeocoding(apiKey: MapApiKey).searchByAddress(address);
      googleMapsModel.destination = LatLng(dir.results[0].geometry.location.lat,
          dir.results[0].geometry.location.lng);
      return googleMapsModel.destination!;
    } catch (e) {
      print(e.toString());
      return googleMapsModel.destination!;
    }
  }

  Future<void> assignDriverToRequest() async {
    emit(AssignDriverToRequestLoadingState());
    if (selectedWenchType == WenchType.norm) {
      // driverModel = normalDriverModel;
      request?.carServiceTypeId = 4;
    } else if (selectedWenchType == WenchType.euro) {
      request?.carServiceTypeId = 5;

      // driverModel = euroDriverModel;
    }
    request?.driver = driverModel;
    final result = await wenchServiceRepository.assignDriverToRequest(request!);

    result.fold(
      (failure) {
        debugPrint(
            'failed to assign driver to request ==============> $failure');
        emit(AssignDriverToRequestErrorState(error: failure));
      },
      (data) {
        debugPrint('assign driver to request ===============> ${data}');

        if (data.status == "success") {
          if (data.driver != null) {
            request?.driver = data.driver;
            driverModel = data.driver;
          }
          request?.vehiclePhoneNumber = data.vehicleNumber!;
        }

        debugPrint(
            'id -> driver of request ===============> ${request?.driver?.id}');
        debugPrint(
            'name -> driver of request ===============> ${request?.driver?.name}');
        debugPrint(
            'phone -> driver of request ===============> ${request?.driver?.phoneNumber}');

        emit(AssignDriverToRequestSuccessState());
      },
    );
  }

  void showHistoryRequestData(ServiceRequest serviceRequest) async {
    request = serviceRequest;
    historyRequestModel = serviceRequest;
    //  updateUserRequestSheetState(UserRequestProcesses.history);

    if (request?.requestLocationModel.clientPoint != null &&
        request?.requestLocationModel.destPoint != null) {
      await drawAnyMapPath(
          from: request!.requestLocationModel.clientPoint!,
          to: request!.requestLocationModel.destPoint!,
          pathId: "");
    }
    if (request?.requestLocationModel.clientPoint != null &&
        request?.requestLocationModel.destPoint != null) {
      await drawAnyMapPathMarkers(
          startIconPath: Platform.isIOS
              ? "assets/images/client_car_ios.png"
              : "assets/images/client_car.png",
          endIconPath: Platform.isIOS
              ? "assets/images/pin_ios.png"
              : "assets/images/pin_android.png",
          startMarkerCoord: request!.requestLocationModel.clientPoint!,
          endMarkerCoord: request!.requestLocationModel.destPoint!,
          heading: activeReq?.driver?.heading);
    }
    if (request?.requestLocationModel.clientPoint != null &&
        request?.requestLocationModel.destPoint != null) {
      animateCameraToShowAnyMapPath(
          from: request!.requestLocationModel.clientPoint!,
          to: request!.requestLocationModel.destPoint!);
    }
  }

  Future<void> drawAnyMapPath({
    required LatLng from,
    required LatLng to,
    required String pathId,
  }) async {
    PolylinePoints polylinePoints = PolylinePoints();
    flutter_polyline_points.TravelMode travelMode =
        flutter_polyline_points.TravelMode.driving;
    polylinePoints
        .getRouteBetweenCoordinates(
      MapApiKey,
      PointLatLng(from.latitude, from.longitude),
      PointLatLng(to.latitude, to.longitude),
      // travelMode: travelMode,
    )
        .then((value) async {
      googleMapsModel.polylines = {};
      driverPolylineResult = value;
      isFirstTimeHitRequest = false;

      if (pathId == 'firstReq') {
        firstPolylineResult = value;
      } else if (pathId == 'secondReq') {
        secondPolylineResult = value;
      } else if (pathId == 'thirdReq') {
        thirdPolylineResult = value;
      }
      PolylineId id = PolylineId('polylineId');

      Polyline polyline = Polyline(
        polylineId: id,
        color: Theme.of(NavigationService.navigatorKey.currentContext!)
            .primaryColor,
        points:
            value.points.map((e) => LatLng(e.latitude, e.longitude)).toList(),
        width: 4,
      );
      if (activeReqModel?.firstClientDestination == null ||
          activeReqModel?.oldRequestStatus ==
              ServiceRequestStatus.destArrived) {
        googleMapsModel.polylines.add(polyline);
      } else {
        if (isFirstTimeHitRequest) {
          googleMapsModel.markers = {};
          drawAnyMapPathMarkers(
              startIconPath: Platform.isIOS
                  ? "assets/images/pin_ios.png"
                  : "assets/images/pin_android.png",
              endIconPath: Platform.isIOS
                  ? "assets/images/client_car_ios.png"
                  : "assets/images/client_car.png",
              startMarkerCoord: to!,
              endMarkerCoord: from!,
              heading: activeReq?.driver?.heading);
          animateCameraToShowAnyMapPath(from: to, to: from);
          //  drawAnyMapPathMarkers(startIconPath: startIconPath, endIconPath: endIconPath, startMarkerCoord: startMarkerCoord, endMarkerCoord: endMarkerCoord);
        }
      }
      if (pathId == 'secondReq') {
        animateCameraToShowAnyMapPath(from: from, to: to);
      }

      // emit(UpdateMapState());
    }).catchError((error) {
      debugPrint('============== error =============');
      debugPrint(error.toString());
      // emit(GetDriverPathToDrawError(error: error?.toString() ?? ''));
    });
  }

  bool gettingLocation = false;
  Future<String?> getForceLocation([bool? isInit]) async {
    if (isInit == true) gettingLocation = true;
    emit(GetLocationLoading());
    locationData = await location.getLocation().then((value) async {
      print(value.latitude);
      print(value.longitude);
      if (value.latitude != null && value.longitude != null) {
        currentPosition = await Geolocator.getCurrentPosition();

        currentLatLng = LatLng(value.latitude!, value.longitude!);
        cameraPosition = CameraPosition(
            target: LatLng(value.latitude!, value.longitude!), zoom: 14);
        final placeDetails =
            await wenchServiceRepository.getPlaceDetailsByCoordinates(
                latLng: "${value.latitude},${value.longitude}");
        currentAddress = placeDetails.fold((l) => currentAddress, (r) {
          currentAddress = r.placeName;
          emit(GetLocationDone());
          gettingLocation = false;
         
          return r.placeName;
        });
      }
    });
    gettingLocation = false;
    return currentAddress;
  }

  Future<void> getOneById(String activeReqId) async {
    final result = await wenchServiceRepository.getOneServiceRequest(
        serviceRequestId: int.parse(activeReqId!));

    result.fold(
      (failure) {
        debugPrint(failure);
        emit(GetRequestByIdErrorState(error: failure));
        return null;
      },
      (data) async {
        // debugPrint('get req by id hi ===============> 1 x ${data.id}');
        activeReq = data.activeReq;
        otherServiceIds = (activeReq?.selectedTowingService ?? [])
            .where((element) => element < 4)
            .toList();
        activeReqModel = data;
        emit(GetRequestByIdSuccessState());

        /// debugPrintFullText('get req by id hi ===============> 2 x ${data.toJson(selectedCarToRequest, null)}');

        //print(activeReqModel?.status);
        if ((activeReq!.confirmed || activeReq!.done) &&
            otherServiceIds.isEmpty) {
          from = activeReq!.requestLocationModel.clientPoint!;
          to = activeReq!.requestLocationModel.destPoint!;
          await handleRequestRoutes(from: from, to: to);
        }
        if (activeReq!.accepted) {
          from = LatLng(activeReq!.driver!.lat!, activeReq!.driver!.lng!);
          to = activeReq!.requestLocationModel.clientPoint!;
          await drawAnyMapPath(
                  from:
                      LatLng(activeReq!.driver!.lat!, activeReq!.driver!.lng!),
                  to: activeReq!.requestLocationModel.clientPoint!,
                  pathId: "")
              .then((value) async {
            drawAnyMapPathMarkers(
                startIconPath: isCarService
                    ? Platform.isIOS
                        ? "assets/images/n300_marker_ios.png"
                        : "assets/images/n300_marker.png"
                    : Platform.isIOS
                        ? "assets/images/wench_ios.png"
                        : "assets/images/wench.png",
                endIconPath: Platform.isIOS
                    ? "assets/images/client_car_ios.png"
                    : "assets/images/client_car.png",
                startMarkerCoord: from!,
                endMarkerCoord: to!,
                heading: activeReq?.driver?.heading!);
          });
          // trimRoute();
          await handleRequestRoutes(from: from, to: to);
        } else if (activeReq!.started) {
          from = LatLng(activeReq!.driver!.lat!, activeReq!.driver!.lng!);
          to = activeReq!.requestLocationModel.clientPoint!;
          if (otherServiceIds.isNotEmpty) return data;
          await drawAnyMapPath(
                  from:
                      LatLng(activeReq!.driver!.lat!, activeReq!.driver!.lng!),
                  to: activeReq!.requestLocationModel.destPoint!,
                  pathId: "")
              .then((value) async {
            drawAnyMapPathMarkers(
                startIconPath: isCarService
                    ? Platform.isIOS
                        ? "assets/images/n300_marker_ios.png"
                        : "assets/images/n300_marker.png"
                    : Platform.isIOS
                        ? "assets/images/wench_with_car_ios.png"
                        : "assets/images/wench_with_car.png",
                endIconPath: Platform.isIOS
                    ? "assets/images/pin_ios.png"
                    : "assets/images/pin_android.png",
                startMarkerCoord: from!,
                endMarkerCoord: to!,
                heading: activeReq?.driver?.heading);
          });
          // trimRoute();
          await handleRequestRoutes(from: from, to: to);
        }

        // wenchServiceBloc?.add(HandleServiceRequestSheetEvent());

        // wenchServiceBloc?.add(HandleRequestRoutesEvent());

        return data;
      },
    );
  }
}
