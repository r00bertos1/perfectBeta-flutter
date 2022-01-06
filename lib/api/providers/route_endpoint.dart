import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:perfectBeta/dto/pages/page_dto.dart';
import 'package:perfectBeta/dto/routes/rating_dto.dart';
import 'package:perfectBeta/dto/routes/route_dto.dart';

import '../api_client.dart';

class RouteEndpoint {
  //Dio _client = new ApiClient().init();
  Dio _client;
  RouteEndpoint(this._client);

  // ANONIM
    // GET
  Future<DataPage> getAllGymRoutes(int gymId) async {
    try {
      //final response = await _client.get('/gym/verified/all');
      Response<String> response = await _client.get('/route/$gymId');
      //print(response.data);

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

  // MANAGER
    // PUT
  Future<RouteDTO> editRouteDetails(int gymId, int routeId, RouteDTO body) async {
    try {
      //body is RouteDTO eg.
      // var body =  {
      // "routeName": "boulder2",
      // "difficulty": "4b+",
      // "climbingGymId": -2
      // };
      Response<String> response = await _client
          .put('/route/$gymId/edit/$routeId', data: jsonEncode(body));

      final jsonResponse = json.decode(response.data);
      RouteDTO page = new RouteDTO.fromJson(jsonResponse);
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
  Future<RouteDTO> addWallToGym(RouteDTO body) async {
    try {
      //body is a RouteDTO eg.
      // var body =  {
      // "routeName": "trasa 1",
      // "difficulty": "6a",
      // "description": "opis tej trudnej trasy",
      // "holdsDetails": " json....",
      // "climbingGymId": -1,
      // "photos": [
      // {
      // "photoUrl" : "https://link.pl/jpg.png33"
      // },
      // {
      // "photoUrl" : "https://link.pl/jpg.gif23"
      // }
      // ]
      // };
      Response<String> response =
          await _client.post('/route/add', data: jsonEncode(body));

      final jsonResponse = json.decode(response.data);
      RouteDTO page = new RouteDTO.fromJson(jsonResponse);
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
  Future<Response> deleteRoute(int gymId, int routeId) async {
    try {
      Response<String> response =
          await _client.delete('/route/$gymId/remove/$routeId');

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

  Future<Response> deleteRatingByOwnerOrMaintainer(int rateId) async {
    try {
      Response<String> response =
          await _client.delete('/route/rate/$rateId/force-delete');

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

  // CLIMBER
    // GET
  Future<DataPage> getAllFavourites() async {
    try {
      Response<String> response = await _client.get('/route/favorites');
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

    // POST
  Future<RouteDTO> addRouteToFavourites(int routeID) async {
    try {
      //body is a RouteDTO eg.
      // var body =  {
      // "routeName": "trasa 1",
      // "difficulty": "6a",
      // "description": "opis tej trudnej trasy",
      // "holdsDetails": " json....",
      // "climbingGymId": -1,
      // "photos": [
      // {
      // "photoUrl" : "https://link.pl/jpg.png33"
      // },
      // {
      // "photoUrl" : "https://link.pl/jpg.gif23"
      // }
      // ]
      // };
      Response<String> response =
          await _client.post('/route/$routeID/add-favorite');
      final jsonResponse = json.decode(response.data);
      RouteDTO page = new RouteDTO.fromJson(jsonResponse);

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

  Future<RouteDTO> addRatingToRoute(int routeID, RatingDTO body) async {
    try {
      //body is a RatingDTO eg.
      // var body =  {
      // "rate": 5,
      // "comment": "great!"
      // };
      Response<String> response = await _client.post('/route/$routeID/rate', data: jsonEncode(body));
      final jsonResponse = json.decode(response.data);
      RouteDTO page = new RouteDTO.fromJson(jsonResponse);

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
  Future<Response> removeRouteFromFavourites(int routeID) async {
    try {
      Response<String> response =
      await _client.delete('/route/$routeID/remove-favorite');

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

  Future<Response> deleteOwnRating(int rateID) async {
    try {
      Response<String> response =
      await _client.delete('/route/rate/$rateID/delete');

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
