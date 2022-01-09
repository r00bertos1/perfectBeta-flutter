//import 'dart:convert';

//import 'package:perfectBeta/helpers/serializers.dart';
//import 'package:flutter/foundation.dart';


//TODO: deserializer / serializer template
// Future<T> decodeJson<T>(String res) async {
//   var list = List();
//   list.add(res);
//   list.add(T);
//   //Replace compute with spawning any other isolate, compute is simpler abstraction of isolate api.
//   var result = await compute(_decode, list);
//   return result;
// }
//
// dynamic _decode(List list) {
//   var decoded = json.decode(list[0]);
//   var matchedDecoder = serializers.serializerForType(list[1]);
//   if (matchedDecoder != null) {
//     return serializers.deserializeWith(matchedDecoder, decoded);
//   } else {
//     return null;
//   }
// }

// Sample usage
/*
Future<User> getUser() async {
  try {
    Response<String> response = await _dio.get("/me");
    var userResponse = await decodeJson<User>(response.data);
    return userResponse;
  } catch (error, stacktrace) {
    print(stacktrace);
    return null;
  }
}
*/