import 'dart:io';

import '../../Configurations/Constants/keys.dart';
import '../../Configurations/di/injection.dart';
import '../../Models/get_config.dart';
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

class SplashRepositoryImplementation extends SplashRepository {
  final DioHelper? dioHelper;
  final CacheHelper? cacheHelper;

  SplashRepositoryImplementation(
      {required this.cacheHelper, required this.dioHelper});

  @override
  Future<dynamic> getToken() {
    return cacheHelper!.get(Keys.token);
  }
  @override
  Future<dynamic> getUserFirstTimeStatus() {
    return cacheHelper!.get(Keys.firstTime);
  }
  @override
  Future<dynamic> setUserFirstTimeStatus() {
    return cacheHelper!.put(Keys.firstTime,false);
  }

  @override
  Future<dynamic> getLanguage() {
    return cacheHelper!.get(Keys.languageCode);
  }

  @override
  Future<dynamic> changeLang(
    String lang,
  ) {
    return cacheHelper!.put(Keys.languageCode, lang);
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
}

abstract class SplashRepository {
  Future<Either<String, GetConfigModel>> getConfig();

  Future<dynamic> getToken();
  Future<dynamic> getUserFirstTimeStatus();
  Future<dynamic> setUserFirstTimeStatus();

  Future<dynamic> getLanguage();

  Future<dynamic> changeLang(String lang);
}

extension on SplashRepositoryImplementation {
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
