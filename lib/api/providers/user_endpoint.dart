import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:perfectBeta/dto/auth/registration_dto.dart';
import 'package:perfectBeta/dto/pages/page_dto.dart';
import 'package:perfectBeta/dto/users/data/change_password_dto.dart';
import 'package:perfectBeta/dto/users/data/email_dto.dart';
import 'package:perfectBeta/dto/users/data/password_dto.dart';
import 'package:perfectBeta/dto/users/data/personal_data_dto.dart';
import 'package:perfectBeta/dto/users/user_dto.dart';
import 'package:perfectBeta/dto/users/user_with_access_level_dto.dart';
import 'package:perfectBeta/dto/users/user_with_personal_data_access_level_dto.dart';
import 'package:perfectBeta/dto/users/user_with_personal_data_dto.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../api_client.dart';

class UserEndpoint {
  //Dio _client = new ApiClient().init();
  Dio _client;
  UserEndpoint(this._client);

  // USER
    // PUT
  Future<UserDTO> requestChangeEmail(EmailDTO body) async {
    try {
      //body is a EmailDTO eg.
      // var body =  {
      // "email": "a@b.c"
      // };
      Response<String> response = await _client
          .put('/users/request_change_email', data: jsonEncode(body));

      final jsonResponse = json.decode(response.data);
      UserDTO page = new UserDTO.fromJson(jsonResponse);

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

  Future<UserDTO> confirmChangeEmail(String token, String email) async {
    try {
      Response<String> response = await _client.put('/users/change_email',
          queryParameters: {'token': token, 'email': email});

      final jsonResponse = json.decode(response.data);
      UserDTO page = new UserDTO.fromJson(jsonResponse);

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

  Future<UserDTO> changePassword(ChangePasswordDTO body) async {
    try {
      //body is a ChangePasswordDTO eg.
      // var body =  {
      // "newPassword": "Test12345!",
      // "oldPassword": "Test1234!"
      // };
      Response<String> response =
          await _client.put('/users/change_password', data: jsonEncode(body));

      final jsonResponse = json.decode(response.data);
      UserDTO page = new UserDTO.fromJson(jsonResponse);

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

  Future<UserWithPersonalDataDTO> updatePersonalData(
      int userID, PersonalDataDTO body) async {
    try {
      //body is a EmailDTO eg.
      // var body =  {
      // "name": "ziomekkk",
      // "surname": "ziomekk",
      // "phoneNumber": "555666777",
      // "gender": true,
      // "language": "EN",
      // };
      Response<String> response =
          await _client.put('/users/update/$userID', data: jsonEncode(body));

      final jsonResponse = json.decode(response.data);
      UserDTO page = new UserDTO.fromJson(jsonResponse);
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

    // DELETE
  Future<Response> deleteUser(int userId, PasswordDTO body) async {
    try {
      Response<String> response =
      await _client.delete('/users/delete/$userId', data: jsonEncode(body));

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
      //body is a RegistrationDTO eg.
      // var body =  {
      // "login": "manager2",
      // "email": "manager2@perfectbeta.pl",
      // "password": "Jdoe123!"
      // };
      Response<String> response =
          await _client.post('/users/register', data: jsonEncode(body),
              options: Options(headers: {"requiresToken" : false}));

      final jsonResponse = json.decode(response.data);
      UserWithPersonalDataAccessLevelDTO page =
          new UserWithPersonalDataAccessLevelDTO.fromJson(jsonResponse);
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
  Future<UserWithAccessLevelDTO> verifyUser(String username, String token) async {
    try {
      Response<String> response = await _client.put('/users/verify',
          queryParameters: {'username': username, 'token': token},
          options: Options(headers: {"requiresToken" : false}));

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

  Future<UserDTO> confirmResetPassword(String id, String token) async {
    try {
      Response<String> response = await _client.put('/users/reset_password',
          queryParameters: {'id': id, 'token': token},
          options: Options(headers: {"requiresToken" : false}));

      final jsonResponse = json.decode(response.data);
      UserDTO page = new UserDTO.fromJson(jsonResponse);

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

  // MANAGER + ADMIN
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

  // ADMIN
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
