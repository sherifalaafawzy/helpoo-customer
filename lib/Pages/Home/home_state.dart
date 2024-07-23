part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class GetRequestsHistoryLoadingState extends HomeState {}

class GetRequestByIdSuccessHomeState extends HomeState {}

class UpdateSliderState extends HomeState {
  final double? percentage;

  UpdateSliderState({required this.percentage});
}

class GetRequestsHistorySuccessState extends HomeState {}

class GetRequestsHistoryErrorState extends HomeState {
  final String error;

  GetRequestsHistoryErrorState({required this.error});
}

class FilterCurrentRequestsState extends HomeState {
  final ServiceRequest? activeReq;
  final int? index;

  FilterCurrentRequestsState({required this.activeReq, required this.index});
}

class FilterHistoryRequestsState extends HomeState {}

class UpdatePercentageSlider extends HomeState {
  final double? percentageState;

  UpdatePercentageSlider({required this.percentageState});
}

class GoogleMapsHitFailed extends HomeState {}

class GoogleMapsHitSucceeded extends HomeState {}

class GetLatestFNOLsLoading extends HomeState {}

class GetLatestFNOLsSuccess extends HomeState {}

class GetLatestFNOLsError extends HomeState {
  final String error;

  GetLatestFNOLsError({
    required this.error,
  });
}

class GetRequestTimeAndDistanceByIdHomeSuccessState extends HomeState {}
