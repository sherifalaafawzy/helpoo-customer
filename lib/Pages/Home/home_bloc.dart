import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:helpooappclient/Models/cars/my_cars.dart';
import 'package:meta/meta.dart';

import '../../Configurations/Constants/PointLatLng.dart';
import '../../Configurations/Constants/constants.dart';
import '../../Configurations/Constants/page_route_name.dart';
import '../../Configurations/di/injection.dart';
import '../../Models/fnol/latestFnolModel.dart';
import '../../Models/service_request/getDistanceAndDurationResponse.dart';
import '../../Models/service_request/getRequestDuratonAndDistance.dart';
import '../../Models/service_request/my_google_maps_hit_response.dart';
import '../../Models/service_request/service_request.dart';
import '../../Models/service_request/service_request_model.dart';
import '../../Services/cache_helper.dart';
import 'home_repository.dart';
import 'widgets/polyline_waypoint.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository = sl<HomeRepository>();
  final CacheHelper cacheHelper = sl<CacheHelper>();
  List<ServiceRequest> latestRequests = [];
  List<ServiceRequest> activeRequestsList = [];
  List<LatestFnolModel> latestFnols = [];
  HomeBloc? homeBloc;
  bool isFromAnimation = true;
  bool gettingLatestRequests = false;
  bool gettingActiveRequests = false;

  /* late LatLng from;
  late LatLng to;
  LatLng? fromForDTO;
  LatLng? toForDTO;
  DistanceAndDuration? getDistanceAndDurationResponse;
 */

  ///  bool isFirstTimeHitRequest = true;

  int? selectedIndex = 0;

  ///int currentServiceRequestIndex = 0;
  double valToPassToPercentage = 100;
  List<ServiceRequest>? activeReq = [];

  // MyGoogleMapsHitResponse myGoogleMapsHitResponse = MyGoogleMapsHitResponse();
  Timer? timerHomeUiUpdates;
  Timer? timerHomeServiceRequestItemUpdates;

  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<NavigateToServiceRequestScreen>((event, emit) {
      //TODO
      Navigator.of(event.context!).pushNamed(
        PageRouteName.roadServicePage,
      );
    });
    on<NavigateToFNOLScreen>((event, emit) {
      //TODO
      Navigator.of(event.context!).pushNamed(PageRouteName.selectCarScreen,
          arguments: {"selectedIndex": 1});
    });
    on<UpdateTabIndexHomeServiceRequestAndFNOL>((event, emit) {
      selectedIndex = event.index!;
      emit(HomeInitial());
    });
    on<GetFNOLLatestRequests>((event, emit) async {
      emit(GetLatestFNOLsLoading());

      final result = await homeRepository.getLatestFNOLs();
      result.fold((l) {
        debugPrint(l);
        emit(GetLatestFNOLsError(error: l.toString()));
      }, (r) {
        latestFnols = r;

        emit(GetLatestFNOLsSuccess());
      });
    });
    on<GetLatestRequests>((event, emit) async {
      emit(GetRequestsHistoryLoadingState());
      gettingLatestRequests = true;
      gettingActiveRequests = true;
      final result = await homeRepository.getUserLast10RequestsHistory();
      gettingLatestRequests = false;
      gettingActiveRequests = false;
      result.fold(
        (failure) async {
          debugPrint(failure);
          gettingLatestRequests = false;
          gettingActiveRequests = false;
          emit(GetRequestsHistoryErrorState(error: failure));

          //   getUserLast10RequestsHistory();
          //  await homeRepository.getUserLast10RequestsHistory();
        },
        (data) async {
          latestRequests = data;
          // await _filterCurrentRequests();
          emit(GetRequestsHistorySuccessState());
        },
      );
    });

    on<FilterCurrentRequests>((event, emit) async {
      if (latestRequests.isNotEmpty) {
        activeRequestsList = latestRequests.where((req) {
          bool isHistoryReq = req.status == ServiceRequestStatus.done ||
              req.status == ServiceRequestStatus.canceled ||
              req.status == ServiceRequestStatus.notAvailable;
          return !isHistoryReq;
        }).toList();

        activeReq = activeRequestsList;
        gettingActiveRequests = false;
        print(activeRequestsList.isNotEmpty);
        print(activeRequestsList.length);
        print(latestRequests.length);
        if (activeRequestsList.isNotEmpty) {
          for (int i = 0; i < activeRequestsList.length; i++) {
            if (activeRequestsList[i].accepted) {
              activeReq![i].from = LatLng(activeRequestsList[i].driver!.lat!,
                  activeRequestsList[i].driver!.lng!);
              activeReq![i].to =
                  activeRequestsList[i].requestLocationModel.clientPoint!;
            } else {
              activeReq![i].from = LatLng(
                  activeRequestsList[i].driver?.lat ?? 0.0,
                  activeRequestsList[i].driver?.lng ?? 0.0);
              if (activeRequestsList[i].requestLocationModel.destPoint !=
                  null) {
                activeReq![i].to =
                    activeRequestsList[i].requestLocationModel.destPoint!;
              } else
                activeReq![i].to =
                    activeRequestsList[i].requestLocationModel.clientPoint!;
            }

            activeRequestsList[i].myGoogleMapsHitResponse =
                await getGoogleMapsRouteBetweenCoordinates(
              googleApiKey: MapApiKey,
              index: i,
              start: PointLatLng(
                  activeReq![i].from!.latitude, activeReq![i].from!.longitude),
              end: PointLatLng(
                  activeReq![i].to!.latitude, activeReq![i].to!.longitude),
            );
            if (activeReq![i].accepted || activeReq![i].started) {
              //calcSliderPercentage(req: activeRequestsList[i]);
            }

            emit(
              FilterCurrentRequestsState(activeReq: activeReq?[i], index: i),
            );
          }
        } else {
          emit(FilterHistoryRequestsState());
        }
      } else {
        gettingActiveRequests = false;
        emit(FilterHistoryRequestsState());
      }
    });
    on<GetRequestByIdHomeEvent>((event, emit) async {
      if (activeReq != null) {
        for (int i = 0; i < activeReq!.length; i++) {
          {
            if (activeReq?.isNotEmpty ?? false) {
              await checkIfGetTimeAndDistanceOrNot(i);

              ///  await increaseAnimation(i);
            }
          }
          final result = await homeRepository.getOneServiceRequest(
              serviceRequestId: activeReq![i].id!);
          await result.fold(
            (failure) {
              debugPrint(failure);

              ///  return null;
            },
            (data) async {
              activeReq![i] = data.activeReq!;
              activeReq![i].activeReqModel = data;
              if (activeReq![i].canceled) {
                activeReq!.remove(activeReq![i]);
              }
              if (activeReq?.isNotEmpty ?? false) {
                ///  await checkIfGetTimeAndDistanceOrNot(i);
                //calcSliderPercentage(req: activeRequestsList[i]);
                if (activeReq![i].arrived) {
                  await cacheHelper.put('${activeReq![i].id!}Duration',
                      activeReq![i].actualDuration.toDouble());
                  await cacheHelper.put('${activeReq![i].id!}Distance',
                      activeReq![i].actualDistance);
                  await cacheHelper.put(
                      '${activeReq![i].id!}percentage', 100.0);
                  await cacheHelper.clear(
                    '${activeReq![i].id!}CounterForHit',
                  );
                }
                if (activeReq![i].done) {
                  await cacheHelper.clear('${activeReq![i].id!}Duration');
                  await cacheHelper.clear('${activeReq![i].id!}Distance');
                  await cacheHelper.clear('${activeReq![i].id!}percentage');
                  await cacheHelper.clear(
                    '${activeReq![i].id!}CounterForHit',
                  );
                }
                if (activeReq![i].started || activeReq![i].accepted) {
                  double? lastLocalPercentage = await sl<CacheHelper>()
                      .get('${activeReq![i].id}percentage');
                  if (lastLocalPercentage != null) {
                    activeReq![i].currentGradientPercentage =
                        lastLocalPercentage;
                  }
                  activeReq![i].actualDuration =
                      await cacheHelper.get('${activeReq![i].id!}Duration') ??
                          -1;
                  activeReq![i].actualDistance =
                      await cacheHelper.get('${activeReq![i].id!}Distance') ??
                          -1;
                  await handleTimeAndDistanceSimulation(i);
                }
              }
              emit(GetRequestByIdSuccessHomeState());

              return data;
            },
          );
        }
      }
    });
  }

  void calcSliderPercentage({required ServiceRequest req}) {
    if (req.accepted) {
      // // TODO: handle the case of saving the driver lat lng of driver initially
      // num? totalDistanceToClient = req.requestLocationModel.firstUpdatedDistanceAndDuration!.driverDistanceMatrix!.distance!.value ?? 1;
      // // num? totalDistanceToClient = req.requestLocationModel.distanceToDest ?? 1;
      // totalDistanceToClient = totalDistanceToClient / 1000; // km
      // num? currentDistanceToClient = req.requestLocationModel.lastUpdatedDistanceAndDuration!.driverDistanceMatrix!.distance!.value;
      // // num? currentDistanceToClient = appBloc.myGoogleMapsHitResponse.distanceInKm;
      // // TODO: handle the case of saving the driver lat lng of driver initially
      // // percentage = currentDistanceToClient / totalDistanceToClient;
      // req.percentage = 0.6;

      int totalDistanceToClient = req
              .requestLocationModel
              .firstUpdatedDistanceAndDuration
              ?.driverDistanceMatrix
              ?.distance
              ?.value ??
          1;
      int currentDistanceToClient = req
              .requestLocationModel
              .lastUpdatedDistanceAndDuration
              ?.driverDistanceMatrix
              ?.distance
              ?.value ??
          1;

      if (req.requestLocationModel.firstUpdatedDistanceAndDuration != null &&
          req.requestLocationModel.lastUpdatedDistanceAndDuration != null) {
        req.percentage =
            (currentDistanceToClient / totalDistanceToClient) * 100;
      } else {
        req.percentage = 100;
      }
    } else if (req.started || req.arrived) {
      num? totalTripDistance = req.requestLocationModel.distanceToDest ?? 1;
      totalTripDistance = totalTripDistance / 1000;
      num? currentDistanceToDest = req.actualDistance / 1000;
      // num? currentDistanceToDest = appBloc.myGoogleMapsHitResponse.distanceInKm;
      req.percentage = currentDistanceToDest / totalTripDistance;
    }

    req.percentage *= 100;
    req.percentage = req.percentage > 99 ? 100 : req.percentage;
    print('from calc Slider request percentage ${req.percentage}');
  }

  List<PointLatLng> _decodeEncodedPolyline(String encoded) {
    List<PointLatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));

      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      PointLatLng p =
          PointLatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }

  Future<MyGoogleMapsHitResponse> getGoogleMapsRouteBetweenCoordinates(
      {required String googleApiKey,
      required PointLatLng start,
      required PointLatLng end,
      TravelMode travelMode = TravelMode.driving,
      List<PolylineWayPoint> wayPoints = const [],
      bool avoidHighways = false,
      bool avoidTolls = false,
      bool avoidFerries = false,
      bool optimizeWaypoints = false,
      required int index}) async {
    
    var params = {
      "key": googleApiKey,
      "mode": travelMode.name,
      "origin": "${start.latitude},${start.longitude}",
      "destination": "${end.latitude},${end.longitude}",
      "avoidHighways": "$avoidHighways",
      "avoidFerries": "$avoidFerries",
      "avoidTolls": "$avoidTolls",
      "departure_time": "now",
      // "region": "kw",
      // "destination": "side_of_road:${destination.latitude},${destination.longitude}",
    };

    if (wayPoints.isNotEmpty) {
      List wayPointsArray = [];
      wayPoints.forEach((point) => wayPointsArray.add(point.location));
      String wayPointsString = wayPointsArray.join('|');
      if (optimizeWaypoints) {
        wayPointsString = 'optimize:true|$wayPointsString';
      }
      params.addAll({"waypoints": wayPointsString});
    }
    final r = await homeRepository.getRouteBetweenCoordinates(params: params);
    r.fold(
      (failure) {
        debugPrint(failure);
        //  emit(GoogleMapsHitFailed());
      },
      (data) {
        Map googleMapsResponse = data;
        activeReq![index].myGoogleMapsHitResponse.status =
            googleMapsResponse["status"];
        if (googleMapsResponse["status"]?.toLowerCase() == 'ok' &&
            googleMapsResponse["routes"] != null &&
            googleMapsResponse["routes"].isNotEmpty) {
          activeReq![index].myGoogleMapsHitResponse.distance =
              googleMapsResponse["routes"][0]["legs"][0]["distance"]["text"];
          activeReq![index].myGoogleMapsHitResponse.distanceInKm =
              googleMapsResponse["routes"][0]["legs"][0]["distance"]["value"];
          // from meter to km
          activeReq![index].myGoogleMapsHitResponse.distanceInKm =
              activeReq![index].myGoogleMapsHitResponse.distanceInKm / 1000;
          activeReq![index].myGoogleMapsHitResponse.distanceInKm =
              activeReq![index].myGoogleMapsHitResponse.distanceInKm.ceil();

          activeReq![index].myGoogleMapsHitResponse.duration =
              googleMapsResponse["routes"][0]["legs"][0]["duration"]["text"];
          activeReq![index].myGoogleMapsHitResponse.durationInSec =
              googleMapsResponse["routes"][0]["legs"][0]["duration"]["value"];
          // from sec to min
          activeReq![index].myGoogleMapsHitResponse.durationInSec =
              activeReq![index].myGoogleMapsHitResponse.durationInSec / 60;
          activeReq![index].myGoogleMapsHitResponse.durationInSec =
              activeReq![index].myGoogleMapsHitResponse.durationInSec.ceil();

          activeReq![index].myGoogleMapsHitResponse.duration_in_traffic =
              googleMapsResponse["routes"][0]["legs"][0]["duration_in_traffic"]
                  ["text"];

          activeReq![index].myGoogleMapsHitResponse.pointsString =
              googleMapsResponse["routes"][0]["overview_polyline"]["points"];

          activeReq![index].myGoogleMapsHitResponse.points =
              _decodeEncodedPolyline(googleMapsResponse["routes"][0]
                  ["overview_polyline"]["points"]);

          //  emit(GoogleMapsHitSucceeded());
        } else {
          activeReq![index].myGoogleMapsHitResponse.errorMessage =
              googleMapsResponse["error_message"];
        }
      },
    );

    return activeReq![index].myGoogleMapsHitResponse;
  }

  void cancelUpdateMapUiTimer() {
    if (timerHomeUiUpdates != null) {
      timerHomeUiUpdates!.cancel();
    }
  }

  //int timer = -1;

  handleMapReqUiUpdates(
      {required bool isCurrentReq, required int index}) async {
    if (activeReq != null) {
      if (activeReq![index].opened ||
          activeReq![index].canceled ||
          activeReq![index].canceledWithPayment ||
          activeReq![index].done ||
          activeReq![index].rated) {
        cancelUpdateMapUiTimer();
      } else {
        if (await cacheHelper.get(
              '${activeReq![index].id!}CounterForHit',
            ) !=
            null) {
          activeReq![index].countForHit = await cacheHelper.get(
            '${activeReq![index].id!}CounterForHit',
          );
        } else {
          activeReq![index].countForHit = 0;
        }
        activeReq![index].countForGetOne = 0;
        //int counterForGetOne = 0;
        activeReq![index].timerForHit = activeReq![index]
                .requestLocationModel
                .intervalsForNextHit
                ?.toInt() ??
            -1;
        /*   timer = ((activeReq![index].actualDuration > 3600)
            ? 900
            : (activeReq![index].actualDuration < 3600 &&
                    activeReq![index].actualDuration >= 1800)
                ? 600
                : (activeReq![index].actualDuration < 1800 &&
                        activeReq![index].actualDuration >= 600)
                    ? 300
                    : (activeReq![index].actualDuration < 600 &&
                            activeReq![index].actualDuration >= 10)
                        ? 120
                        : -1);*/

        /// await checkIfGetTimeAndDistanceOrNot(index);
        /*await homeRepository.getOneServiceRequest(
            serviceRequestId: (activeReq![index].id!));*/
        homeBloc?.add(GetRequestByIdHomeEvent(
            activeReqId: activeReq![index].id!.toString()));
        timerHomeUiUpdates = Timer.periodic(
          const Duration(seconds: 1),
          (timerUi) async {
            if (await cacheHelper.get(
                  '${activeReq![index].id!}CounterForHit',
                ) !=
                null) {
              activeReq![index].countForHit = await cacheHelper.get(
                '${activeReq![index].id!}CounterForHit',
              );
            }
            print('counterForHit');
            print(activeReq![index].countForHit);
            print('timer for next hit');
            print(activeReq![index].timerForHit);
            print('counterForGetOne');
            print(activeReq![index].countForGetOne);
            /*timer = ((activeReq![index].actualDuration > 3600)
                ? 900
                : (activeReq![index].actualDuration < 3600 &&
                        activeReq![index].actualDuration >= 1800)
                    ? 600
                    : (activeReq![index].actualDuration < 1800 &&
                            activeReq![index].actualDuration >= 600)
                        ? 300
                        : (activeReq![index].actualDuration < 600 &&
                                activeReq![index].actualDuration >= 10)
                            ? 120
                            : -1);*/
            activeReq![index].timerForHit = activeReq![index]
                    .requestLocationModel
                    .intervalsForNextHit
                    ?.toInt() ??
                -1;
            if (activeReq![index].countForHit > activeReq![index].timerForHit) {
              await cacheHelper.clear(
                '${activeReq![index].id!}CounterForHit',
              );
            }
            if (activeReq![index].countForGetOne == 10) {
              activeReq![index].countForGetOne = 0;
              if (activeReq != null) {
                for (int i = 0; i < activeReq!.length; i++) {
                  final result = await homeRepository.getOneServiceRequest(
                      serviceRequestId: activeReq![i].id!);
                  await result.fold(
                    (failure) {
                      debugPrint(failure);

                      ///  return null;
                    },
                    (data) async {
                      activeReq![i] = data.activeReq!;
                      activeReq![i].activeReqModel = data;
                      if (activeReq![i].canceled) {
                        activeReq!.remove(activeReq![i]);
                      }
                      {
                        if (activeReq?.isNotEmpty ?? false) {
                          await checkIfGetTimeAndDistanceOrNot(i);

                          ///  await increaseAnimation(i);
                        }
                      }
                      if (activeReq?.isNotEmpty ?? false) {
                        ///  await checkIfGetTimeAndDistanceOrNot(i);
                        //calcSliderPercentage(req: activeRequestsList[i]);
                        if (activeReq![i].arrived) {
                          await cacheHelper.put('${activeReq![i].id!}Duration',
                              activeReq![i].actualDuration.toDouble());
                          await cacheHelper.put('${activeReq![i].id!}Distance',
                              activeReq![i].actualDistance);
                          await cacheHelper.put(
                              '${activeReq![i].id!}percentage', 100.0);
                          await cacheHelper.clear(
                            '${activeReq![i].id!}CounterForHit',
                          );
                        }
                        if (activeReq![i].done) {
                          await cacheHelper
                              .clear('${activeReq![i].id!}Duration');
                          await cacheHelper
                              .clear('${activeReq![i].id!}Distance');
                          await cacheHelper
                              .clear('${activeReq![i].id!}percentage');
                          await cacheHelper.clear(
                            '${activeReq![i].id!}CounterForHit',
                          );
                        }
                        if (activeReq![i].started ||
                            activeReq![index].accepted) {
                          double? lastLocalPercentage = await sl<CacheHelper>()
                              .get('${activeReq![i].id}percentage');
                          if (lastLocalPercentage != null) {
                            activeReq![i].currentGradientPercentage =
                                lastLocalPercentage;
                          }
                          activeReq![index].actualDuration = await cacheHelper
                                  .get('${activeReq![index].id!}Duration') ??
                              -1;
                          activeReq![index].actualDistance = await cacheHelper
                                  .get('${activeReq![index].id!}Distance') ??
                              -1;
                          await handleTimeAndDistanceSimulation(i);
                        }
                      }
                      emit(GetRequestByIdSuccessHomeState());

                      return data;
                    },
                  );
                }
              }
            } else {
              activeReq![index].countForGetOne++;
              if (activeReq![index].accepted || activeReq![index].started) {
                if (activeReq![index].countForHit ==
                    activeReq![index].timerForHit) {
                  activeReq![index].countForHit = 0;
                  await cacheHelper.put(
                      '${activeReq![index].id!}CounterForHit', 0);
                  await checkIfGetTimeAndDistanceOrNot(index, hit: true);
                  /*  timer = ((activeReq![index].actualDuration > 3600)
                      ? 900
                      : (activeReq![index].actualDuration < 3600 &&
                              activeReq![index].actualDuration >= 1800)
                          ? 600
                          : (activeReq![index].actualDuration < 1800 &&
                                  activeReq![index].actualDuration >= 600)
                              ? 300
                              : (activeReq![index].actualDuration < 600 &&
                                      activeReq![index].actualDuration >= 10)
                                  ? 120
                                  : -1);*/
                  activeReq![index].timerForHit = activeReq![index]
                          .requestLocationModel
                          .intervalsForNextHit
                          ?.toInt() ??
                      -1;
                } else {
                  activeReq![index].countForHit++;
                  await cacheHelper.put('${activeReq![index].id!}CounterForHit',
                      activeReq![index].countForHit);
                }
              }
            }
          },
        );

        /// startTimerHomeServiceRequest(index);
      }
    }
  }

  startTimerHomeServiceRequest(int i) async {
    if (activeReq![i].started || activeReq![i].accepted) {
      if (activeReq![i].localDuration != 0) {
        timerHomeServiceRequestItemUpdates =
            Timer.periodic(Duration(seconds: 1), (timer) async {
          // callBack();
          if (activeReq?.isNotEmpty ?? false) {
            await checkIfGetTimeAndDistanceOrNot(i);

            ///  await increaseAnimation(i);
          }
          print('final timer work ${timer.tick}');
        });
      }
    }
  }

  increaseAnimation(int i, bool move, int moveAfter) async {
    {
      if (activeReq![i].accepted || activeReq![i].started) {
        print('increase animation last update duration');
        print(activeReq![i]
            .requestLocationModel
            .lastUpdatedDistanceAndDuration
            ?.driverDistanceMatrix
            ?.duration
            ?.value);
        double? lastLocalPercentage =
            await sl<CacheHelper>().get('${activeReq![i].id}percentage');
        double? lastLocalDuration = await sl<CacheHelper>()
            .get('${activeReq![i].id.toString()}Duration');
        print('started');

        print('actual');
        print(activeReq![i].actualDuration);
        print('fisrt accepted');
        print(activeReq![i].requestLocationModel.acceptedDuration);
/*        print(activeReq![i].actualDuration);
        print('diffLastHitAndCurrentLocal');
        print(activeReq![i].diffLastHitAndCurrentLocal);
        print(activeReq![i]
            .requestLocationModel
            .lastUpdatedDistanceAndDuration!
            .driverDistanceMatrix!
            .duration!
            .value!);
        print(lastLocalDuration);
        print(lastLocalPercentage);
        print('100 / (activeReq![i].actualDuration)');
        print(100 / (activeReq![i].actualDuration));*/
        if (lastLocalPercentage != null) {
          activeReq![i].currentGradientPercentage = lastLocalPercentage;
        }
        {
          if (move && activeReq![i].currentGradientPercentage! > 0) {
            {
              activeReq![i].diffLastHitAndCurrentLocal++;
              /* activeReq![i].currentGradientPercentage =
                  (activeReq![i].currentGradientPercentage!) -
                      (100 -
                          ((activeReq![i].actualDuration /
                                  (activeReq![i].accepted
                                      ? activeReq![i]
                                          .requestLocationModel
                                          .acceptedDuration!
                                      : activeReq![i]
                                          .requestLocationModel
                                          .startedDuration!)) *
                              100));*/
              activeReq![i].currentGradientPercentage =
                  (activeReq![i].currentGradientPercentage!) - 15;
              emit(UpdatePercentageSlider(
                  percentageState: activeReq![i].currentGradientPercentage));
              print(activeReq![i].currentGradientPercentage);
              print('activeReq![i].currentGradientPercentage');

              if (activeReq![i].currentGradientPercentage! > 0) {
                await sl<CacheHelper>().put('${activeReq![i].id}percentage',
                    activeReq![i].currentGradientPercentage);
              }
            }
          } else {
            ///stop
            print('moveAfter');
            print(moveAfter);
            if (moveAfter != 0) {
              await Future.delayed(
                Duration(seconds: moveAfter),
                () {
                  activeReq![i].currentGradientPercentage =
                      (activeReq![i].currentGradientPercentage!) - 15;
                  /*(activeReq![i].currentGradientPercentage!) -
                        (100 -
                            ((activeReq![i].actualDuration /
                                (activeReq![i].accepted
                                    ? activeReq![i]
                                    .requestLocationModel
                                    .acceptedDuration!
                                    : activeReq![i]
                                    .requestLocationModel
                                    .startedDuration!)) *
                                100))*/
                  ;
                },
              );
            }
          }
        }

        /* if (DateTime.now().toString().split('.')[0] ==
                (await cacheHelper.get('${activeReq![i].id!}V1')) ||
            DateTime.now().toString().split('.')[0] ==
                (await cacheHelper.get('${activeReq![i].id!}V2')) ||
            DateTime.now().toString().split('.')[0] ==
                (await cacheHelper.get('${activeReq![i].id!}V3')) ||
            DateTime.now().toString().split('.')[0] ==
                (await cacheHelper.get('${activeReq![i].id!}V4'))) {
          if (lastLocalDuration != null &&
              lastLocalDuration > activeReq![i].actualDuration &&
              activeReq![i].currentGradientPercentage! > 0) {
            activeReq![i].currentGradientPercentage = (activeReq![i]
                    .currentGradientPercentage!) -
                (100 / ((lastLocalDuration! - activeReq![i].actualDuration)));
          }
          */ /*else if (lastLocalDuration != null &&
              lastLocalDuration == activeReq![i].actualDuration &&
              activeReq![i].currentGradientPercentage! > 0) {
            activeReq![i].currentGradientPercentage =
                (activeReq![i].currentGradientPercentage!) -
                    (100 / (activeReq![i].localDuration));
            lastLocalDuration = activeReq![i].actualDuration.toInt();
          }*/ /*
          else {
            ///if local duration<actual no moves stop.
          }
        }
        else {
          if (lastLocalDuration != null &&
              lastLocalDuration > activeReq![i].actualDuration &&
              activeReq![i].currentGradientPercentage! > 0) {
            activeReq![i].currentGradientPercentage =
                (activeReq![i].currentGradientPercentage!) -
                    (100 / (lastLocalDuration! - activeReq![i].actualDuration));
          }
          if (activeReq![i].currentGradientPercentage! > 0) {
            await sl<CacheHelper>().put('${activeReq![i].id}percentage',
                activeReq![i].currentGradientPercentage);
          }
        }*/
        if (lastLocalDuration != 0 &&
            activeReq![i].actualDuration > 0 &&
            activeReq![i].currentGradientPercentage! > 0) {
          //  print('ana hena bgd');
          await sl<CacheHelper>().put('${activeReq![i].id}percentage',
              activeReq![i].currentGradientPercentage);
          await sl<CacheHelper>().put(
              '${activeReq![i].id.toString()}Duration', lastLocalDuration!);
        }
      }
    }
  }

  Future getRequestTimeAndDistance(
      {required GetRequestDurationAndDistanceDTO
          getRequestDurationAndDistanceDto,
      required int index}) async {
    isFromAnimation = false;
    //emit(GetRequestTimeAndDistanceByIdLoadingState());

    //printMeLog("getRequestDurationAndDistanceDto  " + getRequestDurationAndDistanceDto.toJson().toString());
    final result = await homeRepository.getRequestTimeAndDistance(
        getRequestDurationAndDistanceDto: getRequestDurationAndDistanceDto);

    result.fold(
      (failure) {
        debugPrint(failure);

        /// emit(GetRequestTimeAndDistanceByIdErrorState(error: failure));
      },
      (data) async {
        print(
            'driver duration: ${data.distanceAndDuration!.driverDistanceMatrix?.duration?.value}');
        print(
            'driver distance: ${data.distanceAndDuration!.driverDistanceMatrix?.distance?.value}');
        print('move value: ${data.distanceAndDuration?.move}');
        print('move after: ${data.distanceAndDuration?.moveAfter}');
        activeReq![index].getDistanceAndDurationResponse =
            data.distanceAndDuration!;
        activeReq![index].actualDistance = activeReq![index]
            .getDistanceAndDurationResponse!
            .driverDistanceMatrix!
            .distance!
            .value!;
        activeReq![index].actualDuration = activeReq![index]
            .getDistanceAndDurationResponse!
            .driverDistanceMatrix!
            .duration!
            .value!;

        print('cacheHelper.get(${activeReq![index].id!}Duration)');
        print(await cacheHelper.get('${activeReq![index].id!}Duration'));
        if (activeReq![index].started || activeReq![index].accepted) {
          {
            {
              activeReq![index].diffLastHitAndCurrentLocal = 0;
            }

            await cacheHelper.put('${activeReq![index].id!}Duration',
                activeReq![index].actualDuration.toDouble());
            await cacheHelper.put('${activeReq![index].id!}Distance',
                activeReq![index].actualDistance);
            double? lastLocalPercentage = await sl<CacheHelper>()
                .get('${activeReq![index].id}percentage');
            if (lastLocalPercentage != null) {
              activeReq![index].currentGradientPercentage = lastLocalPercentage;
            }
            await increaseAnimation(index, data.distanceAndDuration!.move!,
                data.distanceAndDuration?.moveAfter ?? 0);
          }
        }
        emit(GetRequestTimeAndDistanceByIdHomeSuccessState());
      },
    );
  }

  Future<void> getCorporateLast10RequestsHistory() async {
    emit(GetRequestsHistoryLoadingState());

    final result = await homeRepository.getCorporateLast10RequestsHistory();

    result.fold(
      (failure) {
        debugPrint(failure);
        emit(GetRequestsHistoryErrorState(error: failure));
      },
      (data) async {
        latestRequests = [];
        latestRequests = data;

        ///  await _filterCurrentRequests();
        emit(GetRequestsHistorySuccessState());
      },
    );
  }

  startStartTimer(int i) async {
    activeReq![i].statusStatrtedDuration =
        activeReq![i].requestLocationModel.timeToDest ?? 0;

    activeReq![i].intervalInSeconds =
        activeReq![i].statusStatrtedDuration! ~/ 4;

    activeReq![i].TimeOfLastUpdate = DateTime.parse(activeReq![i]
            .requestLocationModel
            .lastUpdatedDistanceAndDuration!
            .createdAt!)
        .toUtc();
    activeReq![i].currentTimeUtc = DateTime.now().toUtc();
    activeReq![i].secondsFromLastUpdate = activeReq![i]
        .currentTimeUtc!
        .difference(activeReq![i].TimeOfLastUpdate!)
        .inSeconds;

    if (activeReq![i].secondsFromLastUpdate! >=
        activeReq![i].intervalInSeconds!) {
      GetRequestDurationAndDistanceDTO getRequestDurationAndDistanceDto =
          GetRequestDurationAndDistanceDTO(
        serviceRequestId: activeReq![i].id!,
        oldStatus: activeReq![i].activeReqModel != null
            ? activeReq![i].activeReqModel!.oldRequestStatus!.enName
            : null,
        prevClientLocation: activeReq![i].activeReqModel != null &&
                activeReq![i].activeReqModel!.firstClientLocation != null
            ? LatLng(
                activeReq![i]
                    .activeReqModel!
                    .firstClientLocation!
                    .latitude
                    .toDouble(),
                activeReq![i]
                    .activeReqModel!
                    .firstClientLocation!
                    .longitude
                    .toDouble())
            : null,
        oldDest: activeReq![i].activeReqModel != null &&
                activeReq![i].activeReqModel!.firstClientDestination != null
            ? LatLng(
                activeReq![i]
                    .activeReqModel!
                    .firstClientDestination!
                    .latitude
                    .toDouble(),
                activeReq![i]
                    .activeReqModel!
                    .firstClientDestination!
                    .longitude
                    .toDouble())
            : null,
        driverLatLng: activeReq![i].fromForDTO!,
        curClientLocation: activeReq![i].toForDTO!,
      );
      await getRequestTimeAndDistance(
          getRequestDurationAndDistanceDto: getRequestDurationAndDistanceDto,
          index: i);
      print('hit 3');
    }
  }

  checkIfGetTimeAndDistanceOrNot(int i, {bool hit = false}) async {
    await increaseAnimation(i, false, 0);

    /// we need to hit getRequestTimeAndDistance API in three cases
    /// 1. with the interval time
    /// 2. with status changed to handle the new route and simulate it
    /// 3. in case the driver go far of the route with 1 KM
    /* print('xxx 4');
    print(activeReq![i]
        .requestLocationModel
        .lastUpdatedDistanceAndDuration
        ?.points);
    print(activeReq![i]
        .requestLocationModel
        .lastUpdatedDistanceAndDuration
        ?.lastUpdatedStatus
        ?.enName);
    print(activeReq![i].status.enName);
    print(activeReq![i]
        .requestLocationModel
        .lastUpdatedDistanceAndDuration
        ?.createdAt);*/
    if (hit ||
            activeReq![i].requestLocationModel.lastUpdatedDistanceAndDuration ==
                null ||
            (activeReq![i]
                        .requestLocationModel
                        .lastUpdatedDistanceAndDuration!
                        .lastUpdatedStatus ==
                    ServiceRequestStatus.confirmed &&
                activeReq![i].status == ServiceRequestStatus.accepted) ||
            (activeReq![i]
                        .requestLocationModel
                        .lastUpdatedDistanceAndDuration!
                        .lastUpdatedStatus ==
                    ServiceRequestStatus.arrived &&
                activeReq![i].status == ServiceRequestStatus.started) ||
            (activeReq![i]
                        .requestLocationModel
                        .lastUpdatedDistanceAndDuration!
                        .lastUpdatedStatus ==
                    ServiceRequestStatus.accepted &&
                activeReq![i].status == ServiceRequestStatus.arrived)

        //    || isDriverTooFar()
        ) {
      if (activeReq![i].arrived) {
        timerHomeServiceRequestItemUpdates?.cancel();
      }
      if (activeReq![i].confirmed || activeReq![i].done) {
        activeReq![i].fromForDTO =
            activeReq![i].requestLocationModel.clientPoint!;
        if (activeReq![i].requestLocationModel.destPoint != null) {
          activeReq![i].toForDTO =
              activeReq![i].requestLocationModel.destPoint!;
        }
        timerHomeServiceRequestItemUpdates?.cancel();
      } else if (activeReq![i].accepted) {
        activeReq![i].fromForDTO =
            LatLng(activeReq![i].driver!.lat!, activeReq![i].driver!.lng!);
        activeReq![i].toForDTO =
            activeReq![i].requestLocationModel.clientPoint!;
      } else {
        activeReq![i].fromForDTO =
            LatLng(activeReq![i].driver!.lat!, activeReq![i].driver!.lng!);
        activeReq![i].toForDTO = activeReq![i].requestLocationModel.destPoint!;
      }

      GetRequestDurationAndDistanceDTO getRequestDurationAndDistanceDto =
          GetRequestDurationAndDistanceDTO(
        serviceRequestId: activeReq![i].id!,
        oldStatus: activeReq![i].activeReqModel?.oldRequestStatus != null
            ? activeReq![i].activeReqModel!.oldRequestStatus!.enName
            : null,
        prevClientLocation: activeReq![i].activeReqModel != null &&
                activeReq![i].activeReqModel!.firstClientLocation != null
            ? LatLng(
                activeReq![i]
                    .activeReqModel!
                    .firstClientLocation!
                    .latitude
                    .toDouble(),
                activeReq![i]
                    .activeReqModel!
                    .firstClientLocation!
                    .longitude
                    .toDouble())
            : null,
        oldDest: activeReq![i].activeReqModel != null &&
                activeReq![i].activeReqModel!.firstClientDestination != null
            ? LatLng(
                activeReq![i]
                    .activeReqModel!
                    .firstClientDestination!
                    .latitude
                    .toDouble(),
                activeReq![i]
                    .activeReqModel!
                    .firstClientDestination!
                    .longitude
                    .toDouble())
            : null,
        driverLatLng: activeReq![i].fromForDTO!,
        curClientLocation: activeReq![i].toForDTO ?? activeReq![i].fromForDTO!,
      );
      await getRequestTimeAndDistance(
              getRequestDurationAndDistanceDto:
                  getRequestDurationAndDistanceDto,
              index: i)
          .then((value) async {
        final result = await homeRepository.getOneServiceRequest(
            serviceRequestId: activeReq![i].id!);
        await result.fold(
          (failure) {
            debugPrint(failure);
            // emit(GetRequestByIdErrorState(error: failure));
            // wenchServiceBloc?.add(HandlingWaitingTimeEvent());
            return null;
          },
          (data) async {
            activeReq![i] = data.activeReq!;
            activeReq![i].activeReqModel = data;
            if (activeReq![i].canceled) {
              activeReq!.remove(activeReq![i]);
            }
            double? lastLocalPercentage =
                await sl<CacheHelper>().get('${activeReq![i].id}percentage');
            if (lastLocalPercentage != null) {
              activeReq![i].currentGradientPercentage = lastLocalPercentage;
            }

            /// await checkIfGetTimeAndDistanceOrNot(i);
            //calcSliderPercentage(req: activeRequestsList[i]);

            if (activeReq![i].arrived) {
              await cacheHelper.put('${activeReq![i].id!}Duration',
                  activeReq![i].actualDuration.toDouble());
              await cacheHelper.put(
                  '${activeReq![i].id!}Distance', activeReq![i].actualDistance);
              await cacheHelper.put('${activeReq![i].id!}percentage', 100.0);
            }
            if (activeReq![i].done) {
              await cacheHelper.clear('${activeReq![i].id!}Duration');
              await cacheHelper.clear('${activeReq![i].id!}Distance');
              await cacheHelper.clear('${activeReq![i].id!}percentage');
              await cacheHelper.clear(
                '${activeReq![i].id!}CounterForHit',
              );
            }
            if (activeReq![i].started || activeReq![i].accepted) {
              if (await cacheHelper.get('${activeReq![i].id!}Duration') ==
                      null ||
                  cacheHelper.get('${activeReq![i].id!}Duration').toString() ==
                      "" ||
                  await cacheHelper.get('${activeReq![i].id!}Duration') == -1) {
                await cacheHelper.put('${activeReq![i].id!}Duration',
                    activeReq![i].actualDuration.toDouble());
                await cacheHelper.put('${activeReq![i].id!}Distance',
                    activeReq![i].actualDistance);
                startTimerHomeServiceRequest(i);
              }
            }
            emit(GetRequestByIdSuccessHomeState());

            return data;
          },
        );
      });
      print('hit 1');

      /* await homeRepository.getOneServiceRequest(
          serviceRequestId: activeReq![i].id!);*/
    } else {
      if (activeReq![i].accepted &&
          activeReq![i].requestLocationModel.clientPoint != null) {
        activeReq![i].fromForDTO =
            LatLng(activeReq![i].driver!.lat!, activeReq![i].driver!.lng!);
        activeReq![i].toForDTO =
            activeReq![i].requestLocationModel.clientPoint!;
        if (activeReq![i]
                .requestLocationModel
                .firstUpdatedDistanceAndDuration ==
            null) {
          GetRequestDurationAndDistanceDTO getRequestDurationAndDistanceDto =
              GetRequestDurationAndDistanceDTO(
            serviceRequestId: activeReq![i].id!,
            oldStatus: activeReq![i].activeReqModel != null
                ? activeReq![i].activeReqModel!.oldRequestStatus!.enName
                : null,
            prevClientLocation: activeReq![i].activeReqModel != null &&
                    activeReq![i].activeReqModel!.firstClientLocation != null
                ? LatLng(
                    activeReq![i]
                        .activeReqModel!
                        .firstClientLocation!
                        .latitude
                        .toDouble(),
                    activeReq![i]
                        .activeReqModel!
                        .firstClientLocation!
                        .longitude
                        .toDouble())
                : null,
            oldDest: activeReq![i].activeReqModel != null &&
                    activeReq![i].activeReqModel!.firstClientDestination != null
                ? LatLng(
                    activeReq![i]
                        .activeReqModel!
                        .firstClientDestination!
                        .latitude
                        .toDouble(),
                    activeReq![i]
                        .activeReqModel!
                        .firstClientDestination!
                        .longitude
                        .toDouble())
                : null,
            driverLatLng: activeReq![i].fromForDTO!,
            curClientLocation: activeReq![i].toForDTO!,
          );
          await getRequestTimeAndDistance(
              getRequestDurationAndDistanceDto:
                  getRequestDurationAndDistanceDto,
              index: i);
          print('hit 2');
          await homeRepository.getOneServiceRequest(
              serviceRequestId: activeReq![i].id!);
        }

        // startAcceptTimer(i);
      } else if (activeReq![i].started &&
          activeReq![i].requestLocationModel.destPoint != null) {
        activeReq![i].fromForDTO =
            LatLng(activeReq![i].driver!.lat!, activeReq![i].driver!.lng!);
        activeReq![i].toForDTO = activeReq![i].requestLocationModel.destPoint!;

        //  startAcceptTimer(i);
//        startStartTimer(i);
      }
    }
    if (activeReq![i]
                .requestLocationModel
                .lastUpdatedDistanceAndDuration
                ?.driverDistanceMatrix
                ?.distance!
                .value !=
            null &&
        activeReq![i]
                .requestLocationModel
                .lastUpdatedDistanceAndDuration
                ?.driverDistanceMatrix
                ?.duration !=
            null) {
      handleTimeAndDistanceSimulation(i);
    }

    ///  emit(CheckIfGetNewTimeAndDistanceState());
  }

  handleTimeAndDistanceSimulation(int i) {
    activeReq![i].initialRemainingMetres = activeReq![i]
        .requestLocationModel
        .lastUpdatedDistanceAndDuration!
        .driverDistanceMatrix!
        .distance!
        .value!
        .toDouble();
    activeReq![i].initialRemainingSeconds = activeReq![i]
            .requestLocationModel
            .lastUpdatedDistanceAndDuration!
            .driverDistanceMatrix!
            .duration!
            .value
            ?.toDouble() ??
        0;

    activeReq![i].lastHitDate = DateTime.parse(activeReq![i]
                .requestLocationModel
                .lastUpdatedDistanceAndDuration!
                .createdAt ??
            "")
        .toUtc();
    activeReq![i].currentTime = DateTime.now().toUtc();
    activeReq![i].timeElapsed =
        activeReq![i].currentTime!.difference(activeReq![i].lastHitDate!);
    activeReq![i].timeElapsedInSeconds = activeReq![i].timeElapsed!.inSeconds;
    activeReq![i].timeElapsedInMinutes =
        activeReq![i].timeElapsed!.inMinutes == 0
            ? 1
            : activeReq![i].timeElapsed!.inMinutes;
    activeReq![i].remainingTimeInSeconds =
        activeReq![i].initialRemainingSeconds!;
    activeReq![i].speedInMetersPerSecond =
        activeReq![i].initialRemainingMetres! /
            activeReq![i].timeElapsedInSeconds!.toDouble();
    activeReq![i].remainingDistanceInMeters =
        activeReq![i].initialRemainingMetres;
    activeReq![i].actualDistance = double.parse(
        activeReq![i].remainingDistanceInMeters!.toStringAsFixed(1));
    activeReq![i].actualDuration =
        activeReq![i].initialRemainingSeconds?.toDouble() ?? 0;
    print(
        '---------asd \n actualDistance: ${activeReq![i].actualDistance / 1000} \n actualDuration: ${activeReq![i].actualDuration ~/ 60}  \n ---------');
  }
}
