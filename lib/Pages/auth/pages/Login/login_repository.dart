import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../Configurations/Constants/api_endpoints.dart';
import '../../../../Models/auth/login_model.dart';
import '../../../../Services/Network/dio_helper.dart';
import '../../../../Services/Network/error/exceptions.dart';
import '../../../../Services/cache_helper.dart';

class LoginRepositoryImplementation extends LoginRepository {
  final DioHelper? dioHelper;
  final CacheHelper? cacheHelper;

  LoginRepositoryImplementation(
      {required this.cacheHelper, required this.dioHelper});

  @override
  Future<Either<String, LoginModel>> login(
      {required String identifier, required String password,required String fcmToken, required Map<String, dynamic> loginData}) async {
    return _basicErrorHandling<LoginModel>(
      onSuccess: () async {
        final Response f = await dioHelper?.post(
          url: loginEndPoint,
          data: {
            'identifier': identifier,
            'password': password,
            'fcmtoken': fcmToken,
            'loginData': loginData,
          },
        );
        // debugPrintFullText('${f.data} *******');
        return LoginModel.fromJson(f.data);
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }
}

abstract class LoginRepository {
  Future<Either<String, LoginModel>> login({
    required String identifier,
    required String password,
    required String fcmToken,
    required Map<String, dynamic> loginData,
  });
}

extension on LoginRepositoryImplementation {
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
