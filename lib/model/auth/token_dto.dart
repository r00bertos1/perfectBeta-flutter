class TokenDTO {
  String token;

  TokenDTO({this.token});

  factory TokenDTO.fromJson(Map<String, dynamic> json) {
    return TokenDTO(token: json['token']);
  }
}
