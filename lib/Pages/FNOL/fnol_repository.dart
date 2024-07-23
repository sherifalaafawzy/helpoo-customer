import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart' as intl;

import '../../Configurations/Constants/constants.dart';
import '../../Configurations/Constants/enums.dart';
import '../../Configurations/Constants/keys.dart';
import '../../Configurations/di/injection.dart';
import '../../Models/fnol/accident_report_details_model.dart';
import '../../Models/fnol/accident_types_model.dart';
import '../../Models/fnol/fnol_image_model.dart';
import '../../Models/fnol/fnol_required_images_model.dart';
import '../../Models/fnol/latestFnolModel.dart';
import '../../Models/get_config.dart';
import '../../Models/map_place_details_model.dart';
import '../../Models/maps/map_place_details_model.dart';
import '../../Models/service_request/service_request.dart';
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

class FNOLRepositoryImplementation extends FNOLRepository {
  final DioHelper? dioHelper;
  final CacheHelper? cacheHelper;

  FNOLRepositoryImplementation(
      {required this.cacheHelper, required this.dioHelper});

  @override
  Future<Either<String, void>> updateFnolBill(
      {required int id,
      required DateTime date,
      required String time,
      required String notes,
      required String address,
      required double lat,
      required double lng}) {
    return _basicErrorHandling<void>(
      onSuccess: () async {
        final Response response = await dioHelper?.patch(
          url: '$uploadFnolBillEndPoint$id',
          data: {
            'billDeliveryDate': intl.DateFormat('yyyy-MM-dd').format(date),
            'billDeliveryTimeRange': time,
            'billDeliveryNotes': notes,
            "billDeliveryLocation": json.encode({
              "address": address,
              "lat": lat,
              "lng": lng,
            }),
            'status': 'billing'
          },
          token: await cacheHelper?.get(Keys.token),
        );

        return;
      },
      onServerError: (e) async {
        return e.message;
      },
    );
  }

  @override
  Future<Either<String, void>> uploadFnolImages(
      {required FnolImageModel image, required int id}) {
    return _basicErrorHandling<void>(
      onSuccess: () async {
        final Response response = await dioHelper?.post(
          url: '$uploadImagesFnolEndPoint$id',
          data: {
            'images': json.encode([image.toJson()])
          },
          token: await cacheHelper?.get(Keys.token),
        );

        return;
      },
      onServerError: (e) async {
        uploadFnolImages(image: image, id: id);
        return e.message;
      },
    );
  }

  @override
  Future<Either<String, LatestFnolModel>> createFnol({
    required dynamic date,
  }) {
    return _basicErrorHandling<LatestFnolModel>(
      onSuccess: () async {
        final Response response = await dioHelper?.post(
          url: createFnolEndPoint,
          data: date,
          token: await cacheHelper?.get(Keys.token),
        );
        List accidentReport = response.data['accidentReport'] as List;
        return LatestFnolModel.fromJson(accidentReport[0]);
      },
      onServerError: (e) async {
        return e.message;
      },
    );
  }

  @override
  Future<Either<String, void>> updateFnolStatus(
      {required String status, required int id}) {
    return _basicErrorHandling<void>(
      onSuccess: () async {
        final Response response = await dioHelper?.patch(
          url: '$updateStausFnolEndPoint$id',
          data: {'status': status},
          token: await cacheHelper?.get(Keys.token),
        );

        return;
      },
      onServerError: (e) async {
        return e.message;
      },
    );
  }

  @override
  Future<Either<String, void>> updateFnolStepLocation(
      {required LocationFNOLSteps stepEnum,
      required String locationName,
      required double lat,
      required double lng,
      required String address,
      required int id}) {
    return _basicErrorHandling<void>(
      onSuccess: () async {
        final Response response = await dioHelper?.patch(
          url: 'accidentReports/${stepEnum.apiUrl}/$id',
          data: {
            stepEnum.key: json.encode({
              "address": address,
              "lat": lat,
              "lng": lng,
              "name": locationName,
            }),
            'status': stepEnum.status,
          },
          token: await cacheHelper?.get(Keys.token),
        );

        return;
      },
      onServerError: (e) async {
        return e.message;
      },
    );
  }

  @override
  Future<Either<String, AccidentTypesModel>> getAllAccidentTypes() {
    return _basicErrorHandling<AccidentTypesModel>(
      onSuccess: () async {
        final Response response = await dioHelper?.get(
          url: getAllAccidentTypesEndPoint,
          token: await cacheHelper?.get(Keys.token),
        );

        return AccidentTypesModel.fromJson(response.data);
      },
      onServerError: (e) async {
        return e.message;
      },
    );
  }

  @override
  Future<Either<String, void>> uploadFnolCommentAndVoice({
    required int id,
    required String comment,
    required String voice,
  }) {
    return _basicErrorHandling<void>(
      onSuccess: () async {
        final Response response = await dioHelper?.patch(
          url: '$fnolupdateFnolCommentEndPoint$id',
          data: {"comment": comment, "commentUser": voice, "status": "created"},
          token: await cacheHelper?.get(Keys.token),
        );

        return;
      },
      onServerError: (e) async {
        return e.message;
      },
    );
  }

