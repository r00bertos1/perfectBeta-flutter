import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:perfectBeta/dto/auth/credentials_dto.dart';
import 'package:perfectBeta/dto/auth/token_dto.dart';
import '../api_client.dart';

class AuthenticationEndpoint {
  Dio _client;
  AuthenticationEndpoint(this._client);

  // ANONIM
    // POST
  Future<TokenDTO> authenticate(CredentialsDTO body) async {
    try {
      //body is a CredentialsDTO eg.
      // var body =  {
      // "username": "pbucki",
      // "password": "Pbucki123!"
      // };
      Response<String> response =
          await _client.post('/auth/authenticate', data: jsonEncode(body));

      final jsonResponse = json.decode(response.data);
      TokenDTO page = new TokenDTO.fromJson(jsonResponse);
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

  // USER
    // GET
  Future<TokenDTO> refreshToken() async {
    try {
      Response<String> response = await _client.get('/auth/refreshtoken');

      final jsonResponse = json.decode(response.data);
      TokenDTO token = new TokenDTO.fromJson(jsonResponse);
      //TODO: replace old token with new from response
      return token;
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
