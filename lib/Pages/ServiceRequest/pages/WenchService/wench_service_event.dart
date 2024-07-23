part of 'wench_service_bloc.dart';

@immutable
abstract class WenchServiceEvent {}

//class GetLocationEvent extends WenchServiceEvent {}

class InitialWenchServiceEvent extends WenchServiceEvent {
  final BuildContext? context;

  InitialWenchServiceEvent({required this.context});
}

class SetServiceRequestMapDataEvent extends WenchServiceEvent {
  /* final String? selectedAddress;
  final double? lang;
  final double? lat;
 SetServiceRequestMapDataEvent(
     {required this.lat,
       required this.lang,
       required this.selectedAddress});*/
}

class SetFnolMapDataEvent extends WenchServiceEvent {
/*  final String? selectedAddress;
  final double? lang;
  final double? lat;
  SetFnolMapDataEvent(
      {required this.lat,
        required this.lang,
        required this.selectedAddress});*/
}

class GetPlaceDetailsByCoordinatesEvent extends WenchServiceEvent {
  final double? latitude;
  final double? longitude;
  bool? isMyLocation = true;

  GetPlaceDetailsByCoordinatesEvent(
      {required this.longitude, required this.latitude, this.isMyLocation});
}

//class CheckIfGetTimeAndDistanceOrNotEvent extends WenchServiceEvent {}

/*class GetRequestTimeAndDistanceEvent extends WenchServiceEvent {
  final GetRequestDurationAndDistanceDTO? getRequestDurationAndDistanceDto;

  GetRequestTimeAndDistanceEvent(
      {required this.getRequestDurationAndDistanceDto});
}*/

class HandleServiceRequestSheetEvent extends WenchServiceEvent {}

class HandlingWaitingTimeEvent extends WenchServiceEvent {}

class HandleRequestRoutesEvent extends WenchServiceEvent {}

class GetRequestByIdEvent extends WenchServiceEvent {
  final String? activeReqId;

  GetRequestByIdEvent({required this.activeReqId});
}

class GetIframeEvent extends WenchServiceEvent {
  final int? requestId;
  final int? selectedPackage;
  final double? amount;

  GetIframeEvent(
      {required this.amount, required this.requestId, this.selectedPackage});
}

class ConfirmRequestEvent extends WenchServiceEvent {}

class GetConfigEvent extends WenchServiceEvent {}

class InitTrackingEvent extends WenchServiceEvent {
  final String requestId;

  InitTrackingEvent({required this.requestId});
}

class RateRequestDriverEvent extends WenchServiceEvent {
  final String? requestId;
  final String? rate;
  final String? comment;
  final String? rated;

  RateRequestDriverEvent({
    required this.requestId,
    required this.rate,
    required this.comment,
    required this.rated,
  });
}

class ChangeRequestPaymentMethod extends WenchServiceEvent {
  final PaymentMethod? pm;
  final Function? callBack;

  ChangeRequestPaymentMethod({required this.pm, required this.callBack});
}

class GetNearestDriver extends WenchServiceEvent {
  final int? id;

  GetNearestDriver({this.id});
}

class CancelServiceRequest extends WenchServiceEvent {
  final ServiceRequest? request;

  CancelServiceRequest({required this.request});
}

class UpdateUserRequestSheetEvent extends WenchServiceEvent {
  final UserRequestProcesses? userReqProcess;

  UpdateUserRequestSheetEvent({required this.userReqProcess});
}

class CreateServiceRequest extends WenchServiceEvent {
  final BuildContext? context;

  CreateServiceRequest({required this.context});
}

class CreateOtherServiceRequest extends WenchServiceEvent {
  final BuildContext? context;

  CreateOtherServiceRequest({required this.context});
}
