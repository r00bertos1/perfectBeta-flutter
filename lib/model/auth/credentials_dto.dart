class CredentialsDTO {
  String username;
  String password;

  CredentialsDTO(
      {this.username, this.password});

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
  };

  factory CredentialsDTO.fromJson(Map<String, dynamic> json) {
    return CredentialsDTO(
        username: json['username'],
        password: json['password']);
  }
}