import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../Configurations/Constants/api_endpoints.dart';
import '../../../../Models/auth/login_model.dart';
import '../../../../Services/Network/dio_helper.dart';
import '../../../../Services/Network/error/exceptions.dart';
import '../../../../Services/cache_helper.dart';
import '../../Configurations/Constants/keys.dart';
import '../../Models/cars/my_cars.dart';
import '../../Models/fnol/getInsuranceCompanyModel.dart';
import '../../Models/packages/check_promo_normal_or_package.dart';
import '../../Models/promoCode.dart';

class ChooseInsuranceCompanyRepositoryImplementation
    extends ChooseInsuranceCompanyRepository {
  final DioHelper? dioHelper;
  final CacheHelper? cacheHelper;

  ChooseInsuranceCompanyRepositoryImplementation(
      {required this.cacheHelper, required this.dioHelper});

  @override
  Future<Either<String, GetInsuranceCompanyModel>> getAllInsuranceCompanies() {
    return _basicErrorHandling<GetInsuranceCompanyModel>(
      onSuccess: () async {
        final Response response = await dioHelper?.get(
          url: getAllInsuranceCompaniesEndPoint,
          token: await cacheHelper?.get(Keys.token),
        );

        return GetInsuranceCompanyModel.fromJson(response.data);
      },
      onServerError: (e) async {
        return e.message;
      },
    );
  }

  @override
  Future<Either<String, MyCarModel>> insurancePackagecar({
    required String insuranceCompanyId,
    required String VINNo,
  }) {
    return _basicErrorHandling<MyCarModel>(
      onSuccess: () async {
        final Response f = await dioHelper?.post(
          url: getInsuranceCompanyCarEndPoint,
          token: await cacheHelper?.get(Keys.token),
          data: {
            "insuranceCompanyId": insuranceCompanyId.toString(),
            "vinNo": VINNo,
            "clientId": await cacheHelper?.get(Keys.generalID),
          },
        );
        return MyCarModel.fromJson(f.data['car']);
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }
}

abstract class ChooseInsuranceCompanyRepository {
  Future<Either<String, GetInsuranceCompanyModel>> getAllInsuranceCompanies();

  Future<Either<String, MyCarModel>> insurancePackagecar({
    required String insuranceCompanyId,
    required String VINNo,
  });
}

extension on ChooseInsuranceCompanyRepositoryImplementation {
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
