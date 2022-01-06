import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:perfectBeta/dto/auth/registration_dto.dart';
import 'package:perfectBeta/dto/users/user_with_access_level_dto.dart';
import 'package:perfectBeta/dto/users/user_with_personal_data_access_level_dto.dart';

import '../api_client.dart';

class ManagerEndpoint {
  //Dio _client = new ApiClient().init();
  Dio _client;
  ManagerEndpoint(this._client);

  // ADMIN
    // PUT
  Future<UserWithAccessLevelDTO> activateManager(int managerId) async {
    try {
      Response<String> response =
      await _client.put('/managers/activate/$managerId');

      final jsonResponse = json.decode(response.data);
      UserWithAccessLevelDTO page = new UserWithAccessLevelDTO.fromJson(jsonResponse);
      return page;
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

  Future<UserWithAccessLevelDTO> deactivateManager(int managerId) async {
    try {
      Response<String> response =
          await _client.put('/managers/deactivate/$managerId');

      final jsonResponse = json.decode(response.data);
      UserWithAccessLevelDTO page = new UserWithAccessLevelDTO.fromJson(jsonResponse);
      return page;
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

    // POST
  Future<UserWithPersonalDataAccessLevelDTO> registerManager(
      RegistrationDTO body) async {
    try {
      //body is a RegistrationDTO eg.
      // var body =  {
      // "login": "manager2",
      // "email": "manager2@perfectbeta.pl",
      // "password": "Jdoe123!"
      // };
      Response<String> response =
          await _client.post('/managers/register', data: jsonEncode(body));

      final jsonResponse = json.decode(response.data);
      UserWithPersonalDataAccessLevelDTO page =
          new UserWithPersonalDataAccessLevelDTO.fromJson(jsonResponse);
      return page;
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
