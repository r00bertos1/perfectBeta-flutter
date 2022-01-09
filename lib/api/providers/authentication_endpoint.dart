import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:perfectBeta/constants/controllers.dart';
import 'package:perfectBeta/dto/auth/credentials_dto.dart';
import 'package:perfectBeta/dto/auth/token_dto.dart';
import '../api_client.dart';
import '../../storage/secure_storage.dart';

//AuthenticationEndpoint appAuth = new AuthenticationEndpoint();

class AuthenticationEndpoint {
  Dio _client;
  AuthenticationEndpoint(this._client);

  String token;

  // ANONIM
  // POST
  Future<Response> authenticate(CredentialsDTO body) async {
    try {
      //body is a CredentialsDTO eg.
      // var body =  {
      // "username": "pbucki",
      // "password": "Pbucki123!"
      // };
      Response response = await login(body);

      //String token = "${response.data['token']}";
      // String refresh = "${response.data['refresh']}";

      //Map<String, String> data = { 'token': token,'refresh': refresh };
      // Map<String, String> data = { 'token': token,'refresh': refresh };
      //return data;

        // var resp = await response.stream.bytesToString();
        // final data = jsonDecode(resp);
        print(response);
        final jsonResponse = json.decode(response.data);
        TokenDTO tokenDTO = new TokenDTO.fromJson(jsonResponse);
        secStore.secureWrite('token', tokenDTO.token);
        //print('${tokenDTO.token}');
        //return tokenDTO;
        return response;
    } on DioError catch (ex) {
      if (ex.response != null) {
        print('Dio error!');
        print('STATUS: ${ex.response?.statusCode}');
        print('DATA: ${ex.response?.data}');
        print('HEADERS: ${ex.response?.headers}');
      } else {
        print('Error sending request!');
        print(ex.message);
        String errorMessage = json.decode(ex.response.toString())["message"];
        throw new Exception(errorMessage);
      }
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  // OLD
  // Future<TokenDTO> authenticate(CredentialsDTO body) async {
  //   try {
  //     //body is a CredentialsDTO eg.
  //     // var body =  {
  //     // "username": "pbucki",
  //     // "password": "Pbucki123!"
  //     // };
  //     Response<String> response = await _client.post('/auth/authenticate',
  //         data: jsonEncode(body),
  //         options: Options(headers: {'Accept': 'application/json'}));
  //
  //     TokenDTO tokenDTO;
  //
  //     if (response.statusCode == 200) {
  //       // var resp = await response.stream.bytesToString();
  //       // final data = jsonDecode(resp);
  //       final jsonResponse = json.decode(response.data);
  //       tokenDTO = new TokenDTO.fromJson(jsonResponse);
  //       secStore.secureWrite('token', tokenDTO.token);
  //       print('tokenDTO.token');
  //       return tokenDTO;
  //     } else {
  //       return tokenDTO;
  //     }
  //   } on DioError catch (ex) {
  //     if (ex.response != null) {
  //       print('Dio error!');
  //       print('STATUS: ${ex.response?.statusCode}');
  //       print('DATA: ${ex.response?.data}');
  //       print('HEADERS: ${ex.response?.headers}');
  //     } else {
  //       print('Error sending request!');
  //       print(ex.message);
  //       String errorMessage = json.decode(ex.response.toString())["message"];
  //       throw new Exception(errorMessage);
  //     }
  //   } catch (e, s) {
  //     print("Exception $e");
  //     print("StackTrace $s");
  //   }
  // }

  Future<Response> login(CredentialsDTO body) async {
    try {
      //body is a CredentialsDTO eg.
      // var body =  {
      // "username": "pbucki",
      // "password": "Pbucki123!"
      // };
      Response response = await _client.post('/auth/authenticate',
          data: jsonEncode(body),
          options: Options(headers: {'Accept': 'application/json'}));

      print(response.data);

      return response;

    } on DioError catch (ex) {
      if (ex.response != null) {
        print('Dio error!');
        print('STATUS: ${ex.response?.statusCode}');
        print('DATA: ${ex.response?.data}');
        print('HEADERS: ${ex.response?.headers}');
      } else {
        print('Error sending request!');
        print(ex.message);
        String errorMessage = json.decode(ex.response.toString())["message"];
        throw new Exception(errorMessage);
      }
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  Future<void> logout() async {
    secStore.secureWrite('token', '');
    secStore.secureWrite('refreshTimeout', '');

    await Future.delayed(Duration(milliseconds: 100));

    navigationController.navigatorKey.currentState
        .pushNamedAndRemoveUntil("/auth", (Route<dynamic> route) => false);
  }

  Future<void> changeAccessLevel(String value) async {
    secStore.secureWrite('accessLevel', '${value}');
  }

  // USER
  // GET
  Future<TokenDTO> refreshToken() async {
    try {
      // CredentialsDTO user =
      //     new CredentialsDTO(username: 'anowak', password: 'Nowak123!');
      // await login(user);
      final refreshToken = secStore.secureRead('token');

      print('BEFORE REFRESH: $refreshToken');

      Response<String> response = await _client.get('/auth/refreshtoken',
          options: Options(headers: {"Authorization": "Bearer $refreshToken"}));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.data);
        TokenDTO tokenDTO = new TokenDTO.fromJson(jsonResponse);
        secStore.secureWrite('token', tokenDTO.token);
        final newToken = secStore.secureRead('token');

        print('AFTER REFRESH: $newToken');

        return tokenDTO;
      }
    } on DioError catch (ex) {
      if (ex.response != null) {
        print('Dio error!');
        print('STATUS: ${ex.response?.statusCode}');
        print('DATA: ${ex.response?.data}');
        print('HEADERS: ${ex.response?.headers}');
      } else {
        print('Error sending request!');
        print(ex.message);
        String errorMessage = json.decode(ex.response.toString())["message"];
        throw new Exception(errorMessage);
      }
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }
}
