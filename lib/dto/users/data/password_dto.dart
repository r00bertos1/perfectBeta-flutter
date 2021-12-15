class PasswordDTO {
  String password;

  PasswordDTO({this.password});

  factory PasswordDTO.fromJson(Map<String, dynamic> json) {
    return PasswordDTO(password: json['password']);
  }
}
