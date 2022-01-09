import 'dart:async';
import "package:dio/dio.dart";
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:perfectBeta/constants/controllers.dart';
import 'package:perfectBeta/dto/auth/token_dto.dart';
import 'package:perfectBeta/api/providers/authentication_endpoint.dart';

class ApiClient {
  Dio init() {
    Dio _dio = new Dio();
    //  dio instance to request token
    Dio _tokenDio = new Dio();
    String token;
    _dio.options.baseUrl =
        'https://perfectbeta-spring-boot-tls-pyclimb.apps.okd.cti.p.lodz.pl/api';
    _dio.options.headers['Content-Type'] = 'application/json';
    _tokenDio.options = _dio.options;
    //_dio.interceptors.add(ApiInterceptors());
    _dio.interceptors.add(LoggingInterceptors());
    //TODO: Interceptor for token authentication
    // _dio.interceptors.add(QueuedInterceptorsWrapper(
    //   onRequest: (options, handler) async {
    //     print('send request：path:${options.path}，baseURL:${options.baseUrl}');
    //     SharedPreferences prefs = await SharedPreferences.getInstance();
    //     var token = prefs.get("token");
    //     if (token == null) {
    //       print('no token，request token firstly...');
    //       await _tokenDio.post('/auth/authenticate').then((res) {
    //         TokenDTO tokenDTO;
    //         options.headers['Authorization'] = 'Bearer ${token}';
    //         print('request token succeed, value: ' + res.data['data']['token']);
    //         print(
    //             'continue to perform request：path:${options.path}，baseURL:${options.path}');
    //         handler.next(options);
    //       }).catchError((error, stackTrace) {
    //         handler.reject(error, true);
    //       });
    //     } else {
    //       options.headers['Authorization'] = 'Bearer ${token}';
    //       return handler.next(options);
    //     }
    //   },
    // ));
    return _dio;
  }
}

class ApiInterceptors extends Interceptor {
  @override
  FutureOr<dynamic> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('REQUEST[${options.method}] => PATH: ${options.path}');

    // FlutterSecureStorage _storage = new FlutterSecureStorage();
    // var token = _storage.read(key: "token");
    // if (token != null)
    //   options.headers.addAll({"Authorization": 'Bearer ${token}'});

    return super.onRequest(options, handler);
  }

  @override
  FutureOr<dynamic> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');

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
    return super.onResponse(response, handler);
  }

    @override
  Future<FutureOr> onError(DioError err, ErrorInterceptorHandler handler) async {
    print(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    if (err.response == null) {
      print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path} "CONNECTION_ERROR"',
      );
    } else {
      var responseClass = (err.response.statusCode / 100).floor();
      // if (err.response.data['key'] != null) {
      //   print(
      //     'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path} "${err.response.data['key']}"',
      //   );
      // } else
        if (responseClass == 5) {
        print(
          'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path} "SERVER_ERROR"',
        );
      } else if (responseClass == 4) {
        if (err.response.statusCode == 401) {
          print(
            'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path} "UNAUTHENTICATED"',
          );
          // this will push a new route and remove all the routes that were present
          //await refreshToken();
          //return _retry(err.requestOptions);
          // navigationController.navigatorKey.currentState
          //     .pushNamedAndRemoveUntil(
          //         "/auth", (Route<dynamic> route) => false);
        } else if (err.response.statusCode == 403) {
          print(
            'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path} "UNAUTHORIZED"',
          );
        } else {
          print(
            'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path} "SERVER_ERROR"',
          );
        }
      } else {
        print(
          'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path} "UNKNOWN_ERROR"',
        );
      }
    }
    return err;
    //return super.onError(err, handler);
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
}

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
  Future<FutureOr> onError(DioError err, ErrorInterceptorHandler handler) async {
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
