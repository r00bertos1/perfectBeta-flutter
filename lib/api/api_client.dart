import 'dart:async';
import 'dart:convert';
import 'package:dio/adapter.dart';
import "package:dio/dio.dart";
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'dart:io' as IO;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:perfectBeta/api/providers/authentication_endpoint.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:perfectBeta/routing/routes.dart';
import '../storage/secure_storage.dart';
import 'package:get/get.dart' as nav;


class ApiClient {
  Dio init() {
    Dio _dio = new Dio();
    //  dio instance to request token
    Dio _tokenDio = new Dio();
    String token;
    _dio.options.baseUrl =
        'https://perfectbeta-spring-boot-tls-pyclimb.apps.okd.cti.p.lodz.pl/api';
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['Access-Control-Allow-Credentials'] = true;
    _dio.options.headers['Access-Control-Allow-Origin'] = '*';
    _dio.options.headers['Access-Control-Allow-Headers'] = '*';
    _dio.options.headers['Access-Control-Allow-Methods'] = '*';

    _tokenDio.options = _dio.options;
    //_dio.interceptors.add(ApiInterceptors());
    _dio.interceptors.add(ApiInterceptors());

    // if(!kIsWeb){
    //   (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //       (IO.HttpClient client) {
    //     client.badCertificateCallback =
    //         (X509Certificate cert, String host, int port) => true;
    //     return client;
    //   };
    // }
    return _dio;
  }
}

class ApiInterceptors extends Interceptor {
  //static ApiClient _client = new ApiClient();
  // final ApiClient _client = new ApiClient();
  //var _authenticationEndpoint = new AuthenticationEndpoint(_client.init());

  bool isTokenExpired(String _token) {
    DateTime expiryDate = JwtDecoder.getExpirationDate(_token);
    bool isExpired = expiryDate.compareTo(DateTime.now()) < 0;
    return isExpired;
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    // EasyLoading.show(status: 'loading...');

    //ApiClient _client = new ApiClient();
    //var _authenticationEndpoint = new AuthenticationEndpoint(_client.init());
    BaseOptions dioOptions = BaseOptions(
      baseUrl: 'https://perfectbeta-spring-boot-tls-pyclimb.apps.okd.cti.p.lodz.pl/api',
    );
    var _authenticationEndpoint = new AuthenticationEndpoint(new Dio(dioOptions));

    if (options.headers.containsKey("requiresToken")) {
      options.headers.remove("requiresToken");

      handler.next(options);
    } else {
      final storedToken = await secStore.secureRead('token');
      //print('---OLD: ' + storedToken);

      //bool _token = JwtDecoder.isExpired(storedToken);
      bool _token = isTokenExpired(storedToken);
      //print('IS EXPIRED: $_token');
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
          //print('---NEW: ' + newStoredToken);
          handler.next(options);
        }
      }
    }
  }
  //return super.onRequest(options, handler);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    // EasyLoading.dismiss();
    // if (response.headers.value("verifyToken") != null) {
    //   //if the header is present, then compare it with the Shared Prefs key
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   var verifyToken = prefs.get("VerifyToken");
    //
    //   // if the value is the same as the header, continue with the request
    //   if (response.headers.value("verifyToken") == verifyToken) {
    //     //return response;
    //     return super.onResponse(response, handler);
    //   }
    // }
    // return DioError(
    //     requestOptions: response.requestOptions, error: "User is no longer active");

    handler.next(response);
    //return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    // if (err.response.data['key'] != null) {
    //   print(
    //     'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path} "${err.response.data['key']}"',
    //   );
    if (err.response == null) {
      EasyLoading.showError('Unable to connect with Database');
    } else {
      var responseClass = (err.response.statusCode / 100).floor();
      print('DATA==========');
      print(err.response.data);
      print('DATA==========');
      String jsonsDataString = err.response?.data.toString().replaceAll("\n","");
      final jsonData = jsonDecode(jsonsDataString);
      //if (err.response.data['key'] != null) {
        //final jsonResponse = json.decode(err.response.data);
        // ExceptionDTO ex = new ExceptionDTO.fromJson(jsonResponse);
        //EasyLoading.showError(ex.message);
      //} else
        if (responseClass == 5) {
        EasyLoading.showError('An unidentified server error has occurred');
      } else if (responseClass == 4) {
        if (err.response?.statusCode == 400) {
          if (jsonData["message"].toString().contains("duplicate")){
            EasyLoading.showError('User is already added');
          } else {
            EasyLoading.showError('Bad Request');
          }
        }
        if (err.response?.statusCode == 401) {
          if (jsonData["key"] == "INVALID_CREDENTIALS") {
            EasyLoading.showError(
              'There is no user with this username password combination');
          } else {
            EasyLoading.showError('Unauthenticated');
          }
        } else if (err.response?.statusCode == 403) {
          if (jsonData["message"] == "GYM_NOT_VERIFIED_EXCEPTION: Gym must be verified before that operation") {
            EasyLoading.showError(
                'Gym must be verified before that operation');
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
// Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
//   final options = new Options(
//     method: requestOptions.method,
//     headers: requestOptions.headers,
//   );
//   return this.api.request<dynamic>(requestOptions.path,
//       data: requestOptions.data,
//       queryParameters: requestOptions.queryParameters,
//       options: options);
// }

class LoggingInterceptors extends Interceptor {
  @override
  FutureOr<dynamic> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print(
        "--> ${options.method != null ? options.method.toUpperCase() : 'METHOD'} ${"" + (options.baseUrl ?? "") + (options.path ?? "")}");
    print("Headers:");
    options.headers.forEach((k, v) => print('$k: $v'));
    if (options.queryParameters != null) {
      print("queryParameters:");
      options.queryParameters.forEach((k, v) => print('$k: $v'));
    }
    if (options.data != null) {
      print("Body: ${options.data}");
    }
    print(
        "--> END ${options.method != null ? options.method.toUpperCase() : 'METHOD'}");

    //return options;
    return super.onRequest(options, handler);
  }

  @override
  FutureOr<dynamic> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    print(
        "<-- ${response.statusCode} ${(response.requestOptions != null ? (response.requestOptions.baseUrl + response.requestOptions.path) : 'URL')}");
    print("Headers:");
    response.headers?.forEach((k, v) => print('$k: $v'));
    print("Response: ${response.data}");
    print("<-- END HTTP");

    return super.onResponse(response, handler);
  }

  @override
  Future<FutureOr> onError(
      DioError err, ErrorInterceptorHandler handler) async {
    print(
        "<-- ${err.message} ${(err.response?.requestOptions != null ? (err.response.requestOptions.baseUrl + err.response.requestOptions.path) : 'URL')}");
    print("${err.response != null ? err.response.data : 'Unknown Error'}");
    print("<-- End error");
    return err;
    //return super.onError(err, handler);
  }
}

class CacheInterceptor extends Interceptor {
  CacheInterceptor();

  var _cache = new Map<Uri, Response>();

  @override
  FutureOr<dynamic> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    return options;
  }

  @override
  FutureOr<dynamic> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    _cache[response.requestOptions.uri] = response;
  }

  @override
  FutureOr<dynamic> onError(DioError err, ErrorInterceptorHandler handler) {
    print('onError: $err');
    if (err.type == DioErrorType.connectTimeout ||
        err.type == DioErrorType.other) {
      var cachedResponse = _cache[err.requestOptions.uri];
      if (cachedResponse != null) {
        return cachedResponse;
      }
    }
    return err;
  }
}
