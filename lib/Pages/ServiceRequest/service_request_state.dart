part of 'service_request_bloc.dart';

@immutable
abstract class ServiceRequestState {}

class ServiceRequestInitial extends ServiceRequestState {}

class CheckIfUserCanSendRequestLoadingState extends ServiceRequestState {}

class CheckIfUserCanSendRequestSuccessState extends ServiceRequestState {}

class CheckIfGetNewTimeAndDistanceState extends ServiceRequestState {}

class UserCanSendNewRequest extends ServiceRequestState {}

class UserCanNotSendNewRequest extends ServiceRequestState {}

class CheckIfUserCanSendRequestErrorState extends ServiceRequestState {
  final String error;

  CheckIfUserCanSendRequestErrorState({required this.error});
}

class GetLocationLoadingServiceRequest extends ServiceRequestState {}

class GetLocationDone extends ServiceRequestState {}


