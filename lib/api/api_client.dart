import 'dart:async';
import 'dart:convert';
import "package:dio/dio.dart";
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:perfectBeta/api/providers/authentication_endpoint.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:perfectBeta/constants/maps.dart';
import 'package:perfectBeta/constants/variables.dart';
import 'package:perfectBeta/routing/routes.dart';
import '../storage/secure_storage.dart';
import 'package:get/get.dart' as nav;

class ApiClient {
  Dio init() {
    Dio _dio = new Dio();

    _dio.options.baseUrl = API_URL;
    _dio.options.headers.addAll(globalHeaders);
    _dio.interceptors.add(ApiInterceptors());

    return _dio;
  }
}

class ApiInterceptors extends Interceptor {

  var _cache = new Map<Uri, Response>();
  var _authenticationEndpoint = new AuthenticationEndpoint(new Dio(BaseOptions(
    headers: globalHeaders,
    baseUrl: API_URL,
  )));

  bool isTokenExpired(String _token) {
    DateTime expiryDate = JwtDecoder.getExpirationDate(_token);
    bool isExpired = expiryDate.compareTo(DateTime.now()) < 0;
    return isExpired;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.headers.containsKey("requiresToken")) {
      options.headers.remove("requiresToken");
      handler.next(options);
    } else {
      final storedToken = await secStore.secureRead('token');
      bool _token = isTokenExpired(storedToken);
      bool _refreshed = true;

      if (_token) {
        _authenticationEndpoint.logout();
        nav.Get.offAllNamed(authenticationPageRoute);
        EasyLoading.showInfo('Expired session');
        DioError _err;
        handler.reject(_err);
      } else {
        _refreshed = await _authenticationEndpoint.refreshToken();
        if (_refreshed) {
          final newStoredToken = await secStore.secureRead('token');
          options.headers["Authorization"] = "Bearer " + newStoredToken;
          options.headers["Accept"] = "application/json";
          handler.next(options);
        }
      }
    }
  }


  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // EasyLoading.dismiss();

    _cache[response.requestOptions.uri] = response;

    handler.next(response);
  }

  @override
  FutureOr<dynamic> onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response == null) {
      EasyLoading.showError('Unable to connect with Database');
    } else {
      if (err.type == DioErrorType.connectTimeout || err.type == DioErrorType.other) {
        var cachedResponse = _cache[err.requestOptions.uri];
        if (cachedResponse != null) {
          return cachedResponse;
        }
      }
      var responseClass = (err.response.statusCode / 100).floor();
      String jsonsDataString = err.response?.data.toString().replaceAll("\n", "");
      final jsonData = jsonDecode(jsonsDataString);

      if (responseClass == 5) {
        EasyLoading.showError('An unidentified server error has occurred');
      } else if (responseClass == 4) {
        if (err.response?.statusCode == 400) {
          if (jsonData["message"].toString().contains("duplicate")) {
            EasyLoading.showError('User is already added');
          } else {
            EasyLoading.showError('Bad Request');
          }
        }
        if (err.response?.statusCode == 401) {
          if (jsonData["key"] == "INVALID_CREDENTIALS") {
            EasyLoading.showError('There is no user with this username password combination');
          } else {
            EasyLoading.showError('Unauthenticated');
          }
        } else if (err.response?.statusCode == 403) {
          if (jsonData["message"] == "GYM_NOT_VERIFIED_EXCEPTION: Gym must be verified before that operation") {
            EasyLoading.showError('Gym must be verified before that operation');
          } else {
            EasyLoading.showError('Unauthorized');
          }
        } else if (err.response.statusCode == 404) {
          EasyLoading.showError('Not found');
        }
      } else {
        EasyLoading.showError('An unknown error has occurred');
      }
    }
    handler.next(err);
  }
}
