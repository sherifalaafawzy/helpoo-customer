import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../Configurations/Constants/api_endpoints.dart';
import '../../../../Services/Network/dio_helper.dart';
import '../../../../Services/Network/error/exceptions.dart';
import '../../../../Services/cache_helper.dart';
import '../../Configurations/Constants/keys.dart';
import '../../Models/cars/add_car_dto.dart';
import '../../Models/cars/add_corporate_car_response.dart';
import '../../Models/cars/car_model.dart';
import '../../Models/cars/manufacturer_model.dart';
import '../../Models/cars/my_cars.dart';
import '../../Models/packages/get_all.dart';

class MyCarsRepositoryImplementation extends MyCarsRepository {
  final DioHelper? dioHelper;
  final CacheHelper? cacheHelper;

  MyCarsRepositoryImplementation(
      {required this.cacheHelper, required this.dioHelper});

  @override
  Future<Either<String, GetMyCarsResponse>> getMyCars() {
    return _basicErrorHandling<GetMyCarsResponse>(
      onSuccess: () async {
        final Response f = await dioHelper?.get(
          url: getMyCarsEndPoint,
          token: await cacheHelper?.get(Keys.token),
        );
        return GetMyCarsResponse.fromJson(f.data);
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, GetAllManufacturersRes>> getAllManufactures() {
    return _basicErrorHandling<GetAllManufacturersRes>(
      onSuccess: () async {
        final Response f = await dioHelper?.get(
          url: getAllManufacturersEndPoint,
          token: await cacheHelper?.get(Keys.token),
        );
        return GetAllManufacturersRes.fromJson(f.data);
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }

  ///*** Subscribe Package
  @override
  Future<Either<String, void>> subscribeCarToPackage(
      {required String packageId,
      required String clientPackageId,
      required String clientId,
      required String carId}) {
    return _basicErrorHandling<void>(
      onSuccess: () async {
        var data = {
          "clientPackageId": clientPackageId,
          "packageId": packageId,
          "clientId": clientId,
          "carId": carId
        };

        await dioHelper?.post(
            url: subscribeCarToPackageEndPoint,
            token: await cacheHelper?.get(Keys.token),
            data: data);
        return;
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }

  ///*** update car
  Future<Either<String, String>> updateCar({
    required AddCarDTO editCarDTO,
    required String carId,
  }) {
    return _basicErrorHandling<String>(
      onSuccess: () async {
        final Response f = await dioHelper?.patch(
          url: "$editCarEndPoint$carId",
          token: await cacheHelper?.get(Keys.token),
          data: editCarDTO.toJson(clientIdKey: "ClientId"),
        );
        return f.data.toString();
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, GetAllModels>> getModelsForManufacturer({
    required int manufacturerId,
  }) {
    return _basicErrorHandling<GetAllModels>(
      onSuccess: () async {
        final Response f = await dioHelper?.get(
          url: '$getModelsForManufacturerEndPoint$manufacturerId',
          token: await cacheHelper?.get(Keys.token),
        );
        return GetAllModels.fromJson(f.data);
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }

  Future<Either<String, MyCarModel>> addCar({
    required AddCarDTO addCarDTO,
  }) {
    return _basicErrorHandling<MyCarModel>(
      onSuccess: () async {
        final Response f = await dioHelper?.post(
          url: addCarEndPoint,
          token: await cacheHelper?.get(Keys.token),
          data: addCarDTO.toJson(clientIdKey: "ClientId"),
        );
        print('f.data');
        print(f.data);
        return MyCarModel.fromJson(f.data['newCar']);
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }

  Future<Either<String, String>> activateCar({
    required AddCarDTO activateCarDTO,
    required String carId,
  }) {
    return _basicErrorHandling<String>(
      onSuccess: () async {
        final Response f = await dioHelper?.post(
          url: "$activateCarEndPoint$carId",
          token: await cacheHelper?.get(Keys.token),
          data: activateCarDTO.toJson(clientIdKey: "clientId"),
        );
        return f.data.toString();
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }

  ///*** add car
  Future<Either<String, AddCorporateCarResponse>> addCorporateCar({
    required AddCarDTO addCarDTO,
    required String name,
    required String phoneNumber,
  }) {
    return _basicErrorHandling<AddCorporateCarResponse>(
      onSuccess: () async {
        final Response f = await dioHelper?.post(
            url: addCarEndPoint,
            token: await cacheHelper?.get(Keys.token),
            data: {
              "phoneNumber": phoneNumber,
              "name": name,
              "Car": json.encode(addCarDTO.toJsonCorporate())
            });
        return AddCorporateCarResponse.fromJson(f.data);
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, GetAllMyPackagesDTO>> getMyPackages() {
    return _basicErrorHandling<GetAllMyPackagesDTO>(
      onSuccess: () async {
        final Response f = await dioHelper?.get(
          url: getUnFilledPackagesEndPoint,
          token: await cacheHelper?.get(Keys.token),
        );
        return GetAllMyPackagesDTO.fromJson(f.data);
      },
      onServerError: (exception) async {
        return exception.message;
      },
    );
  }
}

abstract class MyCarsRepository {
  Future<Either<String, GetMyCarsResponse>> getMyCars();

  Future<Either<String, void>> subscribeCarToPackage(
      {required String packageId,
      required String clientPackageId,
      required String clientId,
      required String carId});

  Future<Either<String, GetAllManufacturersRes>> getAllManufactures();

  Future<Either<String, String>> updateCar({
    required AddCarDTO editCarDTO,
    required String carId,
  });

  Future<Either<String, GetAllModels>> getModelsForManufacturer({
    required int manufacturerId,
  });

  Future<Either<String, MyCarModel>> addCar({
    required AddCarDTO addCarDTO,
  });

  Future<Either<String, String>> activateCar({
    required AddCarDTO activateCarDTO,
    required String carId,
  });

  Future<Either<String, AddCorporateCarResponse>> addCorporateCar({
    required AddCarDTO addCarDTO,
    required String name,
    required String phoneNumber,
  });
  Future<Either<String, GetAllMyPackagesDTO>> getMyPackages();
}

extension on MyCarsRepositoryImplementation {
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
