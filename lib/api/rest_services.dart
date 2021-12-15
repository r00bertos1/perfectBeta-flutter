import 'dart:convert';
//import 'dart:html';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:perfectBeta/pages/add_route/model/converted_image.dart';

class RestServices {
  final uploadImageURL =
      'https://perfectbeta-python-tls-pyclimb.apps.okd.cti.p.lodz.pl/upload';

  Future<List<ConvertedImage>> convertImage(imagePath) async {
    var uri = Uri.parse(uploadImageURL);
    Map<String, String> headers = {
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      "Access-Control-Allow-Credentials":
      "true", // Required for cookies, authorization headers with HTTPS
    };

    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);
    var multipartFile = new http.MultipartFile('image',
        File(imagePath).readAsBytes().asStream(), File(imagePath).lengthSync());

    request.files.add(multipartFile);
    request
        .send()
        .then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          print("Uploaded! ");
          print('response.body ' + response.body);
          List jsonResponse = json.decode(response.body);
          return jsonResponse
              .map((item) => new ConvertedImage.fromJson(item))
              .toList();
        } else {
          print(response.statusCode);
          return <ConvertedImage>[];
        }
        //return <ConvertedImage>[];
        //return ConvertedImage.fromJson(jsonDecode(response.body));
      });
    })
        .catchError((err) => print('error : ' + err.toString()))
        .whenComplete(() {});
  }
}