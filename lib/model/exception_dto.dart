class ExceptionDTO {
  String message;
  String httpStatus;
  String timestamp;
  String key;

  ExceptionDTO({this.message, this.key, this.httpStatus, this.timestamp});

  factory ExceptionDTO.fromJson(Map<String, dynamic> json) {
    return ExceptionDTO(
        message: json['message'],
        httpStatus: json['httpStatus'],
        timestamp: json['timestamp'],
        key: json['key']);
  }

}