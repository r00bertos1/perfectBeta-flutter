import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perfectBeta/dto/gyms/climbing_gym_dto.dart';
import 'package:perfectBeta/dto/gyms/climbing_gym_with_details_dto.dart';
import 'package:perfectBeta/dto/pages/page_dto.dart';

import '../api_client.dart';

class ClimbingGymEndpoint {
  //Dio _client = new ApiClient().init();
  Dio _client;
  ClimbingGymEndpoint(this._client);


  Future<GymPage> getVerifiedGyms() async {
    try {
      //final response = await _client.get('/gym/verified/all');
      Response<String> response = await _client.get('/gym/verified/all');
      //print(response.data);

      //Decode response data and create new model class
      final jsonResponse = json.decode(response.data);
      GymPage page = new GymPage.fromJson(jsonResponse);
      //print('PAGE' + page.toString());

      return page;

    } on DioError catch (ex) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (ex.response != null) {
        print('Dio error!');
        print('STATUS: ${ex.response?.statusCode}');
        print('DATA: ${ex.response?.data}');
        print('HEADERS: ${ex.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(ex.message);
        // Assuming there will be an errorMessage property in the JSON object
        String errorMessage = json.decode(ex.response.toString())["message"];
        throw new Exception(errorMessage);
      }
    }
    catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  Future<ClimbingGymWithDetailsDTO> getVerifiedGymById(int gymId) async {
    try {
      //final response = await _client.get('/gym/verified/all');
      Response<String> response = await _client.get('/gym/verified/$gymId');
      //print(response.data);

      //Decode response data and create new model class
      final jsonResponse = json.decode(response.data);
      ClimbingGymWithDetailsDTO page = new ClimbingGymWithDetailsDTO.fromJson(jsonResponse);
      //print('PAGE' + page.toString());

      return page;

    } on DioError catch (ex) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (ex.response != null) {
        print('Dio error!');
        print('STATUS: ${ex.response?.statusCode}');
        print('DATA: ${ex.response?.data}');
        print('HEADERS: ${ex.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(ex.message);
        // Assuming there will be an errorMessage property in the JSON object
        String errorMessage = json.decode(ex.response.toString())["message"];
        throw new Exception(errorMessage);
      }
    }
    catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }










  Future<List<ClimbingGymDTO>> getVerifiedGymsWithoutPage() async {
    try {
      final response = await _client.get('/gym/verified/all');
      //Response<String> response = await _client.get('/gym/verified/all');
      //print('RESPONSE: ${response.data.toString()}');
      //print('RESPONSE: ${response.data['content'].toString()}');
      //return response.data;
      // It's better to return a Model class instead but this is
      // only for example purposes only
      //var jsonResponse = json.decode(response.data['content']);
      //print('JSON RESPONSE: ${jsonResponse.toString()}');
      //print('JSON RESPONSE:');

      // print(json.decode(response.data['content'])
      //     .map((item) => new ClimbingGymDTO.fromJson(item))
      //     .toList().toString());

      print(response.data['content']);
      // List jsonResponse = json.decode(response.data['content']);
      // print(jsonResponse);
      // return jsonResponse
      //     .map((item) => new ClimbingGymDTO.fromJson(item))
      //     .toList();
      //var responseBodyGyms = response.data['content'];
      Iterable l = json.decode(response.data['content']);
      //print('TEST Iterable' + l.toString());
      //List<ClimbingGymDTO> res = List<ClimbingGymDTO>.from(responseBodyGyms.map((model)=> ClimbingGymDTO.fromJson(model)));
      List<ClimbingGymDTO> res = List<ClimbingGymDTO>.from(l.map((model)=> ClimbingGymDTO.fromJson(model)));
      print('TEST' + res.toString());
      return res;

      // return (response.data as List)
      //     .map((item) => ClimbingGymDTO.fromJson(item))
      //     .toList();
      // return jsonResponse
      //     .map((item) => new ClimbingGymDTO.fromJson(item))
      //     .toList();
      //return ClimbingGymDTO.fromJson(jsonDecode(response.data));
    } on DioError catch (ex) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (ex.response != null) {
        print('Dio error!');
        print('STATUS: ${ex.response?.statusCode}');
        print('DATA: ${ex.response?.data}');
        print('HEADERS: ${ex.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(ex.message);
        // Assuming there will be an errorMessage property in the JSON object
        // String errorMessage = json.decode(ex.response.toString())["errorMessage"];
        // throw new Exception(errorMessage);
      }
    }
    catch(e) {
      print(e);
    }
  }
}
