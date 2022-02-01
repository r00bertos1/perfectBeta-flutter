import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:perfectBeta/model/auth/registration_dto.dart';
import 'package:perfectBeta/model/pages/page_dto.dart';
import 'package:perfectBeta/model/users/data/change_password_dto.dart';
import 'package:perfectBeta/model/users/data/email_dto.dart';
import 'package:perfectBeta/model/users/data/password_dto.dart';
import 'package:perfectBeta/model/users/data/personal_data_dto.dart';
import 'package:perfectBeta/model/users/data/reset_password_dto.dart';
import 'package:perfectBeta/model/users/user_dto.dart';
import 'package:perfectBeta/model/users/user_with_access_level_dto.dart';
import 'package:perfectBeta/model/users/user_with_personal_data_access_level_dto.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:perfectBeta/storage/secure_storage.dart';
import 'package:perfectBeta/storage/user_secure_storage.dart';

class UserEndpoint {
  final Dio _client;
  UserEndpoint(this._client);

  // USER
    // GET
  Future<UserWithPersonalDataAccessLevelDTO> getUserPersonalDataAccessLevel() async {
    try {
      Response<String> response = await _client.get('/users/self');

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

    // PUT
  Future<Response> requestChangeEmail(EmailDTO body) async {
    try {
      //body is a EmailDTO eg.
      // var body =  {
      // "email": "a@b.c"
      // };
      Response<String> response = await _client
          .put('/users/request_change_email', data: jsonEncode(body));

      // final jsonResponse = json.decode(response.data);
      // UserDTO page = new UserDTO.fromJson(jsonResponse);

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

  Future<Response> confirmChangeEmail(String token, String email) async {
    try {
      Response<String> response = await _client.put('/users/change_email',
          queryParameters: {'token': token, 'email': email});

      // final jsonResponse = json.decode(response.data);
      // UserDTO page = new UserDTO.fromJson(jsonResponse);

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

  Future<Response> changePassword(ChangePasswordDTO body) async {
    try {
      Response<String> response =
          await _client.put('/users/change_password', data: body);

      // final jsonResponse = json.decode(response.data);
      // UserDTO page = new UserDTO.fromJson(jsonResponse);

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

  Future<Response> updatePersonalData(
      int userID, PersonalDataDTO body) async {
    try {
      Response<String> response =
          await _client.put('/users/update/$userID', data: jsonEncode(body));

      // final jsonResponse = json.decode(response.data);
      // UserDTO page = new UserDTO.fromJson(jsonResponse);
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

    // DELETE
  Future<Response> deleteUser(int userId, PasswordDTO body) async {
    try {
      Response<String> response =
      await _client.delete('/users/delete/$userId', data: body);

      //Delete all data from storage
      await secStore.secureDeleteAll();
      await UserSecureStorage.secureDeleteAll();

      return response;
      
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


  // ANONIM
    // POST
  Future<Response> registerUser(
      RegistrationDTO body) async {
    try {
      Response<String> response =
          await _client.post('/users/register', data: jsonEncode(body),
              options: Options(headers: {"requiresToken" : false}));

      // final jsonResponse = json.decode(response.data);
      // UserWithPersonalDataAccessLevelDTO page =
      //     new UserWithPersonalDataAccessLevelDTO.fromJson(jsonResponse);
      //return page;
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

    // PUT
  Future<Response> verifyUser(String token) async {
    try {
      Response<String> response = await _client.get('/users/token_verify',
          queryParameters: {'token': token},
          options: Options(headers: {"requiresToken" : false}));

      // final jsonResponse = json.decode(response.data);
      // UserWithAccessLevelDTO page = new UserWithAccessLevelDTO.fromJson(jsonResponse);
      // return page;

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

  Future<Response> requestResetPassword(EmailDTO body) async {
    try {
      EasyLoading.show(status: 'loading...');

      Response<String> response = await _client
          .put('/users/request_reset_password', data: body,
          options: Options(headers: {"requiresToken" : false}));

      final jsonResponse = json.decode(response.data);
      UserDTO page = new UserDTO.fromJson(jsonResponse);
      //return page;
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

  Future<Response> confirmResetPassword(String token, ResetPasswordDTO body) async {
    try {
      Response<String> response = await _client.put('/users/reset_password',
          data: body,
          queryParameters: {'token': token},
          options: Options(headers: {"requiresToken" : false}));

      // final jsonResponse = json.decode(response.data);
      // UserDTO page = new UserDTO.fromJson(jsonResponse);

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

  // ADMIN
    // GET
  Future<DataPage> getAllUsers() async {
    try {
      Response<String> response = await _client.get('/users');

      final jsonResponse = json.decode(response.data);
      DataPage page = new DataPage.fromJson(jsonResponse);

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

  Future<UserWithPersonalDataAccessLevelDTO> getUserById(int userId) async {
    try {
      Response<String> response = await _client.get('/users/$userId');

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

    // PUT
  Future<UserWithAccessLevelDTO> activateUser(int userId) async {
    try {
      Response<String> response =
      await _client.put('/users/activate/$userId');

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

  Future<UserWithAccessLevelDTO> deactivateUser(int userId) async {
    try {
      Response<String> response =
      await _client.put('/users/deactivate/$userId');

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
}
