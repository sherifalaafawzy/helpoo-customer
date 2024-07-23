part of 'wench_service_bloc.dart';

@immutable
abstract class WenchServiceState {}

class WenchServiceInitial extends WenchServiceState {}
class TrackingLoadingState extends WenchServiceState {}
class TrackingLoadedState extends WenchServiceState {}

class GetPermissionAllowedState extends WenchServiceState {
  final String? selectedAddress;
  final double? lang;
  final double? lat;

  GetPermissionAllowedState(
      {required this.lat, required this.lang, required this.selectedAddress});
}

class GetNearestDriverLoadingState extends WenchServiceState {}

class GetNearestDriverSuccessState extends WenchServiceState {
  final Driver? driver;

  GetNearestDriverSuccessState({required this.driver});
}

class GetNearestDriverErrorState extends WenchServiceState {
  final String error;

  GetNearestDriverErrorState({required this.error});
}

class EmptyStateToRebuild extends WenchServiceState {}

class CameraMoveStartedState extends WenchServiceState {}

class ReturnStringAsKmOrMetersState extends WenchServiceState {}

class ReturnStringAsHoursOrMinutesState extends WenchServiceState {}

class GetRequestTimeAndDistanceByIdLoadingState extends WenchServiceState {}

class GetRequestTimeAndDistanceByIdSuccessState extends WenchServiceState {}

class GetRequestTimeAndDistanceByIdErrorState extends WenchServiceState {
  final String error;

  GetRequestTimeAndDistanceByIdErrorState({required this.error});
}

// cancel request
class CancelRequestLoadingState extends WenchServiceState {}

class CancelRequestSuccessState extends WenchServiceState {}

class CancelRequestErrorState extends WenchServiceState {
  final String error;

  CancelRequestErrorState({required this.error});
}

class DrawRequestPathLoadingState extends WenchServiceState {}

class DrawRequestPathSuccessState extends WenchServiceState {}

class DrawRequestPathErrorState extends WenchServiceState {
  final String error;

  DrawRequestPathErrorState({required this.error});
}

class GetRequestFeesLoadingState extends WenchServiceState {}

class GetRequestFeesSuccessState extends WenchServiceState {}

class GetRequestFeesErrorState extends WenchServiceState {
  final String error;

  GetRequestFeesErrorState({required this.error});
}

class CreateRequestLoadingState extends WenchServiceState {}

class CreateRequestSuccessState extends WenchServiceState {}

class CreateRequestErrorState extends WenchServiceState {
  final String error;

  CreateRequestErrorState({required this.error});
}

// assign deriver to request
class AssignDriverToRequestLoadingState extends WenchServiceState {}

class AssignDriverToRequestSuccessState extends WenchServiceState {}

class AssignDriverToRequestErrorState extends WenchServiceState {
  final String error;

  AssignDriverToRequestErrorState({required this.error});
}

class SetMapControllerSuccess extends WenchServiceState {}

class RateRequestDriverLoadingState extends WenchServiceState {}

class RateRequestDriverSuccessState extends WenchServiceState {}

class RateRequestDriverErrorState extends WenchServiceState {
  final String error;

  RateRequestDriverErrorState({required this.error});
}

class UserRequestProcessChangedState extends WenchServiceState {
  final UserRequestProcesses? userRequestProcesses;

  UserRequestProcessChangedState({required this.userRequestProcesses});
}

class ConfirmRequestLoadingState extends WenchServiceState {}

class ConfirmRequestSuccessState extends WenchServiceState {}

class ConfirmRequestErrorState extends WenchServiceState {
  final String error;

  ConfirmRequestErrorState({
    required this.error,
  });
}

class PaymentMethodChangedState extends WenchServiceState {}

class GetIFrameUrlLoadingState extends WenchServiceState {}

class GetIFrameUrlSuccessState extends WenchServiceState {
  final String? url;

  GetIFrameUrlSuccessState({required this.url});
}

class GetIFrameUrlErrorState extends WenchServiceState {
  final String error;

  GetIFrameUrlErrorState({
    required this.error,
  });
}

class WenchServiceOnlinePaymentSuccessState extends WenchServiceState {}

class GetLocationLoading extends WenchServiceState {}

class GetLocationDone extends WenchServiceState {}

class GetPlacesDetailsSuccess extends WenchServiceState {}

class GetPlacesDetailsError extends WenchServiceState {
  final String error;

  GetPlacesDetailsError({
    required this.error,
  });
}

class GetConfigLoadingState extends WenchServiceState {}

class GetConfigSuccessState extends WenchServiceState {}

class GetConfigErrorState extends WenchServiceState {
  final String error;

  GetConfigErrorState({
    required this.error,
  });
}

class GetRequestByIdLoadingState extends WenchServiceState {}

class GetRequestByIdSuccessState extends WenchServiceState {}

class GetRequestByIdErrorState extends WenchServiceState {
  final String error;

  GetRequestByIdErrorState({required this.error});
}

class AddMarkerSuccess extends WenchServiceState {}

class ClearOnStart extends WenchServiceState {}

class MoveCameraToPositionSuccess extends WenchServiceState {}

class UpdateMapState extends WenchServiceState {}
class LoadingMapState extends WenchServiceState {}

class GoogleMapsHitSucceded extends WenchServiceState {}

class GoogleMapsHitFailed extends WenchServiceState {}

class GetDriverPathToDrawLoading extends WenchServiceState {}

class GetDriverPathToDrawSuccess extends WenchServiceState {}

class GetDriverPathToDrawError extends WenchServiceState {
  final String error;

  GetDriverPathToDrawError({
    required this.error,
  });
}

///
class GetPathToDrawLoading extends WenchServiceState {}

class GetPathToDrawSuccess extends WenchServiceState {}

class IsPayWithPackageDiscount extends WenchServiceState {}

class GetPathToDrawError extends WenchServiceState {
  final String error;

  GetPathToDrawError({
    required this.error,
  });
}

class CalculateWaitingTimeState extends WenchServiceState {}

class CameraMovementPositionChanged extends WenchServiceState {}

class GetMapPlaceCoordinatesDetailsLoading extends WenchServiceState {}

class GetMapPlaceCoordinatesDetailsSuccess extends WenchServiceState {}

class GetMapPlaceCoordinatesDetailsError extends WenchServiceState {
  final String error;

  GetMapPlaceCoordinatesDetailsError({
    required this.error,
  });
}

class CameraIdleDone extends WenchServiceState {}

class IsCameraIdle extends WenchServiceState {}

class UpdateFnolLocationAddress extends WenchServiceState {}

class UpdateFnolCurrentLocation extends WenchServiceState {}

class GetActiveRequestDataFromGoogleMapsState extends WenchServiceState {}

class UpdateSRSearchLocation extends WenchServiceState {}

class UpdateSRLocationAddress extends WenchServiceState {}

class GetPlacesDetailsLoading extends WenchServiceState {}
