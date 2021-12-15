import 'dart:html';
import 'package:time_machine/time_machine.dart';

class ExceptionDTO {
  String message;
  HttpStatus httpStatus;
  ZonedDateTime timestamp;
  String key;

  //ExceptionDTO({this.message, this.httpStatus, this.timestamp});

  ExceptionDTO({this.message, this.httpStatus, this.timestamp, this.key});

  factory ExceptionDTO.fromJson(Map<String, dynamic> json) {
    return ExceptionDTO(
        message: json['message'],
        httpStatus: json['httpStatus'],
        timestamp: json['timestamp'],
        key: json['key']);
  }

}