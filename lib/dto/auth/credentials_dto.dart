class CredentialsDTO {
  String username;
  String password;

  CredentialsDTO(
      {this.username, this.password});

  factory CredentialsDTO.fromJson(Map<String, dynamic> json) {
    return CredentialsDTO(
        username: json['username'],
        password: json['password']);
  }
}