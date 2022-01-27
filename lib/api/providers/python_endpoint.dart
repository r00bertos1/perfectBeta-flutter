import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:async';

class PythonEndpoint {
  Dio _client;
  PythonEndpoint(this._client);


  Future<Response> scanImage(image) async {
    try {
      //List<dynamic> _documents = [];

      var path = image.path;
      var multipart = await MultipartFile.fromFile(path,
          filename: path
              .split('/')
              .last);

      var formData = FormData.fromMap({'image': multipart});


      Response<String> response = await _client.post('https://perfectbeta-python-tls-pyclimb.apps.okd.cti.p.lodz.pl/upload', data: formData);
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
