import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:helpooappclient/Models/cars/add_corporate_car_response.dart';
import 'package:helpooappclient/Models/cars/my_cars.dart';

import '../../../../Configurations/Constants/api_endpoints.dart';
import '../../../../Models/auth/login_model.dart';
import '../../../../Services/Network/dio_helper.dart';
import '../../../../Services/Network/error/exceptions.dart';
import '../../../../Services/cache_helper.dart';
import '../../Configurations/Constants/constants.dart';
import '../../Configurations/Constants/keys.dart';
import '../../Models/get_config.dart';
import '../../Models/get_iframe_res.dart';
import '../../Models/map_place_details_model.dart';
import '../../Models/packages/check_promo_normal_or_package.dart';
import '../../Models/packages/get_all.dart';
import '../../Models/packages/get_promo_with_filters.dart';
import '../../Models/promoCode.dart';
import '../../Models/service_request/driver.dart';
import '../../Models/service_request/fees_response_model.dart';
import '../../Models/service_request/getDistanceAndDurationResponse.dart';
import '../../Models/service_request/getRequestDuratonAndDistance.dart';
import '../../Models/service_request/service_request.dart';
import '../../Models/service_request/service_request_model.dart';

class ServiceRequestRepositoryImplementation extends ServiceRequestRepository {
  final DioHelper? dioHelper;
  final CacheHelper? cacheHelper;

  ServiceRequestRepositoryImplementation(
      {required this.cacheHelper, required this.dioHelper});

  @override
  Future<Either<String, ServiceRequest?>> checkIfUserCanSendNewRequest() {
    return _basicErrorHandling<ServiceRequest?>(
      onSuccess: () async {
        // printMeLog("data===> " + '$checkForCurrentActiveRequestEndPoint$clientId');
        final Response r = await dioHelper?.get(
          url:
              '$checkForCurrentActiveRequestEndPoint${await cacheHelper?.get(Keys.generalID)}',
          token: await cacheHelper?.get(Keys.token),
        );
        debugPrint('x======> response data: ${r.data}');
        if (r.data['request'] != null) {
          return ServiceRequest.fromJson(r.data['request']);
        }
        return null;
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }

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
    required int? packageId,
    required int? serviceRequestId,
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
          data: request.toJson(MyCarModel(id: request.id),
              request.corporateCompanyId //CorporateUser()
              ),
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
    required int userId,
    required int carId,
    required String destinationDistance,
    required String distance,
    // required String distanceEuro,
    // required String distanceNorm,
  }) {
    Map data = {
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
}

abstract class ServiceRequestRepository {
  Future<Either<String, ServiceRequest?>> checkIfUserCanSendNewRequest();

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
    required int? packageId,
    required int? serviceRequestId,
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
    required int userId,
    required int carId,
    required String destinationDistance,
    required String distance,
    // required String distanceEuro,
    // required String distanceNorm,
  });
}

extension on ServiceRequestRepositoryImplementation {
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
    } on CacheException catch (e, s) {
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
