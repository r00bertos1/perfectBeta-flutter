import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:perfectBeta/dto/gyms/climbing_gym_dto.dart';
import 'package:perfectBeta/dto/gyms/climbing_gym_with_details_dto.dart';
import 'package:perfectBeta/dto/gyms/climbing_gym_with_maintainers_dto.dart';
import 'package:perfectBeta/dto/gyms/gym_details_dto.dart';
import 'package:perfectBeta/dto/pages/page_dto.dart';
import '../api_client.dart';

class CloudEndpoint {

  Dio _client;
  CloudEndpoint(this._client);

  // ANONIM
  // POST
  Future<List<Uri>> uploadFile(map) async {
    try {
      var formData = FormData.fromMap(map);
      // map with a list of imagePaths eg.
      // {
      //   'files': '${imagePathList}',
      // }
      Response<String> response =  await _client.post('/info', data: formData);


      var linksList = response.data as List<String>;
      List<Uri> res = List<Uri>.from(linksList.map((item)=> Uri.parse(item)));
      return res;

      // return jsonResponse
      //     .map((item) => new ClimbingGymDTO.fromJson(item))
      //     .toList();

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
