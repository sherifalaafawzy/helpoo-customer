import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../Configurations/Constants/api_endpoints.dart';
import '../../../../Configurations/Constants/keys.dart';
import '../../../../Models/auth/login_model.dart';
import '../../../../Services/Network/dio_helper.dart';
import '../../../../Services/Network/error/exceptions.dart';
import '../../../../Services/cache_helper.dart';

class SignUpRepositoryImplementation extends SignUpRepository {
  final DioHelper? dioHelper;
  final CacheHelper? cacheHelper;

  SignUpRepositoryImplementation(
      {required this.cacheHelper, required this.dioHelper});
  @override
  Future<Either<String, LoginModel>> register({
    required String identifier,
    required String name,
    required String password,
    String? promoCode,
    String? email,
    required Map<String, dynamic> loginData,
  }) {
    return _basicErrorHandling<LoginModel>(
      onSuccess: () async {
        final Response f = await dioHelper?.post(
          url: registerEndPoint,
          data: {
            'identifier': identifier,
            'name': name,
            'password': password,
            'loginData': loginData,
            if (email != null) 'email': email,
            if (promoCode != null) 'promoCode': promoCode,
          },
        );

        return LoginModel.fromJson(f.data);
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }
  @override
  Future<Either<String, void>> updateProfile({
    required String name,
    required String email,
  }) {
    return _basicErrorHandling<void>(
      onSuccess: () async {
        final Response f = await dioHelper?.patch(
          url: updateUserProfileEndPoint,
          token:await cacheHelper?.get(Keys.token),
          data: {
            "name": name,
            "email": email,
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

abstract class SignUpRepository {
  Future<Either<String, LoginModel>> register({
    required String identifier,
    required String name,
    required String password,
    String? promoCode,
    String? email,
    required Map<String, dynamic> loginData,
  });
  Future<Either<String, void>> updateProfile({
    required String name,
    required String email,
  });
}

extension on SignUpRepositoryImplementation {
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
