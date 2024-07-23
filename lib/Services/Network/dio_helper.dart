import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:requests_inspector/requests_inspector.dart';
import '../../Configurations/Constants/api_endpoints.dart';
import '../../Configurations/Constants/constants.dart';
import '../../Configurations/Constants/page_route_name.dart';
import '../../Configurations/di/injection.dart';
import '../cache_helper.dart';
import '../navigation_service.dart';
import 'error/exceptions.dart';

abstract class DioHelper {
  Future<dynamic> post({
    String? base,
    required String url,
    dynamic data,
    dynamic query,
    String? token,
    ProgressCallback? progressCallback,
    CancelToken? cancelToken,
    Duration? timeOut,
    Duration? receiveTimeout,
    bool isMultipart = false,
  });

  Future<dynamic> patch({
    String? base,
    required String url,
    dynamic data,
    dynamic query,
    String? token,
    ProgressCallback? progressCallback,
    CancelToken? cancelToken,
    Duration? timeOut,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    bool isMultipart = false,
  });

  Future<dynamic> get({
    String? base,
    required String url,
    dynamic data,
    dynamic query,
    String? token,
    CancelToken? cancelToken,
    Duration? timeOut,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    bool isMultipart = false,
  });

  Future<dynamic> delete({
    String? base,
    required String url,
    dynamic data,
    dynamic query,
    String? token,
    CancelToken? cancelToken,
    Duration? timeOut,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    bool isMultipart = false,
  });

  Future<dynamic> put({
    String? base,
    required String url,
    dynamic data,
    dynamic query,
    String? token,
    CancelToken? cancelToken,
    Duration? timeOut,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    bool isMultipart = false,
  });
}

