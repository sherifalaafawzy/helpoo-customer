part of 'service_request_bloc.dart';

@immutable
abstract class ServiceRequestEvent {}


class CheckIfUserCanSendNewRequestEvent extends ServiceRequestEvent {}

