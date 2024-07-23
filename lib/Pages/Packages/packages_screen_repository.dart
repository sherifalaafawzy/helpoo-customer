import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:helpooappclient/Models/packages/package_by_corporate_mode.dart';

import '../../../../Configurations/Constants/api_endpoints.dart';
import '../../../../Models/auth/login_model.dart';
import '../../../../Services/Network/dio_helper.dart';
import '../../../../Services/Network/error/exceptions.dart';
import '../../../../Services/cache_helper.dart';
import '../../Configurations/Constants/keys.dart';
import '../../Models/get_iframe_res.dart';
import '../../Models/packages/check_promo_normal_or_package.dart';
import '../../Models/packages/get_all.dart';
import '../../Models/packages/get_promo_with_filters.dart';
import '../../Models/packages/use_promo_on_package_res.dart';
import '../../Models/promoCode.dart';

class PackagesScreenRepositoryImplementation extends PackagesScreenRepository {
  final DioHelper? dioHelper;
  final CacheHelper? cacheHelper;

  PackagesScreenRepositoryImplementation(
      {required this.cacheHelper, required this.dioHelper});

  @override
  Future<Either<String, GetAllMyPackagesDTO>> getMyPackages() {
    return _basicErrorHandling<GetAllMyPackagesDTO>(
      onSuccess: () async {
        final Response f = await dioHelper?.get(
          url: getMyPackagesEndPoint,
          token: await cacheHelper?.get(Keys.token),
        );
        print(f.data);
        return GetAllMyPackagesDTO.fromJson(f.data);
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, GetPromoWithFiltersRes>> getPromoWithFilters({
    String? promoValue,
    String? companyName,
    String? corporateCompanyId,
  }) {
    return _basicErrorHandling<GetPromoWithFiltersRes>(
      onSuccess: () async {
        final Response f = await dioHelper?.get(
          url: getPromoWithFilter,
          token: await cacheHelper?.get(Keys.token),
          query: {
            if (promoValue != null) 'value': promoValue,
            if (companyName != null) 'companyName': companyName,
            if (corporateCompanyId != null)
              'corporateCompanyId': corporateCompanyId,
          },
        );
        print(f.data);
        return GetPromoWithFiltersRes.fromJson(f.data);
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, GetPromoWithFiltersRes>> getPromoState({required String? promoValue}) {
    return _basicErrorHandling<GetPromoWithFiltersRes>(
      onSuccess: () async {
        final Response f = await dioHelper?.get(
          url: getPromoStateEndPoint,
          token: await cacheHelper?.get(Keys.token),
          query: {
            'value': promoValue,
          },
        );
        print(f.data);
        return GetPromoWithFiltersRes.fromJson(f.data);
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, GetAllPackagesDTO>> getAllPackages({
    bool isPublic = true,
  }) {
    return _basicErrorHandling<GetAllPackagesDTO>(
      onSuccess: () async {
        final Response f = await dioHelper?.get(
          url: getAllPackagesEndPoint,
          token: await cacheHelper?.get(Keys.token),
          query: {
            //** (isPublic == true => get Helpoo Packages)
            'isPublic': isPublic ? 'true' : 'false',
          },
        );
        print('packages');
        print(f.data);
        return GetAllPackagesDTO.fromJson(f.data);
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

  @override
  Future<Either<String, UsePromoOnPackageRes>> usePromoOnPackage({
    required int packageId,
    required int userId,
    required int promoId,
  }) {
    return _basicErrorHandling<UsePromoOnPackageRes>(
      onSuccess: () async {
        final Response f = await dioHelper?.post(
          url: usePromoOnPackageEndPoint,
          token: await cacheHelper?.get(Keys.token),
          data: {
            'packageId': packageId,
            'userId': userId,
            'promoId': promoId,
          },
        );
        return UsePromoOnPackageRes.fromJson(f.data);
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, UsePromoOnPackageRes>> usePromoOnPackageShell({
    required int packageId,
    required int userId,
    required String promoId,
    required int amount,
  }) {
    return _basicErrorHandling<UsePromoOnPackageRes>(
      onSuccess: () async {
        final Response f = await dioHelper?.post(
          url: usePromoShellUrl,
          token: await cacheHelper?.get(Keys.token),
          data: {
            "promo": promoId.trim().toString(), //"sh-0020314511705088",
            "amount": amount, //500,
            "userId": userId, //21414,
            "pkgId": packageId //14,
          },
        );
        print('response shell promo');
        print(f.data);
        return UsePromoOnPackageRes.fromJson(f.data);
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }

  //
  //   Future<Either<String, UsePromoOnPackageRes>> usePromoOnPackageShell({

  //   });

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
  Future<Either<String, PackageByCorporateResponse>> getPackagesByCorporate(
      {required String corporateName}) {
    return _basicErrorHandling<PackageByCorporateResponse>(
      onSuccess: () async {
        final Response f = await dioHelper?.get(
          // data: {'corporateName': 'gis'},
          url: getPackagesByCorporateEndPoint + '/$corporateName',
          token: await cacheHelper?.get(Keys.token),
        );
        print('profile respo');
        return PackageByCorporateResponse.fromMap(f.data['data']);
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, UsePromoOnPackageRes>> useByCorporate(
      {required int pkgId,
      required int userId,
      required int dealId,
      required String corporateName,}) {
    return _basicErrorHandling<UsePromoOnPackageRes>(
      onSuccess: () async {
        final Response f = await dioHelper?.post(
          url: useByCorporateEndPoint,
          token: await cacheHelper?.get(Keys.token),
          data: {
            "userId": userId,
            "pkgId": pkgId,
            "dealId": dealId,
            "corporateName": corporateName,
          },
        );
        print('response shell promo');
        print(f.data);
        return UsePromoOnPackageRes.fromJson(f.data);
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }
}

abstract class PackagesScreenRepository {
  Future<Either<String, LoginModel>> getProfile();

  Future<Either<String, GetAllMyPackagesDTO>> getMyPackages();

  Future<Either<String, GetPromoWithFiltersRes>> getPromoWithFilters({
    String? promoValue,
    String? companyName,
    String? corporateCompanyId,
  });

  Future<Either<String, GetPromoWithFiltersRes>> getPromoState({required String? promoValue});

  Future<Either<String, GetAllPackagesDTO>> getAllPackages({
    bool isPublic = true,
  });

  Future<Either<String, GetIframeRes>> getPaymentIframe({
    required double amount,
    required int? packageId,
    required int? serviceRequestId,
  });

  Future<Either<String, UsePromoOnPackageRes>> usePromoOnPackage({
    required int packageId,
    required int userId,
    required int promoId,
  });

  Future<Either<String, UsePromoOnPackageRes>> useByCorporate({
    required int pkgId,
    required int userId,
    required int dealId,
    required String corporateName,
  });

  Future<Either<String, UsePromoOnPackageRes>> usePromoOnPackageShell({
    required int packageId,
    required int userId,
    required String promoId,
    required int amount,
  });

  Future<Either<String, PackageByCorporateResponse>> getPackagesByCorporate(
      {required String corporateName});
}

extension on PackagesScreenRepositoryImplementation {
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
