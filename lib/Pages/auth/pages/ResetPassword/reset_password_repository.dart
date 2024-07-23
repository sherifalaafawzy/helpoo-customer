import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../Configurations/Constants/api_endpoints.dart';
import '../../../../Services/Network/dio_helper.dart';
import '../../../../Services/Network/error/exceptions.dart';
import '../../../../Services/cache_helper.dart';

class ResetPasswordRepositoryImplementation extends ResetPasswordRepository {
  final DioHelper? dioHelper;
  final CacheHelper? cacheHelper;

  ResetPasswordRepositoryImplementation(
      {required this.cacheHelper, required this.dioHelper});

  @override
  Future<Either<String, void>> resetPassword(
      {required String phoneNumber, required String password, String? name}) {
    return _basicErrorHandling<void>(
      onSuccess: () async {
        final Response f = await dioHelper?.post(
          url: resetPasswordEndPoint,
          data: {
            'identifier': phoneNumber,
            'newPassword': password,
            if (name != null) 'name': name
          },
        );
        return;
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }
}

abstract class ResetPasswordRepository {
  Future<Either<String, void>> resetPassword(
      {required String phoneNumber, required String password, String? name});
}

extension on ResetPasswordRepositoryImplementation {
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
