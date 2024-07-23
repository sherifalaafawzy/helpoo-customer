import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:helpooappclient/Pages/ServiceRequest/pages/WenchService/wench_service_repository.dart';
import 'package:meta/meta.dart';

import '../../../../Models/service_request/driver.dart';
import '../../../../Models/service_request/service_request.dart';
import 'other_service_repository.dart';

part 'other_service_state.dart';

class OtherServiceCubit extends Cubit<OtherServiceState> {
  final OtherServiceRepository _repository;
  final WenchServiceRepository _wenchServiceRepository;
  OtherServiceCubit(this._repository, this._wenchServiceRepository)
      : super(OtherServiceState());

  Future<void> getDriverDetails(List<int> ids, Location location) async {
    emit(state.copyWith(status: OtherServiceStateStatus.loading));
    final response = await _repository.getDriverDetails(ids, location);
    response.fold(
      (l) => emit(state.copyWith(
        status: OtherServiceStateStatus.error,
        errorMessage: l,
      )),
      (r) => emit(state.copyWith(
        status: OtherServiceStateStatus.loaded,
        userRequestProcess: UserRequestProcesses.otherService,
        driverDetails: r,
      )),
    );
  }

  void setCameraPosition(CameraPosition cameraPosition) =>
      emit(state.copyWith(cameraPosition: cameraPosition));
  //TODO: implement this method
  Future<void> getPlaceDetailsByCoordinates(LatLng latLng) async {}
  //TODO: implement this method
  void handleRouteZoom(LatLngBounds bounds) {
    final newCameraPosition = CameraPosition(
      target: LatLng(
        (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
      ),
      zoom: 14.4746,
    );
    emit(state.copyWith(cameraPosition: newCameraPosition));
  }
}
