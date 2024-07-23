// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'other_service_cubit.dart';

enum OtherServiceStateStatus {
  initial,
  loading,
  loaded,
  error,
}

@immutable
class OtherServiceState {
  final OtherServiceStateStatus status;
  final UserRequestProcesses userRequestProcess;
  final String? errorMessage;
  final Driver? driverDetails;
  final CameraPosition? cameraPosition;
  final LatLng? destination;
  final List<LatLng> polylineCoordinates;
  final Set<Polyline> polylines;
  final Set<Marker> markers;
  OtherServiceState({
    this.userRequestProcess = UserRequestProcesses.none,
    this.status = OtherServiceStateStatus.initial,
    this.cameraPosition,
    this.errorMessage,
    this.driverDetails,
    this.destination,
    this.polylineCoordinates = const [],
    this.polylines = const {},
    this.markers = const {},
  });

  OtherServiceState copyWith({
    OtherServiceStateStatus? status,
    String? errorMessage,
    Driver? driverDetails,
    UserRequestProcesses? userRequestProcess,
    CameraPosition? cameraPosition,
  }) {
    return OtherServiceState(
      status: status ?? this.status,
      userRequestProcess: userRequestProcess ?? this.userRequestProcess,
      errorMessage: errorMessage ?? this.errorMessage,
      driverDetails: driverDetails ?? this.driverDetails,
      cameraPosition: cameraPosition ?? this.cameraPosition,
    );
  }

  @override
  String toString() =>
      'OtherServiceState(status: $status, errorMessage: $errorMessage, driverDetails: $driverDetails)';

  @override
  bool operator ==(covariant OtherServiceState other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        other.userRequestProcess == userRequestProcess &&
        other.errorMessage == errorMessage &&
        other.driverDetails == driverDetails;
  }

  @override
  int get hashCode =>
      status.hashCode ^
      errorMessage.hashCode ^
      userRequestProcess.hashCode ^
      driverDetails.hashCode;
}
