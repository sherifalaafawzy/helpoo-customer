import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:helpooappclient/Models/cars/add_corporate_car_response.dart';
import 'package:helpooappclient/Models/cars/my_cars.dart';

import '../../../../Configurations/Constants/api_endpoints.dart';
import '../../../../Configurations/Constants/constants.dart';
import '../../../../Configurations/Constants/keys.dart';
import '../../../../Models/auth/login_model.dart';
import '../../../../Models/get_config.dart';
import '../../../../Models/get_iframe_res.dart';
import '../../../../Models/map_place_details_model.dart';
import '../../../../Models/maps/map_place_details_model.dart';
import '../../../../Models/service_request/driver.dart';
import '../../../../Models/service_request/fees_other_service_model.dart';
import '../../../../Models/service_request/fees_response_model.dart';
import '../../../../Models/service_request/getDistanceAndDurationResponse.dart';
import '../../../../Models/service_request/getRequestDuratonAndDistance.dart';
import '../../../../Models/service_request/service_request.dart';
import '../../../../Models/service_request/service_request_model.dart';
import '../../../../Services/Network/dio_helper.dart';
import '../../../../Services/Network/error/exceptions.dart';
import '../../../../Services/cache_helper.dart';

class WenchServiceRepositoryImplementation extends WenchServiceRepository {
  final DioHelper? dioHelper;
  final CacheHelper? cacheHelper;

  WenchServiceRepositoryImplementation(
      {required this.cacheHelper, required this.dioHelper});

