class RegistrationDTO {
  String login;
  String email;
  String password;

  RegistrationDTO({this.login, this.email, this.password});

  Map<String, dynamic> toJson() => {
    'login': login,
    'email': email,
    'password': password,
  };

  factory RegistrationDTO.fromJson(Map<String, dynamic> json) {
    return RegistrationDTO(
        login: json['login'],
        email: json['email'],
        password: json['password']);
  }
}