import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../Configurations/Constants/api_endpoints.dart';
import '../../../../Configurations/Constants/constants.dart';
import '../../../../Configurations/Constants/enums.dart';
import '../../../../Models/auth/login_model.dart';
import '../../../../Models/auth/otp_model.dart';
import '../../../../Services/Network/dio_helper.dart';
import '../../../../Services/Network/error/exceptions.dart';
import '../../../../Services/cache_helper.dart';
import '../../../../Services/device_info_service.dart';

class OTPRepositoryImplementation extends OTPRepository {
  final DioHelper? dioHelper;
  final CacheHelper? cacheHelper;

  OTPRepositoryImplementation(
      {required this.cacheHelper, required this.dioHelper});

  @override
  Future<Either<String, OtpModel>> sendOtp({required String phone}) {
    return _basicErrorHandling<OtpModel>(
      onSuccess: () async {
        final Response f = await dioHelper?.post(
          url: sendOtpEndpoint, //sendOtpLoginEndpoint,
          data: {
            'mobileNumber': phone,
          },
        );
        debugPrintFullText('${f.data} *******');
        return OtpModel.fromJson(f.data);
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, UserExistStatus>> checkIfUserExist({
    required String phoneNumber,
  }) {
    return _basicErrorHandling<UserExistStatus>(
      onSuccess: () async {
        final Response f = await dioHelper?.post(
          url: checkIfUserExistEndPoint,
          data: {
            'PhoneNumber': phoneNumber,
          },
        );
        print('User Exist Status ${f.data['status']}');
        print(
            'User Exist Status ${UserExistStatus.values[f.data['status'] - 1]}');
        return UserExistStatus.values[f.data['status'] - 1];
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, LoginModel>> verifyOtp({
    required String phone,
    required String otp,
    required String message,
    required String fcmToken,
    required bool signUpOrLogin,
  }) {
    return _basicErrorHandling<LoginModel>(
      onSuccess: () async {
        final deviceData = DeviceInfoService().deviceData;

        final Response f = await dioHelper?.post(
          url: signUpOrLogin
              ? signUpOtpEndpoint
              : loginOtpEndpoint, //verifyOtpEndpoint,
          data: {
            "fcmtoken": fcmToken,
            'mobileNumber': phone,
            'otp': otp,
            'message': message,
            'loginData': {
              "loggedAt": deviceData["loggedAt"],
              "device": deviceData["device"],
              "model": deviceData["model"],
              "brand": deviceData["brand"],
            },
          },
        );

        return LoginModel.fromJson(f.data);
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }

  ///*** forgetPassword
  @override
  Future<Either<String, OtpModel>> forgetPassword({
    required String phoneNumber,
  }) {
    return _basicErrorHandling<OtpModel>(
      onSuccess: () async {
        final Response f = await dioHelper?.post(
          url: forgotPasswordEndPoint,
          data: {
            'identifier': phoneNumber,
          },
        );
        return OtpModel.fromJson(f.data);
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }
}

abstract class OTPRepository {
  Future<Either<String, OtpModel>> sendOtp({
    required String phone,
  });

  Future<Either<String, UserExistStatus>> checkIfUserExist({
    required String phoneNumber,
  });

  Future<Either<String, LoginModel>> verifyOtp({
    required String phone,
    required String otp,
    required String fcmToken,
    required String message,
    required bool signUpOrLogin,
  });

  Future<Either<String, OtpModel>> forgetPassword({
    required String phoneNumber,
  });
}

extension on OTPRepositoryImplementation {
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
