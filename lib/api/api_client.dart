import 'dart:async';
import "package:dio/dio.dart";
import 'package:flutter/cupertino.dart';
import 'package:perfectBeta/constants/controllers.dart';
import 'package:perfectBeta/dto/auth/token_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Client{
  Dio init() {
    Dio _dio = new Dio();
    //  dio instance to request token
    Dio _tokenDio = new Dio();
    String token;
    _dio.options.baseUrl = "https://perfectbeta-spring-boot-tls-pyclimb.apps.okd.cti.p.lodz.pl/api";
    _tokenDio.options = _dio.options;
    _dio.interceptors.add(ApiInterceptors());
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
  FutureOr<dynamic> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {

    print('REQUEST[${options.method}] => PATH: ${options.path}');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.get("token");
    if (token != null) options.headers.addAll({"Authorization": 'Bearer ${token}'});

    return super.onRequest(options, handler);
  }

  @override
  FutureOr<dynamic> onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.headers.value("verifyToken") != null) {
      //if the header is present, then compare it with the Shared Prefs key
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var verifyToken = prefs.get("VerifyToken");

      // if the value is the same as the header, continue with the request
      if (response.headers.value("verifyToken") == verifyToken) {
        //return response;
        return super.onResponse(response, handler);
      }
    }

    return DioError(requestOptions: response.data, error: "User is no longer active");
  }

  @override
  FutureOr<dynamic> onError(DioError err, ErrorInterceptorHandler handler) {
    print(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    if (err.response == null) {
      print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path} "CONNECTION_ERROR"',
      );
    } else {
      var responseClass = (err.response.statusCode / 100).floor();
      if (err.response.data['key'] != null) {
        print(
          'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path} "${err.response.data['key']}"',
        );
      } else if (responseClass == 5) {
        print(
          'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path} "SERVER_ERROR"',
        );
      } else if (err.response.statusCode == 401) {
        print(
          'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path} "UNAUTHENTICATED"',
        );
        // this will push a new route and remove all the routes that were present
        navigationController.navigatorKey.currentState.pushNamedAndRemoveUntil(
            "/auth", (Route<dynamic> route) => false);
      } else if (err.response.statusCode == 403) {
        print(
          'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path} "UNAUTHORIZED"',
        );
      } else {
        print(
          'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path} "UNKNOWN_ERROR"',
        );
      }
    }
    return err;
    //return super.onError(err, handler);
  }
}