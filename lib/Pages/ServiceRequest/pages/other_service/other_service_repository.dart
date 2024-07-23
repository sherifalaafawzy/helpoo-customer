import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:helpooappclient/Models/service_request/driver.dart';

import '../../../../Configurations/Constants/api_endpoints.dart';
import '../../../../Configurations/Constants/keys.dart';
import '../../../../Services/Network/dio_helper.dart';
import '../../../../Services/Network/error/exceptions.dart';
import '../../../../Services/cache_helper.dart';

abstract class OtherServiceRepository {
  Future<Either<String, Driver>> getDriverDetails(
    List<int> ids,
    Location location,
  );
}

class OtherServiceRepositoryImpl implements OtherServiceRepository {
  final DioHelper dioHelper;
  final CacheHelper cacheHelper;
  const OtherServiceRepositoryImpl({
    required this.dioHelper,
    required this.cacheHelper,
  });
  @override
  Future<Either<String, Driver>> getDriverDetails(
    List<int> ids,
    Location location,
  ) async {
    return await _basicErrorHandling(
      onSuccess: () async {
        final response = dioHelper.post(
          token: await cacheHelper.get(Keys.token),
          url: getDriverLocationDetails,
          data: {
            'carServiceTypeId': ids,
            'location': {
              'clientLatitude': location.lat,
              'clientLongitude': location.lng,
            }
          },
        );
        return response.then((value) {
          final driver = Driver.fromJson(value.data);
          return driver;
        });
      },
      onServerError: (e) async {
        return e.toString();
      },
      onCacheError: (e) async {
        return e.toString();
      },
    );
  }
}

extension on OtherServiceRepositoryImpl {
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
