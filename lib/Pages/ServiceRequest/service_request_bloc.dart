
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';


import '../../Configurations/Constants/keys.dart';
import '../../Configurations/di/injection.dart';
import '../../Services/cache_helper.dart';
import 'service_request_repository.dart';
import 'package:location/location.dart' as ll;
import 'package:geocoding/geocoding.dart' as GeocodingForCountry;

part 'service_request_event.dart';

part 'service_request_state.dart';

class ServiceRequestBloc
    extends Bloc<ServiceRequestEvent, ServiceRequestState> {
  final ServiceRequestRepository serviceRequestRepository =
      sl<ServiceRequestRepository>();
  final CacheHelper cacheHelper = sl<CacheHelper>();
  ServiceRequestBloc? serviceRequestBloc;
  Position? currentPosition;
  String currentAddress = "";
  LatLng? currentLatLng;

  ServiceRequestBloc() : super(ServiceRequestInitial()) {
    on<ServiceRequestEvent>((event, emit) {});

    on<CheckIfUserCanSendNewRequestEvent>((event, emit) async {
      // TODO: implement event handler
      emit(CheckIfUserCanSendRequestLoadingState());

      final result =
          await serviceRequestRepository.checkIfUserCanSendNewRequest();

      result.fold(
        (failure) {
          debugPrint(failure);
          emit(CheckIfUserCanSendRequestErrorState(error: failure));
          return null;
        },
        (data) {
          emit(CheckIfUserCanSendRequestSuccessState());
          print("data?.carId");
          print(data);
          if (data != null) {
            emit(UserCanNotSendNewRequest());
          } else {
            emit(UserCanSendNewRequest());
          }
          return data;
        },
      );
    });
  }
  ll.LocationData? locationData;
  ll.Location location = ll.Location();

  Future<String?> getForceLocation() async {
    emit(GetLocationLoadingServiceRequest());
    locationData = await location.getLocation().then((value) async {
      print(value.latitude);
      print(value.longitude);
      GeocodingForCountry.Placemark? placemarks;
      if (value.latitude != null && value.longitude != null) {
        placemarks = await GeocodingForCountry.placemarkFromCoordinates(
            value.latitude!, value.longitude!,
            localeIdentifier:
            await cacheHelper.get(Keys.languageCode).then((value) {
              print("locale ${value}");
              return value;
            }))
            .then((value) => value.first);
        String currentAddress2 =
            '${placemarks?.street},${placemarks?.subAdministrativeArea}, ${placemarks?.administrativeArea}, ${placemarks?.postalCode}, ${placemarks?.country}';
        print('placemarks?.toJson()');
        print(placemarks?.toJson());
        currentAddress = currentAddress2; //res2.results[0].formattedAddress!;
        print('address ya omar');
        print(currentAddress);

        currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        currentLatLng = LatLng(value.latitude!, value.longitude!);
       /// cameraPosition = CameraPosition(target: LatLng(value.latitude!, value.longitude!), zoom: 14);
        emit(GetLocationDone());
      }
      return value;
    });
    if (currentAddress.isEmpty) {
      //  emit(GetLocationErr());
    }
    return currentAddress;
  }
}

