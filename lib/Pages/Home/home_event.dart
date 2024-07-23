part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class NavigateToServiceRequestScreen extends HomeEvent {
  final BuildContext? context;

  NavigateToServiceRequestScreen({required this.context});
}


class NavigateToFNOLScreen extends HomeEvent {
  final BuildContext? context;

  NavigateToFNOLScreen({required this.context});
}

class GetLatestRequests extends HomeEvent {}
class CheckIfGetTimeAndDistanceOrNotHomeEvent extends HomeEvent {}
class GetFNOLLatestRequests extends HomeEvent {}

class FilterCurrentRequests extends HomeEvent {}

class UpdateTabIndexHomeServiceRequestAndFNOL extends HomeEvent {
  final int? index;

  UpdateTabIndexHomeServiceRequestAndFNOL({required this.index});
}

class GetRequestByIdHomeEvent extends HomeEvent {
  final String? activeReqId;

  GetRequestByIdHomeEvent({required this.activeReqId});
}
