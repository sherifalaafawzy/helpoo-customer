import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../Configurations/Constants/api_endpoints.dart';
import '../../../../Models/auth/login_model.dart';
import '../../../../Services/Network/dio_helper.dart';
import '../../../../Services/Network/error/exceptions.dart';
import '../../../../Services/cache_helper.dart';
import '../../Configurations/Constants/keys.dart';
import '../../Models/packages/check_promo_normal_or_package.dart';
import '../../Models/promoCode.dart';

class ProfileRepositoryImplementation extends ProfileRepository{
  final DioHelper? dioHelper;
  final CacheHelper? cacheHelper;
  ProfileRepositoryImplementation({required this.cacheHelper,required this.dioHelper});
  @override
  Future<Either<String, PromoCode>> useNormalPromo({
    required String value,
  }) {
    return _basicErrorHandling<PromoCode>(
      onSuccess: () async {
        final Response f = await dioHelper?.post(
          url: useNormalPromoEndPoint,
          token:await cacheHelper?.get(Keys.token),
          data: {
            'promoCode': value,
          },
        );
        return PromoCode.fromJson(f.data['user']['promo']);
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }
  @override
  Future<Either<String, LoginModel>> getProfile() {
    return _basicErrorHandling<LoginModel>(
      onSuccess: () async {
        final Response f = await dioHelper?.get(
          url: profileEndPoint,
          token: await cacheHelper?.get(Keys.token),
        );
        print('profile respo');
        print(f.data);

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
    String? email,
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
  @override
  Future<Either<String, CheckPromoPackageOrNormalResponse>> checkPromoIsPackageOrNormal({
    required String promoValue,
  }) {
    return _basicErrorHandling<CheckPromoPackageOrNormalResponse>(
      onSuccess: () async {
        final Response f = await dioHelper?.post(
          url: checkPromoPackageOrNormalEndPoint,
          data: {
            'value': promoValue,
          },
        );
        return CheckPromoPackageOrNormalResponse.fromJson(f.data);
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
abstract class ProfileRepository{
  Future<Either<String, PromoCode>> useNormalPromo({
    required String value,
  });
  Future<Either<String, LoginModel>> getProfile();
  Future<Either<String, void>> updateProfile({
    required String name,
    String? email,
  });
  Future<Either<String, CheckPromoPackageOrNormalResponse>> checkPromoIsPackageOrNormal({
    required String promoValue,
  });
}
extension on ProfileRepositoryImplementation {
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
