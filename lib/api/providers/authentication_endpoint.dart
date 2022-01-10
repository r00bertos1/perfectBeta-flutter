import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:perfectBeta/constants/controllers.dart';
import 'package:perfectBeta/dto/auth/credentials_dto.dart';
import 'package:perfectBeta/dto/auth/token_dto.dart';
import 'package:perfectBeta/pages/authentication/authentication.dart';
import 'package:perfectBeta/routing/routes.dart';
import '../api_client.dart';
import 'package:http/http.dart' as http;
import '../../storage/secure_storage.dart';



class AuthenticationEndpoint {
  Dio _client;
  AuthenticationEndpoint(this._client);

  String token;

  // ANONIM
  // POST
  Future<Response> authenticate(CredentialsDTO body) async {
    try {
      Response response = await login(body);

      TokenDTO tokenDTO = new TokenDTO.fromJson(response.data);
      Map<String, dynamic> decodedToken = JwtDecoder.decode(tokenDTO.token);
      secStore.secureWrite('username', decodedToken["sub"]);
      secStore.secureWrite('token', tokenDTO.token);
      secStore.secureWrite('tokenExpiry', JwtDecoder.getExpirationDate(tokenDTO.token).toString());
      secStore.secureWrite('isAdmin', decodedToken["isAdmin"].toString());
      secStore.secureWrite('isManager', decodedToken["isManager"].toString());
      secStore.secureWrite('isClimber', decodedToken["isClimber"].toString());

      Map<String, bool> accessLevels = {'ADMIN': decodedToken["isAdmin"], 'MANAGER': decodedToken["isManager"], 'CLIMBER': decodedToken["isClimber"]};
      secStore.setAccessLevels(accessLevels);

      if(decodedToken["isAdmin"] == true) {
        secStore.secureWrite('accessLevel', 'ADMIN');
      } else if (decodedToken["isManager"] == true) {
        secStore.secureWrite('accessLevel', 'MANAGER');
      } else if (decodedToken["isClimber"] == true) {
        secStore.secureWrite('accessLevel', 'CLIMBER');
      }

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

  bool authenticateAnonim()  {
    try {
      //secStore.secureWrite('username', 'anonymous');
      secStore.secureDelete('token');
      // secStore.secureDelete('username');
      secStore.secureDelete('tokenExpiry');
      //secStore.secureDelete('accessLevel');
      secStore.secureWrite('accessLevel', '');
      secStore.secureWrite('isAdmin', 'false');
      secStore.secureWrite('isManager', 'false');
      secStore.secureWrite('isClimber', 'false');
      secStore.secureWrite('isAnonymous', 'true');

      return true;

    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  Future<Response> login(CredentialsDTO body) async {
    try {

      //body is a CredentialsDTO eg.
      // var body =  {
      // "username": "pbucki",
      // "password": "Pbucki123!"
      // };
      Response response = await _client.post('/auth/authenticate',
          data: jsonEncode(body),
          options: Options(headers: {'Accept': 'application/json', "requiresToken" : false}));

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
    //secStore.secureWrite('refreshTimeout', '');
    secStore.secureWrite('username', '');
    secStore.secureWrite('accessLevel', '');
    secStore.secureWrite('accessLevels', '');
    secStore.secureWrite('tokenExpiry', '');

    await Future.delayed(Duration(milliseconds: 100));
    // navigationController.navigatorKey.currentState
    //     .pushNamedAndRemoveUntil(
    //         "/auth", (Route<dynamic> route) => false);
    navigationController.navigateTo(authenticationPageRoute);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => AuthenticationPage()),
    // );
  }

// USER
// GET
  Future<bool> refreshToken() async {
    try {
      final oldToken = await secStore.secureRead('token');

      print('BEFORE REFRESH: $oldToken');

      Response response = await _client.get('/auth/refreshtoken',
          options: Options(headers: {"Authorization": "Bearer $oldToken", "requiresToken" : false}));

      if (response.statusCode == 200) {
        TokenDTO tokenDTO = new TokenDTO.fromJson(response.data);
        Map<String, dynamic> decodedToken = JwtDecoder.decode(tokenDTO.token);
        secStore.secureWrite('username', decodedToken["sub"]);
        secStore.secureWrite('token', tokenDTO.token);
        secStore.secureWrite('tokenExpiry', JwtDecoder.getExpirationDate(tokenDTO.token).toString());
        secStore.secureWrite('isAdmin', decodedToken["isAdmin"].toString());
        secStore.secureWrite('isManager', decodedToken["isManager"].toString());
        secStore.secureWrite('isClimber', decodedToken["isClimber"].toString());
        Map<String, bool> accessLevels = {'ADMIN': decodedToken["isAdmin"], 'MANAGER': decodedToken["isManager"], 'CLIMBER': decodedToken["isClimber"]};
        secStore.setAccessLevels(accessLevels);

        final newToken = await secStore.secureRead('token');
        print('AFTER REFRESH: $newToken');

        return true;
        //return tokenDTO;
      } else {
        return false;
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

  //String baseURL = 'https://perfectbeta-spring-boot-tls-pyclimb.apps.okd.cti.p.lodz.pl/api';

  //HTTP
  // // ANONIM
  // // POST
  // Future<http.Response> authenticate(CredentialsDTO body) async {
  //   try {
  //     http.Response response = await login(body);
  //
  //     if (response.statusCode == 200) {
  //       var resp = response.body;
  //       final data = jsonDecode(resp);
  //       token = data['token'];
  //
  //       TokenDTO tokenDTO = new TokenDTO(token: token);
  //       Map<String, dynamic> decodedToken = JwtDecoder.decode(tokenDTO.token);
  //       secStore.secureWrite('username', decodedToken["sub"]);
  //       secStore.secureWrite('token', tokenDTO.token);
  //       secStore.secureWrite('tokenExpiry', decodedToken["exp"]);
  //       secStore.secureWrite('isAdmin', decodedToken["isAdmin"]);
  //       secStore.secureWrite('isManager', decodedToken["isManager"]);
  //       secStore.secureWrite('isClimber', decodedToken["isClimber"]);
  //
  //       return response;
  //     }
  //     return response;
  //   } catch (e, s) {
  //     print("Exception $e");
  //     print("StackTrace $s");
  //   }
  // }
  //
  // Future<http.Response> login(CredentialsDTO body) async {
  //   try {
  //     var headers = {'Accept': 'application/json'};
  //     // var request = http.MultipartRequest('POST', Uri.parse(baseURL + '/auth/authenticate'));
  //     // request.fields.addAll({'username': body.username, 'password': body.password});
  //     // request.headers.addAll(headers);
  //     var response = await http.post(Uri.parse(baseURL + '/auth/authenticate'), body: {'username': body.username, 'password': body.password}, headers: headers);
  //
  //     //http.StreamedResponse response = await request.send();
  //     return response;
  //
  //   } catch (e, s) {
  //     print("Exception $e");
  //     print("StackTrace $s");
  //   }
  // }
  //
  // Future<void> logout() async {
  //   secStore.secureWrite('token', '');
  //   //secStore.secureWrite('refreshTimeout', '');
  //   secStore.secureWrite('username', '');
  //   secStore.secureWrite('accessLevel', '');
  //   secStore.secureWrite('accessLevels', '');
  //   secStore.secureWrite('tokenExpiry', '');
  //
  //   await Future.delayed(Duration(milliseconds: 100));
  //   // navigationController.navigatorKey.currentState
  //   //     .pushNamedAndRemoveUntil(
  //   //         "/auth", (Route<dynamic> route) => false);
  //   navigationController.navigateTo(authenticationPageRoute);
  //   // Navigator.push(
  //   //   context,
  //   //   MaterialPageRoute(builder: (context) => AuthenticationPage()),
  //   // );
  // }
  //
  //
  // // USER
  // // GET
  // Future<bool> refreshToken() async {
  //   try {
  //     final oldToken = secStore.secureRead('token');
  //
  //     print('BEFORE REFRESH: $oldToken');
  //
  //     var headers = {'Accept': 'application/json', "Authorization": "Bearer $oldToken"};
  //     var request =
  //     http.MultipartRequest('POST', Uri.parse(baseURL + '/auth/refreshtoken'));
  //     request.headers.addAll(headers);
  //
  //     http.StreamedResponse response = await request.send();
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(await response.stream.bytesToString());
  //       token = data['token'];
  //
  //       TokenDTO tokenDTO = new TokenDTO(token: token);
  //       Map<String, dynamic> decodedToken = JwtDecoder.decode(tokenDTO.token);
  //       secStore.secureWrite('username', decodedToken["sub"]);
  //       secStore.secureWrite('token', tokenDTO.token);
  //       secStore.secureWrite('tokenExpiry', decodedToken["exp"]);
  //       secStore.secureWrite('isAdmin', decodedToken["isAdmin"]);
  //       secStore.secureWrite('isManager', decodedToken["isManager"]);
  //       secStore.secureWrite('isClimber', decodedToken["isClimber"]);
  //
  //
  //       final newToken = secStore.secureRead('token');
  //       print('AFTER REFRESH: $newToken');
  //
  //       return true;
  //       //return tokenDTO;
  //     }
  //     else {
  //       print(response.reasonPhrase);
  //       return false;
  //     }
  //   } catch (e, s) {
  //     print("Exception $e");
  //     print("StackTrace $s");
  //   }
  // }
}
