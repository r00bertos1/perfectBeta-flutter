import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

class CloudEndpoint {
  final Dio _client;
  CloudEndpoint(this._client);

  Future<Response> uploadFile(files) async {
    try {
      List<dynamic> _documents = [];

      for (int i = 0; i < files.length; i++) {
        var path = files[i].path;
        _documents.add(await MultipartFile.fromFile(path, filename: path.split('/').last));
      }
      var formData = FormData.fromMap({'files': _documents});

      Response<String> response = await _client.post('/image/upload', data: formData);

      return response;
    } on DioError catch (ex) {
      String errorMessage = json.decode(ex.response.toString())["message"];
      throw new Exception(errorMessage);
    } catch (e) {
      return null;
    }
  }
}
