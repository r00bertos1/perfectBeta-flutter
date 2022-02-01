import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:perfectBeta/model/gyms/climbing_gym_dto.dart';
import 'package:perfectBeta/model/gyms/climbing_gym_with_details_dto.dart';
import 'package:perfectBeta/model/gyms/climbing_gym_with_maintainers_dto.dart';
import 'package:perfectBeta/model/gyms/gym_details_dto.dart';
import 'package:perfectBeta/model/pages/page_dto.dart';

class ClimbingGymEndpoint {
  final Dio _client;
  ClimbingGymEndpoint(this._client);

  // ANONIM
  // GET
  Future<DataPage> getVerifiedGyms() async {
    try {
      Response<String> response = await _client.get('/gym/verified/all',
          options: Options(headers: {"requiresToken": false}));

      //Decode response data and create new model class
      final jsonResponse = json.decode(response.data);
      DataPage page = new DataPage.fromJson(jsonResponse);

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
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  Future<ClimbingGymWithDetailsDTO> getVerifiedGymById(int gymId) async {
    try {
      //final response = await _client.get('/gym/verified/all');
      Response<String> response = await _client.get('/gym/verified/$gymId',
          options: Options(headers: {"requiresToken": false}));
      //print(response.data);

      //Decode response data and create new model class
      final jsonResponse = json.decode(response.data);
      ClimbingGymWithDetailsDTO page =
          new ClimbingGymWithDetailsDTO.fromJson(jsonResponse);
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
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  // ADMIN
  // GET
  Future<DataPage> getAllGyms() async {
    try {
      Response<String> response = await _client.get('/gym/all');

      //Decode response data and create new model class
      final jsonResponse = json.decode(response.data);
      DataPage page = new DataPage.fromJson(jsonResponse);
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
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  Future<ClimbingGymWithDetailsDTO> getGymById(int gymId) async {
    try {
      Response<String> response = await _client.get('/gym/$gymId');

      //Decode response data and create new model class
      final jsonResponse = json.decode(response.data);
      ClimbingGymWithDetailsDTO page =
          new ClimbingGymWithDetailsDTO.fromJson(jsonResponse);
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
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  // PUT
  Future<ClimbingGymDTO> verifyGym(int gymId) async {
    try {
      Response<String> response = await _client.put('/gym/verify/$gymId');

      //Decode response data and create new model class
      final jsonResponse = json.decode(response.data);
      ClimbingGymDTO page = new ClimbingGymDTO.fromJson(jsonResponse);
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

  Future<ClimbingGymDTO> closeGym(int gymId) async {
    try {
      Response<String> response = await _client.put('/gym/close/$gymId');

      //Decode response data and create new model class
      final jsonResponse = json.decode(response.data);
      ClimbingGymDTO page = new ClimbingGymDTO.fromJson(jsonResponse);
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

  // MANAGER
  // GET
  Future<DataPage> getAllOwnedGyms() async {
    try {
      Response<String> response = await _client.get('/gym/owned_gyms');

      //Decode response data and create new model class
      final jsonResponse = json.decode(response.data);
      DataPage page = new DataPage.fromJson(jsonResponse);
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
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  Future<DataPage> getAllMaintainedGyms() async {
    try {
      Response<String> response = await _client.get('/gym/maintained_gyms');

      //Decode response data and create new model class
      final jsonResponse = json.decode(response.data);
      DataPage page = new DataPage.fromJson(jsonResponse);
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
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
    }
  }

  // PUT
  Future<ClimbingGymWithMaintainersDTO> addMaintainerToGym(
      int gymId, String maintainerUsername) async {
    try {
      Response<String> response =
          await _client.put('/gym/$gymId/add_maintainer/$maintainerUsername');

      final jsonResponse = json.decode(response.data);
      ClimbingGymWithMaintainersDTO page =
          new ClimbingGymWithMaintainersDTO.fromJson(jsonResponse);
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

  Future<Response> editGymDetails(
      int gymId, GymDetailsDTO body) async {
    try {
      Response<String> response = await _client
          .put('/gym/edit_gym_details/$gymId', data: jsonEncode(body));

      // final jsonResponse = json.decode(response.data);
      // ClimbingGymWithDetailsDTO page =
      //     new ClimbingGymWithDetailsDTO.fromJson(jsonResponse);
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

  // POST
  Future<ClimbingGymWithDetailsDTO> registerNewGym(String gymName) async {
    try {
      Response<String> response = await _client.post('/gym/register/$gymName');

      final jsonResponse = json.decode(response.data);
      ClimbingGymWithDetailsDTO page =
          new ClimbingGymWithDetailsDTO.fromJson(jsonResponse);
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
