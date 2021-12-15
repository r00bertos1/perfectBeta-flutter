class EmailDTO {
  String email;

  EmailDTO({this.email});

  factory EmailDTO.fromJson(Map<String, dynamic> json) {
    return EmailDTO(email: json['email']);
  }
}