  @override
  Future<Either<String, Map>> cancelServiceRequest(ServiceRequest request) {
    var data = {"id": request.id};

    debugPrint('cancel req id: ============> ${request.id}');

    return _basicErrorHandling<Map>(
      onSuccess: () async {
        final Response r = await dioHelper?.post(
          url: '$cancelRequestEndPoint${request.id}',
          token: await cacheHelper?.get(Keys.token),
          data: data,
        );
        debugPrint('cancel req response: ===========> ${r.data}');
        return data;
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, Map>> confirmServiceRequest({
    required int serviceRequestId,
    required String status,
    required String paymentMethod,
    String? paymentStatus,
  }) {
    return _basicErrorHandling<Map>(
      onSuccess: () async {
        final Response r = await dioHelper?.patch(
          url: '$updateOneServiceRequestUrl/$serviceRequestId',
          token: await cacheHelper?.get(Keys.token),
          data: paymentStatus != null
              ? {
                  'status': status,
                  'paymentMethod': paymentMethod,
                  'paymentStatus': paymentStatus,
                }
              : {
                  'status': status,
                  'paymentMethod': paymentMethod,
                },
        );

        debugPrint('created req response ===============> ${r.data}');
        return r.data;
      },
      onServerError: (exception) async {
        debugPrint('**** onServerError ****');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, Driver>> getNearestDriver({
    required String carServiceTypeId,
    required String location,
  }) async {
    var data = {
      "carServiceTypeId": carServiceTypeId,
      "location": location,
    };

    debugPrint('data of get driver post req: ============> ${data}');

    return _basicErrorHandling<Driver>(
      onSuccess: () async {
        final Response r = await dioHelper?.post(
          url: getNearestDriverEndPoint,
          token: await cacheHelper?.get(Keys.token),
          data: data,
        );
        debugPrint('nearest driver ===========> ${r.data}');
        return Driver.fromJson(r.data);
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, void>> rateRequestDriver({
    required String reqID,
    required String rate,
    required String comment,
    required String rated,
  }) async {
    var data = {
      "ServiceRequestId": reqID,
      "rating": rate,
      "comment": comment,
      "rated": rated
    };

    return _basicErrorHandling<void>(
      onSuccess: () async {
        final Response r = await dioHelper?.post(
          url: rateRequestEndPoint,
          token: await cacheHelper?.get(Keys.token),
          data: data,
        );
        debugPrint('rate driver ===========> ${r.data}');
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, GetIframeRes>> getPaymentIframe({
    required double amount,
    int? packageId,
    int? serviceRequestId,
  }) {
    return _basicErrorHandling<GetIframeRes>(
      onSuccess: () async {
        final Response f = await dioHelper?.post(
          url: getPaymentIframeEndPoint,
          token: await cacheHelper?.get(Keys.token),
          data: {
            'amount': amount,
            if (packageId != null) 'packageId': packageId,
            if (serviceRequestId != null) 'serviceRequestId': serviceRequestId,
          },
        );
        return GetIframeRes.fromJson(f.data);
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }

  ///need to edit ya omar
  @override
  Future<Either<String, Map>> createServiceRequest(ServiceRequest request) {
    return _basicErrorHandling<Map>(
      onSuccess: () async {
        final Response r = await dioHelper?.post(
          url: requestServiceEndPoint,
          token: await cacheHelper?.get(Keys.token),
          data: request.toJson(
              MyCarModel(
                id: request.clientCar?.id,
              ),
              CorporateUser(
                  id: (userRoleName == "Client")
                      ? null
                      : await cacheHelper?.get(Keys.currentCompanyId))),
        );

        debugPrint('created req response ===============> ${r.data}');
        return r.data;
      },
      onServerError: (exception) async {
        debugPrint('********** onServerError **********');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, Map>> createOtherServiceRequest(
      ServiceRequest request) {
    return _basicErrorHandling<Map>(
      onSuccess: () async {
        final Response r = await dioHelper?.post(
          url: requestOtherService,
          token: await cacheHelper?.get(Keys.token),
          data: request.toJson(
              isOtherService: true,
              MyCarModel(
                id: request.clientCar?.id,
              ),
              CorporateUser(
                  id: (userRoleName == "Client")
                      ? null
                      : await cacheHelper?.get(Keys.currentCompanyId))),
        );

        //await assignDriverToRequest(request);
        debugPrint('created req response ===============> ${r.data}');
        return r.data;
      },
      onServerError: (exception) async {
        debugPrint('********** onServerError **********');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, GetConfigModel>> getConfig() {
    return _basicErrorHandling<GetConfigModel>(
      onSuccess: () async {
        final Response f = await dioHelper?.get(
          url: '$getConfigEndPoint',
        );
        return GetConfigModel.fromJson(f.data);
      },
      onServerError: (exception) async {
        debugPrint('********** onServerError **********');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, ServiceRequestModel>> getOneServiceRequest({
    required int serviceRequestId,
  }) {
    return _basicErrorHandling<ServiceRequestModel>(
      onSuccess: () async {
        final Response f = await dioHelper?.get(
          token: await cacheHelper?.get(Keys.token),
          url: '$getRequestByIdEndPoint$serviceRequestId',
        );
        return ServiceRequestModel.fromJson(f.data);
      },
      onServerError: (exception) async {
        debugPrint('********** onServerError **********');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, GetDistanceAndDurationResponse>>
      getRequestTimeAndDistance(
          {required GetRequestDurationAndDistanceDTO
              getRequestDurationAndDistanceDto}) {
    return _basicErrorHandling<GetDistanceAndDurationResponse>(
      onSuccess: () async {
        final Response f = await dioHelper?.post(
          token: await cacheHelper?.get(Keys.token),
          url: getRequestTimeAndDistanceByIdEndPoint,
          data: getRequestDurationAndDistanceDto.toJson(),
        );
        print(f.data.toString());
        return GetDistanceAndDurationResponse.fromJson(f.data);
      },
      onServerError: (exception) async {
        debugPrint('********** onServerError **********');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, GetDistanceAndDurationResponse>>
      getRequestTimeAndDistanceOtherService(
          {required GetRequestDurationAndDistanceDTO
              getRequestDurationAndDistanceDto}) {
    return _basicErrorHandling<GetDistanceAndDurationResponse>(
      onSuccess: () async {
        final Response f = await dioHelper?.post(
          token: await cacheHelper?.get(Keys.token),
          url: getRequestTimeAndDistanceByIdEndPoint,
          data: getRequestDurationAndDistanceDto.toJson(),
        );
        print(f.data.toString());
        return GetDistanceAndDurationResponse.fromJson(f.data);
      },
      onServerError: (exception) async {
        debugPrint('********** onServerError **********');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, MapPlaceDetailsCoordinatesModel>>
      getPlaceDetailsByCoordinates({
    required String latLng,
  }) async {
    return _basicErrorHandling<MapPlaceDetailsCoordinatesModel>(
      onSuccess: () async {
        final Response f = await dioHelper?.get(
          base: mapUrl,
          url: getPlacesDetailsByCoordinatesUrl,
          query: {
            'latlng': latLng,
            'key': MapApiKey,
          },
        );

        return MapPlaceDetailsCoordinatesModel.fromJson(f.data);
      },
      onServerError: (exception) async {
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        // debugPrint(exception.error);
        return exception.message;
      },
      onOtherError: (exception) async {
        debugPrint(exception.token);
        debugPrint(exception.title.toString());
        debugPrint(exception.error);
        return exception.token;
      },
    );
  }

  @override
  Future<Either<String, FeesResponseModel>> getServiceRequestFees({
    int? serviceId,
    required int userId,
    required int carId,
    required String destinationDistance,
    required String distance,
    // required String distanceEuro,
    // required String distanceNorm,
  }) {
    Map data = {
      if (serviceId != null) 'serviceId': serviceId,
      'userId': userId,
      'carId': carId,
      'destinationDistance': destinationDistance,
      'distance': distance,
      // 'distanceEuro': distanceEuro,
      // 'distanceNorm': distanceNorm,
    };

    debugPrint('input data x=================> ${data}');

    return _basicErrorHandling<FeesResponseModel>(
      onSuccess: () async {
        final Response r = await dioHelper?.post(
          url: calculateTripFeesEndPoint,
          token: await cacheHelper?.get(Keys.token),
          data: data,
        );
        debugPrint('fees response x=================> ${r.data}');
        return FeesResponseModel.fromJson(r.data);
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, FeesOtherServiceResponseModel>>
      getOtherServiceRequestFees({
    required int userId,
    required int carId,
    required Map<String, dynamic> distance,
    required Map<String, int> services,
  }) {
    Map data = {
      'userId': userId,
      'carId': carId,
      'distance': distance,
      'services': services,
    };

    debugPrint('input data x=================> ${data}');

    return _basicErrorHandling<FeesOtherServiceResponseModel>(
      onSuccess: () async {
        final Response r = await dioHelper?.post(
          url: calculateTripFeesOtherService,
          token: await cacheHelper?.get(Keys.token),
          data: data,
        );
        debugPrint('fees response x=================> ${r.data}');
        return FeesOtherServiceResponseModel.fromMap(r.data);
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, MapPlaceDetailsModel>> getPlaceDetails({
    required String placeId,
  }) async {
    return _basicErrorHandling<MapPlaceDetailsModel>(
      onSuccess: () async {
        final Response f = await dioHelper?.get(
          base: mapUrl,
          url: getPlacesDetailsUrl,
          query: {
            'place_id': placeId,
            'key': MapApiKey,
          },
        );

        return MapPlaceDetailsModel.fromJson(f.data);
      },
      onServerError: (exception) async {
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        // debugPrint(exception.error);
        return exception.message;
      },
      onOtherError: (exception) async {
        debugPrint(exception.token);
        debugPrint(exception.title.toString());
        debugPrint(exception.error);
        return exception.token;
      },
    );
  }

  @override
  Future<Either<String, AssignDriverToRequestResponse>> assignDriverToRequest(
      ServiceRequest request) {
    var data = {
      "driverId": request.driver!.id.toString(),
      "requestId": request.id.toString()
    };

    return _basicErrorHandling<AssignDriverToRequestResponse>(
      onSuccess: () async {
        final Response r = await dioHelper?.post(
          url: assignDriverToRequestEndPoint,
          data: data,
        );
        debugPrint('assigning driver response ============> ${r.data}');
        return AssignDriverToRequestResponse.fromJson(r.data);
      },
      onServerError: (exception) async {
        return exception.toString();
      },
    );
  }

  @override
  Future<Either<String, Driver>> getDriverDetails(
    List<int> ids,
    Location location,
  ) async {
    return await _basicErrorHandling(
      onSuccess: () async {
        final response = dioHelper?.post(
          token: await cacheHelper?.get(Keys.token),
          url: getDriverLocationDetails,
          data: {
            'carServiceTypeId': ids,
            'location': {
              'clientLatitude': location.lat,
              'clientLongitude': location.lng,
            }
          },
        );
        return response!.then((value) {
          final driver = Driver.fromJson(value.data);
          return driver;
        });
      },
      onServerError: (e) async {
        return e.message;
      },
      onCacheError: (e) async {
        return e.toString();
      },
    );
  }
}

abstract class WenchServiceRepository {
  Future<Either<String, Map>> cancelServiceRequest(ServiceRequest request);

  Future<Either<String, Map>> confirmServiceRequest({
    required int serviceRequestId,
    required String status,
    required String paymentMethod,
    String? paymentStatus,
  });

  Future<Either<String, Driver>> getNearestDriver({
    required String carServiceTypeId,
    required String location,
  });

  Future<Either<String, void>> rateRequestDriver({
    required String reqID,
    required String rate,
    required String comment,
    required String rated,
  });

  Future<Either<String, GetIframeRes>> getPaymentIframe({
    required double amount,
    int? packageId,
    int? serviceRequestId,
  });

  Future<Either<String, Map>> createServiceRequest(ServiceRequest request);

  Future<Either<String, GetConfigModel>> getConfig();

  Future<Either<String, ServiceRequestModel>> getOneServiceRequest(
      {required int serviceRequestId});

  Future<Either<String, GetDistanceAndDurationResponse>>
      getRequestTimeAndDistance(
          {required GetRequestDurationAndDistanceDTO
              getRequestDurationAndDistanceDto});

  Future<Either<String, MapPlaceDetailsCoordinatesModel>>
      getPlaceDetailsByCoordinates({
    required String latLng,
  });

  Future<Either<String, FeesResponseModel>> getServiceRequestFees({
    int? serviceId,
    required int userId,
    required int carId,
    required String destinationDistance,
    required String distance,
    // required String distanceEuro,
    // required String distanceNorm,
  });

  Future<Either<String, MapPlaceDetailsModel>> getPlaceDetails({
    required String placeId,
  });

  Future<Either<String, AssignDriverToRequestResponse>> assignDriverToRequest(
      ServiceRequest request);
  Future<Either<String, Driver>> getDriverDetails(
    List<int> ids,
    Location location,
  );
  Future<Either<String, GetDistanceAndDurationResponse>>
      getRequestTimeAndDistanceOtherService(
          {required GetRequestDurationAndDistanceDTO
              getRequestDurationAndDistanceDto});
  Future<Either<String, Map>> createOtherServiceRequest(ServiceRequest request);
  Future<Either<String, FeesOtherServiceResponseModel>>
      getOtherServiceRequestFees({
    required int userId,
    required int carId,
    required Map<String, dynamic> distance,
    required Map<String, int> services,
    // required String distanceEuro,
    // required String distanceNorm,
  });
}

extension on WenchServiceRepositoryImplementation {
  Future<Either<String, T>> _basicErrorHandling<T>({
    required Future<T> Function() onSuccess,
    Future<String> Function(ServerException exception)? onServerError,
    Future<String> Function(CacheException exception)? onCacheError,
    Future<String> Function(dynamic exception)? onOtherError,
  }) async {
    try {
      final f = await onSuccess();
      return Right(f);
    } on ServerException catch (e, s) {
      // recordError(e, s);
      debugPrint(s.toString());
      if (onServerError != null) {
        final f = await onServerError(e);
        return Left(f);
      }
      return const Left('Server Error');
    } on CacheException catch (e, _) {
      debugPrint(e.toString());
      if (onCacheError != null) {
        final f = await onCacheError(e);
        return Left(f);
      }
      return const Left('Cache Error');
    } catch (e, s) {
      // recordError(e, s);
      debugPrint(s.toString());
      if (onOtherError != null) {
        final f = await onOtherError(e);
        return Left(f);
      }
      return Left(e.toString());
    }
  }
}
