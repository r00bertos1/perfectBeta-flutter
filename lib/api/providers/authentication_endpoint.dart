import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:perfectBeta/model/auth/credentials_dto.dart';
import 'package:perfectBeta/model/auth/token_dto.dart';
import '../../storage/secure_storage.dart';

class AuthenticationEndpoint {
  final Dio _client;
  AuthenticationEndpoint(this._client);

  // ANONIM
  // POST
  Future<Response> authenticate(CredentialsDTO body) async {
    try {
      Response<String> response = await login(body);
      if(response != null) {
        final jsonResponse = json.decode(response.data);
        TokenDTO tokenDTO = new TokenDTO.fromJson(jsonResponse);
        Map<String, dynamic> decodedToken = JwtDecoder.decode(tokenDTO.token);
        await secStore.secureWrite('username', decodedToken["sub"]);
        await secStore.secureWrite('token', tokenDTO.token);
        await secStore.secureWrite('tokenExpiry', JwtDecoder.getExpirationDate(tokenDTO.token).toString());
        await secStore.secureWrite('isAdmin', decodedToken["isAdmin"].toString());
        await secStore.secureWrite('isManager', decodedToken["isManager"].toString());
        await secStore.secureWrite('isClimber', decodedToken["isClimber"].toString());
        await secStore.secureWrite('isAnonymous', 'false');

        Map<String, bool> accessLevels = {'ADMIN': decodedToken["isAdmin"], 'MANAGER': decodedToken["isManager"], 'CLIMBER': decodedToken["isClimber"]};
        await secStore.setAccessLevels(accessLevels);

        if (decodedToken["isAdmin"] == true) {
          secStore.secureWrite('accessLevel', 'ADMIN');
        } else if (decodedToken["isManager"] == true) {
          secStore.secureWrite('accessLevel', 'MANAGER');
        } else if (decodedToken["isClimber"] == true) {
          secStore.secureWrite('accessLevel', 'CLIMBER');
        }
      }

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

  Future<bool> authenticateAnonim() async {
    try {
      //secStore.secureWrite('username', 'anonymous');
      await secStore.secureDelete('token');
      // secStore.secureDelete('username');
      await secStore.secureDelete('tokenExpiry');
      //secStore.secureDelete('accessLevel');
      await secStore.secureWrite('accessLevel', '');
      // secStore.secureWrite('isAdmin', 'false');
      // secStore.secureWrite('isManager', 'false');
      // secStore.secureWrite('isClimber', 'false');
      await secStore.secureWrite('isAnonymous', 'true');

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
      Response<String> response = await _client.post('/auth/authenticate',
          data: jsonEncode(body), options: Options(headers: {'Accept': 'application/json', "requiresToken": false}));

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
    //await secStore.secureDeleteAll();
    await secStore.secureDelete('username');
    await secStore.secureDelete('token');
    await secStore.secureDelete('tokenExpiry');
    await secStore.secureDelete('accessLevel');
    await secStore.secureDelete('accessLevels');
    await secStore.secureDelete('isAdmin');
    await secStore.secureDelete('isManager');
    await secStore.secureDelete('isClimber');
    await secStore.secureDelete('isAnonymous');
    await Future.delayed(Duration(milliseconds: 100));
  }

// USER
// GET
  Future<bool> refreshToken() async {
    try {
      final oldToken = await secStore.secureRead('token');

      //print('BEFORE REFRESH: $oldToken');

      Response response =
          await _client.get('/auth/refreshtoken', options: Options(headers: {"Authorization": "Bearer $oldToken", "requiresToken": false}));

      if (response.statusCode == 200) {
        TokenDTO tokenDTO = new TokenDTO.fromJson(response.data);
        Map<String, dynamic> decodedToken = JwtDecoder.decode(tokenDTO.token);
        secStore.secureWrite('username', decodedToken["sub"]);
        secStore.secureWrite('token', tokenDTO.token);
        secStore.secureWrite('tokenExpiry', JwtDecoder.getExpirationDate(tokenDTO.token).toString());
        secStore.secureWrite('isAdmin', decodedToken["isAdmin"].toString());
        secStore.secureWrite('isManager', decodedToken["isManager"].toString());
        secStore.secureWrite('isClimber', decodedToken["isClimber"].toString());
        Map<String, bool> accessLevels = {
          'ADMIN': decodedToken["isAdmin"],
          'MANAGER': decodedToken["isManager"],
          'CLIMBER': decodedToken["isClimber"]
        };
        secStore.setAccessLevels(accessLevels);

        //final newToken = await secStore.secureRead('token');
        //print(' AFTER REFRESH: $newToken');

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
}
