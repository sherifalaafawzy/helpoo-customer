import 'dart:io';

import '../../Configurations/Constants/keys.dart';
import '../../Configurations/di/injection.dart';
import '../../Models/fnol/latestFnolModel.dart';
import '../../Models/get_config.dart';
import '../../Models/service_request/getDistanceAndDurationResponse.dart';
import '../../Models/service_request/getRequestDuratonAndDistance.dart';
import '../../Models/service_request/service_request.dart';
import '../../Models/service_request/service_request_model.dart';
import '../../Services/Network/dio_helper.dart';
import '../../Services/cache_helper.dart';
import '../../Services/storage_service.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../Configurations/Constants/api_endpoints.dart';
import '../../../../Services/Network/dio_helper.dart';
import '../../../../Services/Network/error/exceptions.dart';
import '../../../../Services/cache_helper.dart';

class HomeRepositoryImplementation extends HomeRepository {
  final DioHelper? dioHelper;
  final CacheHelper? cacheHelper;

  HomeRepositoryImplementation(
      {required this.cacheHelper, required this.dioHelper});

  @override
  Future<Either<String, List<ServiceRequest>>> getUserLast10RequestsHistory() {
    return _basicErrorHandling<List<ServiceRequest>>(
      onSuccess: () async {
        final Response r = await dioHelper?.get(
          url:
              '$getUserLatestRequestsEndPoint${await cacheHelper?.get(Keys.generalID)}',
          token: await cacheHelper?.get(Keys.token),
        );
        AllServiceRequests allReqs = AllServiceRequests.fromJson(r.data);

        return allReqs.requests!;
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, Map>> getRouteBetweenCoordinates(
      {required var params}) {
    return _basicErrorHandling<Map>(
      onSuccess: () async {
        Uri uri = Uri.https(
            "maps.googleapis.com", "maps/api/directions/json", params);

        final Response r = await dioHelper?.get(
          url: uri.toString(),
        );

        // debugPrintFullText('********** maps ${r.data} **********');

        return r.data;
      },
      onServerError: (exception) async {
        debugPrint('********** maps onServerError **********');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, List<LatestFnolModel>>> getLatestFNOLs() {
    return _basicErrorHandling<List<LatestFnolModel>>(
      onSuccess: () async {
        List<LatestFnolModel> latestFnolsList = [];
        final Response response = await dioHelper?.get(
          url:
              '$getLatestFnolsEndPoint${await cacheHelper?.get(Keys.generalID)}',
          token: await cacheHelper?.get(Keys.token),
        );
        Iterable I = response.data['reports'];
        latestFnolsList = List<LatestFnolModel>.from(
            I.map((fnol) => LatestFnolModel.fromJson(fnol)));

        return latestFnolsList;
      },
      onServerError: (e) async {
        return e.message;
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
  Future<Either<String, List<ServiceRequest>>> getCorporateLast10RequestsHistory() {
    return _basicErrorHandling<List<ServiceRequest>>(
      onSuccess: () async {
        final Response r = await dioHelper?.get(
          url: '$getCorporateLatestRequestsEndPoint${await cacheHelper?.get(Keys.currentUserId)}',
          token: await cacheHelper?.get(Keys.token),
        );
        AllServiceRequests allReqs = AllServiceRequests.fromJson(r.data);

        return allReqs.requests!;
      },
      onServerError: (exception) async {
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
}

abstract class HomeRepository {
  Future<Either<String, List<ServiceRequest>>> getUserLast10RequestsHistory();

  Future<Either<String, Map>> getRouteBetweenCoordinates(
      {required Map<String, Object> params});

  Future<Either<String, GetDistanceAndDurationResponse>>
      getRequestTimeAndDistance(
          {required GetRequestDurationAndDistanceDTO
              getRequestDurationAndDistanceDto});

  Future<Either<String, List<LatestFnolModel>>> getLatestFNOLs();

  Future<Either<String, ServiceRequestModel>> getOneServiceRequest(
      {required int serviceRequestId});

  Future<Either<String, List<ServiceRequest>>>
      getCorporateLast10RequestsHistory();
}

extension on HomeRepositoryImplementation {
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