  @override
  Future<Either<String, void>> sendFnolStep({
    required String pdfReportId,
    required String AccidentReportId,
    required String carId,
    required String Type,
    required String pdfReport,
    required String subject,
    required String body,
  }) {
    return _basicErrorHandling<void>(
      onSuccess: () async {
        final Response f = await dioHelper?.post(
          token: await cacheHelper?.get(Keys.token),
          url: createPdfReportCombineEndPoint,
          data: {
            'pdfReportId': pdfReportId,
            'AccidentReportId': AccidentReportId,
            'carId': carId,
            'Type': Type,
            'pdfReport': pdfReport,
            "subject": subject,
            "text": body,
          },
        );
        debugPrintFullText('******* ::: >>> ${f.data}');
        return;
      },
      onServerError: (exception) async {
        debugPrint('********** onServerError **********');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, FnolRequiredImagesModel>>
      getFnolRequiredImagesBasedOnSelectedTypes({
    required List<int> accidentTypes,
  }) {
    return _basicErrorHandling<FnolRequiredImagesModel>(
      onSuccess: () async {
        final Response response = await dioHelper?.post(
          url: fnolRequiredImagesEndPoint,
          data: {'accidentTypesIds': accidentTypes},
          token: await cacheHelper?.get(Keys.token),
        );

        return FnolRequiredImagesModel.fromJson(response.data);
      },
      onServerError: (e) async {
        return e.message;
      },
    );
  }

  @override
  Future<Either<String, MapPlaceDetailsCoordinatesModel>>
      getPlaceDetailsByCoordinates({
    required String latLng,
  }) async {
    return _basicErrorHandling<MapPlaceDetailsCoordinatesModel>(
      onSuccess: () async {
        final Response f = await dioHelper?.get(
          base: mapUrl,
          url: getPlacesDetailsByCoordinatesUrl,
          query: {
            'latlng': latLng,
            'key': MapApiKey,
          },
        );

        return MapPlaceDetailsCoordinatesModel.fromJson(f.data);
      },
      onServerError: (exception) async {
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        // debugPrint(exception.error);
        return exception.message;
      },
      onOtherError: (exception) async {
        debugPrint(exception.token);
        debugPrint(exception.title.toString());
        debugPrint(exception.error);
        return exception.token;
      },
    );
  }

  @override
  Future<Either<String, MapPlaceDetailsModel>> getPlaceDetails({
    required String placeId,
  }) async {
    return _basicErrorHandling<MapPlaceDetailsModel>(
      onSuccess: () async {
        final Response f = await dioHelper?.get(
          base: mapUrl,
          url: getPlacesDetailsUrl,
          query: {
            'place_id': placeId,
            'key': MapApiKey,
          },
        );

        return MapPlaceDetailsModel.fromJson(f.data);
      },
      onServerError: (exception) async {
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        // debugPrint(exception.error);
        return exception.message;
      },
      onOtherError: (exception) async {
        debugPrint(exception.token);
        debugPrint(exception.title.toString());
        debugPrint(exception.error);
        return exception.token;
      },
    );
  }

  @override
  Future<Either<String, GetAccidentDetailsModel>> getAccidentDetails(
      {required int accidentId}) async {
    return _basicErrorHandling<GetAccidentDetailsModel>(
      onSuccess: () async {
        final Response f = await dioHelper?.get(
          token: await cacheHelper?.get(Keys.token),
          url: '$accidentReportsDetailsPoint/$accidentId',
        );
        debugPrintFullText('******* ::: >>> ${f.data}');
        return GetAccidentDetailsModel.fromJson(f.data);
      },
      onServerError: (exception) async {
        debugPrint('********** onServerError **********');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, void>> updateFnolAdditionalFields(
      {required int accidentId, required Map<String, dynamic> data}) {
    return _basicErrorHandling<void>(
      onSuccess: () async {
        final Response f = await dioHelper?.patch(
          token: await cacheHelper?.get(Keys.token),
          url: '$fnolupdateFnolCommentEndPoint/$accidentId',
          data: {
            "additionalFields": data,
          },
        );
        debugPrintFullText('******* ::: >>> ${f.data}');
        return;
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

abstract class FNOLRepository {
  Future<Either<String, void>> updateFnolStepLocation(
      {required LocationFNOLSteps stepEnum,
      required String locationName,
      required double lat,
      required double lng,
      required String address,
      required int id});
  Future<Either<String, void>> sendFnolStep({
    required String pdfReportId,
    required String AccidentReportId,
    required String carId,
    required String Type,
    required String pdfReport,
    required String subject,
    required String body,
  });
  Future<Either<String, void>> updateFnolBill(
      {required int id,
      required DateTime date,
      required String time,
      required String notes,
      required String address,
      required double lat,
      required double lng});

  Future<Either<String, void>> uploadFnolCommentAndVoice({
    required int id,
    required String comment,
    required String voice,
  });

  Future<Either<String, LatestFnolModel>> createFnol({
    required dynamic date,
  });

  Future<Either<String, void>> updateFnolStatus(
      {required String status, required int id});

  Future<Either<String, void>> uploadFnolImages(
      {required FnolImageModel image, required int id});

  Future<Either<String, FnolRequiredImagesModel>>
      getFnolRequiredImagesBasedOnSelectedTypes(
          {required List<int> accidentTypes});

  Future<Either<String, AccidentTypesModel>> getAllAccidentTypes();

  Future<Either<String, MapPlaceDetailsModel>> getPlaceDetails({
    required String placeId,
  });
  Future<Either<String, MapPlaceDetailsCoordinatesModel>>
      getPlaceDetailsByCoordinates({
    required String latLng,
  });

  Future<Either<String, GetAccidentDetailsModel>> getAccidentDetails(
      {required int accidentId});
  Future<Either<String, void>> updateFnolAdditionalFields(
      {required int accidentId, required Map<String, dynamic> data});
}

extension on FNOLRepositoryImplementation {
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