class DioImpl extends DioHelper {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: '$baseUrl$apiVersion',
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 20),
    ),
  )..interceptors.add(RequestsInspectorInterceptor());

  @override
  Future post({
    String? base,
    required String url,
    dynamic data,
    dynamic query,
    String? token,
    ProgressCallback? progressCallback,
    CancelToken? cancelToken,
    Duration? timeOut,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    bool isMultipart = false,
  }) async {
    if (timeOut != null) {
      dio.options.connectTimeout = timeOut;
    }
    if (connectTimeout != null) {
      dio.options.connectTimeout = connectTimeout * 6000;
    }
    if (receiveTimeout != null) {
      dio.options.connectTimeout = receiveTimeout * 6000;
    }
    if (connectTimeout != null) {
      dio.options.connectTimeout = connectTimeout * 6000;
    }

    if (base != null) {
      dio.options.baseUrl = base;
    } else {
      dio.options.baseUrl = '$baseUrl$apiVersion';
    }

    dio.options.headers = {
      'Accept-Language': isArabic ? 'ar' : 'en',
      if (isMultipart) 'Content-Type': 'multipart/form-data',
      if (!isMultipart) 'Content-Type': 'application/json',
      if (!isMultipart) 'Accept': 'application/json',
      if (token != null)
        'authentication': '${base == null ? 'Bearer' : ''} $token'
    };

    if (url.contains('??')) {
      url = url.replaceAll('??', '?');
    }

    debugPrint('URL => ${dio.options.baseUrl + url}');
    debugPrint('Header => ${dio.options.headers.toString()}');
    debugPrint('Body => $data');
    debugPrint('Query => $query');

    return await request(
      () async => await dio.post(
        url,
        data: data,
        queryParameters: query,
        onSendProgress: progressCallback,
        cancelToken: cancelToken,
      ),
    );
  }

  @override
  Future patch({
    String? base,
    required String url,
    dynamic data,
    dynamic query,
    String? token,
    ProgressCallback? progressCallback,
    CancelToken? cancelToken,
    Duration? timeOut,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    bool isMultipart = false,
  }) async {
    if (timeOut != null) {
      dio.options.connectTimeout = timeOut;
    }
    if (connectTimeout != null) {
      dio.options.connectTimeout = connectTimeout * 6000;
    }
    if (receiveTimeout != null) {
      dio.options.connectTimeout = receiveTimeout * 6000;
    }
    if (base != null) {
      dio.options.baseUrl = base;
    } else {
      dio.options.baseUrl = '$baseUrl$apiVersion';
    }

    dio.options.headers = {
      'Accept-Language': isArabic ? 'ar' : 'en',
      if (isMultipart) 'Content-Type': 'multipart/form-data',
      if (!isMultipart) 'Content-Type': 'application/json',
      if (!isMultipart) 'Accept': 'application/json',
      if (token != null)
        'authentication': '${base == null ? 'Bearer' : ''} $token'
    };

    if (url.contains('??')) {
      url = url.replaceAll('??', '?');
    }

    debugPrint('URL => ${dio.options.baseUrl + url}');
    debugPrint('Header => ${dio.options.headers.toString()}');
    debugPrint('Body => $data');
    debugPrint('Query => $query');

    return await request(
      () async => await dio.patch(
        url,
        data: data,
        queryParameters: query,
        onSendProgress: progressCallback,
        cancelToken: cancelToken,
      ),
    );
  }

  @override
  Future get({
    String? base,
    required String url,
    dynamic data,
    dynamic query,
    String? token,
    CancelToken? cancelToken,
    Duration? timeOut,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    bool isMultipart = false,
  }) async {
    if (timeOut != null) {
      dio.options.connectTimeout = timeOut;
    }

    if (base != null) {
      dio.options.baseUrl = base;
    } else {
      dio.options.baseUrl = '$baseUrl$apiVersion';
    }
    if (connectTimeout != null) {
      dio.options.connectTimeout = connectTimeout * 6000;
    }
    if (receiveTimeout != null) {
      dio.options.connectTimeout = receiveTimeout * 6000;
    }

    dio.options.headers = {
      'Accept-Language': isArabic ? 'ar' : 'en',
      if (isMultipart) 'Content-Type': 'multipart/form-data',
      if (!isMultipart) 'Content-Type': 'application/json',
      if (!isMultipart) 'Accept': 'application/json',
      if (token != null)
        'authentication': '${base == null ? 'Bearer' : ''} $token'
    };

    if (url.contains('??')) {
      url = url.replaceAll('??', '?');
    }

    debugPrint('URL => ${dio.options.baseUrl + url}');
    debugPrint('Header => ${dio.options.headers.toString()}');
    debugPrint('Body => $data');
    debugPrint('Query => $query');

    return await request(
      () async => await dio.get(
        url,
        queryParameters: query,
        cancelToken: cancelToken,
      ),
    );
  }

  @override
  Future delete({
    String? base,
    required String url,
    dynamic data,
    dynamic query,
    String? token,
    CancelToken? cancelToken,
    Duration? timeOut,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    bool isMultipart = false,
  }) async {
    if (timeOut != null) {
      dio.options.connectTimeout = timeOut;
    }

    if (base != null) {
      dio.options.baseUrl = base;
    } else {
      dio.options.baseUrl = baseUrl;
    }
    if (connectTimeout != null) {
      dio.options.connectTimeout = connectTimeout * 6000;
    }
    if (receiveTimeout != null) {
      dio.options.connectTimeout = receiveTimeout * 6000;
    }
    dio.options.headers = {
      'Accept-Language': isArabic ? 'ar' : 'en',
      if (isMultipart) 'Content-Type': 'multipart/form-data',
      if (!isMultipart) 'Content-Type': 'application/json',
      if (!isMultipart) 'Accept': 'application/json',
      if (token != null)
        'Authorization': '${base == null ? 'Bearer' : ''} $token'
    };

    if (url.contains('??')) {
      url = url.replaceAll('??', '?');
    }

    debugPrint('URL => ${dio.options.baseUrl + url}');
    debugPrint('Header => ${dio.options.headers.toString()}');
    debugPrint('Body => $data');
    debugPrint('Query => $query');

    return await request(
      () async => await dio.delete(
        url,
        queryParameters: query,
        data: data,
        cancelToken: cancelToken,
      ),
    );
  }

  @override
  Future put({
    String? base,
    required String url,
    dynamic data,
    dynamic query,
    String? token,
    CancelToken? cancelToken,
    Duration? timeOut,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    bool isMultipart = false,
  }) async {
    if (timeOut != null) {
      dio.options.connectTimeout = timeOut;
    }

    if (base != null) {
      dio.options.baseUrl = base;
    } else {
      dio.options.baseUrl = baseUrl;
    }
    if (connectTimeout != null) {
      dio.options.connectTimeout = connectTimeout * 6000;
    }
    if (receiveTimeout != null) {
      dio.options.connectTimeout = receiveTimeout * 6000;
    }
    dio.options.headers = {
      'Accept-Language': isArabic ? 'ar' : 'en',
      if (isMultipart) 'Content-Type': 'multipart/form-data',
      if (!isMultipart) 'Content-Type': 'application/json',
      if (!isMultipart) 'Accept': 'application/json',
      'APP-VERSION': appVersion,
      if (token != null)
        'Authorization': '${base == null ? 'Bearer' : ''} $token'
    };

    if (url.contains('??')) {
      url = url.replaceAll('??', '?');
    }

    debugPrint('URL => ${dio.options.baseUrl + url}');
    debugPrint('Header => ${dio.options.headers.toString()}');
    debugPrint('Body => $data');
    debugPrint('Query => $query');

    return await request(
      () async => await dio.put(
        url,
        queryParameters: query,
        data: data,
        cancelToken: cancelToken,
      ),
    );
  }
}

extension on DioHelper {
  Future request(Future<Response> Function() request) async {
    try {
      final r = await request.call();
      return r;
    } on DioError catch (e) {
      debugPrint("Error Message => ${e.message}");
      debugPrint("Error => ${e.error.toString()}");
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        await sl<CacheHelper>().clearAll();
        NavigationService.navigatorKey.currentState!.pushNamedAndRemoveUntil(
            PageRouteName.enterPhoneNumScreen, (route) => false);
      }
      if (e.response != null) {
        debugPrint("Error Response => ${e.response}");
        debugPrint("Error Response Message => ${e.response!.statusMessage}");
        debugPrint("Error Response Status Code => ${e.response!.statusCode}");
        debugPrint("Error Response Data => ${e.response!.data}");

        throw ServerException(
          code: e.response!.statusCode!,
          message: e.response!.data['msg'],
        );
      } else {
        throw ServerException(
          code: 500,
          message: e.message!,
        );
      }
    } catch (e) {
      throw Exception();
    }
  }
}
