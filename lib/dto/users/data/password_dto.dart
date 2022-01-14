class PasswordDTO {
  String password;

  PasswordDTO({this.password});

  Map<String, dynamic> toJson() => {
    'password': password,
  };

  factory PasswordDTO.fromJson(Map<String, dynamic> json) {
    return PasswordDTO(password: json['password']);
  }
}
