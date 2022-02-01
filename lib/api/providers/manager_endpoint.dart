import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:perfectBeta/model/auth/registration_dto.dart';
import 'package:perfectBeta/model/users/user_with_access_level_dto.dart';

class ManagerEndpoint {
  final Dio _client;
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
  Future<Response> registerManager(
      RegistrationDTO body) async {
    try {
      Response<String> response =
          await _client.post('/managers/register', data: jsonEncode(body));

      // final jsonResponse = json.decode(response.data);
      // UserWithPersonalDataAccessLevelDTO page =
      //     new UserWithPersonalDataAccessLevelDTO.fromJson(jsonResponse);
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
}
